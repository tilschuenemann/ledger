#' Tests for ledger
#'
#' @param path_to_ledger Path to ledger
#'
#' @keywords internal
#' @import readr
check_ledger <- function(path_to_ledger) {

  # check for file
  if (!file.exists(path_to_ledger)) {
    stop("ledger doesnt exist in ledger dir")
  }

  ledger <- read_delim(path_to_ledger,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8",
                                           decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  # check for column names
  l_colnames <- c(
    "date", "recipient", "amount", "balance", "date_custom",
    "amount_custom", "type", "occurence", "label1", "label1_custom",
    "label2", "label2_custom", "label3", "label3_custom", "recipient_clean",
    "recipient_clean_custom"
  )
  l_colamount <- length(l_colnames)

  if (sum(l_colnames %in% colnames(ledger)) != l_colamount) {
    stop("columns in short ledger are malformed")
  }

  # check if short ledger has rows
  if (nrow(ledger) == 0) {
    stop("short ledger has no rows")
  }
}
