# negative epsilon triggers expected warning [plain]

    Code
      local({
        sc_trans_gradual(model = model.example, start.date = "2022-02-03", end.date = "2022-03-02",
          value = 2, epsilon = -0.1)
      })
    Condition
      Error in `sc_trans_gradual()`:
      ! Scenario option `epsilon` = -0.1 is less than or equal to zero.
      i `epsilon` must be strictly greater than zero.

# negative epsilon triggers expected warning [ansi]

    Code
      local({
        sc_trans_gradual(model = model.example, start.date = "2022-02-03", end.date = "2022-03-02",
          value = 2, epsilon = -0.1)
      })
    Condition
      [1m[33mError[39m in `sc_trans_gradual()`:[22m
      [1m[22m[33m![39m Scenario option `epsilon` = [34m-0.1[39m is less than or equal to zero.
      [36mi[39m `epsilon` must be strictly greater than zero.

# negative epsilon triggers expected warning [unicode]

    Code
      local({
        sc_trans_gradual(model = model.example, start.date = "2022-02-03", end.date = "2022-03-02",
          value = 2, epsilon = -0.1)
      })
    Condition
      Error in `sc_trans_gradual()`:
      ! Scenario option `epsilon` = -0.1 is less than or equal to zero.
      ℹ `epsilon` must be strictly greater than zero.

# negative epsilon triggers expected warning [fancy]

    Code
      local({
        sc_trans_gradual(model = model.example, start.date = "2022-02-03", end.date = "2022-03-02",
          value = 2, epsilon = -0.1)
      })
    Condition
      [1m[33mError[39m in `sc_trans_gradual()`:[22m
      [1m[22m[33m![39m Scenario option `epsilon` = [34m-0.1[39m is less than or equal to zero.
      [36mℹ[39m `epsilon` must be strictly greater than zero.

# zero epsilon triggers expected warning [plain]

    Code
      local({
        sc_trans_gradual(model = model.example, start.date = "2022-02-03", end.date = "2022-03-02",
          value = 2, epsilon = 0)
      })
    Condition
      Error in `sc_trans_gradual()`:
      ! Scenario option `epsilon` = 0 is less than or equal to zero.
      i `epsilon` must be strictly greater than zero.

# zero epsilon triggers expected warning [ansi]

    Code
      local({
        sc_trans_gradual(model = model.example, start.date = "2022-02-03", end.date = "2022-03-02",
          value = 2, epsilon = 0)
      })
    Condition
      [1m[33mError[39m in `sc_trans_gradual()`:[22m
      [1m[22m[33m![39m Scenario option `epsilon` = [34m0[39m is less than or equal to zero.
      [36mi[39m `epsilon` must be strictly greater than zero.

# zero epsilon triggers expected warning [unicode]

    Code
      local({
        sc_trans_gradual(model = model.example, start.date = "2022-02-03", end.date = "2022-03-02",
          value = 2, epsilon = 0)
      })
    Condition
      Error in `sc_trans_gradual()`:
      ! Scenario option `epsilon` = 0 is less than or equal to zero.
      ℹ `epsilon` must be strictly greater than zero.

# zero epsilon triggers expected warning [fancy]

    Code
      local({
        sc_trans_gradual(model = model.example, start.date = "2022-02-03", end.date = "2022-03-02",
          value = 2, epsilon = 0)
      })
    Condition
      [1m[33mError[39m in `sc_trans_gradual()`:[22m
      [1m[22m[33m![39m Scenario option `epsilon` = [34m0[39m is less than or equal to zero.
      [36mℹ[39m `epsilon` must be strictly greater than zero.

