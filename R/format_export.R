#' Transform cleaned export to short ledger format
#'
#' @param export_clean CSV dataframe.
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
#' @importFrom dplyr '%>%'
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom lubridate dmy
#' @importFrom lubridate floor_date
#' @importFrom rlang .data
#' @importFrom dplyr arrange
#' @keywords internal
#' @md
#'
format_export <- function(export_clean) {
  short_ledger <- export_clean %>%
    mutate(
      date = dmy(.data$date),
      date_custom = NA,
      year = floor_date(date, unit = "year"),
      month = floor_date(date, unit = "month"),
      quarter = floor_date(date, unit = "quarter"),
      recipient = .data$recipient,
      recipient_clean_custom = NA,
      amount = .data$amount,
      amount_custom = NA,
      balance = as.numeric(0),
      type = ifelse(.data$amount > 0, "Income", "Expense"),
      label1_custom = "unknown",
      label2_custom = "unknown",
      label3_custom = "unknown",
      occurence = 0
    ) %>%
    arrange(date)

  return(short_ledger)
}
