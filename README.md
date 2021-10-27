
# ledger

<!-- badges: start -->
[![R-CMD-check](https://github.com/tilschuenemann/ledger/workflows/R-CMD-check/badge.svg)](https://github.com/tilschuenemann/ledger2/actions)
<!-- badges: end -->

ledger is an interface automatically format banking exports. Once you have downloaded and fed your exports into this program, it will generate a ledger and optionally a mapping table for you.
You are free to choose the base (short ledger) or the extended form with mapped labels and clean names (wide ledger).

## Table of Contents
- [Workflow](#workflow)
- [Ledger Data Layout](#ledger-data-layout)
- [Custom Data Entry](#custom-data-entry)
- [Localization](#localization)
- [Testing](#testing)

## Workflow

```r
library("ledger2")
ledger_dir <- "my_ledger/"
dkb_export <- "dkb_export_20210101.csv"

# starting a ledger
start_short_ledger(dkb_export, "dkb", ledger_dir)

# updating ledgers cdates, maptab or balance
update_short_ledger(ledger_dir)

# create wide ledger
create_wide_ledger(ledger_dir)

# append a new ledger to your short ledger
dkb_export2 <- "dkb_export_20211201.csv"
append_short_ledger(dkb_export2, ledger_dir)
```

## Ledger Data Layout

| Column                 | Short Ledger | Wide Ledger |
|------------------------|--------------|-------------|
| date                   | +            | +           |
| amount                 | +            | +           |
| balance                | +            | +           |
| recipient              | +            | +           |
| date_custom            | +            | +           |
| year                   | +            | +           |
| quarter                | +            | +           |
| month                  | +            | +           |
| recipient_clean_custom | +            | +           |
| amount_custom          | +            | +           |
| type                   | +            | +           |
| label1_custom          | +            | +           |
| label2_custom          | +            | +           |
| label3_custom          | +            | +           |
| occurence              | +            | +           |
| label1                 |              | +           |
| label2                 |              | +           |
| label3                 |              | +           |
| recipient_clean        |              | +           |

## Custom Data Entry
General labels are not always best - in case you want to overwrite data, you 
enter that in any of the *_custom columns:

* date_custom
* recipient_clean_custom
* amount_custom
* label1_custom
* label2_custom
* label3_custom

This way you'll be able to still see the changes you made. 

Year, quarter and month columns are set by both date and date_custom. User-entered data
takes precedence (using coalesce()).

## Supported Banking exports
Right now the following banking exports are supported:

* DKB

This package should be extendable enough so that you can contribute.

1. Create a workflow as function called clean__YOURBANKNAME_.R
    1. Read export file
    2. Create a dataframe with date, recipient and amount columns.
2. Add it into the switch-case statements inside create_short_ledger.R and
append_short_ledger.R
3. Add YOURBANKNAME to test_export_type.R
4. Create a pull request!

## Testing
The existing tests are called in every function and will check if the ledger directory and its files(short ledger, mapping table) actually exist, if they have at least one row and if the column names match.
