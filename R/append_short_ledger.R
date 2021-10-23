#' Appends short ledgers
#'
#' @param path_to_export path to dkb export
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
#' @importFrom dplyr filter
#' @importFrom readr write_excel_csv2
#'
append_short_ledger <- function(path_to_export) {

  # read and format new export
  dkb_export <- read_delim(path_to_export,
    ";",
    escape_double = FALSE, locale = locale(encoding = "ISO-8859-1", decimal_mark = ","),
    trim_ws = TRUE, skip = 6
  )

  dkb_cleaned <- clean_dkb(dkb_export)
  ledger_appendage <- ledger2::format_export(dkb_cleaned)

  # read current ledger
  current_short_ledger <- read_delim("short_ledger.csv",
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE,
  )

  # cut off
  cutoff_date <- max(current_short_ledger$date)

  current_short_ledger <- current_short_ledger %>%
    filter(date < cutoff_date)

  current_short_ledger <- current_short_ledger %>%
    filter(date >= cutoff_date)

  # append
  updated_ledger <- rbind(current_short_ledger, ledger_appendage)

  write_excel_csv2(updated_ledger, "short_ledger.csv")
}
