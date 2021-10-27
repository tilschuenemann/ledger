#' Update Custom Dates
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#' @description Recalculates year, quarter and month columns using date column
#' (default) or date_custom column (user input)
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
#'
update_cdates <- function(path_to_ledgerdir) {
  sl_path <- paste0(path_to_ledgerdir, "short_ledger.csv")
  test_ledger_dir(path_to_ledgerdir)
  test_short_ledger(sl_path)

  short_ledger <- read_delim(sl_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  short_ledger$date_custom <- ymd(short_ledger$date_custom)

  # TODO date temp is not a clean solution
  short_ledger <- short_ledger %>%
    select(-.data$year, -.data$quarter, -.data$month) %>%
    mutate(
      date_temp = coalesce(.data$date_custom, .data$date),
      year = floor_date(.data$date_temp, "year"),
      quarter = floor_date(.data$date_temp, "quarter"),
      month = floor_date(.data$date_temp, "month")
    ) %>%
    select(-.data$date_temp) %>%
    relocate(c(.data$year, .data$quarter, .data$month), .after = .data$date_custom)

  # write and print
  readr::write_excel_csv2(short_ledger, sl_path)
  print("updated custom dates")
}
