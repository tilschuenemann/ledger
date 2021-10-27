#' Tests for valid export types.
#'
#' @param export_type Specify which bank export will be used.
#'
#' @keywords internal
#'
test_export_type <- function(export_type) {
  valid_types <- c("dkb")

  if (!export_type %in% valid_types) {
    stop("export type not valid!")
  }
}
