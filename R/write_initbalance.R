
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
#' @importFrom readr cols
#' @importFrom lubridate dmy
#' @importFrom readr write_excel_csv2
#' @importFrom readr parse_number
#' @importFrom tidyr replace_na
#' @importFrom dplyr bind_rows
write_initbalance <- function(dkb_export) {

  # read file
  suppressWarnings({
  ledger_import <- read_delim(dkb_export,
    ";",
    escape_double = FALSE, locale = locale(encoding = "ISO-8859-1", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )
  })

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

  # stub entry with same formatting
  first_entry <- data.frame(date = first_date,
                            recipient = "LEDGER INITIAL BALANCE",
                            amount = 0,
                            balance = first_balance) %>%
    mutate(
      date_custom = NA,
      year = floor_date(date, unit = "year"),
      month = floor_date(date, unit = "month"),
      quarter = floor_date(date, unit = "quarter"),
      recipient_clean_custom = NA,
      amount_custom = NA,
      type = ifelse(.data$amount > 0, "Income", "Expense"),
      label1_custom = "unknown",
      label2_custom = "unknown",
      label3_custom = "unknown"
    )

  # add as first row to short ledger
  short_ledger <- bind_rows(first_entry, short_ledger)
  short_ledger$balance <- replace_na(short_ledger$balance, 0)

  # write short ledger
  readr::write_excel_csv2(short_ledger, "short_ledger.csv")
}
