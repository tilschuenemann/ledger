#' Transforms export to ledger format
#'
#' @param path_to_export Path to export
#' @param export_type Specify which bank export will be used
#'
#' @keywords internal
#' @import dplyr
#' @import readr
#' @import lubridate
#' @import rlang
#'
transform_export <- function(path_to_export, export_type) {

  switch(export_type,
         dkb = {base_ledger <- transform_export_dkb(path_to_export)},
         bbb = {base_ledger <- transform_export_bbb(path_to_export)}
  )

  ledger <- base_ledger %>%
    mutate(
      date_custom = NA,
      amount_custom = NA,
      balance = as.numeric(0),
      type = ifelse(.data$amount > 0, "Income", "Expense"),
      occurence = 0,
      recipient_clean = "unknown",
      recipient_clean_custom = NA,
      label1 = "unknown",
      label1_custom = NA,
      label2 = "unknown",
      label2_custom = NA,
      label3 = "unknown",
      label3_custom = NA,
    ) %>%
    arrange(date)

  return(ledger)

}