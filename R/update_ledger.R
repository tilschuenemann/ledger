#' Wrapper for updating mapping table, balance and maps
#'
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @export

update_ledger <- function(path_to_ledgerdir) {
  update_maptab(path_to_ledgerdir)
  update_balance(path_to_ledgerdir)
  update_ledger_mappings(path_to_ledgerdir)
}
