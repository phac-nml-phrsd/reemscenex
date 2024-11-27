test_that("errors trigger", {
  expect_error(sc(name = "non-existant scenario"))
  # missing required scenario values
  expect_error(sc(opts(list(name = "sudden change in transmission"))))
  expect_error(sc(opts(list(name = "gradual change in transmission"))))
})

# write when there are multiple scenario types
# test_that("mixed scenarios compose", {
#
# })

# sc_trans_sudden()
# --------------------

# # reset model parameters to original values
model.example$prms <- prms

test_that("errors trigger", {
  expect_error(sc_trans_sudden(start.date = 2))
  expect_error(sc_trans_sudden(start.date = "01/05/2024"))
  expect_error(sc_trans_sudden(model = model.example, start.date = lubridate::today()))
})

date.change <- c(as.Date("2022-02-01"), as.Date("2022-02-05"))
mult <- c(1.5, 2, 3)

test_that("scenario is correctly set up from scratch", {
  B_new <- data.frame(
    date = date.change[1] + -1:0,
    mult = c(1, mult[1])
  )

  # no existing parameters
  expect_identical(
    sc_trans_sudden(model = model.example, start.date = date.change[1], value = mult[1]),
    list(B = B_new)
  )

  # unrelated existing parameters
  prm.sc_existing <- list(h.prop = 1)
  expect_identical(
    sc_trans_sudden(
      prm.sc = prm.sc_existing,
      model = model.example,
      start.date = date.change[1],
      value = mult[1]
    ),
    list(
      h.prop = 1,
      B = B_new
    )
  )
})

# sc_trans_gradual()
# --------------------

# Test default epsilon - make sure the value gets used if nothing is passed
expect_identical(
  sc_trans_gradual(model = model.example, start.date = as.Date("2022-02-01"), end.date = as.Date("2022-02-02"), value = 2, epsilon = 0.001),
  sc_trans_gradual(model = model.example, start.date = as.Date("2022-02-01"), end.date = as.Date("2022-02-02"), value = 2),
)

# Test that the date orders and formats work - date = as.Date(c(start.date:end.date))
test_that("errors trigger", {
  expect_error(sc_trans_gradual(model = model.example, start.date = as.Date("2022-02-03"), end.date = as.Date("2022-02-01"), value = 2, epsilon = 0.001))
  expect_error(sc_trans_gradual(model = model.example, start.date = "yes", end.date = as.Date("2022-02-01"), value = 2, epsilon = 0.001))
  expect_error(sc_trans_gradual(model = model.example, start.date = as.Date("2022-02-03"), end.date = "01/05/2024", value = 2, epsilon = 0.001))
  expect_error(sc_trans_gradual(model = model.example, start.date = as.Date("2022-02-03"), end.date = as.Date("2022-02-01"), value = "no", epsilon = 0.001))
  expect_error(sc_trans_gradual(model = model.example, start.date = as.Date("2022-02-03"), end.date = as.Date("2022-02-01"), value = 2, epsilon = "no"))
  })

cli::test_that_cli(
  desc = "negative epsilon triggers expected warning",
  code = {
      testthat::expect_snapshot(
          error = TRUE,
      local({
          sc_trans_gradual(model = model.example, start.date = "2022-02-03", end.date = "2022-03-02", value = 2, epsilon = -0.1)
      }))
  }
)

cli::test_that_cli(
  desc = "zero epsilon triggers expected warning",
  code = {
      testthat::expect_snapshot(
          error = TRUE,
      local({
          sc_trans_gradual(model = model.example, start.date = "2022-02-03", end.date = "2022-03-02", value = 2, epsilon = 0)
      }))
  }
)

# compose_B()
# --------------------

test_that("scenarios compose", {
  # no overlap in dates
  B_old <- data.frame(
    date = date.change[1] - 1:0,
    mult = c(1, mult[1])
  )
  B_new <- data.frame(
    date = date.change[2] - 1:0,
    mult = c(1, mult[2])
  )
  B_expected <- tibble::tibble(
    date = seq(date.change[1] - 1, date.change[2], by = 1),
    mult = c(1, rep(mult[1], as.numeric(date.change[2] - date.change[1])), mult[1] * mult[2])
  )

  expect_identical(
    compose_B(B_old, B_new),
    B_expected
  )

  # complete overlap in dates
  B_new <- data.frame(
    date = date.change[1] - 1:0,
    mult = c(1, mult[3])
  )
  B_expected <- tibble::tibble(
    date = date.change[1] - 1:0,
    mult = c(1, mult[1]*mult[3])
  )

  expect_identical(
    compose_B(B_old, B_new),
    B_expected
  )

  # partial overlap in dates
  B_new <- data.frame(
    date = date.change[1] + 0:2,
    mult = c(1, rep(mult[3], 2))
  )
  B_expected <- tibble::tibble(
    date = date.change[1] + -1:2,
    mult = c(1, mult[1], rep(mult[1]*mult[3],2))
  )

  expect_identical(
    compose_B(B_old, B_new),
    B_expected
  )

  # is compose_B() transitive?
  expect_identical(
    compose_B(B_new, B_old),
    B_expected
  )
})
