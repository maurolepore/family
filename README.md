
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

child_a <- dir_create(path(parent, "child_a"))
child_b <- dir_create(path(parent, "child_b"))

# Add a file ".family" in the root each sibling under a parent directory
file_create(path(child_a, ".family"))
file_create(path(child_b, ".family"))

# Other directories will be ignored
neighbour <- dir_create(path(parent, "other"))

dir_tree(parent)
#> /tmp/Rtmpstb3Iy/parent
#> ├── child_a
#> ├── child_b
#> └── other

# From anywhere
find_family(parent, family = "^[.]family$")
#> [1] "/tmp/Rtmpstb3Iy/parent/child_a" "/tmp/Rtmpstb3Iy/parent/child_b"

# From the parent (using default `family = "^[.]family$")
setwd(parent)
find_children()
#> [1] "/tmp/Rtmpstb3Iy/parent/child_a" "/tmp/Rtmpstb3Iy/parent/child_b"

# From any child
setwd(child_a)
find_siblings()
#> [1] "/tmp/Rtmpstb3Iy/parent/child_b"
find_siblings(self = TRUE)
#> [1] "/tmp/Rtmpstb3Iy/parent/child_a" "/tmp/Rtmpstb3Iy/parent/child_b"

setwd(child_b)
find_siblings()
#> [1] "/tmp/Rtmpstb3Iy/parent/child_a"
find_parent()
#> [1] "/tmp/Rtmpstb3Iy/parent"

setwd(wd)
```

## Related projects

-   [here](https://github.com/r-lib/here).
