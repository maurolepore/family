
<!-- README.md is generated from README.Rmd. Please edit that file -->

# family

<!-- badges: start -->

[![R-CMD-check](https://github.com/maurolepore/family/workflows/R-CMD-check/badge.svg)](https://github.com/maurolepore/family/actions)
[![Codecov test
coverage](https://codecov.io/gh/maurolepore/family/branch/master/graph/badge.svg)](https://codecov.io/gh/maurolepore/family?branch=master)
<!-- badges: end -->

The goal of the this package is to make it easy to reference a family of
related directories, with one or more children directories under the
same parent directory.

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
#> /tmp/RtmpQCpCwG/parent
#> ├── brother
#> ├── me
#> ├── neighbour
#> └── sister

# From anywhere
family::find_family(parent, family = "^[.]smith$")
#> [1] "/tmp/RtmpQCpCwG/parent/brother" "/tmp/RtmpQCpCwG/parent/me"     
#> [3] "/tmp/RtmpQCpCwG/parent/sister"

# You may use convenient helpers form the parent or a child:

# From the parent
setwd(parent)
family::children("^[.]smith$")
#> [1] "/tmp/RtmpQCpCwG/parent/brother" "/tmp/RtmpQCpCwG/parent/me"     
#> [3] "/tmp/RtmpQCpCwG/parent/sister"

# You may pass `family` via `options()`
op <- options(family = "^[.]smith$")
on.exit(op, add = TRUE)

family::children()
#> [1] "/tmp/RtmpQCpCwG/parent/brother" "/tmp/RtmpQCpCwG/parent/me"     
#> [3] "/tmp/RtmpQCpCwG/parent/sister"

# From a child
setwd(me)
family::siblings()
#> [1] "/tmp/RtmpQCpCwG/parent/brother" "/tmp/RtmpQCpCwG/parent/sister"
family::siblings(self = TRUE)
#> [1] "/tmp/RtmpQCpCwG/parent/brother" "/tmp/RtmpQCpCwG/parent/me"     
#> [3] "/tmp/RtmpQCpCwG/parent/sister"
family::parent()
#> [1] "/tmp/RtmpQCpCwG/parent"

setwd(wd)
```

## Related projects

-   Inspired by the package [here](https://github.com/r-lib/here).
