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
transform_export <- function(path_to_export, export_type) {

  # clean to base ledger (date, recipient, amount)
  switch(export_type,
# dkb ---------------------------------------------------------------------
         dkb = {
           suppressWarnings({
             export <- read_delim(path_to_export,
                                  ";",
                                  escape_double = FALSE,
                                  locale = locale(encoding = "ISO-8859-1",
                                                  decimal_mark = ","),
                                  trim_ws = TRUE, skip = 6, col_types = cols(),
                                  name_repair = "minimal"
             )
           })

           base_ledger <- export %>%
             select(1, 4, 8) %>%
             rename(
               date = 1,
               recipient = 2,
               amount = 3) %>%
             mutate(
               date = dmy(.data$date))
         }
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