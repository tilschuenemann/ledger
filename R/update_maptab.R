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
#' @importFrom readr write_excel_csv2
#' @importFrom rlang .data
#' @importFrom dplyr anti_join
#' @importFrom dplyr mutate_at
#' @importFrom tidyr replace_na
#' @importFrom dplyr vars
#' @keywords internal
update_maptab <- function(path_to_ledgerdir) {

  ledger_path <- paste0(path_to_ledgerdir, "ledger.csv")
  mp_path <- paste0(path_to_ledgerdir, "maptab.csv")

  # run tests
  check_ledger_dir(path_to_ledgerdir)
  check_ledger(ledger_path)
  check_maptab(mp_path)

  ledger <- read_delim(ledger_path,
    ";",
    escape_double = FALSE, locale = locale(encoding = "UTF-8",
                                           decimal_mark = ","),
    trim_ws = TRUE, col_types = cols()
  )

  # get distinct recipients
  new_maptab <- ledger %>%
    group_by(.data$recipient) %>%
    distinct(.data$recipient) %>%
    arrange(.data$recipient)

  if (file.exists(mp_path)) {

    print("found old mapping table")

    old_maptab <- read_delim(mp_path,
      delim = ";",
      escape_double = FALSE, locale = locale(encoding = "UTF-8",
                                             decimal_mark = ","),
      trim_ws = TRUE, col_types = cols()
    )

    maptab <- left_join(old_maptab, new_maptab, by = "recipient")

    # replace NAs except in recipient
    # TODO vars and mutate_at were superseded, ?across
    maptab <- maptab %>%
      mutate_at(vars(.data$recipient_clean, .data$label1, .data$label2,
                     .data$label3), ~replace_na(., "unknown"))

    new_rows <- nrow(anti_join(old_maptab, new_maptab, by = "recipient"))

  } else {
    maptab <- new_maptab %>%
      mutate(
        recipient_clean = "unknown",
        label1 = "unknown",
        label2 = "unknown",
        label3 = "unknown"
      )

    new_rows <- nrow(maptab)
  }

  # write and print
  readr::write_excel_csv2(maptab, mp_path)

}
