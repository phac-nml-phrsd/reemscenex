#' Unpack a list into the current (calling) environment
#' 
#' This is a replacement for \code{with()} (which is hard to debug) and \code{attach()} (which is frowned upon by CRAN/triggers package-check warnings)
#' 
#' Copied from https://github.com/mac-theobio/McMasterPandemic/blob/master/R/utils.R
#' @param x a named vector or a list
#' @export
unpack <- function(x) {
    if (any(names(x) == "")) stop("unnamed elements in x")
    invisible(list2env(as.list(x), envir = parent.frame()))
}