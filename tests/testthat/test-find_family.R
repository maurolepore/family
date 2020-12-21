test_that("with too-long `parent` errors gracefully", {
  expect_error(find_family(parent = "."), "can't.*NULL")
})

test_that("with too-long `parent` errors gracefully", {
  expect_error(find_family(c("a", "b")), "must.*length 1")
})

test_that("with parent path finds siblings", {
  parent <- withr::local_tempdir()

  siblings <- c("a", "b")
  create_file_in_child(parent, siblings, family = ".us")
  # Tricky files that should be ignored
  create_file_in_child(parent, child = "x", "....child")
  create_file_in_child(parent, child = "y", ".child-not-just")
  create_file_in_child(parent, child = "z", "not-dot-child")

  expect_equal(path_file(find_family(parent, "^[.]us$")), siblings)
})

test_that("with family defined via options(), finds siblings", {
  parent <- withr::local_tempdir()
  create_file_in_child(parent, child = "a", family = ".us")
  withr::local_dir(parent)

  withr::local_options(list(family = ".us"))
  expect_equal(path_file(find_family(".")), "a")
})

test_that("with relative path from the parent, finds siblings", {
  parent <- withr::local_tempdir()
  create_file_in_child(parent, child = "a", family = ".us")
  # From the parent
  withr::local_dir(parent)

  expect_equal(path_file(find_family(".", family = ".us")), "a")
})

test_that("with relative path from a child, finds siblings", {
  parent <- withr::local_tempdir()
  name <- ".us"
  create_file_in_child(parent, child = "a", family = name)
  # From a child
  withr::local_dir(path(parent, "a"))

  out <- find_family("..", family = name)
  expected <- as.character(path(parent, "a"))

  out_parent <- fs::path_file(path_dir(out))
  expected_parent <- fs::path_file(path_dir(expected))
  expect_equal(out_parent, expected_parent)

  out_file <- fs::path_file(out)
  expected_file <- fs::path_file(expected)
  expect_equal(out_file, expected_file)
})

test_that("children() from parent finds children", {
  parent <- withr::local_tempdir()
  siblings <- c("a", "b")
  create_file_in_child(parent, child = siblings, family = ".family")

  withr::local_dir(parent)
  children <- children()
  expect_equal(path_file(children), siblings)
})

test_that("children() with family defined in options(), finds parent", {
  parent <- withr::local_tempdir()
  siblings <- c("a", "b")
  create_file_in_child(parent, child = siblings, family = ".us")

  withr::local_dir(parent)
  withr::local_options(list(family = ".us"))
  expect_equal(path_file(children()), c("a", "b"))
})

test_that("parent() from child finds parent", {
  parent <- withr::local_tempdir()
  siblings <- c("a", "b")
  create_file_in_child(parent, child = siblings, family = ".family")

  withr::local_dir(path(parent, "a"))
  expect_equal(path_file(parent()), path_file(parent))
})

test_that("parent() with family defined in options(), finds parent", {
  parent <- withr::local_tempdir()
  siblings <- c("a", "b")
  create_file_in_child(parent, child = siblings, family = ".us")

  withr::local_dir(path(parent, "a"))
  withr::local_options(list(family = ".us"))
  expect_equal(path_file(parent()), path_file(parent))
})

test_that("siblings() from child finds siblings", {
  parent <- withr::local_tempdir()
  siblings <- c("a", "b")
  create_file_in_child(parent, child = siblings, family = ".family")

  withr::local_dir(path(parent, "a"))
  expect_equal(path_file(siblings()), "b")
})

test_that("siblings() is sensitive to self", {
  parent <- withr::local_tempdir()
  siblings <- c("a", "b")
  create_file_in_child(parent, child = siblings, family = ".family")

  withr::local_dir(path(parent, "a"))
  expect_equal(path_file(siblings(self = TRUE)), siblings)
})

test_that("siblings() with family defined in options(), finds parent", {
  parent <- withr::local_tempdir()
  siblings <- c("a", "b")
  create_file_in_child(parent, child = siblings, family = ".us")

  withr::local_dir(path(parent, "a"))
  withr::local_options(list(family = ".us"))
  expect_equal(path_file(siblings()), "b")
})

test_that("siblings() from one level into a child errors gracefully", {
  parent <- withr::local_tempdir()
  create_file_in_child(parent, child = "a", family = ".us")
  fs::dir_create(path(parent, "a", "1"))
  withr::local_dir(path(parent, "a", "1"))

  expect_error(siblings(family = ".us"), "parent.*shouldn't.*match.* ")
})
