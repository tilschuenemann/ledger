#' Title
#'
#' @export
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
update_balance <- function() {

  short_ledger <- read_delim("short_ledger.csv",
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



  balances <- data.frame(amount = c(initial_balance$amount, short_ledger$amount))

  balances <- balances %>%
    mutate(balance = cumsum(.data$amount)) %>%
    slice(2:n())

  short_ledger$balance <- balances$balance

  write_excel_csv2(short_ledger, "short_ledger.csv")

}


