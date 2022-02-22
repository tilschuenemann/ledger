#' Title
#'
#' @param ledger
#'
#' @return
#' @export
#'
#' @import lubridate
setup_balance_bbb <- function(path_to_export, ledger){

  suppressWarnings({
    export <- read_delim(path_to_export,
                         ";",
                         escape_double = FALSE,
                         locale = locale(encoding = "ISO-8859-1",
                                         decimal_mark = ","),
                         trim_ws = TRUE, skip = 13, col_types = cols(),
                         name_repair = "minimal"
    )
  })

  initial_balance <- export[export$Kundenreferenz=="Anfangssaldo" & !is.na(export$Kundenreferenz),]$Umsatz

  lib_base <- data.frame(
    date = ymd(min(ledger$date)),
    amount = initial_balance,
    recipient = "~~LEDGER INITIAL BALANCE",
    balance = 0)

  return(lib_base)
}
