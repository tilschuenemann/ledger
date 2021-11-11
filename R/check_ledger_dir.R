#' Test for ledger dir
#'
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @keywords internal
check_ledger_dir <- function(path_to_ledgerdir) {

  if (!is.character(path_to_ledgerdir)) {
    stop("path_to_ledgerdir is not a character vector")
  }

  if (nchar(path_to_ledgerdir) == 0) {
    stop("path_to_ledgerdir is empty")
  }

  if (!dir.exists(path_to_ledgerdir)) {
    stop("ledger dir does not exist!")
  }
}
