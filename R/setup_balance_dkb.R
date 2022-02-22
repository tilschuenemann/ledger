#' Title
#'
#' @param path_to_export
#' @param ledger
#'
#' @return
#' @export
#'
#' @import readr
#' @import dplyr
#' @import lubridate
setup_balance_dkb <- function(path_to_export, ledger){

  ledger_turnover <- sum(ledger$amount) * -1

  suppressWarnings({
    ledger_import <- read_delim(path_to_export,
                                ";",
                                escape_double = FALSE, locale = locale(encoding = "ISO-8859-1",
                                                                       decimal_mark = ","),
                                trim_ws = TRUE, col_types = cols(),
                                name_repair = "minimal", progress = F
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

  return(lib_base)
}