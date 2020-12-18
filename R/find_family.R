#' Find directories of a family
#'
#' @param parent A string giving a single path to the parent directory. The
#'   children directories should be nested one level under it.
#' @param family A regular expression to match the name of the file that defines
#'   the family.
#' @param self Include the working directory in the output? Yes: `TRUE`; No:
#'   `FALSE`.
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' library(fs)
#' library(withr)
#' library(family)
#'
#' wd <- getwd()
#' on.exit(setwd(wd))
#'
#' parent <- path(tempdir(), "parent")
#'
#' me <- dir_create(path(parent, "me"))
#' sister <- dir_create(path(parent, "sister"))
#' brother <- dir_create(path(parent, "brother"))
#'
#' # Add a file ".family" in the root each sibling under a parent directory
#' file_create(path(me, ".family"))
#' file_create(path(sister, ".family"))
#' file_create(path(brother, ".family"))
#'
#' # Other directories will be ignored
#' neighbour <- dir_create(path(parent, "neighbour"))
#'
#' dir_tree(parent)
#'
#' # From anywhere
#' find_family(parent, family = "^[.]family$")
#'
#' # From the parent (using default `family = "^[.]family$")
#' setwd(parent)
#' children()
#'
#' # From a child
#' setwd(me)
#' siblings()
#' siblings(self = TRUE)
#' parent()
#'
#' setwd(wd)
find_family <- function(parent, family = getOption("family") %||% "^[.]family") {
  if (!identical(length(parent), 1L)) {
    stop("`parent` must be of length 1", call. = FALSE)
  }

  paths <- list_all_files(parent)
  pick_children(paths, family)
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

list_all_files <- function(parent) {
  fs::dir_ls(fs::path_abs(parent), recurse = 1, all = TRUE)
}

pick_children <- function(paths, family) {
  file_path <- paths[detect_file(paths, family)]
  sort(path_dir(file_path))
}

detect_file <- function(paths, file) {
  grepl(file, path_file(paths))
}

#' @export
#' @rdname find_family
parent <- function(family = getOption("family") %||% "^[.]family") {
  children <- find_family("..", family)
  unique(path_dir(children))
}

#' @export
#' @rdname find_family
children <- function(family = "^[.]family$") {
  find_family(".", family)
}

#' @export
#' @rdname find_family
siblings <- function(family = "^[.]family$", self = FALSE) {
  children <- find_family("..", family)
  if (self) {
    return(children)
  }

  self <- getwd()
  grep(self, children, value = TRUE, invert = TRUE)
}
