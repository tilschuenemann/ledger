test_that("append ledger", {

  append_ledger(path_to_export = test_path("dkb_example_export_2.csv"),
                export_type = "dkb",
                path_to_ledgerdir = test_path("./"))

  expect_true(file.exists(test_path("ledger.csv")))

  ledger <- read_delim(test_path("ledger.csv"),
                               ";",
                               escape_double = FALSE,
                               locale = locale(encoding = "UTF-8",
                                               decimal_mark = ","),
                               trim_ws = TRUE, col_types = cols(),
  )

  l_rows <- nrow(ledger)
  expect_true(l_rows==25)
})