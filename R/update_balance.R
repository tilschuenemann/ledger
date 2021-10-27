#' Update balance column in short ledger.
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom dplyr rename
#' @importFrom dplyr mutate
#' @importFrom dplyr arrange
#' @importFrom dplyr slice
#' @importFrom readr write_excel_csv2
#' @importFrom dplyr n
#' @keywords internal
update_balance <- function(path_to_ledgerdir) {
  sl_path <- paste0(path_to_ledgerdir, "short_ledger.csv")

  # run tests
  test_ledger_dir(path_to_ledgerdir)
  test_short_ledger(sl_path)

  short_ledger <- read_delim(sl_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  short_ledger <- short_ledger %>%
    arrange(date)

  initial_balance <- short_ledger %>%
    filter(.data$recipient == "LEDGER INITIAL BALANCE") %>%
    select(.data$balance) %>%
    rename(amount = 1)

  # TODO too difficult
  balances <- data.frame(amount = c(initial_balance$amount, short_ledger$amount))
  balances <- balances %>%
    mutate(balance = cumsum(.data$amount)) %>%
    slice(2:n())

  short_ledger$balance <- balances$balance

  # write and print
  write_excel_csv2(short_ledger, sl_path)
  print("updated short ledger balances")
}
