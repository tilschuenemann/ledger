
# ledger2

<!-- badges: start -->
<!-- badges: end -->

ledger2 (working title) interacts with the DKB Bank CSV export. Once downloaded
and fed into this program, it will generate a ledger and optionally a mapping table for you.
You are free to choose the base (short ledger) or the extended form with mapped labels and clean names (wide ledger).

## Open tasks
[] create simple workflows
[] rename read_dkbexport()
[] replace selection by name in format_export()
[] create wrapper for read_delim for better code readability
[] clean up update_cdates()
[] is it possible to mirror custom dates from short to wide format / vice versa?
[] add testing

# Ledger Data Layout
## Short Ledger
 * date
 * amount
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

## Wide Ledger (in addition to the short ledger columns)
* label1
* label2
* label3
* recipient_clean

These will be mapped automatically everytime you run "update_maptab()" successfully.

# Custom Data Entry
General labels are not always best - incase you want to cherry pick some data, you enter that in all of the *_custom columns:
* date_custom
* recipient_clean_custom
* amount_custom
* label1_custom
* label2_custom
* label3_custom

Year, quarter and month columns are set by date and date_custom. User-entered data
takes precedence.