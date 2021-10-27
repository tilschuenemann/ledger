#' Write short ledger to disk using banking CSV export
#'
#' @param path_to_export Path to CSV export file.
#' @param export_type Specify which bank export will be used.
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @description Wrapper around clean_dkb() and format_export(), which writes short ledger to disc
#' @export
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @importFrom readr write_excel_csv2
#'
create_short_ledger <- function(path_to_export, export_type, path_to_ledgerdir) {
  sl_path <- paste0(path_to_ledgerdir, "short_ledger.csv")
  test_ledger_dir(path_to_ledgerdir)
  test_export_type(export_type)

  # clean to base format (date, recipient, amount)
  switch(export_type,
    dkb = {
      # read file, dont warn about missing column name
      suppressWarnings({
        export <- read_delim(path_to_export,
          ";",
          escape_double = FALSE, locale = locale(encoding = "ISO-8859-1", decimal_mark = ","),
          trim_ws = TRUE, skip = 6, col_types = cols()
        )
      })

      export_cleaned <- clean_dkb(export)
    }
  )

  # create short format
  short_ledger <- format_export(export_cleaned)

  # write and print
  write_excel_csv2(short_ledger, sl_path)
  print("wrote short_ledger")

  write_initbalance(path_to_export, path_to_ledgerdir)
  update_short_ledger(path_to_ledgerdir)
}
