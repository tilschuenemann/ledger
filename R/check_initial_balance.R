#' Title
#'
#' @param ledger
#'
#' @return
#' @export
#'
#' @import dplyr
check_initial_balance <- function(ledger){

  amount_initbal <- ledger %>%
    filter(.data$recipient == "~~LEDGER INITIAL BALANCE") %>%
    nrow()

  if (amount_initbal >= 1) {
    stop("initial balance has been set already!")
  }

}