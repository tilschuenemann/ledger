#' Wrapper for updating cdates, maptab and balance
#'
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @export
#'
update_short_ledger <- function(path_to_ledgerdir) {
  update_maptab(path_to_ledgerdir)
  update_balance(path_to_ledgerdir)
}
