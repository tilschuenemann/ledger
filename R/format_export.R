#' Transform DKB export to short ledger format
#'
#' @param dkbexport_df The DKB CSV dataframe.
#'
#' @description Transforms the DKV CSV dataframe to the short ledger format.
#' The final columns are:
#'
#' * date
#' * amount
#' * recipient
#' * date_custom
#' * year
#' * quarter
#' * month
#' * recipient_clean_custom
#' * amount_custom
#' * type
#' * label1_custom
#' * label2_custom
#' * label3_custom
#'
#' @return Ledger in short format.
#' @export
#'
#' @importFrom dplyr '%>%'
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom lubridate dmy
#' @importFrom lubridate floor_date
#' @importFrom rlang .data
#' @md
format_export <- function(dkbexport_df) {

  # clean column names
  colnames(dkbexport)<- colnames(dkbexport)  %>%
    gsub(pattern ="[^[:alpha:]*]" ,replacement = "",) %>%
    iconv(to='ASCII//TRANSLIT')

  short_ledger <- dkbexport_df %>%
    select(1, 4, 8) %>%
    mutate(
      date = dmy(.data$Buchungstag),
      date_custom = NA,
      year = floor_date(date, unit = "year"),
      month = floor_date(date, unit = "month"),
      quarter = floor_date(date, unit = "quarter"),
      recipient = .data$AuftraggeberBegunstigter,
      recipient_clean_custom = NA,
      amount = .data$BetragEUR,
      amount_custom = NA,
      type = ifelse(.data$amount > 0, "Income", "Expense"),
      label1_custom = "unknown",
      label2_custom = "unknown",
      label3_custom = "unknown"
    ) %>%
    select(-.data$Buchungstag, -.data$BetragEUR, -.data$AuftraggeberBegunstigter)

  return(short_ledger)
}
