#' Title
#'
#' @param path_to_export
#'
#' @keywords internal
#' @importFrom tools file_ext
check_export <- function(path_to_export){

  if(!is.character(path_to_export)){
    stop("path_to_export is not a character vector")
  }

  if(nchar(path_to_export)==0){
    stop("path_to_export is empty character vector")
  }
  if(!file.exists(path_to_export)){
    stop("export file doesnt exist")
  }
  if(tools::file_ext(path_to_export)!="csv"){
    stop("export is not a csv")
  }

}