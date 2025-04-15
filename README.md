# reemscenex

An R package to perform scenario exploration using [reem](https://github.com/phac-nml-phrsd/reem).

# Get started

Please review the main package vignette (`vignette("reemscenex")`) first, followed by the supplementary scenarios vignette (`vignette("scenarios")`) to get started.

# For developers

## `renv`

This package uses [`renv`](https://rstudio.github.io/renv/index.html) to manage dependencies.

In order to ensure the development environment is properly tracked, please use the `dev=TRUE` option in `renv` functions. For instance, to check the status of your environment, use `renv::status(dev=TRUE)`. To log packages, use `renv::snapshot(dev=TRUE)`. (`renv::restore()` does not use this flag.)

Note that at project startup, `renv::status(dev=FALSE)` will execute first, reporting that the project is
out-of-sync. After, the project is set up to automatically run `renv::status(dev=TRUE)`, so consult this second output to check the true status of the project.

### Upgrading `{reem}`

To upgrade to a newer version of `{reem}`, first retrieve the commit number for the desired version from the [`{reem}` GitHub repository](https://github.com/phac-nml-phrsd/reem/commits/main/). Then use 

```
renv::install("phac-nml-phrsd/reem@[[commit-number]]")
```

to upgrade `{reem}`, replacing `[[commit-number]]` with the desired commit number.

Snapshot this change with `renv::snapshot(dev=T)`. Note the version number for `{reem}` reported in the confirmation message.

Update the version of `{reem}` saved in the DESCRIPTION file with 

```
usethis::use_package("reem", min_version="[[version-number]]")
```

Now, run all package unit tests with `devtools::test()` and ensure they are passing.

## "Get started" guide

Use `vignettes/reemscenex.Rmd` to get familiar with current package functionality. This demo should be updated as new functions and features are added. 

If you just want to read the vignette and interactively execute the code, you may do so by looking at `vignettes/reemscenex.Rmd`, but be sure to load the latest version of the package with `devtools::load_all()` first (instead of executing `library(reemscenex)` at the top of the vignette, which relies on you having installed a version of the package that will work with the code in the vignette).

If you want to build the entire vignette using the latest version of the package, you must either:

1. Install the package with `devtools::install()` and then use the RStudio `Knit` button, or 
1. Use `devtools::build_rmd("vignettes/my-vignette.Rmd")`, which installs the package in a temporary location before building the file.

Using either of these options will result in `vignettes/reemscenex.html`, which is a disposable preview of the doc---a vignette that would ship with the package would be generated in a different way.

You can always try to compile the vignette without re-installing the package with `rmarkdown::render("vignettes/my-vignette.Rmd")`. This is a much faster process and can be really useful if you're just iterating on vignette text, or you're working on code chunks but you aren't simultaneously working on package functions. However, if you've updated the package since the last time you installed, and your vignette relies on those changes, compilation of the vignette could fail.

## Scenarios guide

Use `vignettes/scenarios.Rmd` to keep track of which scenarios are currently available and to document the development of new scenarios.


