#' Appends new exports to your ledger
#'
#' @param path_to_export Path to export
#' @param export_type Specify which bank export will be used
#' @param path_to_ledgerdir Path to directory that contains all ledger files
#'
#' @export
#' @import readr
#' @import dplyr
append_ledger <- function(path_to_export, export_type, path_to_ledgerdir) {
  check_ledger_dir(path_to_ledgerdir)
  ledger_path <- paste0(path_to_ledgerdir, "ledger.csv")
  check_ledger(ledger_path)
  check_export_type(export_type)

  # bank specific cleaning and creating short ledger format
  ledger_appendage <- transform_export(path_to_export, export_type)

  # read current ledger
  suppressWarnings({
    current_ledger <- read_delim(ledger_path,
                                       ";",
                                       escape_double = FALSE,
                                       locale = locale(encoding = "UTF-8",
                                                       decimal_mark = ","),
                                       trim_ws = TRUE, col_types = cols(), progress = F
    )
  })

  # determine cut off dates and filter
  cutoff_date <- max(current_ledger$date)

  current_ledger <- current_ledger %>%
    filter(date < cutoff_date)

  ledger_appendage <- ledger_appendage %>%
    filter(date >= cutoff_date)

  #
  newrow_count <- nrow(ledger_appendage)

  # append
  updated_ledger <- rbind(current_ledger, ledger_appendage)

  # write and print
  write_excel_csv2(updated_ledger, ledger_path)
  print(paste0("appended ", newrow_count, " new entries to ledger!"))

  update_ledger(path_to_ledgerdir)

}