
############################
# Active WGCNA
###########################

#' SetActiveWGCNA
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetActiveWGCNA
SetActiveWGCNA <- function(seurat_obj, wgcna_name){

  # set the active_wgcna variable
  seurat_obj@misc$active_wgcna <- wgcna_name

  # initialize empty list for this WGCNA if it doesn't exist yet
  if(!(wgcna_name %in% names(seurat_obj@misc))){
    seurat_obj@misc[[seurat_obj@misc$active_wgcna]] <- list()
  }
  seurat_obj
}

#' GetActiveWGCNA
#'
#' @param seurat_obj A Seurat object
#' @keywords scRNA-seq
#' @export
#' @examples GetActiveWGCNA
GetActiveWGCNA <- function(seurat_obj){
  seurat_obj@misc[[seurat_obj@misc$active_wgcna]]
}

# get any WGCNA data, but by default get the active
GetWGCNA <- function(seurat_obj, wgcna_name=NULL){

  # test if wgcna_name is valid (TODO)

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  seurat_obj@misc[[wgcna_name]]
}

############################
# WGCNA Group
###########################

#' SetWGCNAGroup
#'
#' @param seurat_obj A Seurat object
#' @param group group name
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetWGCNAGroup
SetWGCNAGroup <- function(seurat_obj, group, wgcna_name){

  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # add gene list to Seurat obj
  seurat_obj@misc[[wgcna_name]]$wgcna_group <- group
  seurat_obj
}

#' GetWGCNAGroup
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetWGCNAGroup
GetWGCNAGroup <- function(seurat_obj, wgcna_name){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$wgcna_group
}


############################
# metacell object
###########################

#' SetMetacellObject
#'
#' @param seurat_obj A Seurat object
#' @param metacell_obj metacell Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetMetacellObject
SetMetacellObject <- function(seurat_obj, metacell_obj, wgcna_name=NULL){
  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # add metacell obj to Seurat obj
  seurat_obj@misc[[wgcna_name]]$wgcna_metacell_obj <- metacell_obj
  seurat_obj
}

#' GetMetacellObject
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetMetacellObject
GetMetacellObject <- function(seurat_obj,  wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  if(class(seurat_obj@misc[[wgcna_name]]$wgcna_metacell_obj) == "Seurat"){
    return(seurat_obj@misc[[wgcna_name]]$wgcna_metacell_obj)
  } else{
    metacell_location <- seurat_obj@misc[[wgcna_name]]$wgcna_metacell_obj
    return(seurat_obj@misc[[metacell_location]]$wgcna_metacell_obj)
  }

}

############################
# WGCNA genes
###########################

#' SetWGCNAGenes
#'
#' @param seurat_obj A Seurat object
#' @param gene_list vector of genes to be used for WGCNA
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetWGCNAGenes
SetWGCNAGenes <- function(seurat_obj, gene_list, wgcna_name=NULL){

  # test if wgcna_name is valid (TODO)
  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # add gene list to Seurat obj
  seurat_obj@misc[[wgcna_name]]$wgcna_genes <- gene_list
  seurat_obj
}

#' GetWGCNAGenes
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetWGCNAGenes
GetWGCNAGenes <- function(seurat_obj, wgcna_name=NULL){
  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$wgcna_genes
}

############################
# datExpr
###########################


