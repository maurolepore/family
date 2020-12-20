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
#' neighbour <- "neighbour"
#' dir_create(path(mother, c(us, neighbour)))
#'
#' # Define the family with any identifying file in the root of each sibling
#' family_name <- ".us"
#' file_create(path(mother, us, ".us"))
#'
#' dir_tree(mother, recurse = TRUE, all = TRUE)
#'
#' # Find the family from anywhere
#' family(parent = mother, family = family_name)
#'
#' # Find the family from the parent, the siblings or their neighbours
#' setwd(path(mother, "neighbour"))
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
