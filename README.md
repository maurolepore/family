
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

# To define the family, say 'smith', add a file '.smith' to each child directory
file_create(path(me, ".smith"))
file_create(path(sister, ".smith"))
file_create(path(brother, ".smith"))

# Other directories will be ignored
neighbour <- dir_create(path(parent, "neighbour"))

dir_tree(parent)
#> /tmp/RtmpgQjLXP/parent
#> ├── brother
#> ├── me
#> ├── neighbour
#> └── sister

# From anywhere
family::find_family(parent, family = "^[.]smith$")
#> [1] "/tmp/RtmpgQjLXP/parent/brother" "/tmp/RtmpgQjLXP/parent/me"     
#> [3] "/tmp/RtmpgQjLXP/parent/sister"

# From the parent
setwd(parent)
family::children()
#> character(0)
family::children("^[.]smith$")
#> [1] "/tmp/RtmpgQjLXP/parent/brother" "/tmp/RtmpgQjLXP/parent/me"     
#> [3] "/tmp/RtmpgQjLXP/parent/sister"
op <- options(family = "^[.]smith$")
on.exit(op, add = TRUE)
family::children()
#> character(0)

# From a child
setwd(me)
family::siblings()
#> character(0)
family::siblings(self = TRUE)
#> character(0)
family::parent()
#> character(0)

setwd(wd)
```

## Related projects

-   [here](https://github.com/r-lib/here).