#' SetDatExpr
#'
#' This function sets up the gene expression matrix for co-expression network analysis.
#'
#' @param seurat_obj A Seurat object
#' @param group_name A string containing a group present in the provided group.by column or in the Seurat Idents. A character vector can be provided to select multiple groups at a time.
#' @param use_metacells A logical determining if we use the metacells (TRUE) or the full expression matrix (FALSE)
#' @param group.by A string containing the name of a column in the Seurat object with cell groups (clusters, cell types, etc). If NULL (default), hdWGCNA uses the Seurat Idents as the group.
#' @param multi.group.by A string containing the name of a column in the Seurat object with groups for consensus WGCNA (dataset, sample, condition, etc)
#' @param multi_group_name A string containing the name of a group present in the multi.group.by column.
#' @param wgcna_name A string containing the name of the WGCNA slot in seurat_obj@misc. Default = NULL which retrieves the currently active WGCNA data
#' @keywords scRNA-seq
#' @export
#' @examples
#' SetDatExpr(pbmc)
SetDatExpr <- function(
  seurat_obj,
  group_name,
  use_metacells=TRUE,
  group.by=NULL,
  multi.group.by = NULL,
  multi_group_name = NULL,
  return_seurat = TRUE,
  wgcna_name=NULL,
  slot = 'data',
  ...
){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # get parameters from seurat object
  params <- GetWGCNAParams(seurat_obj, wgcna_name)
  genes_use <- GetWGCNAGenes(seurat_obj, wgcna_name)
  modules <- GetModules(seurat_obj, wgcna_name)
  assay <- params$metacell_assay

  # use metacells or whole seurat object?
  if(use_metacells){
    s_obj <- GetMetacellObject(seurat_obj, wgcna_name)
  } else{
    s_obj <- seurat_obj
  }

  # check that group.by is in the Seurat object & in the metacell object:
  if(!(group.by %in% colnames(s_obj@meta.data))){
    m_cell_message <- ""
    if(use_metacells){m_cell_message <- "metacell"}
    stop(paste0(group.by, ' not found in the meta data of the ', m_cell_message, ' Seurat object'))
  }

  # get the metadata from the seurat object:
  seurat_meta <- s_obj@meta.data

  # columns to group by for cluster/celltype
  if(!is.null(group.by)){
    seurat_meta <- seurat_meta %>% subset(get(group.by) %in% group_name)
  }

  # check that the group names are actually in the group.by column:


  # subset further if multiExpr:
  if(!is.null(multi.group.by)){
    seurat_meta <- seurat_meta %>% subset(get(multi.group.by) %in% multi_group_name)
  }

  # get list of cells to use
  cells <- rownames(seurat_meta)

  # get expression data from seurat obj
  datExpr <- as.data.frame(
    Seurat::GetAssayData(
      s_obj,
      assay=assay,
      slot=slot
    )[genes_use,cells]
  )

  # transpose data
  datExpr <- as.data.frame(t(datExpr))

  # only get good genes:
  if(is.null(multi.group.by)){
    gene_list = genes_use[WGCNA::goodGenes(datExpr, ...)]
    datExpr <- datExpr[,gene_list]
  }


  if(return_seurat){

    # update the WGCNA gene list:
    seurat_obj <- SetWGCNAGenes(seurat_obj, gene_list, wgcna_name)

    # set the datExpr in the Seurat object
    seurat_obj@misc[[wgcna_name]]$datExpr <- datExpr
    out <- seurat_obj
  } else{
    out <- datExpr
  }
  out
}


#' GetDatExpr
#'
#' This function gets the WGCNA expression matrix.
#'
#' @param seurat_obj A Seurat object
#' @keywords scRNA-seq
#' @export
#' @examples
#' GetDatExpr
GetDatExpr <- function(seurat_obj, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$datExpr

}


