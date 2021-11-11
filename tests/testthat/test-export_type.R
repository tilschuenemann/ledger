test_that("export type works", {

  expect_silent(ledger:::check_export_type("dkb"))
})

test_that("export type is not a character vector", {

  expect_error(ledger:::check_export_type(1),
                 "export_type is not a character vector")
  expect_error(ledger:::check_export_type(as.Date("2021-01-01")),
                 "export_type is not a character vector")
})

test_that("export type is empty string", {

  expect_error(ledger:::check_export_type(""),
               "export_type is empty")

})

test_that("export type not valid", {

  expect_error(ledger:::check_export_type("visa"),
               "export_type not valid")

})