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
#' restore_working_directory <- getwd()
#'
#' mother <- path(tempdir(), "mother")
#' us <- c("sister", "brother")
#' neighbor <- "neighbor"
#' dir_create(path(mother, c(us, neighbor)))
#'
#' # Define the family with any identifying file in the root of each sibling
#' family_name <- ".us"
#' file_create(path(mother, us, ".us"))
#'
#' dir_tree(mother, recurse = TRUE, all = TRUE)
#'
#' # Find the family from anywhere
#' find_family(parent = mother, family = family_name)
#'
#' # Find the family from the parent, the siblings or their neighbors
#' setwd(path(mother, "neighbor"))
#' siblings(family_name, self = TRUE)
#'
#' setwd(path(mother, "sister"))
#' siblings(family_name, self = TRUE)
#'
#' siblings(family_name)
#'
#' # Save typing and reuse code with other families
#' restore_options <- options(family = family_name)
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
find_family <- function(parent, family = getOption("family") %||% "^[.]family") {
  stop_if_too_long(parent)

  candidates <- find_candidates(parent, family)
  children <- pick_children(candidates, family)
  children
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

stop_if_too_long <- function(parent) {
  if (!identical(length(parent), 1L)) {
    stop("`parent` must be of length 1", call. = FALSE)
  }

  invisible(parent)
}

find_candidates <- function(parent, family) {
  all_files <- list_all_files(parent)
  stop_if_nested_too_deeply(all_files, family)
  children_files <- list_all_files(all_files)
  children_files
}

list_all_files <- function(parent) {
  fs::dir_ls(fs::path_abs(parent), all = TRUE)
}

stop_if_nested_too_deeply <- function(files, family) {
  if (any(grepl(family, files))) {
    stop(
      "The parent directory shouldn't have a file matching '", family, "'.\n",
      "Is your working directory nested too deeply?\n",
      getwd(),
      call. = FALSE
    )
  }

  invisible(files)
}

working_from_granchild <- function(parent, family) {
  fs::file_exists(path(parent, family))
}

pick_children <- function(paths, family) {
  is_family <- grepl(family, path_file(paths))
  child_files <- paths[is_family]
  child_dirs <- sort(path_dir(child_files))
  child_dirs
}

detect_file <- function(paths, family) {
  grepl(family, path_file(paths))
}

#' @export
#' @rdname find_family
parent <- function(family = getOption("family") %||% "^[.]family") {
  children <- find_family("..", family)
  unique(path_dir(children))
}

#' @export
#' @rdname find_family
children <- function(family = getOption("family") %||% "^[.]family") {
  find_family(".", family)
}

#' @export
#' @rdname find_family
siblings <- function(family = getOption("family") %||% "^[.]family",
                     self = FALSE) {
  children <- find_family("..", family)
  if (self) {
    return(children)
  }

  grep(getwd(), children, value = TRUE, invert = TRUE)
}
