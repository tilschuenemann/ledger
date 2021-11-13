test_that("ledger columns are malformed", {
  expect_error(ledger:::check_ledger(test_path("ledger_malformed1.csv"))
    ,"columns in short ledger are malformed")
})
test_that("ledger has no rows", {
  expect_error(ledger:::check_ledger(test_path("ledger_malformed2.csv"))
               ,"short ledger has no rows")
})

test_that("ledger doesnt exist", {
  expect_error(ledger:::check_ledger(test_path("non_existent_ledger.csv"))
               ,"ledger doesnt exist in ledger dir")
})