#' SetMultiExpr
#'
#' This function sets up the expression matrix input for consensus WGCNA based on
#' the metacell expression matrix, or from the full expression matrix.
#'
#' @param seurat_obj A Seurat object
#' @param group_name A string containing a group present in the provided group.by column or in the Seurat Idents.
#' @param use_metacells A logical determining if we use the metacells (TRUE) or the full expression matrix (FALSE)
#' @param group.by A string containing the name of a column in the Seurat object with cell groups (clusters, cell types, etc). If NULL (default), hdWGCNA uses the Seurat Idents as the group.
#' @param multi.group.by A string containing the name of a column in the Seurat object with groups for consensus WGCNA (dataset, sample, condition, etc)
#' @param multi_groups A character vecrtor containing the names of
#' @param wgcna_name A string containing the name of the WGCNA slot in seurat_obj@misc. Default = NULL which retrieves the currently active WGCNA data
#' @keywords scRNA-seq
#' @export
#' @examples
#' SetDatExpr
SetMultiExpr <- function(
  seurat_obj,
  group_name,
  use_metacells=TRUE,
  group.by=NULL,
  multi.group.by = NULL,
  multi_groups = NULL,
  wgcna_name=NULL,
  ...
){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # get the WGCNA genes:
  gene_names <- GetWGCNAGenes(seurat_obj, wgcna_name)

  # get the different groups present if not specified by the user:
  if(is.null(multi_groups)){
    multi_groups <- unique(seurat_obj@meta.data[[multi.group.by]])
  } else{
    seurat_groups <- unique(seurat_obj@meta.data[[multi.group.by]])
    if(sum(multi_groups %in% seurat_groups) != length(multi_groups)){
      stop('Some or all groups specified in multi_groups not found in seurat_obj@meta.data[,multi.group.by]')
    }
  }

  # get the datExpr for each group
  datExpr_list <- lapply(multi_groups, function(x){
    SetDatExpr(
      seurat_obj,
      group_name = group_name,
      group.by = group.by,
      multi.group.by = multi.group.by,
      multi_group_name = x,
      return_seurat = FALSE,
      wgcna_name = wgcna_name
    ) %>% as.matrix
  })
  datExpr_list

  # convert to multiExpr, get good genes:
  multiExpr <- WGCNA::list2multiData(datExpr_list)
  genes_use <- WGCNA::goodGenesMS(multiExpr)
  gene_names <- gene_names[genes_use]

  # subset the multiExpr by the good genes::
  datExpr_list <- lapply(1:length(multiExpr), function(i){
    multiExpr[[i]]$data[,genes_use]
  })
  multiExpr <- WGCNA::list2multiData(datExpr_list)
  names(multiExpr) <- multi_groups

  # update the WGCNA gene list:
  seurat_obj <- SetWGCNAGenes(seurat_obj, gene_names, wgcna_name)

  # set the multiExpr in the Seurat object
  seurat_obj@misc[[wgcna_name]]$multiExpr <- multiExpr
  seurat_obj

}


#' GetMultiExpr
#'
#' This function gets the expression matrix from the metacell object.
#'
#' @param seurat_obj A Seurat object
#' @keywords scRNA-seq
#' @export
#' @examples
#' GetDatExpr
GetMultiExpr <- function(seurat_obj, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$multiExpr

}

############################
# WGCNA params
###########################

#' SetWGCNAParams
#'
#' @param seurat_obj A Seurat object
#' @param params list of WGCNA parameters
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetWGCNAParams
SetWGCNAParams <- function(seurat_obj, params, wgcna_name=NULL){

  if(is.null(GetActiveWGCNA(seurat_obj)$wgcna_params)){
    seurat_obj@misc[[seurat_obj@misc$active_wgcna]]$wgcna_params <- params
  } else{
    for(i in 1:length(params)){
      seurat_obj@misc[[seurat_obj@misc$active_wgcna]]$wgcna_params[[names(params)[i]]] <- params[[i]]
    }
  }
  seurat_obj
}

#' GetWGCNAParams
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetWGCNAParams
GetWGCNAParams <- function(seurat_obj, wgcna_name=NULL){
  # test if wgcna_name is valid (TODO)

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$wgcna_params
}

############################
# SoftPower Table
###########################

#' SetPowerTable
#'
#' @param seurat_obj A Seurat object
#' @param power_table a dataframe containing the results of the soft power test
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetPowerTable
SetPowerTable <- function(seurat_obj, power_table, wgcna_name=NULL){
  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # add power table to Seurat obj
  seurat_obj@misc[[wgcna_name]]$wgcna_powerTable <- power_table
  seurat_obj
}

#' GetPowerTable
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetPowerTable
GetPowerTable <- function(seurat_obj, wgcna_name=NULL){
  # get data from active assay if wgcna_name is not given

  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$wgcna_powerTable
}

############################
# WGCNA Network
###########################

