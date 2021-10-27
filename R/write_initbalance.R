
#' Add initial balance entry to short ledger.
#'
#' @param path_to_export Banking CSV export
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#' @description Reads the banking CSV export and writes an initial entry into the
#' working directory. It contains the ledger starting date as well the initial balance.
#' This is used as a starting point for a cumulative history plot.
#'
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @importFrom lubridate dmy
#' @importFrom readr write_excel_csv2
#' @importFrom readr parse_number
#' @importFrom tidyr replace_na
#' @importFrom dplyr bind_rows
#' @keywords internal
write_initbalance <- function(path_to_export, path_to_ledgerdir) {
  sl_path <- paste0(path_to_ledgerdir, "short_ledger.csv")
  test_ledger_dir(path_to_ledgerdir)
  test_short_ledger(sl_path)

  short_ledger <- read_delim(sl_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  # TODO test if init entry already exists
  amount_initbal <- short_ledger %>%
    filter(.data$recipient == "LEDGER INITIAL BALANCE") %>%
    nrow()

  if (amount_initbal > 1) {
    stop("initial balance has been set already!")
  }

  # read file
  suppressWarnings({
    ledger_import <- read_delim(path_to_export,
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

  first_balance <- sum(short_ledger$amount) * -1 + last_balance

  # stub entry with same formatting
  first_entry <- data.frame(
    date = NA,
    recipient = "LEDGER INITIAL BALANCE",
    amount = 0
  )

  fe_df <- format_export(first_entry)
  fe_df$balance <- first_balance
  fe_df$date <- first_date


  # add as first row to short ledger
  short_ledger <- bind_rows(fe_df, short_ledger)
  short_ledger$balance <- replace_na(short_ledger$balance, 0)

  # write and print
  readr::write_excel_csv2(short_ledger, sl_path)
  print("added initial balance to short_ledger")
}
