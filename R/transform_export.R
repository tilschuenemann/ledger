#' Title
#'
#' @param path_to_export path to  export
#' @param export_type Specify which bank export will be used.
#' @description Transforms the export CSV dataframe to the short ledger format.
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
#' @keywords internal
#'
#' @importFrom readr read_delim
#' @importFrom readr cols
#' @importFrom readr locale
#' @importFrom dplyr select
#' @importFrom dplyr rename
#' @importFrom dplyr '%>%'
#' @importFrom dplyr mutate
#' @importFrom dplyr arrange
#' @importFrom rlang .data
#' @importFrom lubridate dmy

transform_export <- function(path_to_export, export_type) {
  # clean to base ledger (date, recipient, amount)
  switch(export_type,
         dkb = {
           suppressWarnings({
             export <- read_delim(path_to_export,
                                  ";",
                                  escape_double = FALSE, locale = locale(encoding = "ISO-8859-1", decimal_mark = ","),
                                  trim_ws = TRUE, skip = 6, col_types = cols()
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

  short_ledger <- base_ledger %>%
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