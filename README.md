# scWGCNA


***WARNING!!!!!!***

scWGCNA is currently under construction! Everything is being overhauled and tons of new features are being added. You can check the dev branch, or check the [fancy new website](https://smorabit.github.io/scWGCNA/) for a sneak peak. For now use the dev branch with caution because it is changing on a pretty much daily basis, but I am planning to have a stable release of the updated scWGCNA soon.


scWGCNA is a bioinformatics workflow and an add-on to the R package [WGCNA](https://horvath.genetics.ucla.edu/html/CoexpressionNetwork/Rpackages/WGCNA/) to perform weighted gene co-expression network analysis in single-cell or single-nucleus RNA-seq datasets.
WGCNA was originally built for the analysis of bulk gene expression datasets, and the performance of
vanilla WGCNA on single-cell data is limited due to the inherent sparsity of scRNA-seq data. To account for this,
scWGCNA has a function to aggregate transcriptionally similar cells into pseudo-bulk ***metacells*** before
running the WGCNA pipeline. Furthermore, WGCNA is a well established tool with many different options and parameters,
so we recommend trying different options in network construction that are best suited to your dataset.

