#' Find directories of a family
#'
#' @param parent A string giving a single path to the parent directory. The
#'   children directories should be nested one level under it.
#' @param family A regular expression to match the name of the file that defines
#'   the family.
#' @param self `FALSE` excludes the working directory in the output?
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
#' child_a <- dir_create(path(parent, "child_a"))
#' child_b <- dir_create(path(parent, "child_b"))
#'
#' # Add a file ".child" in the root each sibling under a parent directory
#' file_create(path(child_a, ".child"))
#' file_create(path(child_b, ".child"))
#'
#' # Other directories will be ignored
#' neighbour <- dir_create(path(parent, "other"))
#'
#' dir_tree(parent)
#'
#' # From anywhere
#' find_family(parent, family = "^[.]child$")
#'
#' # From the parent (using default `family = "^[.]child$")
#' setwd(parent)
#' find_children()
#'
#' # From any child
#' setwd(child_a)
#' find_siblings()
#' find_siblings(self = TRUE)
#'
#' setwd(child_b)
#' find_siblings()
#' find_parent()
#'
#' setwd(wd)
find_family <- function(parent, family = "^[.]child$") {
  if (!identical(length(parent), 1L)) {
    stop("`parent` must be have length 1", call. = FALSE)
  }

  paths <- list_all_files(parent)
  pick_children(paths, family)
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
find_parent <- function(parent = "..", family = "^[.]child$") {
  children <- find_family(parent, family)
  unique(path_dir(children))
}

#' @export
#' @rdname find_family
find_children <- function(parent = ".", family = "^[.]child$") {
  find_family(parent, family)
}

#' @export
#' @rdname find_family
find_siblings <- function(parent = "..", family = "^[.]child$", self = FALSE) {
  children <- find_family(parent, family)
  if (self) {
    return(children)
  }

  self <- getwd()
  grep(self, children, value = TRUE, invert = TRUE)
}
