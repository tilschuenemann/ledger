
#' Updates ledger mappings.
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#'
#' @export
#' @import dplyr
#' @import readr
#' @import rlang
update_ledger_mappings <- function(path_to_ledgerdir) {
  ledger_path <- paste0(path_to_ledgerdir, "ledger.csv")
  mp_path <- paste0(path_to_ledgerdir, "maptab.csv")
  check_ledger_dir(path_to_ledgerdir)
  check_ledger(ledger_path)
  check_maptab(mp_path)


  ledger <- read_delim(ledger_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8",
                                           decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  maptab <- read_delim(mp_path,
    delim = ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8",
                                           decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  # TODO check if this step is necessary or if it can be done in left_join
  ledger <- ledger %>%
    select(-.data$recipient_clean, -.data$label1, -.data$label2, -.data$label3)

  mapped_ledger <- left_join(ledger, maptab, by = "recipient") %>%
    mutate(recipient_clean_custom = NA,
           label1_custom = NA,
           label2_custom = NA,
           label3_custom = NA)

  # write and print
  write_excel_csv2(mapped_ledger, ledger_path)
  print("updated ledger mappings")
}
