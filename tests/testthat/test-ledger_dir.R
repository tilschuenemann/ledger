test_that("ledger_dir parameter isnt a character vector", {
  expect_error(ledger:::check_ledger_dir(1),
               "path_to_ledgerdir is not a character vector")

})

test_that("ledger_dir parameter is empty string", {
  expect_error(ledger:::check_ledger_dir(""),
               "path_to_ledgerdir is empty")

})

test_that("ledger_dir doesnt exist", {
  expect_error(ledger:::check_ledger_dir("./error/"),
               "ledger dir does not exist")

})