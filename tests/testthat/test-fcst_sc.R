test_that("fcst_sc returns simulation results in expected format", {
  sim <- fcst_sc(model=model.example)

  expect_type(
    sim,
    "list"
  )
  expect_named(
    sim,
    c("asof",
      "simfwd", "summary.fcst",
      "simfwd.aggr", "summary.fcst.aggr")
  )
})

test_that("errors trigger", {
  model.nofcst <- readRDS(test_path("fixtures", "model.nofcst.rds"))
  expect_error(
    fcst_sc(model=model.nofcst)
  )

})

# update_prm
# --------------------

test_that("parameters are updated", {
  expect_equal(
  update_prm(model.example,
    list(horizon = 2L))$prms$horizon,
  2L
  )
})

test_that("errors trigger", {
  expect_error(
    update_prm(model.example,
    list(bad_prm = 5))
  )
  expect_error(
    update_prm(model.example,
    list(start.delta = 2.5))
  )
}
)
