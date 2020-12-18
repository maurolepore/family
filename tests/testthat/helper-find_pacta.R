create_file_in_child <- function(parent, child, family = ".family") {
  child_path <- fs::dir_create(path(parent, child))
  file.create(path(child_path, family))
}
