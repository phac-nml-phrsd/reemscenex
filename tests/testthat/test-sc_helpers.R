# sc_helpers
# --------------------

## 1. Test Sudden changes in population activity Function----

test_that("sudden_change returns a numeric vector of values", {
  expect_type(
    sudden_change(p=1,x=-1),
    "double"
  )

  expect_length(
    sudden_change(p=1, x=1:10),
    10
  )
})

test_that("sudden_change returns correct values", {
  expect_identical(
    sudden_change(p=1,x=-1),
    1
  )
  expect_identical(
    sudden_change(p=1,x=1),
    2
  )
})

test_that("expect elements match before and after t=0", {

  #before values should be equal to 1
  expect_setequal(
    sudden_change(p=1,x=-9:-1),
    rep(1,length(sudden_change(p=1,x=-9:-1)))
  )

  #after values should be equal to p+1 = 2
  expect_setequal(
    sudden_change(p=1,x=0:10),
    rep(2,length(sudden_change(p=1,x=0:10)))
  )
})

## 2. Test Gradual changes in population activity Function----
# gradual_change(p = target transmission rate change proportion, delta = halfway point, epsilon = chosen amount over asymptote, x = time)

test_that("gradual_change returns a numeric vector of values", {
  expect_type(
    gradual_change(1, 2, 0.1, 1),
    "double"
  )

  expect_length(
    gradual_change(1, 2, 0.1, 1:10),
    10
  )
})

test_that("gradual_change returns correct values", {

  # the value at 0 for B(t) should be 1 to match up with the previous B(t) values
  expect_identical(
    gradual_change(1, 2, 0.1, 0),
    1
  )

  # this value should be 1 plus p/2
  expect_identical(
    gradual_change(1, 2, 0.1, 2),
    1.5
  )

  # this value should be 1 + p
  expect_identical(
    gradual_change(1, 2, 0.1, 4),
    2
  )
})


## 3. Test invasion changes in population activity Function----
# Lisa test epsilon and other variables
# invasion_change(p = target transmission rate change proportion, delta = delta halfway point, m = slope of change, b = y-intercept, x = time)

test_that("invasion_change returns a numeric vector of values", {
  expect_type(
    invasion_change(5, 1/4, 1, 2, 1),
    "double"
  )

  expect_length(
    invasion_change(5, 1/4, 1, 2, 1:10),
    10
  )
})

test_that("invasion_change returns correct values", {

  # the value at 0 for B(t) should be 1 to match up with the previous B(t) values
  expect_identical(
    invasion_change(5, 1/4, 1, 2, -1),
    1
  )

  # this value should be 1 plus p/2
  expect_identical(
    invasion_change(5, 1/4, 1, 2, 1),
    6
  )

})
