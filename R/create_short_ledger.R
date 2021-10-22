#' Write short ledger to disk using DKB CSV export
#'
#' @param path_to_export Path to DKB CSV export file
#'
#' @description Wrapper around format_export(), which writes short ledger to disc
#'
#' @export
#'
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @importFrom readr write_excel_csv2
#'
create_short_ledger <- function(path_to_export) {

  # debugging
  # path_to_export <- "dkb_export_20211017.csv"

  dkbexport <- read_delim(path_to_export,
    ";",
    escape_double = FALSE, locale = locale(encoding = "ISO-8859-1", decimal_mark = ","),
    trim_ws = TRUE, skip = 6, col_types = cols()
  )

  short_ledger <- ledger2::format_export(dkbexport)

  write_excel_csv2(short_ledger, "short_ledger.csv")

  print("wrote short_ledger")
}
