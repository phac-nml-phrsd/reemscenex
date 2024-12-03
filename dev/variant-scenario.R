# sample inputs
selection.coefficient <- 0.138 # avg growth rate per day
infectious.period <- 3
L0 <- 0.05
start.date <- lubridate::today() - lubridate::weeks(1) # invasion started a week from today with share of 5% relative to rest

# calculate params for input into scenario
t.half <- 1/selection.coefficient*log(1/L0-1)
end.date <- start.date + 2*t.half
value <- exp(selection.coefficient * infectious.period) - 1 # transmission advantage (ratio of R0s) - 1 because of how chg is implemented in logistic_change() (1 gets added later)

# scenario opts
opts <- list(
    list(
        name = "logistic change in transmission",
        start.date = start.date,
        end.date = end.date,
        value = value,
        L0 = L0
    )
)

# plot of scenario
dvec = as.Date(start.date:end.date, origin = "1970-01-01")
tvec = 0:(length(dvec) - 1)

mult = reemscenex:::logistic_change(
    chg    = value,
    t.half = as.numeric(end.date - start.date) / 2,
    L0     = L0,
    t      = tvec
)

(data.frame(
    date = dvec,
    mult = mult - 1
)
    |> ggplot2::ggplot(ggplot2::aes(x = date, y = mult))
    + ggplot2::geom_line()
    + ggplot2::theme_minimal()
    + ggplot2::labs(title = "Transmission increase due to new variant")
    +ggplot2::scale_y_continuous(labels = scales::label_percent())
    +ggplot2::theme(axis.title = ggplot2::element_blank())
)
