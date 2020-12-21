
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
```

To define the family we add an empty file under the root of each
sibling. You may name it anything, maybe starting with “.” so the file
is hidden.

``` r
family_name <- ".us"
family_regexp <- "^[.]us$"
file_create(path(mother, us, family_name))

dir_tree(mother, recurse = TRUE, all = TRUE)
#> /tmp/Rtmpg1fiYf/mother
#> ├── brother
#> │   └── .us
#> ├── neighbour
#> └── sister
#>     └── .us
```

`find_family()` finds the family from anywhere.

``` r
find_family(parent = mother, regexp = family_regexp)
#> [1] "/tmp/Rtmpg1fiYf/mother/brother" "/tmp/Rtmpg1fiYf/mother/sister"
```

A handful of other functions help you work more comfortably when your
working directory is set to either the parent directory or one level
under it. For example, `siblngs()` finds the family from any family
member or unrelated neighbour.

``` r
setwd(path(mother, "neighbour"))
siblings(family_regexp, self = TRUE)
#> [1] "/tmp/Rtmpg1fiYf/mother/brother" "/tmp/Rtmpg1fiYf/mother/sister"

setwd(path(mother, "sister"))
siblings(family_regexp, self = TRUE)
#> [1] "/tmp/Rtmpg1fiYf/mother/brother" "/tmp/Rtmpg1fiYf/mother/sister"

siblings(family_regexp)
#> [1] "/tmp/Rtmpg1fiYf/mother/brother"

# Save typing and reuse code with other families
options(family.regexp = family_regexp)
siblings()
#> [1] "/tmp/Rtmpg1fiYf/mother/brother"
```
