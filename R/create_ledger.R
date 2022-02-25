#' Creates the standard ledger
#'
#' @param path_to_export Path to CSV export file.
#' @param export_type Specify which bank export will be used.
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @export
#'
#' @import readr
#' @import utils
create_ledger <- function(path_to_ledgerdir, path_to_export, export_type) {

  # test inputs and prepare output path
  check_ledger_dir(path_to_ledgerdir)
  check_export_type(export_type)
  ledger_path <- paste0(path_to_ledgerdir, "ledger.csv")

  if(file.exists(ledger_path)){
    overwrite <- menu(c("no","yes"),title="ledger already exists. Do you want to overwrite it?")

    if(overwrite==1){
      stop("not overwriting ledger. stopping.")
    }
  }

  ledger <- transform_export(path_to_export, export_type)

  write_excel_csv2(ledger, ledger_path)
  print("wrote ledger")

  setup_balance(path_to_export, export_type, path_to_ledgerdir)
  update_ledger(path_to_ledgerdir)
  sort_ledger(path_to_ledgerdir)

}