#' SetNetworkData
#'
#' @param seurat_obj A Seurat object
#' @param net list of network data from WGCNA
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetNetworkData
SetNetworkData <- function(seurat_obj, net, wgcna_name=NULL){
  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # add network data to Seurat obj
  seurat_obj@misc[[wgcna_name]]$wgcna_net <- net
  seurat_obj
}


#' GetNetworkData
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetNetworkData
GetNetworkData <- function(seurat_obj, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$wgcna_net
}

############################
# WGCNA modules dataframe
###########################


#' SetModules
#'
#' @param seurat_obj A Seurat object
#' @param modules dataframe containing gene module assignments
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetModules
SetModules <- function(seurat_obj, mod_df, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # set module df
  seurat_obj@misc[[wgcna_name]]$wgcna_modules <- mod_df
  seurat_obj
}

#' GetModules
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetModules
GetModules <- function(seurat_obj, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$wgcna_modules
}


############################
# Module Eigengenes
###########################

#' SetMEs
#'
#' @param seurat_obj A Seurat object
#' @param MEs dataframe or matrix containing module eigengenes
#' @param harmonized logical indicating whether MEs have been harmonized
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetMEs
SetMEs <- function(seurat_obj, MEs, harmonized=TRUE, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # harmonized MEs?
  if(harmonized){
    seurat_obj@misc[[wgcna_name]]$hMEs <- MEs
  } else{
    seurat_obj@misc[[wgcna_name]]$MEs <- MEs
  }
  seurat_obj
}

#' GetMEs
#'
#' Function to retrieve module eigengens from Seurat object.
#'
#' @param seurat_obj A Seurat object
#' @param harmonized logical indicating whether MEs have been harmonized
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples
#' GetMEs
GetMEs <- function(seurat_obj, harmonized=TRUE, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # get harmonized MEs?
  if(harmonized == TRUE && !is.null(seurat_obj@misc[[wgcna_name]]$hMEs)){
    MEs <- seurat_obj@misc[[wgcna_name]]$hMEs
  } else{
    MEs <- seurat_obj@misc[[wgcna_name]]$MEs
  }
  MEs
}


#' SetMELoadings
#'
#' @param seurat_obj A Seurat object
#' @param loadings named numeric vector with eigengene loadings
#' @param harmonized logical indicating whether MEs have been harmonized
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetMELoadings
SetMELoadings <- function(seurat_obj, loadings, harmonized=TRUE, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # harmonized MEs?
  if(harmonized){
    seurat_obj@misc[[wgcna_name]]$hME_loadings <- c(seurat_obj@misc[[wgcna_name]]$hME_loadings, loadings)
  } else{
    seurat_obj@misc[[wgcna_name]]$ME_loadings <- c(seurat_obj@misc[[wgcna_name]]$ME_loadings, loadings)
  }
  seurat_obj
}

#' GetMELoadings
#'
#' Function to retrieve module eigengens from Seurat object.
#'
#' @param seurat_obj A Seurat object
#' @param harmonized logical indicating whether MEs have been harmonized
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples
#' GetMELoadings
GetMELoadings <- function(seurat_obj, harmonized=TRUE, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # get harmonized MEs?
  if(harmonized == TRUE && !is.null(seurat_obj@misc[[wgcna_name]]$hME_loadings)){
    MEs <- seurat_obj@misc[[wgcna_name]]$hME_loadings
  } else{
    MEs <- seurat_obj@misc[[wgcna_name]]$ME_loadings
  }
  MEs
}


############################
# GO term table
###########################

#' SetEnrichrTable
#'
#' @param seurat_obj A Seurat object
#' @param enrichr_table dataframe storing the results of running enrichr
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetEnrichrTable
SetEnrichrTable <- function(seurat_obj, enrich_table, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # set enrichr table
  seurat_obj@misc[[wgcna_name]]$enrichr_table <- enrich_table
  seurat_obj
}



#' GetEnrichrTable
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetEnrichrTable
GetEnrichrTable <- function(seurat_obj,  wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$enrichr_table
}


############################
# Module Scores
###########################


