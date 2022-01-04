#' Title
#'
#' @param path_to_export Path to CSV export file.
#' @param export_type Specify which bank export will be used.
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @export
#'
#' @import readr
create_ledger <- function(path_to_ledgerdir, export_type, path_to_export) {

  # test inputs and prepare output path
  check_ledger_dir(path_to_ledgerdir)
  check_export_type(export_type)
  ledger_path <- paste0(path_to_ledgerdir, "ledger.csv")

  # bank specific cleaning and creating short ledger format
  ledger <- ledger:::transform_export(path_to_export, export_type)

  # write and print
  write_excel_csv2(ledger, ledger_path)
  print("wrote ledger")

  # write balance
  ledger:::setup_balance(path_to_export, export_type, path_to_ledgerdir)

  # update balance and maptab
  update_ledger(path_to_ledgerdir)
  sort_ledger(path_to_ledgerdir)

}