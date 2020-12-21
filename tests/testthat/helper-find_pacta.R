create_file_in_child <- function(parent, child, family_name = ".us") {
  child_path <- fs::dir_create(path(parent, child))
  fs::file_create(path(child_path, family_name))
}

family_regexp <- function() "^[.]us$"
