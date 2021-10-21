
#' Write initial balance to disk
#'
#' @param dkb_export DKB CSV export
#' @description Reads the DKB CSV export and writes an initial entry into the
#' working directory. It contains the ledger starting date as well the initial balance.
#' This is used as a starting point for a cumulative history plot.
#'
#' @export
#'
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom lubridate dmy
#' @importFrom readr write_excel_csv2
#'
write_initbalance <- function(dkb_export) {

  # dkb_export <- "dkb_export_20211017.csv"

  ledger_import <- read_delim(dkb_export,
    ";",
    escape_double = FALSE, locale = locale(encoding = "ISO-8859-1", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  # these are dkb specific
  first_date <- dmy(ledger_import[1, 2])
  last_date <- dmy(ledger_import[2, 2])
  last_balance <- ledger_import[3, 2] %>%
    gsub(pattern = "[[:alpha:]]|[[:blank:]]", replacement = "") %>%
    parse_number(locale = locale(decimal_mark = ",", grouping_mark = "."))

  # TODO dirty: read final ledger after reading dkb_export - cant get sum of
  # amount in export as formatting is bad
  short_ledger <- read_delim("short_ledger.csv",
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  first_balance <- sum(short_ledger$amount) * -1 + last_balance

  first_entry <- data.frame(date = first_date, amount = first_balance)
  readr::write_excel_csv2(first_entry, "initial_balance.csv")
}
