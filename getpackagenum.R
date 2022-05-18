library(futile.logger)
args = commandArgs(trailingOnly=TRUE)
version <- args[1]
Sys.setenv(BIOCONDUCTOR_USE_CONTAINER_REPOSITORY=FALSE)
repos <- BiocManager::repositories()
workrepos <- sub("/[[:digit:]\\.]+/", paste0("/",version,"/"), repos)
db <- available.packages(repos = repos)
contrib_url <- contrib.url(workrepos[["BioCsoft"]])
idx <- db[, "Repository"] == contrib_url
software_pkgs <- rownames(db)[idx]
flog.info(
    '%d software packages available',
    length(software_pkgs),
    name = "kube_install")
