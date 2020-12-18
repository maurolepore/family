
<!-- README.md is generated from README.Rmd. Please edit that file -->

# family

<!-- badges: start -->

[![R-CMD-check](https://github.com/maurolepore/family/workflows/R-CMD-check/badge.svg)](https://github.com/maurolepore/family/actions)
[![Codecov test
coverage](https://codecov.io/gh/maurolepore/family/branch/master/graph/badge.svg)](https://codecov.io/gh/maurolepore/family?branch=master)
<!-- badges: end -->

The goal of the this package is to make it easy to reference a family of
related directories, with one or more children directories under the
same parent directory. Inspired by the package
[here](https://github.com/r-lib/here), it is a simple way to find
directories.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("maurolepore/family")
```

## Example

``` r
wd <- getwd()
on.exit(setwd(wd))

# Helper
create_directory <- function(...) {
  path <- file.path(...)
  dir.create(path, recursive = TRUE)
  invisible(path)
}



parent <- file.path(tempdir(), "parent")
me <- create_directory(file.path(parent, "me"))
sister <- create_directory(file.path(parent, "sister"))
brother <- create_directory(file.path(parent, "brother"))

# Add a file ".family" in the root each sibling under a parent directory
file.create(file.path(me, ".family"))
#> [1] TRUE
file.create(file.path(sister, ".family"))
#> [1] TRUE
file.create(file.path(brother, ".family"))
#> [1] TRUE

# Other directories will be ignored
neighbour <- create_directory(file.path(parent, "neighbour"))

list.files(parent)
#> [1] "brother"   "me"        "neighbour" "sister"

# From anywhere
family::find_family(parent, family = "^[.]family$")
#> [1] "/tmp/RtmpCrLgha/parent/brother" "/tmp/RtmpCrLgha/parent/me"     
#> [3] "/tmp/RtmpCrLgha/parent/sister"

# From the parent (using default `family = "^[.]family$")
setwd(parent)
family::children()
#> [1] "/tmp/RtmpCrLgha/parent/brother" "/tmp/RtmpCrLgha/parent/me"     
#> [3] "/tmp/RtmpCrLgha/parent/sister"

# From a child
setwd(me)
family::siblings()
#> [1] "/tmp/RtmpCrLgha/parent/brother" "/tmp/RtmpCrLgha/parent/sister"
family::siblings(self = TRUE)
#> [1] "/tmp/RtmpCrLgha/parent/brother" "/tmp/RtmpCrLgha/parent/me"     
#> [3] "/tmp/RtmpCrLgha/parent/sister"
family::parent()
#> [1] "/tmp/RtmpCrLgha/parent"

setwd(wd)
```

## Related projects

-   Inspired by [here](https://github.com/r-lib/here).
