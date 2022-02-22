
# ledger

<!-- badges: start -->
[![R-CMD-check](https://github.com/tilschuenemann/ledger/workflows/R-CMD-check/badge.svg)](https://github.com/tilschuenemann/ledger2/actions)
[![codecov](https://codecov.io/gh/tilschuenemann/ledger/branch/main/graph/badge.svg?token=FY46JP4Y9X)](https://codecov.io/gh/tilschuenemann/ledger)
<!-- badges: end -->

ledger is an interface for formatting banking exports. The idea is that every bank export should provide tabular data with a date, a recipient and an amount. This data gets extended by this library to add a mapping table for categorization, enabling further analysis and dashboarding.


## Table of Contents
- [Workflow](#workflow)
- [Custom Data Entry](#custom-data-entry)
- [Occurence](#occurence)
- [Supported Exports](#supported-exports)
- [Testing](#testing)

## Workflow

```r
library("ledger")

ledger_dir <- "my_ledger/"              # designated directory for all your ledger files
export_type <- "dkb"                    # specify from which bank your export is from
dkb_export <- "dkb_export_20210101.csv" # path to your export

# starting a ledger
create_ledger(dkb_export, ledger_dir, export_type)

# updating ledgers mapping table or balance
update_ledger(ledger_dir)

# append a new ledger to your short ledger
dkb_export2 <- "dkb_export_20211201.csv"
append_ledger(dkb_export2, ledger_dir, export_type)
```

## Custom Data Entry
General labels are not always best - in case you want to overwrite data in a transparent way, you 
enter that in any of the *_custom columns:

* date_custom
* amount_custom
* recipient_clean_custom
* label1_custom
* label2_custom
* label3_custom

## Occurence
The occurence column is a way to specify how often that exact transaction occurs per year.
This is especially useful when determining what your baseline income and expense is.

## Supported Exports
Right now the following banking exports are supported:

* DKB
* BBB

If you want to contribute another export, this is what you need supply:

1. Add your bank to valid_types in check_export_type.R

2. Add functions transform_export_YOURBANK.R and setup_balance_YOURBANK.R

3. Implement the new function call in transform_export.R and setup_balance.R

4. Create a pull request!

## Testing
The existing tests are called in every function and will check if the ledger directory and its files(short ledger, mapping table) actually exist, if they have at least one row and if the column names match.
