test_that("Migration time conversion works", {
    expect_equal(convertMtime(numeric()), numeric())

  ## load test data
  rtime <- c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
  marker <- c(20, 80)
  mobility <- c(0, 2000)
  marker_s <- 20
  mobility_s <- 0

  mu_s <- convertMtime(rtime, marker_s, mobility_s, U = 30, L = 90)
  mu_m <-  convertMtime(rtime, marker, mobility)

  expect_equal(length(mu_s), length(rtime))
  expect_equal(length(mu_m), length(rtime))
  expect_true(is.numeric(mu_s))
  expect_true(is.numeric(mu_m))
  expect_equal(sum(mu_s), -55.91786, tolerance = 1e-06)
  expect_equal(sum(mu_m), 11045.5, tolerance = 1e-06)
  expect_error(convertMtime(x = rtime, rtime = marker_s, mobility = mobility),
               "'rtime' and 'mobility' need to have the same length")
  expect_error(convertMtime(x = rtime, rtime = c(1,2,3), mobility = c(20,40,60)),
               "'rtime' and 'mobility' are expected to have either length 1 or 2 but not 3")
  expect_warning(convertMtime(x = rtime, rtime = marker,
                              mobility = mobility, tR = c(3,4)),
               "Length or parameter 'tR' > 1 but using only first element")
  expect_error(convertMtime(x = rtime, rtime = marker_s, mobility = mobility_s),
               "'U' and 'L' are expected to be of length 1.")

})

test_that("convertMultiple works", {
    expect_error(
        convertMultiple(1:3, 1:3, mobility = c(1, 2)), "expected to be")
})
