#' Add initial balance entry to ledger
#'
#' @param path_to_export Path to export
#' @param export_type Specify which bank export will be used
#' @param path_to_ledgerdir Path to directory that contains all ledger files
#'
#' @keywords internal
#' @import readr
#' @import dplyr
#' @import lubridate
setup_balance <- function(path_to_export, export_type, path_to_ledgerdir) {

  # tests and prepare path
  check_ledger_dir(path_to_ledgerdir)
  ledger_path <- paste0(path_to_ledgerdir, "ledger.csv")
  check_ledger(ledger_path)



  ledger <- read_delim(ledger_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8",
                                           decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  # TODO extract to test class
  # test if init entry already exists
  amount_initbal <- ledger %>%
    filter(.data$recipient == "~~LEDGER INITIAL BALANCE") %>%
    nrow()

  if (amount_initbal >= 1) {
    stop("initial balance has been set already!")
  }

  ledger_turnover <- sum(ledger$amount) * -1

  # add initial balance according to export type from export
  initial_balance <- switch(export_type,

# dkb ---------------------------------------------------------------------
    "dkb" = {
      # read file
      suppressWarnings({
        ledger_import <- read_delim(path_to_export,
          ";",
          escape_double = FALSE, locale = locale(encoding = "ISO-8859-1",
                                                 decimal_mark = ","),
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
        balance = first_balance
      )
    }
  )

  initial_balance <- initial_balance %>%
    mutate(
      date_custom = NA,
      amount_custom = NA,
      type = "Expense",
      occurence = 0,
      recipient_clean = "unknown",
      recipient_clean_custom = "unknown",
      label1 = "unknown",
      label1_custom = "unknown",
      label2 = "unknown",
      label2_custom = "unknown",
      label3 = "unknown",
      label3_custom = "unknown"
    )

  # add as first row to short ledger
  ledger <- bind_rows(initial_balance, ledger)

  # write and print
  write_excel_csv2(ledger, ledger_path)
  print("added initial balance to ledger")

}
