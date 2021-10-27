#' Test for ledgerdir.
#'
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @keywords internal
#'
test_ledger_dir <- function(path_to_ledgerdir) {
  if (!dir.exists(path_to_ledgerdir)) {
    stop("ledger dir does not exist!")
  }
}
