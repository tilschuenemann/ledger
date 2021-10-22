
#' Write wide ledger to disc
#'
#' @description Reads short ledger and mapping table in working directory,
#' joins them and writes a CSV.
#'
#' @export
#'
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @importFrom dplyr left_join
#' @importFrom readr write_excel_csv2
#'
create_wide_ledger <- function() {
  if (!file.exists("short_ledger.csv") || !file.exists("maptab.csv")) {
    stop("either short ledger or maptab dont exist in wd!")
  }

  short_ledger <- read_delim("short_ledger.csv",
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  maptab <- read_delim("maptab.csv",
    delim = ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  wide_ledger <- left_join(short_ledger, maptab, by = "recipient")

  readr::write_excel_csv2(wide_ledger, "wide_ledger.csv")

  print("wrote wide_ledger")
}
