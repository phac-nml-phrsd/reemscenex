# These are special checks 
# [using a helper function from cli](https://cli.r-lib.org/reference/test_that_cli.html)
# that use [testthat snapshots](https://testthat.r-lib.org/articles/snapshotting.html)

cli::test_that_cli(
    desc = "check_class() returns expected error messages with single expected class",
    code = {
        testthat::expect_snapshot(
            error = TRUE,
        local({
            name <- 2.5
            check_class(name, expected = "character")
        }))
    }
)

cli::test_that_cli(
    desc = "check_class() returns expected error messages with multiple expected classes",
    code = {
        testthat::expect_snapshot(
            error = TRUE,
        local({
            start.date <- 2
            check_class(start.date, expected = c("character", "Date"))
        }))
    }
)

cli::test_that_cli(
    desc = "check_date_parse() returns expected error message",
    code = {
        testthat::expect_snapshot(
            error = TRUE,
            local({
                date <- "01-15-2024" # not YYYY-MM-DD
                date_parsed <- NA
                check_date_parse(date, date_parsed)
            })
        )
    }
)

cli::test_that_cli(
    desc = "check_date_order() returns expected error message for out of order dates",
    code = {
        testthat::expect_snapshot(
            error = TRUE,
        local({
            start.date <- parse_date("2024-12-01")
            end.date <- parse_date("2024-11-15")
            check_date_order(start.date, end.date)
        }))
    }
)