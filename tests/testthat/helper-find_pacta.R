create_file_in_child <- function(parent, child, file = ".family") {
  child_path <- fs::dir_create(path(parent, child))
  fs::file_create(path(child_path, file))
}
