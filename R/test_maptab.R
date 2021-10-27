#' Tests for mapping table.
#'
#' @param path_to_maptab Path to mapping table.
#'
#' @importFrom readr read_delim
#' @importFrom readr cols
#' @importFrom readr locale
#' @keywords internal
#'
test_maptab <- function(path_to_maptab) {

  # dont test maptab if there isnt one
  if (!file.exists(path_to_maptab)) {
    return()
  }

  mapping_table <- read_delim(path_to_maptab,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  # check for column names
  mp_colnames <- c(
    "recipient", "recipient_clean", "label1", "label2",
    "label3"
  )
  mp_colamount <- length(mp_colnames)

  if (sum(mp_colnames %in% colnames(mapping_table)) != mp_colamount) {
    stop("columns in mapping table are malformed")
  }

  # check if mapping table has rows
  if (nrow(mapping_table) == 0) {
    stop("mapping_table has no rows")
  }
}
