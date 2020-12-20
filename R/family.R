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
#' # To define the family, say 'smith', add a file '.smith' to each child directory
#' file_create(path(me, ".smith"))
#' file_create(path(sister, ".smith"))
#' file_create(path(brother, ".smith"))
#'
#' # Other directories will be ignored
#' neighbour <- dir_create(path(parent, "neighbour"))
#'
#' dir_tree(parent)
#'
#' # From anywhere
#' family(parent, family = "^[.]smith$")
#'
#' # You may use convenient helpers form the parent or a child:
#'
#' # From the parent
#' setwd(parent)
#' children("^[.]smith$")
#'
#' # You may also pass `family` via `options()`
#' op <- options(family = "^[.]smith$")
#' on.exit(op, add = TRUE)
#'
#' children()
#'
#' # From a child
#' setwd(me)
#' siblings()
#' siblings(self = TRUE)
#' parent()
#'
#' setwd(wd)
family <- function(parent, family = getOption("family") %||% "^[.]family") {
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
#' @rdname family
parent <- function(family = getOption("family") %||% "^[.]family") {
  children <- family("..", family)
  unique(path_dir(children))
}

#' @export
#' @rdname family
children <- function(family = getOption("family") %||% "^[.]family") {
  family(".", family)
}

#' @export
#' @rdname family
siblings <- function(family = getOption("family") %||% "^[.]family",
                     self = FALSE) {
  children <- family("..", family)
  if (self) {
    return(children)
  }

  self <- getwd()
  grep(self, children, value = TRUE, invert = TRUE)
}
