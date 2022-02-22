#' Transformation for BBB bank
#'
#' @param path_to_export path_to_export
#'
#' @export
#'
#' @import readr
#' @import dplyr
#' @import lubridate
#' @import rlang
#' @import utils
#'
transform_export_bbb <- function(path_to_export){

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

  export <- head(export, - 3)

  base_ledger <- export %>%
    select(1, 5, 13, 14) %>%
    rename(
      date = 1,
      recipient = 2,
      amount = 3,
      amount_type = 4)

  base_ledger$amount_type <- replace(base_ledger$amount_type,
                                     base_ledger$amount_type=="S",
                                     -1)
  base_ledger$amount_type <- replace(base_ledger$amount_type,
                                     base_ledger$amount_type=="H",
                                     1)

  base_ledger <- base_ledger %>%
    mutate(
      amount = .data$amount*as.numeric(.data$amount_type),
      date = dmy(.data$date)) %>%
    select(-.data$amount_type)

  return(base_ledger)
}