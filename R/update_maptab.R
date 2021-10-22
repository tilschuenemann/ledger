#' Update the Mapping Table
#'
#' @description Updates the mapping table CSV in the working directory. If there
#' is an existing mapping table, new entries will be appended.
#'
#' Instead of NA "unknown" is set as it can be ordered in plots later.
#'
#' @export
#'
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @importFrom dplyr group_by
#' @importFrom dplyr distinct
#' @importFrom dplyr arrange
#' @importFrom dplyr left_join
#' @importFrom dplyr mutate
#' @importFrom readr write_excel_csv2

update_maptab <- function() {
  if (file.exists("short_ledger.csv")) {
    short_ledger <- read_delim("short_ledger.csv",
      ";",
      escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
      trim_ws = TRUE, col_types = cols()
    )
  } else {
    stop("no short ledger in wd found!")
  }

  # get distinct recipients
  new_maptab <- short_ledger %>%
    group_by(recipient) %>%
    distinct(recipient) %>%
    arrange(recipient)

  # look for file in wd
  if (file.exists("maptab.csv")) {
    print("found old mapping table")

    old_maptab <- read_delim("maptab.csv",
      delim = ";",
      escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
      trim_ws = TRUE, col_types = cols()
    )

    maptab <- left_join(new_maptab, old_maptab, by = "recipient")
  } else {
    maptab <- new_maptab %>%
      mutate(
        recipient_clean = "unknown",
        label1 = "unknown",
        label2 = "unknown",
        label3 = "unknown"
      )
  }

  readr::write_excel_csv2(maptab, "maptab.csv")
  print("updated mapping table")
}
