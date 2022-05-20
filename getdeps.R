library(BiocKubeInstall)


args = commandArgs(trailingOnly=TRUE)
bioc_version = args[1]
image_name = "bioconductor_docker"

.repos <-
    function(version, image_name, cloud_id = c('google', 'azure'))
{

    cloud <- match.arg(cloud_id)

    if (cloud == "google") {
        bucket <- paste0("gs://", "bioconductor-packages/")
    }

    if (cloud == "azure") {
        bucket <- "https://bioconductordocker.blob.core.windows.net/"
    }

    ## 'binary_repo' is where the existing binaries are located.
    ## 'cran_bucket' is where packages are uploaded on a google bucket
    binary_repo <- paste0(
        bucket,
        version, "/container-binaries/", image_name
    )
    cran_repo <- paste0(binary_repo, "/src/contrib/")
    logs_repo <- paste0(binary_repo, "/src/package_logs/")

    list(cran = cran_repo, binary = binary_repo, logs = logs_repo)
}

repos <- .repos(bioc_version,image_name, cloud_id = 'google')

deps <- pkg_dependencies(
                bioc_version, build = "_software",
                binary_repo = repos$binary)
