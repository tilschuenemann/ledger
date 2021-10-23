#' Update Custom Dates
#'
#' @param wide_ledger Path to wide ledger file
#'
#' @description Recalculates year, quarter and month columns using date column
#' (default) or date_custom column (user input)
#'
#' @export
#'
#' @importFrom readr read_delim
#' @importFrom readr locale
#' @importFrom readr cols
#' @importFrom lubridate ymd
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr coalesce
#' @importFrom lubridate floor_date
#' @importFrom readr write_excel_csv2
#' @importFrom dplyr relocate
#' @importFrom rlang .data

udpate_cdates <- function(ledger_format) {

  if(ledger_format!= "wide" && ledger_format != "short" &&  ledger_format != "both"){
    stop("wrong ledger_format. please use either 'short','wide' or 'both'")
  }

  if(ledger_format == "wide"){
    ledger <- read_delim("wide_ledger.csv",
                              ";",
                              escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
                              trim_ws = TRUE, col_types = cols()
    )
  } else if (ledger_format == "short"){
    ledger <- read_delim("short_ledger.csv",
                              ";",
                              escape_double = FALSE, locale = locale(encoding = "UTF-8", decimal_mark = ","),
                              trim_ws = TRUE, col_types = cols()
    )
  } else if (ledger_format== "both"){
    update_cdates("short")
    update_cdates("wide")

  }


  ledger$date_custom <- ymd(.data$date_custom)

  # TODO date temp is not a clean solution
  ledger <- ledger %>%
    select(-.data$year, -.data$quarter, -.data$month) %>%
    mutate(
      date_temp = coalesce(.data$date_custom, .data$date),
      year = floor_date(.data$date_temp, "year"),
      quarter = floor_date(.data$date_temp, "quarter"),
      month = floor_date(.data$date_temp, "month")
    ) %>%
    select(-.data$date_temp) %>%
    relocate(c(.data$year,.data$quarter,.data$month),.after = .data$date_custom)

  if(ledger_format == "wide"){
    readr::write_excel_csv2(ledger, "wide_ledger.csv")
  } else if(ledger_format == "short"){
    readr::write_excel_csv2(ledger, "short_ledger.csv")
  }
  print("updated custom dates")
}
