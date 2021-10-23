#' Title
#'
#' @param dkbexport_df DKV CSV export as dataframe
#'
#' @return Input Dataframe cleaned to contain date, recipient and amount columns
#' @export
#'
#' @importFrom dplyr select
#' @importFrom dplyr rename
clean_dkb <- function(dkbexport_df) {

  # clean column names
  colnames(dkbexport_df)<- colnames(dkbexport_df)  %>%
    gsub(pattern ="[^[:alpha:]*]" ,replacement = "",) %>%
    iconv(to='ASCII//TRANSLIT')

  # change names to standardised format
  dkbexport_df <- dkbexport_df %>%
    select(Buchungstag,AuftraggeberBegunstigter,BetragEUR) %>%
    rename(date = 1,
           recipient = 2,
           amount = 3)

  return(dkbexport_df)

}