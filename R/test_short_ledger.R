#' Tests for short ledger.
#'
#' @param path_to_shortledger Path to short ledger.
#'
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @keywords internal
#'
test_short_ledger <- function(path_to_shortledger) {

  # check for file
  if (!file.exists(path_to_shortledger)) {
    stop("short ledger doesnt exist in ledger dir")
  }

  short_ledger <- read_delim(path_to_shortledger,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  # check for column names
  sl_colnames <- c(
    "date", "recipient", "amount", "balance", "date_custom",
    "year", "quarter", "month", "recipient_clean_custom",
    "amount_custom", "type", "label1_custom", "label2_custom",
    "label3_custom", "occurence"
  )
  sl_colamount <- length(sl_colnames)

  if (sum(sl_colnames %in% colnames(short_ledger)) != sl_colamount) {
    stop("columns in short ledger are malformed")
  }

  # check if short ledger has rows
  if (nrow(short_ledger) == 0) {
    stop("short ledger has no rows")
  }
}