#' SetModuleScores
#'
#' @param seurat_obj A Seurat object
#' @param mod_scores dataframe storing the module expression scores
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetModuleScores
SetModuleScores <- function(seurat_obj, mod_scores, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$module_scores <- mod_scores
  seurat_obj
}

#' GetModuleScores
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetModuleScores
GetModuleScores <- function(seurat_obj,  wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$module_scores
}

############################
# Average Module Expression
###########################

#' SetAvgModuleExpr
#'
#' @param seurat_obj A Seurat object
#' @param avg_mods dataframe storing the average expression of all genes in the same module
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetAvgModuleExpr
SetAvgModuleExpr <- function(seurat_obj, avg_mods, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$avg_modules <- avg_mods
  seurat_obj
}

#' GetAvgModuleExpr
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetAvgModuleExpr
GetAvgModuleExpr <- function(seurat_obj,  wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$avg_modules
}

############################
# TOM
###########################

#' GetTOM
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetTOM
GetTOM <- function(seurat_obj, wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # get WGCNA genes:
  gene_names <- GetWGCNAGenes(seurat_obj, wgcna_name)

  # load TOM
  tom_files <- GetNetworkData(seurat_obj, wgcna_name)$TOMFiles
  load(tom_files[[1]])

  TOM <- as.matrix(consTomDS)
  rownames(TOM) <- gene_names; colnames(TOM) <- gene_names
  TOM

}

############################
# ROC Curve
###########################

#' SetROCData
#'
#' @param seurat_obj A Seurat object
#' @param roc_info dataframe storing the ROC results
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetROCData
SetROCData <- function(seurat_obj, roc_info, wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$roc_data <- roc_info
  seurat_obj
}


#' GetROCData
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetROCData
GetROCData <- function(seurat_obj,  wgcna_name=NULL){

  # get data from active assay if wgcna_name is not given
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$roc_data
}


############################
# TF Match Matrix (not stored within the WGCNA slot)
###########################

#' SetMotifMatrix
#'
#' @param seurat_obj A Seurat object
#' @param tf_match matrix containing tf-promoter matches
#' @keywords scRNA-seq
#' @export
#' @examples SetMotifMatrix
SetMotifMatrix <- function(seurat_obj, tf_match){

  # make a spot for the motif info if it's not already there:
  if(is.null(seurat_obj@misc$motifs)){
    seurat_obj@misc$motifs <- list()
  }
  seurat_obj@misc$motifs$tf_match_matrix <- tf_match
  seurat_obj
}

#' GetMotifMatrix
#'
#' @param seurat_obj A Seurat object
#' @keywords scRNA-seq
#' @export
#' @examples GetMotifMatrix
GetMotifMatrix <- function(seurat_obj){
  seurat_obj@misc$motifs$tf_match_matrix
}


############################
# Motif table
###########################

#' SetMotifs
#'
#' @param seurat_obj A Seurat object
#' @param motif_df dataframe containing info about the motifs being analyzed
#' @keywords scRNA-seq
#' @export
#' @examples SetMotifs
SetMotifs <- function(seurat_obj, motif_df){

  # make a spot for the motif info if it's not already there:
  if(is.null(seurat_obj@misc$motifs)){
    seurat_obj@misc$motifs <- list()
  }
  seurat_obj@misc$motifs$motif_df <- motif_df
  seurat_obj
}



#' GetMotifs
#'
#' @param seurat_obj A Seurat object
#' @keywords scRNA-seq
#' @export
#' @examples GetMotifs
GetMotifs <- function(seurat_obj){
  seurat_obj@misc$motifs$motif_df
}

############################
# PFM List
###########################


#' SetPFMList
#'
#' @param seurat_obj A Seurat object
#' @param pfm_list list of pfm objects
#' @keywords scRNA-seq
#' @export
#' @examples SetPFMList
SetPFMList <- function(seurat_obj, pfm_list){

  # make a spot for the motif info if it's not already there:
  if(is.null(seurat_obj@misc$motifs)){
    seurat_obj@misc$motifs <- list()
  }
  seurat_obj@misc$motifs$pfm_list <- pfm_list
  seurat_obj
}

