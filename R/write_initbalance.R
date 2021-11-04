
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
#' @importFrom readr write_excel_csv2
#' @importFrom dplyr bind_rows
#' @importFrom lubridate dmy
#' @importFrom readr parse_number
#' @importFrom dplyr mutate
#' @keywords internal
write_initbalance <- function(path_to_export, export_type, path_to_ledgerdir) {
  sl_path <- paste0(path_to_ledgerdir, "short_ledger.csv")
  test_ledger_dir(path_to_ledgerdir)
  test_short_ledger(sl_path)


  short_ledger <- read_delim(sl_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  # test if init entry already exists
  amount_initbal <- short_ledger %>%
    filter(.data$id == 0 & .data$recipient == "~~LEDGER INITIAL BALANCE") %>%
    nrow()

  if (amount_initbal > 1) {
    stop("initial balance has been set already!")
  }

  ledger_turnover <- sum(short_ledger$amount) * -1

  # add initial balance according to export type from export
  ledger_initial_balance <- switch(export_type,
    "dkb" = {
      # read file
      suppressWarnings({
        ledger_import <- read_delim(path_to_export,
          ";",
          escape_double = FALSE, locale = locale(encoding = "ISO-8859-1", decimal_mark = ","),
          trim_ws = TRUE, col_types = cols()
        )
      })

      first_date <- dmy(ledger_import[1, 2])
      last_balance <- ledger_import[3, 2] %>%
        gsub(pattern = "[[:alpha:]]|[[:blank:]]", replacement = "") %>%
        parse_number(locale = locale(decimal_mark = ",", grouping_mark = "."))

      first_balance <- ledger_turnover + last_balance

      lib_base <- data.frame(
        date = first_date,
        amount = 0,
        recipient = "~~LEDGER INITIAL BALANCE",
        balance = first_balance,
        id = 0
      )
    }
  )

  initial_balance <- lib_base %>%
    mutate(
      date_custom = NA,
      amount_custom = NA,
      type = "Expense",
      occurence = 0
    )

  # add as first row to short ledger
  short_ledger <- bind_rows(initial_balance, short_ledger)

  short_ledger <- sort_ledger(short_ledger, "short")

  # write and print
  readr::write_excel_csv2(short_ledger, sl_path)
  print("added initial balance to short_ledger")
}
