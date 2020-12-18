# Avoid dependency on fs
dir_create <- function(...) {
  path <- path(...)
  dir.create(path, recursive = TRUE)
  invisible(path)
}
path <- function(...) file.path(...)
file_create <- function(...) file.create(...)
dir_ls <- function(...) list.files(...)

path_file <- function (path) {
  is_missing <- is.na(path)
  path[!is_missing] <- basename(path[!is_missing])
  as.character(path)
}

path_dir <- function (path) {
  is_missing <- is.na(path)
  path[!is_missing] <- dirname(path[!is_missing])
  as.character(path)
}
