library("ledger2")

dkb_export <- "dkb_export_20211017.csv"

# create new ledger -------------------------------------------------------

read_dkbexport(dkb_export)
ledger2::update_maptab()
ledger2::write_initbalance(dkb_export)

# updated maptab or cdates ------------------------------------------------

ledger2::create_wide_ledger()
ledger2::udpate_cdates()

# append new ledger -------------------------------------------------------

legder2::append_ledger(dkb_export)
ledger2::update_maptab()


