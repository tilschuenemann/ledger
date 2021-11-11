#' Tests for valid export types.
#'
#' @param export_type Specify which bank export will be used.
#'
#' @keywords internal
check_export_type <- function(export_type) {

  valid_types <- c("dkb")

  if (!is.character(export_type)) {
    stop("export_type is not a character vector")
  }

  if (nchar(export_type) == 0) {
    stop("export_type is empty")
  }

  if (!export_type %in% valid_types) {
    stop("export_type not valid!")
  }
}
