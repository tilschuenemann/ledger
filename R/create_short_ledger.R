#' Write short ledger to disk using banking CSV export
#'
#' @param path_to_export Path to CSV export file.
#' @param export_type Specify which bank export will be used.
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @description Cleans and formats export to short ledger format.
#' @export
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @importFrom readr write_excel_csv2
#' @importFrom dplyr row_number
#' @importFrom dplyr mutate
#'
create_short_ledger <- function(path_to_export, export_type, path_to_ledgerdir) {

  # test for valid ledger dir and export type
  sl_path <- paste0(path_to_ledgerdir, "short_ledger.csv")
  test_ledger_dir(path_to_ledgerdir)
  test_export_type(export_type)

  # bank specific cleaning and creating short ledger format
  short_ledger <- transform_export(path_to_export, export_type)

  # add id
  short_ledger <- short_ledger %>%
    mutate(id = row_number())

  # sort ledger columns
  short_ledger <- sort_ledger(short_ledger, "short")

  # write and print
  write_excel_csv2(short_ledger, sl_path)
  print("wrote short_ledger")

  write_initbalance(path_to_export, export_type, path_to_ledgerdir)
  update_short_ledger(path_to_ledgerdir)
}
