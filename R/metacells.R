#' ConstructMetacells
#'
#' This function takes a Seurat object and constructs averaged 'metacells' based
#' on neighboring cells.
#' @param seurat_obj A Seurat object
#' @param k Number of nearest neighbors to aggregate. Default = 50
#' @param name A string appended to resulting metalcells. Default = 'agg'
#' @param reduction A dimensionality reduction stored in the Seurat object. Default = 'umap'
#' @param assay Assay to extract data for aggregation. Default = 'RNA'
#' @param slot Slot to extract data for aggregation. Default = 'data'
#' @param return_metacell Logical to determine if we return the metacell seurat object (TRUE), or add it to the misc in the original Seurat object (FALSE). Default to FALSE.
#' @keywords scRNA-seq
#' @export
#' @examples
#' ConstructMetacells(pbmc)
ConstructMetacells <- function(
  seurat_obj, name='agg', ident.group='seurat_clusters', k=50,
  reduction='umap', assay='RNA',
  cells.use = NULL, # if we don't want to use all the cells to make metacells, good for train/test split
  slot='counts',  meta=NULL, return_metacell=FALSE, wgcna_name=NULL
){

  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # check reduction
  if(!(reduction %in% names(seurat_obj@reductions))){
    stop(paste0("Invalid reduction (", reduction, "). Reductions in Seurat object: ", paste(names(seurat_obj@reductions), collapse=', ')))
  }

  # check assay
  if(!(assay %in% names(seurat_obj@assays))){
    stop(paste0("Invalid assay (", assay, "). Assays in Seurat object: ", paste(names(seurat_obj@assays), collapse=', ')))
  }

  # check slot
  if(!(slot %in% c('counts', 'data', 'scale.data'))){
    stop(paste0("Invalid slot (", slot, "). Valid options for slot: counts, data, scale.data "))
  }

  # subset seurat object by selected cells:
  if(!is.null(cells.use)){
    seurat_full <- seurat_obj
    seurat_obj <- seurat_obj[,cells.use]
  }

  print(dim(seurat_obj))

  reduced_coordinates <- as.data.frame(seurat_obj@reductions[[reduction]]@cell.embeddings)
  nn_map <- FNN::knn.index(reduced_coordinates, k = (k - 1))
  row.names(nn_map) <- row.names(reduced_coordinates)
  nn_map <- cbind(nn_map, seq_len(nrow(nn_map)))
  good_choices <- seq_len(nrow(nn_map))
  choice <- sample(seq_len(length(good_choices)), size = 1,
      replace = FALSE)
  chosen <- good_choices[choice]
  good_choices <- good_choices[good_choices != good_choices[choice]]
  it <- 0
  k2 <- k * 2
  get_shared <- function(other, this_choice) {
      k2 - length(union(cell_sample[other, ], this_choice))
  }
  while (length(good_choices) > 0 & it < 5000) {
      it <- it + 1
      choice <- sample(seq_len(length(good_choices)), size = 1,
          replace = FALSE)
      new_chosen <- c(chosen, good_choices[choice])
      good_choices <- good_choices[good_choices != good_choices[choice]]
      cell_sample <- nn_map[new_chosen, ]
      others <- seq_len(nrow(cell_sample) - 1)
      this_choice <- cell_sample[nrow(cell_sample), ]
      shared <- sapply(others, get_shared, this_choice = this_choice)

      if (max(shared) < 0.9 * k) {
          chosen <- new_chosen
      }
  }

  cell_sample <- nn_map[chosen, ]
  combs <- combn(nrow(cell_sample), 2)
  shared <- apply(combs, 2, function(x) {
      k2 - length(unique(as.vector(cell_sample[x, ])))
  })

  message(paste0("Overlap QC metrics:\nCells per bin: ",
      k, "\nMaximum shared cells bin-bin: ", max(shared),
      "\nMean shared cells bin-bin: ", mean(shared), "\nMedian shared cells bin-bin: ",
      median(shared)))
  if (mean(shared)/k > 0.1)
      warning("On average, more than 10% of cells are shared between paired bins.")

  exprs_old <- GetAssayData(seurat_obj, assay=assay, slot=slot)

  mask <- sapply(seq_len(nrow(cell_sample)), function(x) seq_len(ncol(exprs_old)) %in%
      cell_sample[x, , drop = FALSE])
  mask <- Matrix::Matrix(mask)
  new_exprs <- (exprs_old %*% mask) / k
  colnames(new_exprs) <- paste0(name, '_', 1:ncol(new_exprs))
  rownames(cell_sample) <- paste0(name, '_', 1:ncol(new_exprs))
  colnames(cell_sample) <- paste0('knn_', 1:ncol(cell_sample))

  # make seurat obj:
  metacell_obj <- CreateSeuratObject(
    counts = new_exprs
  )

  print(meta)
  print(names(meta))

  # add meta-data:
  if(!is.null(meta)){
    meta_names <- names(meta)
    for(x in meta_names){
      metacell_obj@meta.data[[x]] <- meta[[x]]
    }
  } else(
    warning('meta not found')
  )

  # add seurat metacell object to the main seurat object:
  if(return_metacell){
    out <- metacell_obj
  } else{

    # revert to full seurat object if we subsetted earlier
    if(!is.null(cells.use)){
      seurat_obj <- seurat_full
    }

    # add seurat metacell object to the main seurat object:
    seurat_obj <- SetMetacellObject(seurat_obj, metacell_obj, wgcna_name)

    # add other info
    seurat_obj <- SetWGCNAParams(
      seurat_obj, params = list(
        'metacell_k' = k,
        'metacell_reduction' = reduction,
        'metacell_slot' = slot,
        'metacell_assay' = assay
      ),
      wgcna_name
    )

    out <- seurat_obj
  }
  out

}

