# Helpers to set up B(t) for scenario functions (defined in sc.R)

# The following scenarios will involve imposing a temporal change in transmission, B(t), after the model is fit with B(t) = 1 for all t. t is in units of days, where t = 0 is the start of the simulation/fit. There are underlying factors and dynamics that guide changes in population activity and several types of models to consider to analyse the effects of population activity such as:
# 1. Sudden changes in population activity
# 2. Gradual Growth in Population Activity
# 3. Invasion of a new, more-transmissible strain

# Change in Transmission Functions ----

## 1. Sudden changes in population activity ----

#' Piecewise change in transmission
#' sudden_change(p = target proportion for transmission rate change, x = time)
#'
#' @template p
#' @template x
#'
#' @template return.B

sudden_change <- function(p, x) {
  ifelse(x < 0 , 1, 1+p)
}

## 2. Gradual changes in population activity ----

#' Piecewise change in transmission
#' gradual_change(p = target transmission rate change proportion, delta = halfway point, epsilon = chosen amount over asymptote, x = time)
#'
#' @template p
#' @param delta Halfway point between transmission beginning and reaching its maximum growth/decline
#' @param epsilon Some chosen amount over the 1+p asymptote
#' @template x
#'
#' @template return.B

gradual_change <- function(p, delta, epsilon, x) {
  r =  1/delta * log(p/epsilon+1)
  1+p*(exp(r*x)-1)/((exp(r*delta)-1)*(1+exp(r*(x-delta))))
}

## 3. Invasion of a new, more-transmissible strain ----

#' Piecewise change in transmission
#' invasion_change(p = target transmission rate change proportion, delta = delta halfway point, m = slope of change, b = y-intercept, x = time)
#'
#' @template p
#' @param delta Halfway point between transmission beginning and reaching its maximum growth/decline
#' @param m TEMPORARY slope
#' @param b TEMPORARY y-intercept
#' @template x
#'
#' @template return.B

invasion_change <- function(p, delta, m, b, x) {
  1 + p * ifelse(x < 0, 0, ifelse(x >= 5, 6, x))
}
