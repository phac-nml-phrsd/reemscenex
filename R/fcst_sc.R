#' Forecast a scenario
#'
#' @param prm.sc A named list of non-fitted parameters that reflect the desired scenario. If NULL, produce status quo forecast
#' @param prm.fcst A named list of forecast settings. If NULL, uses forecast settings already stored in `model` (provided they exist)
#' @template model
#'
#' @return Simulation results, in a list with elements:
#' * `asof`: the forecast date
#' * `simfwd`: a list of data frames, where each gives the full results of a single simulation run
#' * `summary.fcst`: a data frame, summarizing the forecast simulations using quantiles by unit time
#' * `simfwd.aggr`: a named list, where each element is a list of data frames similar to those in `simfwd`. Here, the name of each list element denotes the variable for which simulation results are reported in the enclosed data frames. Each data frame comes from one simulation run. `.aggr` refers to the fact that the simulation variable is aggregated on the schedule of the observed values (_e.g._, weekly, monthly).
#' * `summary.fcst.aggr`: a named list, where each element is a data frame like `summary.fcst`, but for aggregated variables (those found in the names of `simfwd.aggr`). Here, the name of each list element denotes the variable for which the summary is reported in the enclosed data frame.
#' @export
#' @autoglobal
fcst_sc <- function(prm.sc=NULL, prm.fcst=NULL, model){
  if(is.null(prm.fcst)){
    if(length(model$fcst.prm)==0) cli::cli_abort(
      "Forecast settings not found in {.var model}.",
      "i" = "Please pass forecast settings via {.arg fcst.prm}"
    )

    prm.fcst <- model$fcst.prm
  }

  model <- update_prm(model = model, prm = prm.sc)
  model$forecast(
    prm.fcst=prm.fcst,
    verbose=0
  )
}

#' Update baseline parameters in a model object
#'
#' @template model
#' @param prm A named list of parameters to update, whose names are found in model$prms
#'
#' @autoglobal
update_prm <- function(model, prm){
  if(is.null(prm)) return(model)

  unmatched_names <- names(prm)[!(names(prm) %in% names(model$prms))]

  if(length(unmatched_names)>0) cli::cli_abort(c(
    "Attempting to update {length(unmatched_names)} parameter{?s} that {?is/are} not defined in {.var model}:",
    "x" = "{.var {unmatched_names}}"
  ), call = rlang::caller_env())

  invisible(lapply(names(prm), \(nn){

    if(!all(inherits(prm[[nn]], class(model$prms[[nn]])))) cli::cli_abort(c(
    # if(!all(class(prm[[nn]])==class(model$prms[[nn]]))) cli::cli_abort(c(
      "Class of replacement parameter {.var {nn}} does not match original",
      "i" = "Expected {.cls {class(model$prms[[nn]])}}",
      "x" = "Replacement of class {.cls {class(prm[[nn]])}}"
    ),
    call = rlang::caller_env())

    model$prms[[nn]] <- prm[[nn]]
  }))

  model

}
