#' Write a Dockerfile with appropriate system dependencies for your project
#'
#' @param analysis_dir Directory to your analysis. Defaults to current directory.
#' @param rocker_rstudio_tag Tag for rocker/rstudio. See details.
#' @param port What port to open
#' @param username Username for rstudio
#' @param password Password for rstudio
#' @param distribution Which distribution of linux will your dockerfile run?
#' @param release Release number for distribution.
#'
#' @return Path to created dockerfile.
#'
#' @details
#' Additional details...
#'
#'
#' @export
#'
#' @examples
write_dockerfile <- function(
                      analysis_dir = '.',
                      rocker_rstudio_tag = 'latest',
                      port = '8787',
                      username = 'rstudio',
                      password = 'rstudio',
                      distribution = 'ubuntu',
                      release = '20.04',
                      build = FALSE,
                      container_name = NULL){

  withr::with_dir(analysis_dir, {

  # Check that the project has an renv directory and a lockfile

  if(!dir.exists('renv')){
    cli::cli_abort(c("{.fn write_dockerfile} only works for projects with renv.",
              "!"= "Does your package use renv?"))
    }

  if(!file.exists('renv.lock')){
      cli::cli_abort(c("{.fn write_dockerfile} only works for projects with renv.",
                       "!"= "No lockfile found.  Try {.fn renv::snapshot}"))
    }


  # Get system dependncies
  sys_reqs <- getsysreqs::apt_get_install("renv.lock", distribution = distribution, release = release)

  data <- list(
    rocker_rstudio_tag=rocker_rstudio_tag,
    system_dependencies=sys_reqs,
    port=port,
    username=username,
    password=password

  )

  # Write the dockerfile to the local directory.
  usethis::use_template('dockerfile', package = 'dockerizer', data=data)

  })


  if(rlang::is_true(build)){

    if(rlang::is_null(container_name)){
      cli::cli_abort("{.arg container_name} is null, please enter a valid string.")
    }

    build_container(container_name = container_name)
  }



}


build_container <- function(container_name='rstudio-analysis'){

  if(!file.exists('dockerfile')){
    cli::cli_abort("A dockerfile must exist in the analysis directory.")
  }

  command <- paste("docker build -t", container_name, '.', collapse = " ")

  system(command)

}

