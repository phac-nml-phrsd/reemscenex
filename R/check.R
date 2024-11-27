# Universal checks used across code

#' Check argument class
#'
#' Returns a custom error message
#'
#' @details See See https://rlang.r-lib.org/reference/topic-error-call.html for more info on how/why `arg` and `call` are defined
#'
#' @param x Value to check
#' @param expected Expected class
#' @inheritParams rlang::args_error_context
#' @template call
#'
#' @return NULL
#' @autoglobal
check_class <- function(x, expected, arg = rlang::caller_arg(x), call = rlang::caller_env())
{
    is_expected <- any(unlist(lapply(expected, \(ee) methods::is(x, ee))))

    if (!is_expected) {
        cli::cli_abort(
                c(
                    "{.arg {arg}} is a {.cls {class(x)}} type",
                    "i" = "{.arg {arg}} must be given as {.cls {expected}}"
                ),
                call = call
        )
    }
}

#' Check date was successfully parsed
#'
#' Returns a custom error message
#'
#' @details See See https://rlang.r-lib.org/reference/topic-error-call.html for more info on how/why `arg` and `call` are defined
#'
#' @param x Original date
#' @param x_parsed Parsed date
#' @param p Parser function
#' @inheritParams rlang::args_error_context
#' @param arg_parsed Same as `arg` but for `x_parsed`
#' @param arg_p Same as `arg` but for `p`
#' @template call
#'
check_date_parse <- function(x, x_parsed, p = lubridate::ymd, arg = rlang::caller_arg(x), arg_parsed = rlang::caller_arg(x_parsed), arg_p = rlang::caller_arg(p), call = rlang::caller_env()) {
    if (is.na(x_parsed)) {
        cli::cli_abort(
            c(
                "{.arg {arg}} = {.val {x}} could not be parsed",
                "i" = "{.arg {arg}} must be given in a format that can be parsed by {.fn {arg_p}}"
            ),
            call = call
        )
    }
}


#' Check start date is before end date
#'
#' Returns a custom error message
#'
#' @details See See https://rlang.r-lib.org/reference/topic-error-call.html for more info on how/why `arg` and `call` are defined
#'
#' @param d1 First date to check
#' @param d2 Second date to check
#' @param arg_d1 Same as `arg` in [check_date_parse] but for `d1`
#' @param arg_d2 Same as `arg` in [check_date_parse] but for `d2`
#' @template call
#'
check_date_order <- function(d1, d2, arg_d1 = rlang::caller_arg(d1), arg_d2 = rlang::caller_arg(d2), call = rlang::caller_env()){
  if (d1 > d2) {
    cli::cli_abort(c(
      "{.arg {arg_d1}} = {.val {d1}} must occur before {.arg {arg_d2}} = {.val {d2}}"
    ),
    call = call)
  }
}