#' MetacellsByGroups
#'
#' This function takes a Seurat object and constructs averaged 'metacells' based
#' on neighboring cells in provided groupings, such as cluster or cell type.
#' @param seurat_obj A Seurat object
#' @param group.by A character vector of Seurat metadata column names representing groups for which metacells will be computed.
#' @param k Number of nearest neighbors to aggregate. Default = 50
#' @param name A string appended to resulting metalcells. Default = 'agg'
#' @param reduction A dimensionality reduction stored in the Seurat object. Default = 'umap'
#' @param assay Assay to extract data for aggregation. Default = 'RNA'
#' @param slot Slot to extract data for aggregation. Default = 'data'
#' @keywords scRNA-seq
#' @export
#' @examples
#' MetacellsByGroups(pbmc)
MetacellsByGroups <- function(
  seurat_obj, group.by=c('seurat_clusters'), ident.group='seurat_clusters',
  k=50, reduction='umap', assay='RNA',
  cells.use = NULL, # if we don't want to use all the cells to make metacells, good for train/test split
  slot='counts', wgcna_name=NULL
){

  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # check group.by for invalid characters:
  if(any(grepl('#', group.by))){
    stop('Invalid character # found in group.by, please re-name the group.')
  }

  if(!(ident.group %in% group.by)){
    stop('ident.group must be in group.by')
  }

  # subset seurat object by seleted cells:
  if(!is.null(cells.use)){
    seurat_full <- seurat_obj
    seurat_obj <- seurat_obj[,cells.use]
  }

  # setup grouping variables
  if(length(group.by) > 1){
    seurat_meta <- seurat_obj@meta.data[,group.by]
    for(col in colnames(seurat_meta)){
      seurat_meta[[col]] <- as.character(seurat_meta[[col]])
    }
    seurat_obj$metacell_grouping <- apply(seurat_meta, 1, paste, collapse='#')
  } else {
    seurat_obj$metacell_grouping <- as.character(seurat_obj@meta.data[[group.by]])
  }
  groupings <- unique(seurat_obj$metacell_grouping)
  groupings <- groupings[order(groupings)]

  # remove groups that are too small:
  # TODO: add a warning to let the user know that some groups are skipped?
  groupings <- groupings[table(seurat_obj$metacell_grouping) >= 2*k]
  print(groupings)

  # unique meta-data for each group
  meta_df <- as.data.frame(do.call(rbind, strsplit(groupings, '#')))
  colnames(meta_df) <- group.by

  # list of meta-data to pass to each metacell seurat object
  meta_list <- lapply(1:nrow(meta_df), function(i){
    x <- list(as.character(meta_df[i,]))[[1]]
    names(x) <- colnames(meta_df)
    x
  })

  # split seurat obj by groupings
  seurat_list <- lapply(groupings, function(x){seurat_obj[,seurat_obj$metacell_grouping == x]})
  names(seurat_list) <- groupings

  print(meta_list)

  # construct metacells
  metacell_list <- mapply(
    ConstructMetacells,
    seurat_obj = seurat_list,
    name = groupings,
    meta = meta_list,
    MoreArgs = list(k=k, reduction=reduction, assay=assay, slot=slot, return_metacell=TRUE, wgcna_name=wgcna_name)
  )
  names(metacell_list) <- groupings
  print('done making metacells')
  # combine metacell objects
  metacell_obj <- merge(metacell_list[[1]], metacell_list[2:length(metacell_list)])
  print('done merging seurat objc')

  # set idents for metacell object:
  Idents(metacell_obj) <- metacell_obj@meta.data[[ident.group]]
  print('set idents')

  # revert to full seurat object if we subsetted earlier
  if(!is.null(cells.use)){
    seurat_obj <- seurat_full
  }

  # add seurat metacell object to the main seurat object:
  seurat_obj <- SetMetacellObject(seurat_obj, metacell_obj, wgcna_name)
  print('update seurat')

  # add other info
  seurat_obj <- SetWGCNAParams(
    seurat_obj, params = list(
      'metacell_k' = k,
      'metacell_reduction' = reduction,
      'metacell_slot' = slot,
      'metacell_assay' = assay
    ),
    wgcna_name
  )
  print('set params')

  seurat_obj
}
