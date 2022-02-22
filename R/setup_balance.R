#' Add initial balance entry to ledger
#'
#' @param path_to_export Path to export
#' @param export_type Specify which bank export will be used
#' @param path_to_ledgerdir Path to directory that contains all ledger files
#'
#' @keywords internal
#' @import readr
#' @import dplyr
#' @import lubridate
setup_balance <- function(path_to_export, export_type, path_to_ledgerdir) {

  check_ledger_dir(path_to_ledgerdir)
  ledger_path <- paste0(path_to_ledgerdir, "ledger.csv")
  check_ledger(ledger_path)

  ledger <- read_delim(ledger_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8",
                                           decimal_mark = ","),
    trim_ws = TRUE, col_types = cols(),progress = F
  )

  check_initial_balance(ledger)

  switch(export_type,
    "dkb" = {lib_base <- setup_balance_dkb(path_to_export, ledger)},
    "bbb" = {lib_base <- setup_balance_bbb(path_to_export, ledger)}
  )

  initial_balance <- lib_base %>%
    mutate(
      date_custom = NA,
      amount_custom = NA,
      type = "Expense",
      occurence = 0,
      recipient_clean = "unknown",
      recipient_clean_custom = NA,
      label1 = "unknown",
      label1_custom = NA,
      label2 = "unknown",
      label2_custom = NA,
      label3 = "unknown",
      label3_custom = NA,
    )

  ledger <- bind_rows(initial_balance, ledger)

  # write and print
  write_excel_csv2(ledger, ledger_path,progress = F)
  print("added initial balance to ledger")

}
