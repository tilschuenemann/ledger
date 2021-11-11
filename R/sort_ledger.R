#' Sort ledger columns
#'
#' @param ledger Dataframe containing ledger
#'
#' @keywords internal
#' @import readr
#' @import dplyr
#' @import rlang
#'
sort_ledger <- function(path_to_ledgerdir) {

  check_ledger_dir(path_to_ledgerdir)
  ledger_path <- paste0(path_to_ledgerdir, "ledger.csv")
  check_ledger(ledger_path)

  ledger <- read_delim(ledger_path,
                       ";",
                       escape_double = FALSE,
                       locale = locale(encoding = "UTF-8",
                                       decimal_mark = ","),
                       trim_ws = TRUE, col_types = cols()
  )

  # TODO ordering by select will remove all non specified columns
    ledger_ordered <- ledger %>%
      select(.data$date, .data$date_custom, .data$amount, .data$amount_custom,
             .data$recipient, .data$occurence, .data$type, .data$balance,
             .data$recipient_clean, .data$recipient_clean_custom, .data$label1,
             .data$label1_custom, .data$label2, .data$label2_custom,
             .data$label3, .data$label3_custom)

  write_excel_csv2(ledger_ordered, ledger_path)
  print("sorted ledger columns")
}
