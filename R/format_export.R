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
#' @importFrom dplyr mutate
#' @importFrom dplyr arrange
#' @importFrom rlang .data
#' @keywords internal
#' @md
#'
format_export <- function(export_clean) {
  short_ledger <- export_clean %>%
    mutate(
      date_custom = NA,
      amount_custom = NA,
      balance = as.numeric(0),
      type = ifelse(.data$amount > 0, "Income", "Expense"),
      occurence = 0
    ) %>%
    arrange(date)

  return(short_ledger)
}
