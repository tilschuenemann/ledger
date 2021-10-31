#' Appends short ledgers
#'
#' @param path_to_export path to  export
#' @param export_type Specify which bank export will be used.
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @description Creates a new short ledger and appends it to the existing one.
#' To avoid overlapping date ranges, the report discards the most recent days
#' entries in the existing ledger. The new ledger will start at that cut off
#' date.
#'
#' @export
#'
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @importFrom dplyr filter
#' @importFrom dplyr '%>%'
#' @importFrom readr write_excel_csv2
#'
append_short_ledger <- function(path_to_export, export_type, path_to_ledgerdir) {
  test_ledger_dir(path_to_ledgerdir)
  sl_path <- paste0(path_to_ledgerdir, "short_ledger.csv")
  test_short_ledger(sl_path)
  test_export_type(export_type)

  base_ledger <- clean_export(path_to_export, export_type)

  ledger_appendage <- format_export(base_ledger)

  # read current ledger
  suppressWarnings({
    current_short_ledger <- read_delim(sl_path,
      ";",
      escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
      trim_ws = TRUE, col_types = cols(),
    )
  })

  # cut off
  cutoff_date <- max(current_short_ledger$date)

  current_short_ledger <- current_short_ledger %>%
    filter(date < cutoff_date)

  ledger_appendage <- ledger_appendage %>%
    filter(date >= cutoff_date)

  newrow_count <- nrow(ledger_appendage)

  # append
  updated_ledger <- rbind(current_short_ledger, ledger_appendage)

  # write and print
  write_excel_csv2(updated_ledger, sl_path)
  print(paste0("appended ", newrow_count, " new entries to short ledger!"))

  update_short_ledger(path_to_ledgerdir)
}
