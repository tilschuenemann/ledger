#' Title
#'
#' @param path_to_export path to  export
#' @param export_type Specify which bank export will be used.
#'
#' @keywords internal
#'
#' @importFrom readr read_delim
#' @importFrom readr cols
#' @importFrom readr locale
#' @importFrom dplyr select
#' @importFrom dplyr rename
#' @importFrom dplyr mutate
#' @importFrom lubridate dmy

clean_export <- function(path_to_export,export_type){
  # clean to base ledger (date, recipient, amount)
  switch(export_type,
         dkb = {
           suppressWarnings({
             export <- read_delim(path_to_export,
                                  ";",
                                  escape_double = FALSE, locale = locale(encoding = "ISO-8859-1", decimal_mark = ","),
                                  trim_ws = TRUE, skip = 6, col_types = cols()
             )
           })

           base_ledger <- export %>%
             select(1,4,8) %>%
             rename(
               date = 1,
               recipient = 2,
               amount = 3) %>%
             mutate(
               date = dmy(.data$date))
         }
  )

  return(base_ledger)

}