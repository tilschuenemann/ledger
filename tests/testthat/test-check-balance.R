test_that("multiplication works", {

 expect_error(ledger:::setup_balance(test_path("dkb_example_export.csv"),"dkb",path_to_ledgerdir = test_path("./")),
              "initial balance has been set already!")

  })
