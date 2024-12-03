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
    + ggplot2::labs(title = "Transmission increase due to invading variant")
    +ggplot2::scale_y_continuous(labels = scales::label_percent())
    +ggplot2::theme(axis.title = ggplot2::element_blank())
)

# plot of more general transmission change scenario
start.date <- as.Date("2024-12-04", origin = "1970-01-01")
change.date.1 <- as.Date("2024-12-11", origin = "1970-01-01")
change.date.2 <- as.Date("2024-12-25", origin = "1970-01-01")
end.date <- as.Date("2025-01-09", origin = "1970-01-01")

dvec <- seq(start.date, end.date, by=1)

dvec1 = as.Date(start.date:change.date.1, origin = "1970-01-01")
tvec1 = 0:(length(dvec1) - 1)

dvec2 = as.Date(change.date.2:end.date, origin = "1970-01-01")
tvec2 = 0:(length(dvec2) - 2)

mult = c(
    reemscenex:::logistic_change(
        chg    = -0.1,
        t.half = as.numeric(change.date.1 - start.date) / 2,
        L0     = 0.00001,
        t      = tvec1
    ),
    rep(0.9, length(change.date.1:change.date.2)-1),
    reemscenex:::logistic_change(
        chg    = -0.1,
        t.half = (as.numeric(end.date - change.date.2) / 2),
        L0     = 0.99999,
        t      = tvec2
    )
) - 1

    
(data.frame(
    date = dvec,
    mult = mult
)
    |> ggplot2::ggplot(ggplot2::aes(x = date, y = mult))
    + ggplot2::geom_line()
    + ggplot2::theme_minimal()
    + ggplot2::labs(title = "Transmission change due to successful messaging")
    +ggplot2::scale_y_continuous(labels = scales::label_percent())
    +ggplot2::theme(axis.title = ggplot2::element_blank())
)