#' GetPFMList
#'
#' @param seurat_obj A Seurat object
#' @keywords scRNA-seq
#' @export
#' @examples GetPFMList
GetPFMList <- function(seurat_obj){
  seurat_obj@misc$motifs$pfm_list
}


############################
# TF Target Genes:
###########################

#' SetMotifTargets
#'
#' @param seurat_obj A Seurat object
#' @param motif_targets list of motifs and their target genes
#' @keywords scRNA-seq
#' @export
#' @examples SetMotifTargets
SetMotifTargets <- function(seurat_obj, motif_targets){

  # make a spot for the motif info if it's not already there:
  if(is.null(seurat_obj@misc$motifs)){
    seurat_obj@misc$motifs <- list()
  }
  seurat_obj@misc$motifs$motif_targets <- motif_targets
  seurat_obj
}


#' GetMotifTargets
#'
#' @param seurat_obj A Seurat object
#' @keywords scRNA-seq
#' @export
#' @examples GetMotifTargets
GetMotifTargets <- function(seurat_obj){
  seurat_obj@misc$motifs$motif_targets
}


############################
# motif overlap
###########################


#' SetMotifOverlap
#'
#' @param seurat_obj A Seurat object
#' @param overlap_df dataframe containing motif-module overlap info
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetMotifOverlap
SetMotifOverlap <- function(seurat_obj, overlap_df, wgcna_name=NULL){

  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$motif_module_overlaps <- overlap_df
  seurat_obj
}


#' GetMotifOverlap
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetMotifOverlap
GetMotifOverlap <- function(seurat_obj, wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$motif_module_overlaps
}


############################
# motif scores
###########################


#' SetMotifScores
#'
#' @param seurat_obj A Seurat object
#' @param tf_scores dataframe of tf motif target scores
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetMotifScores
SetMotifScores <- function(seurat_obj, tf_scores, wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$motif_target_scores <- tf_scores
  seurat_obj
}


#' GetMotifScores
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetMotifScores
GetMotifScores <- function(seurat_obj, wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$motif_target_scores
}

############################
# ModuleUMAP
###########################

#' SetModuleUMAP
#'
#' @param seurat_obj A Seurat object
#' @param umap_df dataframe of UMAP coordinates
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetModuleUMAP
SetModuleUMAP <- function(seurat_obj, umap_df, wgcna_name=NULL){

  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$module_umap <- umap_df
  seurat_obj
}

#' GetModuleUMAP
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetModuleUMAP
GetModuleUMAP <- function(seurat_obj, wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$module_umap
}

############################
# ModuleTraitCorrelation
###########################


#' SetModuleTraitCorrelation
#'
#' @param seurat_obj A Seurat object
#' @param mt_cor matrix of module-trait correlation results
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetModuleTraitCorrelation
SetModuleTraitCorrelation <- function(seurat_obj, mt_cor, wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$mt_cor <- mt_cor
  seurat_obj
}

#' GetModuleTraitCorrelation
#'
#' @param seurat_obj A Seurat object
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetModuleTraitCorrelation
GetModuleTraitCorrelation <- function(seurat_obj, wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  seurat_obj@misc[[wgcna_name]]$mt_cor
}

############################
# ModulePreservation
###########################


#' SetModulePreservation
#'
#' @param seurat_obj A Seurat object
#' @param mt_cor matrix of module-trait correlation results
#' @param mod_name name of the module preservation test to store
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples SetModulePreservation
SetModulePreservation <- function(seurat_obj, mod_pres, mod_name, wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # make an empty list if module preservation hasn't been called yet
  if(is.null(seurat_obj@misc[[wgcna_name]]$module_preservation)){
    seurat_obj@misc[[wgcna_name]]$module_preservation <- list()
  }

  seurat_obj@misc[[wgcna_name]]$module_preservation[[mod_name]] <- mod_pres
  seurat_obj
}



