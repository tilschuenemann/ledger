#' Update the Mapping Table.
#' @param path_to_ledgerdir Path to directory that contains all ledger files.
#' @description Updates the mapping table CSV in the working directory. If there
#' is an existing mapping table, new entries will be appended.
#'
#' Instead of NA "unknown" is set as it can be ordered in plots later.
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
#' @importFrom rlang .data
#' @keywords internal
update_maptab <- function(path_to_ledgerdir) {
  sl_path <- paste0(path_to_ledgerdir, "short_ledger.csv")
  mp_path <- paste0(path_to_ledgerdir, "maptab.csv")

  # run tests
  test_ledger_dir(path_to_ledgerdir)
  test_short_ledger(sl_path)
  test_maptab(mp_path)

  short_ledger <- read_delim(sl_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  # get distinct recipients
  new_maptab <- short_ledger %>%
    group_by(.data$recipient) %>%
    distinct(.data$recipient) %>%
    arrange(.data$recipient)

  # replace all NAs
  new_maptab <- new_maptab %>%
    replace(is.na(.), "unknown")

  if (file.exists(mp_path)) {
    print("found old mapping table")

    old_maptab <- read_delim(mp_path,
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

  # write and print
  readr::write_excel_csv2(maptab, mp_path)
  print("updated mapping table and added ",nrow(new_entries)," new rows")
}
