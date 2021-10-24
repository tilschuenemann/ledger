
# ledger2

<!-- badges: start -->
[![R-CMD-check](https://github.com/tilschuenemann/ledger2/workflows/R-CMD-check/badge.svg)](https://github.com/tilschuenemann/ledger2/actions)
[![Codecov test coverage](https://codecov.io/gh/tilschuenemann/ledger2/branch/main/graph/badge.svg)](https://app.codecov.io/gh/tilschuenemann/ledger2?branch=main)
<!-- badges: end -->

ledger2 (working title) interacts with the DKB Bank CSV export. Once downloaded
and fed into this program, it will generate a ledger and optionally a mapping table for you.
You are free to choose the base (short ledger) or the extended form with mapped labels and clean names (wide ledger).

## Table of Contents
- [Workflow](#workflow)
    + [create new ledger](#create-new-ledger)
    + [updated maptab, cdates or balance](#updated-maptab--cdates-or-balance)
    + [create wide ledger](#create-wide-ledger)
    + [append new ledger](#append-new-ledger)
- [Open Issues](#open-issues)
    + [functionality](#functionality)
    + [development](#development)
- [Ledger Data Layout](#ledger-data-layout)
    + [Short Ledger](#short-ledger)
    + [Wide Ledger](#wide-ledger)

    - [Custom Data Entry](#custom-data-entry)

## Workflow
ledger2 is designed to currently work in a designated folder and not with paths.
This is by design to make prototyping easier, but will be changed in the future.
```r
library("ledger2")
setwd("my_wd/")
dkb_export <- "dkb_export_20210101.csv"
```

#### create new ledger
```r
create_short_ledger(dkb_export)
write_initbalance(dkb_export)
update_balance()
update_maptab()
```

#### updated maptab, cdates or balance
```r
update_maptab()
update_cdates()
update_balance()
```

#### create wide ledger
```r
create_wide_ledger()
```

#### append new ledger
```r
dkb_export <- "dkb_export_20210801.csv"
append_ledger(dkb_export)
update_maptab()
```

## Open Issues
#### functionality
- [ ] clean up update_cdates()
- [ ] consistent argument naming
- [ ] create simple workflows
- [ ] add paths to arguments

#### development
* add testing
* add coverage

## Ledger Data Layout
#### Short Ledger
 * date
 * amount
 * balance
 * recipient
 * date_custom
 * year
 * quarter
 * month
 * recipient_clean_custom
 * amount_custom
 * type
 * label1_custom
 * label2_custom
 * label3_custom

#### Wide Ledger
These columns are provided additionally to the short ledger columns.
* label1
* label2
* label3
* recipient_clean

These will be mapped automatically everytime you run "update_maptab()" successfully.

## Custom Data Entry
General labels are not always best - incase you want to cherry pick some data, you enter that in all of the *_custom columns:
* date_custom
* recipient_clean_custom
* amount_custom
* label1_custom
* label2_custom
* label3_custom

Year, quarter and month columns are set by date and date_custom. User-entered data
takes precedence.
