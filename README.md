
# ledger

<!-- badges: start -->
[![R-CMD-check](https://github.com/tilschuenemann/ledger/workflows/R-CMD-check/badge.svg)](https://github.com/tilschuenemann/ledger2/actions)
[![Codecov test coverage](https://codecov.io/gh/tilschuenemann/ledger2/branch/main/graph/badge.svg)](https://app.codecov.io/gh/tilschuenemann/ledger2?branch=main)
<!-- badges: end -->

ledger is an interface for formatting banking exports. The general idea is that every bank export should provide 
tabular data with 1. a date, 2. a recipient and 3. the amount that was exchanged. This is the base format, which is used for creating the ledger.

That is the foundation for visualisation and dashboarding. I've started to work on a Shiny app, which I'll reference here when it's online.

## Table of Contents
- [Workflow](#workflow)
- [Custom Data Entry](#custom-data-entry)
- [Occurence](#occurence)
- [Supported Exports](#supported-exports)
- [Testing](#testing)

## Workflow

```r
library("ledger2")

ledger_dir <- "my_ledger/"              # designated directory for all your ledger files
export_type <- "dkb"                    # specify from which bank your export is from
dkb_export <- "dkb_export_20210101.csv" # path to your export

# starting a ledger
create_ledger(dkb_export, export_type, ledger_dir)

# updating ledgers mapping table or balance
update_ledger(ledger_dir)

# append a new ledger to your short ledger
dkb_export2 <- "dkb_export_20211201.csv"
append_ledger(dkb_export2, export_type, ledger_dir)
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

If you want to contribute another export, this is what you need supply:

1. Add your bank to valid_types in text_export_type.R

2. Add your section inside the switch case to clean_export.R. Generally the export is read
and tailored to the base format (date, recipient, amount)

3. In balance_export.R you'll need to add an extra case inside the switch case statement.
 The initial balance gets set from the export. 


## Testing
The existing tests are called in every function and will check if the ledger directory and its files(short ledger, mapping table) actually exist, if they have at least one row and if the column names match.
