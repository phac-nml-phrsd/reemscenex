# check_class() returns expected error messages with single expected class [plain]

    Code
      local({
        name <- 2.5
        check_class(name, expected = "character")
      })
    Condition
      Error:
      ! `name` is a <numeric> type
      i `name` must be given as <character>

# check_class() returns expected error messages with single expected class [ansi]

    Code
      local({
        name <- 2.5
        check_class(name, expected = "character")
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `name` is a [34m<numeric>[39m type
      [36mi[39m `name` must be given as [34m<character>[39m

# check_class() returns expected error messages with single expected class [unicode]

    Code
      local({
        name <- 2.5
        check_class(name, expected = "character")
      })
    Condition
      Error:
      ! `name` is a <numeric> type
      ℹ `name` must be given as <character>

# check_class() returns expected error messages with single expected class [fancy]

    Code
      local({
        name <- 2.5
        check_class(name, expected = "character")
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `name` is a [34m<numeric>[39m type
      [36mℹ[39m `name` must be given as [34m<character>[39m

# check_class() returns expected error messages with multiple expected classes [plain]

    Code
      local({
        start.date <- 2
        check_class(start.date, expected = c("character", "Date"))
      })
    Condition
      Error:
      ! `start.date` is a <numeric> type
      i `start.date` must be given as <character/Date>

# check_class() returns expected error messages with multiple expected classes [ansi]

    Code
      local({
        start.date <- 2
        check_class(start.date, expected = c("character", "Date"))
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `start.date` is a [34m<numeric>[39m type
      [36mi[39m `start.date` must be given as [34m<character/Date>[39m

# check_class() returns expected error messages with multiple expected classes [unicode]

    Code
      local({
        start.date <- 2
        check_class(start.date, expected = c("character", "Date"))
      })
    Condition
      Error:
      ! `start.date` is a <numeric> type
      ℹ `start.date` must be given as <character/Date>

# check_class() returns expected error messages with multiple expected classes [fancy]

    Code
      local({
        start.date <- 2
        check_class(start.date, expected = c("character", "Date"))
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `start.date` is a [34m<numeric>[39m type
      [36mℹ[39m `start.date` must be given as [34m<character/Date>[39m

# check_date_parse() returns expected error message [plain]

    Code
      local({
        date <- "01-15-2024"
        date_parsed <- NA
        check_date_parse(date, date_parsed)
      })
    Condition
      Error:
      ! `date` = "01-15-2024" could not be parsed
      i `date` must be given in a format that can be parsed by `lubridate::ymd()`

# check_date_parse() returns expected error message [ansi]

    Code
      local({
        date <- "01-15-2024"
        date_parsed <- NA
        check_date_parse(date, date_parsed)
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `date` = [34m"01-15-2024"[39m could not be parsed
      [36mi[39m `date` must be given in a format that can be parsed by `lubridate::ymd()`

# check_date_parse() returns expected error message [unicode]

    Code
      local({
        date <- "01-15-2024"
        date_parsed <- NA
        check_date_parse(date, date_parsed)
      })
    Condition
      Error:
      ! `date` = "01-15-2024" could not be parsed
      ℹ `date` must be given in a format that can be parsed by `lubridate::ymd()`

# check_date_parse() returns expected error message [fancy]

    Code
      local({
        date <- "01-15-2024"
        date_parsed <- NA
        check_date_parse(date, date_parsed)
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `date` = [34m"01-15-2024"[39m could not be parsed
      [36mℹ[39m `date` must be given in a format that can be parsed by `lubridate::ymd()`

# check_date_order() returns expected error message for out of order dates [plain]

    Code
      local({
        start.date <- parse_date("2024-12-01")
        end.date <- parse_date("2024-11-15")
        check_date_order(start.date, end.date)
      })
    Condition
      Error:
      ! `start.date` = 2024-12-01 must occur before `end.date` = 2024-11-15

# check_date_order() returns expected error message for out of order dates [ansi]

    Code
      local({
        start.date <- parse_date("2024-12-01")
        end.date <- parse_date("2024-11-15")
        check_date_order(start.date, end.date)
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `start.date` = [34m2024-12-01[39m must occur before `end.date` = [34m2024-11-15[39m

# check_date_order() returns expected error message for out of order dates [unicode]

    Code
      local({
        start.date <- parse_date("2024-12-01")
        end.date <- parse_date("2024-11-15")
        check_date_order(start.date, end.date)
      })
    Condition
      Error:
      ! `start.date` = 2024-12-01 must occur before `end.date` = 2024-11-15

# check_date_order() returns expected error message for out of order dates [fancy]

    Code
      local({
        start.date <- parse_date("2024-12-01")
        end.date <- parse_date("2024-11-15")
        check_date_order(start.date, end.date)
      })
    Condition
      [1m[33mError[39m:[22m
      [1m[22m[33m![39m `start.date` = [34m2024-12-01[39m must occur before `end.date` = [34m2024-11-15[39m

