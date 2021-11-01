#' Sort ledger
#'
#' @param ledger Dataframe containing ledger
#' @param ledger_type "short" or "wide"
#'
#' @export
#' @keywords internal
#' @importFrom dplyr '%>%'
#' @importFrom dplyr select
sort_ledger <- function(ledger, ledger_type){

  if(ledger_type != "short" | ledger_type != "wide"){
    stop("ledger type not short or wide")
  }

  if(ledger_type == "short"){
    ledger_ordered <- ledger %>%
      select(.data$date, .data$date_custom, .data$amount, .data$amount_custom,
             .data$recipient, .data$occurence, .data$type, .data$balance)
  } else if(ledger_type =="wide"){
    ledger_ordered <- ledger %>%
      select(.data$date, .data$date_custom, .data$amount, .data$amount_custom,
             .data$recipient, .data$occurence, .data$type, .data$balance,
             .data$recipient_clean, .data$recipient_clean_custom, .data$label1,
             .data$label1_custom, .data$label2,.data$label2_custom, .data$label3,
             .data$label3_custom)
  }

  return(ledger_ordered)
}
