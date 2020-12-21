#' Find directories of a family
#'
#' @param parent A string giving a single path to the parent directory. The
#'   children directories should be nested one level under it.
#' @param regexp A regular expression to match the name of the file that defines
#'   the family. You may pass it directly of with "options()", e.g.
#'   `options(family.regexp = "^[.]us$")`.
#' @param self Include the working directory in the output? Yes: `TRUE`; No:
#'   `FALSE`.
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' library(fs)
#' library(family)
#'
#' restore_working_directory <- getwd()
#'
#' mother <- path(tempdir(), "mother")
#' siblings <- c("sister", "brother")
#' neighbour <- "neighbour"
#' dir_create(path(mother, c(siblings, neighbour)))
#'
#' # Define the family with any identifying file in the root of each sibling
#' family_name <- ".us"
#' family_regexp <- "^[.]us$"
#' file_create(path(mother, siblings, family_name))
#'
#' dir_tree(mother, recurse = TRUE, all = TRUE)
#'
#' # Find the family from anywhere
#' find_family(parent = mother, regexp = family_regexp)
#'
#' # Find the family from the parent, the siblings or their neighbours
#' setwd(path(mother, "neighbour"))
#' siblings(family_regexp, self = TRUE)
#'
#' setwd(path(mother, "sister"))
#' siblings(family_regexp, self = TRUE)
#'
#' siblings(family_regexp)
#'
#' # Save typing and reuse code with other families
#' restore_options <- options(family.regexp = family_regexp)
#' siblings()
#'
#' parent()
#'
#' setwd(parent())
#' children()
#'
#' # Cleanup
#' options(restore_options)
#' setwd(restore_working_directory)
find_family <- function(parent, regexp = NULL) {
  regexp <- regexp %||% getOption("family.regexp")
  check_find_family(parent, regexp)

  candidates <- find_candidates(parent)
  children <- unique(pick_children(candidates, regexp))
  children
}

#' @export
#' @rdname find_family
parent <- function(regexp = NULL) {
  regexp <- regexp %||% getOption("family.regexp")
  children <- find_family("..", regexp)
  unique(path_dir(children))
}

#' @export
#' @rdname find_family
children <- function(regexp = NULL) {
  regexp <- regexp %||% getOption("family.regexp")
  find_family(".", regexp)
}

#' @export
#' @rdname find_family
siblings <- function(regexp = NULL, self = FALSE) {
  regexp <- regexp %||% getOption("family.regexp")
  children <- find_family("..", regexp)
  if (self) {
    return(children)
  }

  grep(getwd(), children, value = TRUE, invert = TRUE)
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

check_find_family <- function(parent, regexp) {
  stop_if_too_long(parent)
  if (is.null(regexp)) {
    stop(
      "`family` must be provided.\n",
      "Did you forget to pass it (via `options()` or directly)?",
      call. = FALSE
    )
  }

  invisible(parent)
}

stop_if_too_long <- function(parent) {
  if (!identical(length(parent), 1L)) {
    stop("`parent` must be of length 1", call. = FALSE)
  }

  invisible(parent)
}

find_candidates <- function(parent) {
  dirs <- list_all_dirs(parent, type = "directory")
  children_files <- list_all_dirs(dirs)
  children_files
}

list_all_dirs <- function(parent, type = "any") {
  fs::dir_ls(fs::path_abs(parent), all = TRUE, type = type)
}

pick_children <- function(paths, regexp) {
  is_family <- grepl(regexp, path_file(paths))
  child_files <- paths[is_family]
  child_dirs <- sort(path_dir(child_files))
  child_dirs
}
