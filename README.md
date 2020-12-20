
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
library(family)
library(fs)
```

Here is a collection of related packages (“sister”, “brother”) and one
unrelated neighbour (“them”), all under the same parent directory
(“mother”).

``` r
mother <- path(tempdir(), "mother")
us <- c("sister", "brother")
neighbour <- "neighbour"
dir_create(path(mother, c(us, neighbour)))

dir_tree(mother)
#> /tmp/Rtmpbqof9n/mother
#> ├── brother
#> ├── neighbour
#> └── sister
```

To define the family we add an empty file under the root of each
sibling. You may name it anything, maybe starting with “.” so the file
is hidden.

``` r
family_name <- ".us"
file_create(path(mother, us, ".us"))

dir_tree(mother, recurse = TRUE, all = TRUE)
#> /tmp/Rtmpbqof9n/mother
#> ├── brother
#> │   └── .us
#> ├── neighbour
#> └── sister
#>     └── .us
```

`family()` finds the family from anywhere.

``` r
family(parent = mother, family = family_name)
#> [1] "/tmp/Rtmpbqof9n/mother/brother" "/tmp/Rtmpbqof9n/mother/sister"
```

A handful of other functions help you work more comfortably when your
working directory is set to either the parent directory or one level
under it. For example, `siblngs()` finds the family from any family
member or unrelated neighbour.

``` r
setwd(path(mother, "neighbour"))
siblings(family_name, self = TRUE)
#> [1] "/tmp/Rtmpbqof9n/mother/brother" "/tmp/Rtmpbqof9n/mother/sister"

setwd(path(mother, "sister"))
siblings(family_name, self = TRUE)
#> [1] "/tmp/Rtmpbqof9n/mother/brother" "/tmp/Rtmpbqof9n/mother/sister"

siblings(family_name)
#> [1] "/tmp/Rtmpbqof9n/mother/brother"

# Save typing and reuse code with other families
options(family = family_name)
siblings()
#> [1] "/tmp/Rtmpbqof9n/mother/brother"
```
