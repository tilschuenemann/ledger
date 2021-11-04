
#' Write wide ledger to disc
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
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
#' @importFrom dplyr mutate
#'
create_wide_ledger <- function(path_to_ledgerdir) {
  sl_path <- paste0(path_to_ledgerdir, "short_ledger.csv")
  mp_path <- paste0(path_to_ledgerdir, "maptab.csv")
  wl_path <- paste0(path_to_ledgerdir, "wide_ledger.csv")
  test_ledger_dir(path_to_ledgerdir)
  test_short_ledger(sl_path)
  test_maptab(mp_path)


  short_ledger <- read_delim(sl_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  maptab <- read_delim(mp_path,
    delim = ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  wide_ledger <- left_join(short_ledger, maptab, by = "recipient") %>%
    mutate(recipient_clean_custom = NA,
           label1_custom = NA,
           label2_custom = NA,
           label3_custom = NA)

  # sort ledger
  wide_ledger <- sort_ledger(wide_ledger, "wide")

  # write and print
  readr::write_excel_csv2(wide_ledger, wl_path)
  print("wrote wide_ledger")
}
