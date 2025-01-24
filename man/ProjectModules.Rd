% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/WGCNA_functions.R
\name{ProjectModules}
\alias{ProjectModules}
\title{ProjectModules}
\usage{
ProjectModules(
  seurat_obj,
  seurat_ref,
  group.by.vars = NULL,
  gene_mapping = NULL,
  genome1_col = NULL,
  genome2_col = NULL,
  scale_genes = FALSE,
  wgcna_name = NULL,
  wgcna_name_proj = NULL,
  ...
)
}
\arguments{
\item{seurat_obj}{A Seurat object}

\item{wgcna_name}{The name of the hdWGCNA experiment in the seurat_obj@misc slot}

\item{dbs}{List of EnrichR databases}

\item{max_genes}{Max number of genes to include per module, ranked by kME.}
}
\description{
Computes intramodular connectivity (kME) based on module eigengenes.
}
\examples{
ProjectModules
}
\keyword{scRNA-seq}
