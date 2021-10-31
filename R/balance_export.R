#' Title
#'
#' @param path_to_export
#' @param export_type
#' @param ledger_turnover
#'
#' @keywords internal
#'
#' @importFrom readr cols
#' @importFrom readr read_delim
#' @importFrom lubridate dmy
#' @importFrom readr locale
#' @importFrom readr parse_number
#' @importFrom dplyr mutate
#'
balance_export <- function(path_to_export, export_type, ledger_turnover){

  ledger_initial_balance <- switch (export_type,
    "dkb" = {
      #read file
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

      lib_base <- data.frame(date = first_date,
                                           amount = 0,
                                           recipient = "~~LEDGER INITIAL BALANCE",
                                           balance = first_balance)
    })

  lib_short <- lib_base %>%
    mutate(date_custom = NA,
           amount_custom = NA,
           type = "Expense",
           occurence = 0)
  return(lib_short)

}


