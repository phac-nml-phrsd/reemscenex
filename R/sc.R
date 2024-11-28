#' Set up a scenario
#'
#' See details for available scenarios
#'
#' @details
#' Scenarios are fully described in `vignette("scenarios")`
#'
#' Currently implemented scenarios, and the values required to specify them, include:
#' - `name = "sudden change in transmission"`: A sudden change in transmission in a given date. See ?sc_trans_gradual for required scenario arguments.
#' - `name = "gradual change in transmission"`: A gradual change in transmission between two given dates. See ?sc_trans_gradual for required scenario arguments
#' - `name = "logistic change in transmission"`: A change in transmission between two given dates, parameterized with a logistic function. See ?sc_trans_logistic for required scenario arguments
#'
#' All dates must be in YYYY-MM-DD format, either as `character` or `Date` objects. `value` must always be numeric.
#'
#' @param prm.sc (Optional) existing list of parameter updates for a scenario
#' @template model
#' @param opts A list with options used to set up the scenario. Must include a `name` element specifying the character name of the scenario, along with additional arguments that depend on the scenario chosen. See Details section below for a summary of each available scenario, or `vignettes("scenarios")`` for full details.
#'
#' @template return-prm.sc
#'
#' @export
#' @examples
#' sc(
#'  model = reemscenex::model.example,
#'  opts = list(
#'    name = "sudden change in transmission",
#'    start.date = "2022-02-01",
#'    value = 1.5
#'  )
#' )
#' @autoglobal
sc <- function(prm.sc = NULL, model, opts) {
  name_not_found <- TRUE # tracking if scenario name is found, flip this switch at the end of each scenario's conditional to ensure name not found error does not trigger

  # unpack scenario args into the local environment of this function
  unpack(opts)

  if (name == "sudden change in transmission") {
    prm.sc <- sc_trans_sudden(
      prm.sc = prm.sc, model = model,
      start.date = start.date, value = value
    )
    name_not_found <- FALSE
  }

  if(name=="gradual change in transmission"){
    if(is.null(opts$epsilon)){
      prm.sc <- sc_trans_gradual(
      prm.sc = prm.sc, model = model,
      start.date = start.date, end.date = end.date,
      value = value
    )} else {
      prm.sc <- sc_trans_gradual(
      prm.sc = prm.sc, model = model,
      start.date = start.date, end.date = end.date,
      value = value, epsilon = epsilon
      )}
    name_not_found <- FALSE
  }

  if(name == "logistic change in transmission"){
    prm.sc = sc_trans_logistic(
      prm.sc     = prm.sc,
      model      = model,
      start.date = start.date,
      end.date   = end.date,
      value      = value,
      L0         = 0.02)

    name_not_found <- FALSE
  }

  #
  #   if(name=="Invasion change in transmission"){
  #   prm.sc <- sc_trans_invasion(prm.sc, model, FILL IN ARGS)
  #   name_not_found <- TRUE
  # }

    if (name_not_found) {
    cli::cli_abort(
      "Scenario {.arg {name}} not found. See {.help sc} for a list of implemented scenarios."
    )
  }

  return(prm.sc)
}

# Specific scenario functions (not exported)
# --------------------

#' Scenario: sudden change in transmission
#'
#' @param prm.sc (Optional) list of existing scenario parameters
#' @param model A [reem::reem-class] model object
#' @param start.date Date on which to change transmission
#' @param value Multiplier for transmission after `date`
#'
#' @template return-prm.sc
#'
#' @export
#' @autoglobal
sc_trans_sudden <- function(prm.sc = NULL, model, start.date, value) {

  # Required argument checks
  # - - - - - - - - - - - - - - -

  rlang::check_required(start.date, call = rlang::caller_env())
  rlang::check_required(value, call = rlang::caller_env())

  # Argument type checks
  # - - - - - - - - - - - - - - -

  check_class(start.date, expected = c("Date", "character"))
  check_class(value, expected = c("numeric"))

  # Argument consistency checks
  # - - - - - - - - - - - - - - -

  start.date <- parse_date(start.date)

  # check that desired date for transmission change is within the simulation dates
  # (simulation start date can change to be even earlier if start.delta is being fitted,
  # so this check is maybe too strict, so we could revisit it if it's causing problems)

  sim.start.date <- model$prms$date.start
  sim.end.date <- sim.start.date + model$prms$horizon

  check_date_order(sim.start.date, start.date)
  check_date_order(start.date, sim.end.date)

  # Main commands
  # - - - - - - - - - - - - - - -

  # # translate date of change into time index
  # t <- as.numeric(as.Date(date) - model$prms$date.start)
  # B = 1 before change and new value after
  B_new <- data.frame(
    date = as.Date(start.date) + -1:0,
    mult = c(1, value)
  )

  # initialize prm.sc list if need be (not provided by user)
  if (is.null(prm.sc)) prm.sc <- list()

  # if B isn't in existing parameters
  # (either because it isn't in the list or
  # because the user didn't provide a parameter list)
  # return B as computed above
  if (is.null(prm.sc$B)) {
    prm.sc$B <- B_new
  } else {
    # otherwise, compose transmission scenarios
    prm.sc$B <- compose_B(prm.sc$B, B_new)
  }

  prm.sc
}

