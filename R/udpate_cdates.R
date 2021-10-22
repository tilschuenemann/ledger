#' Update Custom Dates
#'
#' @param wide_ledger Path to wide ledger file
#'
#' @description Recalculates year, quarter and month columns using date column
#' (default) or date_custom column (user input)
#'
#' @export
#'
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @importFrom lubridate ymd
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr coalesce
#' @importFrom lubridate floor_date
#' @importFrom readr write_excel_csv2
#' @importFrom dplyr relocate
#' @importFrom rlang .data

udpate_cdates <- function(wide_ledger) {
  wide_ledger <- read_delim("wide_ledger.csv",
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  wide_ledger$date_custom <- ymd(.data$date_custom)

  # TODO date temp is not a clean solution
  wide_ledger <- wide_ledger %>%
    select(-.data$year, -.data$quarter, -.data$month) %>%
    mutate(
      date_temp = coalesce(.data$date_custom, .data$date),
      year = floor_date(.data$date_temp, "year"),
      quarter = floor_date(.data$date_temp, "quarter"),
      month = floor_date(.data$date_temp, "month")
    ) %>%
    select(-.data$date_temp) %>%
    relocate(c(.data$year,.data$quarter,.data$month),.after = .data$date_custom)

  readr::write_excel_csv2(wide_ledger, "wide_ledger.csv")
  print("updated custom dates")
}
