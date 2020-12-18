
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

wd <- getwd()
on.exit(setwd(wd))

parent <- path(tempdir(), "parent")

me <- dir_create(path(parent, "me"))
sister <- dir_create(path(parent, "sister"))
brother <- dir_create(path(parent, "brother"))

# Add a file ".family" in the root each sibling under a parent directory
file.create(path(me, ".family"))
#> [1] TRUE
file.create(path(sister, ".family"))
#> [1] TRUE
file.create(path(brother, ".family"))
#> [1] TRUE

# Other directories will be ignored
neighbour <- dir_create(path(parent, "neighbour"))

dir_tree(parent)
#> /tmp/RtmpSkNshh/parent
#> ├── brother
#> ├── me
#> ├── neighbour
#> └── sister

# From anywhere
family::find_family(parent, family = "^[.]family$")
#> [1] "/tmp/RtmpSkNshh/parent/brother" "/tmp/RtmpSkNshh/parent/me"     
#> [3] "/tmp/RtmpSkNshh/parent/sister"

# From the parent (using default `family = "^[.]family$")
setwd(parent)
family::children()
#> [1] "/tmp/RtmpSkNshh/parent/brother" "/tmp/RtmpSkNshh/parent/me"     
#> [3] "/tmp/RtmpSkNshh/parent/sister"

# From a child
setwd(me)
family::siblings()
#> [1] "/tmp/RtmpSkNshh/parent/brother" "/tmp/RtmpSkNshh/parent/sister"
family::siblings(self = TRUE)
#> [1] "/tmp/RtmpSkNshh/parent/brother" "/tmp/RtmpSkNshh/parent/me"     
#> [3] "/tmp/RtmpSkNshh/parent/sister"
family::parent()
#> [1] "/tmp/RtmpSkNshh/parent"

setwd(wd)
```

## Related projects

-   [here](https://github.com/r-lib/here).