#' Scenario: gradual change in transmission
#'
#' @param prm.sc (Optional) list of existing scenario parameters
#' @template model
#' @param start.date Date on which to start change transmission
#' @param end.date Date on which to end change transmission
#' @param value Multiplier for transmission after `date`
#' @param epsilon (Optional) shape parameter for the logistic function. See `vignette('scenarios')` for details.
#'
#' @template return-prm.sc
#'
#' @export
#' @autoglobal
sc_trans_gradual <- function(prm.sc = NULL, model, start.date, end.date, value, epsilon = 0.001) {

  # Required argument checks
  # - - - - - - - - - - - - - - -

  rlang::check_required(start.date, call = rlang::caller_env())
  rlang::check_required(end.date, call = rlang::caller_env())
  rlang::check_required(value, call = rlang::caller_env())
  rlang::check_required(epsilon, call = rlang::caller_env())

  # Argument type checks
  # - - - - - - - - - - - - - - -

  check_class(start.date, expected = c("Date", "character"))
  check_class(end.date, expected = c("Date", "character"))
  check_class(value, expected = c("numeric"))
  check_class(value, expected = c("numeric"))

  # Argument consistency checks
  # - - - - - - - - - - - - - - -

  start.date <- parse_date(start.date)
  end.date <- parse_date(end.date)

  sim.start.date <- model$prms$date.start
  sim.end.date <- sim.start.date + model$prms$horizon

  check_date_order(sim.start.date, start.date)
  check_date_order(start.date, sim.end.date)
  check_date_order(start.date, end.date)

  # episilon must be > 0 or else piecewise logistic will be discontinuous
  if (epsilon <= 0) {
    cli::cli_abort(c(
      "Scenario option {.var epsilon} = {.val {epsilon}} is less than or equal to zero.",
      "i" = "{.var epsilon} must be strictly greater than zero."
    ))
  }

  # Main commands
  # - - - - - - - - - - - - - - -

  # # translate date of change into time index
  B_new <- data.frame(
    date = as.Date(c(start.date:end.date), origin = '1970-01-01'),
    mult = gradual_change(
      p = value-1,
      delta = as.numeric(end.date - start.date)/2,
      epsilon = epsilon,
      x = 0:(length(as.Date(start.date:end.date, origin = '1970-01-01'))-1)
    )
  )

  # initialize prm.sc list if nseed be (not provided by user)
  if (is.null(prm.sc)) prm.sc <- list()

  # if B isn't in existing parameters
  # (either because it isn't in the list or
  # because the user didn't provide a parameter list)
  # return B as computed above
  if (is.null(prm.sc$B)) {
    prm.sc$B <- B_new
  } else {
    # otherwise, compose transmission scenarios
    prm.sc$B <- compose_B(prm.sc$B, B_new)
  }

  prm.sc
}

#' Scenario: logistic change in transmission
#'
#' @param prm.sc (Optional) list of existing scenario parameters
#' @template model
#' @param start.date Date on which to start change transmission
#' @param end.date Date on which to end change transmission
#' @param value Multiplier for transmission after `date`
#' @param L0 Numerical. Initial change at time 0. Must be 0 < L0 < 1.
#'
#' @template return-prm.sc
#'
#' @export
#' @autoglobal
sc_trans_logistic <- function(prm.sc,
                              model,
                              start.date,
                              end.date,
                              value,
                              L0) {

  # Argument consistency checks
  start.date <- parse_date(start.date)
  end.date   <- parse_date(end.date)

  sim.start.date <- model$prms$date.start
  sim.end.date   <- sim.start.date + model$prms$horizon

  check_date_order(sim.start.date, start.date)
  check_date_order(start.date, sim.end.date)
  check_date_order(start.date, end.date)

  if (L0 <= 0 | L0 >= 1) {
    cli::cli_abort(
      "Scenario option {.var L0} = {.val {L0}} must be strictly between 0 and 1.")
  }

  # translate date of change into time index

  dvec = as.Date(start.date:end.date, origin = '1970-01-01')
  tvec = 0:(length(dvec)-1)

  mult = logistic_change(
    chg    = value - 1,
    t.half = as.numeric(end.date - start.date) / 2,
    L0     = L0,
    t      = tvec
  )

  B_new <- data.frame(date = dvec, mult = mult)

  # initialize prm.sc list if nseed be (not provided by user)
  if (is.null(prm.sc)) prm.sc <- list()

  # if B isn't in existing parameters
  # (either because it isn't in the list or
  # because the user didn't provide a parameter list)
  # return B as computed above
  if (is.null(prm.sc$B)) {
    prm.sc$B <- B_new
  } else {
    # otherwise, compose transmission scenarios
    prm.sc$B <- compose_B(prm.sc$B, B_new)
  }

  return(prm.sc)
}


# Helper to compose two B scenarios (not exported)
# --------------------

#' Compose scenarios for B(t)
#'
#' @param B_old Original B scenario data frame (cols: `date`, `mult`)
#' @param B_new New B scenario data frame
#'
#' @return A B data frame with columns `date` and `mult`
#' @autoglobal
compose_B <- function(B_old, B_new) {
  (dplyr::full_join(B_old, B_new, by = "date")
    # fill consecutive dates (`reem` a B for each date inside the range)
    |> tidyr::complete(date = tidyr::full_seq(date, 1))
    # fill missing values up and down, like `reem does internally`
    |> tidyr::fill(dplyr::starts_with("mult"), .direction = "updown")
    |> dplyr::transmute(
      date,
      mult = mult.x * mult.y # combine cols with multiplication
    )
  )
}
