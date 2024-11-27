#' Parse date carefully
#' 
#' @param date Date to parse
#' @param parser A parser function like [lubridate::ymd]
#' 
#' @return Date as a `Date` type
parse_date <- function(date, parser = lubridate::ymd){
    date_parsed <- try(suppressWarnings(parser(date)))
    check_date_parse(date, date_parsed, p = parser,
        call = rlang::caller_env(n = 2)
    )
    date_parsed
}