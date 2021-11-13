test_that("create ledger", {


  expect_output(  create_ledger(path_to_ledgerdir = test_path("./"),
                                 export_type = "dkb",
                                 path_to_export = test_path("dkb_example_export.csv")),
                 "wrote ledger")

  expect_true(file.exists(test_path("ledger.csv")))

})
