#' Title
#'
#' @param path_to_ledgerdir
#' @param path_to_export
#' @param export_type
#' @param ledger_path
#' @param ledger
#' @param path_to_maptab
#'
#' @keywords internal
#'
check_routine <- function(path_to_ledgerdir = F,
                          path_to_export = F,
                          export_type = F,
                          ledger_path = F,
                          ledger = F,
                          path_to_maptab = F){

  if(path_to_ledgerdir!=F){
    check_ledger_dir(path_to_ledgerdir)
  } else if (export_type!=F){
    check_export_type(export_type)
  } else if(ledger_path!=F){
    check_ledger(ledger_path)
  } else if(ledger != F){
    check_initial_balance(ledger)
  } else if(path_to_export!=F){
    check_export(path_to_export)
  } else if(path_to_maptab!=F){
    check_maptab(path_to_maptab)
  }




}