#' GetModulePreservation
#'
#' @param seurat_obj A Seurat object
#' @param mod_name name of the module preservation test to store
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples GetModulePreservation
GetModulePreservation <- function(seurat_obj, mod_name, wgcna_name=NULL){
  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}
  if(is.null(seurat_obj@misc[[wgcna_name]]$module_preservation[[mod_name]])){
    stop("Invalid module preservation name.")
  }
  seurat_obj@misc[[wgcna_name]]$module_preservation[[mod_name]]
}


############################
# Reset module names:
###########################


#' ResetModuleNames
#'
#' Reset the uname of each hdWGCNA module
#'
#' @param seurat_obj A Seurat object
#' @param new_name string containing the base name to re-name the modules
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples
ResetModuleNames <- function(
  seurat_obj,
  new_name = "M",
  wgcna_name=NULL
){

  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # get modules
  modules <- GetModules(seurat_obj, wgcna_name)
  old_mods <- levels(modules$module)

  new_names <- paste0(new_name, 1:(length(old_mods)-1))
  grey_ind <- which(old_mods == 'grey')

  # account for when grey is first / last
  if(grey_ind == 1){
    new_names <- c('grey', new_names)
  } else if(grey_ind == length(old_mods)){
    new_names <- c(new_names, 'grey')
  } else{
    new_names <- c(new_names[1:(grey_ind-1)], 'grey', new_names[grey_ind:length(new_names)])
  }

  # update kMEs
  new_kMEs <- paste0('kME_', new_names)
  colnames(modules) <- c(colnames(modules)[1:3], new_kMEs)

  # update module names
  new_mod_df <- data.frame(
    old = old_mods ,
    new = new_names
  )

  modules$module <- factor(
    new_mod_df[match(modules$module, new_mod_df$old),'new'],
    levels = as.character(new_mod_df$new)
  )

  # set module table
  seurat_obj <- SetModules(seurat_obj, modules, wgcna_name)

  # update hME table:
  hMEs <- GetMEs(seurat_obj, harmonized=TRUE, wgcna_name)
  if(!is.null(hMEs)){
    colnames(hMEs) <- new_mod_df$new
    seurat_obj <- SetMEs(seurat_obj, hMEs, harmonized=TRUE, wgcna_name)
  }

  # update ME table
  MEs <- GetMEs(seurat_obj, harmonized=FALSE, wgcna_name)
  if(!is.null(MEs)){
    colnames(MEs) <- new_mod_df$new
    seurat_obj <- SetMEs(seurat_obj, MEs, harmonized=FALSE, wgcna_name)
  }

  # update module scores:
  module_scores <- GetModuleScores(seurat_obj, wgcna_name)
  if(!is.null(module_scores)){
    if(!("grey" %in% colnames(module_scores))){
      colnames(module_scores) <- new_mod_df$new[new_mod_df$new != 'grey']
    } else {
      colnames(module_scores) <- new_mod_df$new
    }
    seurat_obj <- SetModuleScores(seurat_obj, module_scores, wgcna_name)
  }

  # update average module expression:
  avg_exp <- GetAvgModuleExpr(seurat_obj, wgcna_name)
  if(!is.null(avg_exp)){
    if(!("grey" %in% colnames(avg_exp))){
      colnames(avg_exp) <- new_mod_df$new[new_mod_df$new != 'grey']
    } else {
      colnames(avg_exp) <- new_mod_df$new
    }
    seurat_obj <- SetAvgModuleExpr(seurat_obj, avg_exp, wgcna_name)
  }

  # update enrichr table:
  enrich_table <- GetEnrichrTable(seurat_obj, wgcna_name)
  if(!is.null(enrich_table)){
    enrich_table$module <- factor(
      new_mod_df[match(enrich_table$module, new_mod_df$old),'new'],
      levels = as.character(new_mod_df$new)
    )
    seurat_obj <- SetEnrichrTable(seurat_obj, enrich_table, wgcna_name)
  }

  # update ROC info:
  # THIS DOES NOT UPDATE THE ROC OBJECTS THEMSELVES!!!
  roc_data <- GetROCData(seurat_obj, wgcna_name)
  if(!is.null(roc_data)){
    roc_data$roc$module <- factor(
      new_mod_df[match(roc_data$roc$module, new_mod_df$old),'new'],
      levels = as.character(new_mod_df$new)
    )
    roc_data$conf$module <- factor(
      new_mod_df[match(roc_data$conf$module, new_mod_df$old),'new'],
      levels = as.character(new_mod_df$new)
    )
    seurat_obj <- SetROCData(seurat_obj, roc_data, wgcna_name)
  }

  # update motif overlap
  overlap_df <- GetMotifOverlap(seurat_obj, wgcna_name)
  if(!is.null(overlap_df)){
    overlap_df$module <- factor(
      new_mod_df[match(overlap_df$module, new_mod_df$old),'new'],
      levels = as.character(new_mod_df$new)
    )
    seurat_obj <- SetMotifOverlap(seurat_obj, overlap_df, wgcna_name)
  }

  # update module umap:
  umap_df <- GetModuleUMAP(seurat_obj, wgcna_name)
  if(!is.null(umap_df)){
    umap_df$module <- factor(
      new_mod_df[match(umap_df$module, new_mod_df$old),'new'],
      levels = as.character(new_mod_df$new)
    )
    seurat_obj <- SetModuleUMAP(seurat_obj, umap_df, wgcna_name)
  }


  seurat_obj

}


