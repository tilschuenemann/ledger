#' Transformation for DKB bank
#'
#' @param export
#'
#' @export
#'
#' @import readr
#' @import dplyr
#' @import lubridate
#' @import rlang
#'
transform_export_dkb <- function(path_to_export){

  # suppress warnings for muting console printing of read_delim
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

  return(base_ledger)

}