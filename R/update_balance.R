#' Update balance column in ledger
#'
#' @param path_to_ledgerdir Path to directory that contains all ledger files
#'
#' @keywords internal
#' @import readr
#' @import dplyr
update_balance <- function(path_to_ledgerdir) {

  ledger_path <- paste0(path_to_ledgerdir, "ledger.csv")

  check_ledger_dir(path_to_ledgerdir)
  check_ledger(ledger_path)

  ledger <- read_delim(ledger_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8",
                                           decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  ledger <- ledger %>%
    arrange(date)


  inital_amount = ledger[ledger$recipient=="~~LEDGER INITIAL BALANCE" & !is.na(ledger$recipient),]$balance

  balances <- data.frame(amount = c(inital_amount, ledger$amount))
  balances <- balances %>%
    mutate(balance = cumsum(.data$amount)) %>%
    slice(2:n())

  ledger$balance <- balances$balance

  write_excel_csv2(ledger, ledger_path)
  print("updated ledger balances")
}
