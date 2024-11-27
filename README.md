# reemscenex

An R package to perform scenario exploration using [reem](https://github.com/phac-nml-phrsd/reem).

## Get started

Please review the main package vignette (`vignette("reemscenex")`) first, followed by the supplementary scenarios vignette (`vignette("scenarios")`) to get started.

---

## For developers

To start, be sure to always

1. Identify the branch you want to work on (check on GitLab for available branches and locally in GitHub Desktop for the ones you have available)
1. Sync with the cloud repo on GitLab via GitHub Desktop

### `renv`

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

### "Get started" guide

Use `vignettes/reemscenex.Rmd` to get familiar with current package functionality. This demo should be updated as new functions and features are added. 

If you just want to read the vignette and interactively execute the code, you may do so by looking at `vignettes/reemscenex.Rmd`, but be sure to load the latest version of the package with `devtools::load_all()` first (instead of executing `library(reemscenex)` at the top of the vignette, which relies on you having installed a version of the package that will work with the code in the vignette).

If you want to build the entire vignette using the latest version of the package, you must either:

1. Install the package with `devtools::install()` and then use the RStudio `Knit` button, or 
1. Use `devtools::build_rmd("vignettes/my-vignette.Rmd")`, which installs the package in a temporary location before building the file.

Using either of these options will result in `vignettes/reemscenex.html`, which is a disposable preview of the doc---a vignette that would ship with the package would be generated in a different way.

You can always try to compile the vignette without re-installing the package with `rmarkdown::render("vignettes/my-vignette.Rmd")`. This is a much faster process and can be really useful if you're just iterating on vignette text, or you're working on code chunks but you aren't simultaneously working on package functions. However, if you've updated the package since the last time you installed, and your vignette relies on those changes, compilation of the vignette could fail.

### Scenarios guide

Use `vignettes/scenarios.Rmd` to keep track of which scenarios are currently available and to document the development of new scenarios.

## Lisa's workflow notes

**When sitting down to work on the project again:**

1. Identify the task you want to work on. Usually this will be documented in an [Issue on GitLab](https://gitlab.cscscience.ca/phrsd/risk/reemscenex/-/issues)
1. In GitHub Desktop, create or switch to the branch on which you want to complete this task (the associated "working branch"). 
    - If there is work in progress on this Issue, you should see the working branch name documented in the Issue thread.
    - If no work has been done for this issue, create a working branch based off of the latest version of `main` (which you can get by switching to `main`, clicking the "Fetch origin" button, and then the "Pull" button if there are any changes). Once your copy of `main` is up to date, go into the "Current branch" menu and select the "New branch". Choose a name that is succinct and evocative of the task you seek to accomplish. Finish by publishing this branch to the origin repository (on GitLab) by selecting the "Publish branch" button that will appear once the branch has been created. Document the name of your working branch in the associated issue.
1. Open the RStudio project, either by double clicking `reemscenex.Rproj` in Windows Explorer or by going to RStudio, clicking into the Projects menu at the top right of the window, and selecting `reemscenex`.
1. Check the last message put out by the R console. This will be the outputs of `renv::status(dev=T)`.
    - If the message says the project is in a consistent state, you can move on. 
    - If instead the message reports that your project is in an inconsistent state, resolve these issues. Typically, if your `renv` project is out of date in this context, it is because a collaborator added new/updated dependencies in the `renv` lockfile that are not yet installed in your local library. In that case, you'd want to do `renv::restore()`. Follow its prompts and skip updates to packages with new versions (why poke the bear?). Restart your R console if instructed.
1. Use `load_all()` to load the package in its current state. You will now have access to package functions in your R console.

**While developing vignettes (editing files in `vignettes`):**

1. You can read the raw `.Rmd` file and execute chunks interactively. This is the easiest way to work on vignettes, especially if you are going back and forth between writing in the vignette file and writing package code. You should have access to the latest version of the package functions from doing `load_all()` in the setup above.
1. If you want to knit the whole vignette (perhaps you want to check that the vignette text displays as desired after compilation), you can try to do so with `rmarkdown::render_rmd("vignettes/my-vignette.Rmd")`. However, if you're getting errors related to package functions, it might be because the version of our package you have installed is out of date (perhaps you recently added a function to the package code that you use in a vignette chunk). In this case, use `install()` to re-install the package (so that when `library(reemscenex)` gets called when the vignette is knitted, it will use the latest version of the package).

**While developing package code (editing files in `R/` or `tests/testthat/`):**

1. Use `use_r(myfun.R)` to create a new `.R` file in `R/` for your fabulous new package function called `myfun()`. If the file already exists, this command will simply open it for you.
1. Write your function! Use `load_all()` to play around with your newly-written function in the R console. 
    - **`load_all()` quickly re-loads the package in your console** (avoiding a time-consuming re-install) so that you can experiment with any newly-written/edited functions on the fly. Re-run it any time you've made changes to package functions that you want to experiment with in the console.
    - If you want to use functions from a package within your function definition (and functions from this package have not yet been used elsewhere in our package functions---excluding vignettes), do `use_package("pkgname")` and then refer to functions from it with `pkgname::funname()` within your function definition. You can see the list of existing dependencies for our package in the `DESCRIPTION` file (the "Imports:" field). Then use `renv::snapshot(dev=T)` to record this package as a dependency in our project environment. This will update the lockfile to include this package.
1. Once you have a basic version of your function, use `use_test()` to create a place to write tests for your function. 
    - **`use_test()` will create a test file** within `tests/testthat/` for the `.R` file that is currently visible in your editor pane (the "active file"---this should be a package function file). If the test file already exists, this command will simply open it for you.
    - Start with just a few basic tests. You don't need to think of every possible case to start.
    - The [`testthat` function reference](https://testthat.r-lib.org/reference/index.html#expectations) lists all of its expectation functions (`expect_*()`) that can help you think of what to test.
1. Use **`test_active_file()` to run your tests**. Make sure they're all passing before moving on!
1. Sometimes while thinking up tests, you realize that you need to add something to your function definition. This is super helpful! Add a test you'd want your function to pass to its test file, and then go back to the function and go between update its definition and running your tests until all tests have passed.
1. Once your function definition has settled down, **add function documentation** by putting your cursor in the function definition and using the shortcut `Ctrl + Alt + Shift + R` to insert a `roxygen` skeleton for your function above its definition.
    - Fill in this skeleton and then use **`document()` to generate compiled documentation pages** (`.Rd` files stored in `man`) that can be called up quickly from the console using `?myfun`.

**When you're wrapping up a work session:**

If you are not yet done with resolving the issue you're working on:

1. In GitHub Desktop, select the changes you want to bundle together, write a commit message, and hit the commit button
1. Push commits up to `origin` when you want to make them visible in GitLab (to others).

If you have finished work on the issue:

1. Create a merge request in GitLab from your working branch to `main` and request a review of your work, if desired.
    - In GitHub Desktop, start by ensuring all of the changes to your working branch are committed and pushed up to `origin`.
        - Next, switch to `main` and pull the latest changes available in `origin`.
        - Switch back to your working branch and go into the "Current branch" menu. Click the button at the bottom of the menu that says "Choose a branch to merge into `[[WORKING-BRANCH]]`" and select `main`.
        - Resolve any merge conflicts from pulling `main` into your working branch.
        - Push your changes up to `origin`
    - Go to GitLab to create a merge request.
        - There should be a banner with a button to create a merge request from your working branch to `main` on the repo home page. Click that to open a merge request. If this banner is not available, go into the side menu, `Code > Merge requests` and click the "New merge request" button. The source branch is your working branch and the target branch is `main`.
        - Give your merge request a short but descriptive title. 
        - In the description, add any notes about what you did and anything you want the reviewer to focus on. You should also connect the focal issue to the merge request so that it gets closed when the Merge Request is accepted by using a phrase like "fixes #2" on a new line of the description (_e.g._ to link issue #2).
        - Request a reviewer if you desire.
        - Options for the working branch upon merge:
            - “Delete”: This option will delete the source branch once accepted **on origin** (each collaborator would need to manually delete their local version of this branch, if they have it.) Working branches should generally be thought of as disposable, so once a branch has fulfilled its purpose (all its changes have been merged into `main`, there is usually no reason to keep the working branch around).
    almost always do this – delete it in the origin will not delete the local copy and so delete the local copy
            - “Squash”: This option affects how the history of the working branch is integrated into `main` branch's history. Whether or not you want to do this depends on how you prefer to keep the history. The default is to just slot the working branches commits into `main`'s history with all the incremental steps logged via commit, while the "squash" option squashes the working branch's history into a single commit.
    - Once your request is reviewed and approved, the assignee should click the "Merge" button. This will also close the associated issue if you used trigger text in the description as suggested above. Your changes are now live in `main`! 
    - Any related working branches should now be deleted from the `origin` repository in GitLab, as well as locally, to keep the branch list current. The copy on `origin` will usually be deleted by the repository maintainer when the merge request is closed, so all that's left to do is delete your local copy.

Lisa notes:
1. Debugging - https://support.posit.co/hc/en-us/articles/205612627-Debugging-with-the-RStudio-IDE
1. test() at the end of making new functions and code - I love these!!! Check that everything was accounted for
1. if getting an error while trying to knit a vignette then make sure to install()
