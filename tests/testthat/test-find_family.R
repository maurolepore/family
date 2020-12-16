test_that("with too-long `parent` errors gracefully", {
  expect_error(find_family(c("a", "b")), "must.*length 1")
})

test_that("with parent path finds siblings", {
  # family silings
  parent <- withr::local_tempdir()
  create_file_in_child(parent, child = "a")
  create_file_in_child(parent, child = "b")
  # other
  create_file_in_child(parent, child = "x", "....child")
  create_file_in_child(parent, child = "y", ".child-not-just")
  create_file_in_child(parent, child = "z", "not-dot-child")

  family_siblings <- c("a", "b")
  expect_equal(path_file(find_family(parent)), family_siblings)
})

test_that("with relative path finds siblings", {
  parent <- withr::local_tempdir()
  withr::local_dir(parent)
  create_file_in_child(parent, child = "a")

  expect_equal(path_file(find_family(".")), "a")
})

test_that("with relative path finds siblings", {
  parent <- withr::local_tempdir()
  create_file_in_child(parent, child = "a")

  withr::local_dir(path(parent, "a"))
  out <- find_family("..")
  expected <- as.character(path(parent, "a"))

  out_parent <- fs::path_file(path_dir(out))
  expected_parent <- fs::path_file(path_dir(expected))
  expect_equal(out_parent, expected_parent)

  out_file <- fs::path_file(out)
  expected_file <- fs::path_file(expected)
  expect_equal(out_file, expected_file)
})

test_that("find_children() from parent finds children", {
  parent <- withr::local_tempdir()
  create_file_in_child(parent, child = "a")
  create_file_in_child(parent, child = "b")

  withr::local_dir(parent)
  children <- find_children()
  expect_equal(path_file(children), c("a", "b"))
})

test_that("find_parent() from child finds parent", {
  parent <- withr::local_tempdir()
  create_file_in_child(parent, child = "a")
  create_file_in_child(parent, child = "b")

  withr::local_dir(path(parent, "a"))
  expect_equal(path_file(find_parent()), path_file(parent))
})

test_that("find_siblings() from child finds siblings", {
  parent <- withr::local_tempdir()
  create_file_in_child(parent, child = "a")
  create_file_in_child(parent, child = "b")

  withr::local_dir(path(parent, "a"))
  expect_equal(path_file(find_siblings()), "b")
})

test_that("find_siblings() is sensitive to self", {
  parent <- withr::local_tempdir()
  create_file_in_child(parent, child = "a")
  create_file_in_child(parent, child = "b")

  withr::local_dir(path(parent, "a"))
  expect_equal(path_file(find_siblings(self = TRUE)), c("a", "b"))
})
