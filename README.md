
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
library(fs)
library(withr)
library(family)

wd <- getwd()
on.exit(setwd(wd))

parent <- path(tempdir(), "parent")

me <- dir_create(path(parent, "me"))
sister <- dir_create(path(parent, "sister"))
brother <- dir_create(path(parent, "brother"))

# Add a file ".family" in the root each sibling under a parent directory
file_create(path(me, ".family"))
file_create(path(sister, ".family"))
file_create(path(brother, ".family"))

# Other directories will be ignored
neighbour <- dir_create(path(parent, "neighbour"))

dir_tree(parent)
#> /tmp/Rtmp4igSMj/parent
#> ├── brother
#> ├── me
#> ├── neighbour
#> └── sister

# From anywhere
find_family(parent, family = "^[.]family$")
#> [1] "/tmp/Rtmp4igSMj/parent/brother" "/tmp/Rtmp4igSMj/parent/me"     
#> [3] "/tmp/Rtmp4igSMj/parent/sister"

# From the parent (using default `family = "^[.]family$")
setwd(parent)
children()
#> character(0)

# From a child
setwd(me)
siblings()
#> character(0)
siblings(self = TRUE)
#> character(0)
parent()
#> character(0)

setwd(wd)
```

## Related projects

-   [here](https://github.com/r-lib/here).
