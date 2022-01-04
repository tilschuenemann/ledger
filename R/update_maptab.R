#' Update the mapping table
#'
#' @param path_to_ledgerdir Path to directory that contains all ledger files
#'
#' @keywords internal
#' @import dplyr
#' @import tidyr
#' @import readr
#' @import rlang
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

    maptab <- left_join(new_maptab,old_maptab, by = "recipient")

    # replace NAs except in recipient
    # TODO tidy selection everything except recipient
    maptab <- maptab %>%
      mutate(across(c(.data$recipient_clean,.data$label1,.data$label2,.data$label3),~ replace_na(.,"unknown")))

    new_rows <- nrow(anti_join(new_maptab, old_maptab, by = "recipient"))

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
  write_excel_csv2(maptab, mp_path)

  if (new_rows>0) {
    print(paste0("added ",new_rows," new recipients to mapping table"))
  }

}