############################
# Reset module names:
###########################

#' ResetModuleColors
#'
#' Reset the unique color for each hdWGCNA module
#'
#' @param seurat_obj A Seurat object
#' @param new_colors a character vector containing the new colors
#' @param wgcna_name The name of the hdWGCNA experiment in the seurat_obj@misc slot
#' @keywords scRNA-seq
#' @export
#' @examples
ResetModuleColors <- function(
  seurat_obj,
  new_colors,
  wgcna_name=NULL
){

  if(is.null(wgcna_name)){wgcna_name <- seurat_obj@misc$active_wgcna}

  # get modules
  modules <- GetModules(seurat_obj, wgcna_name)
  mod_colors_df <- dplyr::select(modules, c(module, color)) %>%
    distinct %>% arrange(module)
  mod_colors <- mod_colors_df$color
  grey_ind <- which(mod_colors == 'grey')

  # case where we give a named list:
  if(class(new_colors) == 'list'){
    print('named list')
    ix <- match(names(new_colors), mod_colors_df$module)
    mod_colors_df[ix, 'color'] <- as.character(new_colors)
    new_colors <- mod_colors_df$color
  } else{
    if(grey_ind == 1){
      new_colors <- c('grey', new_colors)
    } else if(grey_ind == length(mod_colors)){
      new_colors <- c(new_colors, 'grey')
    } else{
      new_colors <- c(new_colors[1:(grey_ind-1)], 'grey', new_colors[grey_ind:length(new_colors)])
    }
  }

  new_color_df <- data.frame(
    old = mod_colors,
    new = new_colors
  )

  modules$color <- new_color_df[match(modules$color, new_color_df$old),'new']

  # set module table
  seurat_obj <- SetModules(seurat_obj, modules, wgcna_name)

  # update motif overlap
  overlap_df <- GetMotifOverlap(seurat_obj, wgcna_name)
  if(!is.null(overlap_df)){
    overlap_df$color <- new_color_df[match(overlap_df$color, new_color_df$old),'new']
    seurat_obj <- SetMotifOverlap(seurat_obj, overlap_df, wgcna_name)
  }

  # update module umap:
  umap_df <- GetModuleUMAP(seurat_obj, wgcna_name)
  if(!is.null(umap_df)){
    umap_df$color <- new_color_df[match(umap_df$color, new_color_df$old),'new']
    seurat_obj <- SetModuleUMAP(seurat_obj, umap_df, wgcna_name)
  }

  # update hdWGCNA dendrogram:
  net <- GetNetworkData(seurat_obj, wgcna_name)
  net$colors <- new_color_df[match(net$colors, new_color_df$old),'new']
  seurat_obj <- SetNetworkData(seurat_obj, net, wgcna_name)

  seurat_obj

}
