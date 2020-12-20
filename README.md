
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

Here is a collection of related packages (“sister”, “brother”, and “me”)
and one unrelated neighbour (“them”), all under the same parent
directory (“mother”).

``` r
mother <- path(tempdir(), "mother")
us <- c("sister", "brother", "me")
neighbour <- "neighbour"
dir_create(path(mother, c(us, neighbour)))

dir_tree(mother)
#> /tmp/Rtmp1fMF2i/mother
#> ├── brother
#> ├── me
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
#> /tmp/Rtmp1fMF2i/mother
#> ├── brother
#> │   └── .us
#> ├── me
#> │   └── .us
#> ├── neighbour
#> └── sister
#>     └── .us
```

`find_family()` finds the family from anywhere.

``` r
family::find_family(parent = mother, family = family_name)
#> [1] "/tmp/Rtmp1fMF2i/mother/brother" "/tmp/Rtmp1fMF2i/mother/me"     
#> [3] "/tmp/Rtmp1fMF2i/mother/sister"
```

A handful of other functions help you work more comfortably when your
working directory is set to either the parent directory or one level
under it. For example, `siblngs()` finds the family from any directory
on level under the parent directory.

``` r
setwd(path(mother, "me"))

siblings(family_name, self = TRUE)
#> [1] "/tmp/Rtmp1fMF2i/mother/brother" "/tmp/Rtmp1fMF2i/mother/me"     
#> [3] "/tmp/Rtmp1fMF2i/mother/sister"

siblings(family_name)
#> [1] "/tmp/Rtmp1fMF2i/mother/brother" "/tmp/Rtmp1fMF2i/mother/sister"

# Save typing and reuse your code with other families
options(family = family_name)
siblings()
#> [1] "/tmp/Rtmp1fMF2i/mother/brother" "/tmp/Rtmp1fMF2i/mother/sister"
```
