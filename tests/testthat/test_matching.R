test_that("matchSimilar works", {
    set.seed(123)
    yvals <- abs(rnorm(1000))
    yvals[123] <- yvals[2] - yvals[2] * 10 * 1e-6
    yvals[124] <- yvals[2] + yvals[2] * 10 * 1e-6
    yvals[125] <- yvals[2] + yvals[2] * 12 * 1e-6
    xvals <- yvals[c(2, 3, 3, 20, 21, 20)]
    xvals[2] <- xvals[2] + (10 * xvals[2] / 1e6)
    xvals[3] <- xvals[3] - (10 * xvals[3] / 1e6)
    xvals[6] <- xvals[6] + (12 * xvals[6] / 1e6)

    res <- matchSimilar(xvals, yvals)
    expect_true(is.list(res))
    expect_equal(length(res), length(xvals))
    expect_equal(res[[1]], 2L)
    expect_equal(res[[2]], integer())
    expect_equal(res[[3]], integer())
    expect_equal(res[[4]], 20L)


    res <- matchSimilar(xvals, yvals, ppm = 10)
    expect_equal(res[[1]], c(2L, 123L, 124L))
    expect_equal(res[[2]], 3L)
    expect_equal(res[[3]], 3L)

    res <- matchSimilar(xvals, yvals, ppm = 20)
    expect_equal(res[[1]], c(2L, 123L, 124L, 125L))

    ## Errors
    expect_error(matchSimilar(1:3, 1:6, ppm = c(1, 2)), "'ppm' has to be")
    expect_error(matchSimilar(1:3, 1:3, tolerance = c(1, 2)),
                 "length of 'tolerance'")

    res <- matchSimilar(1:3, c(1.1, 2, 3.1, 2.1, 1))
    expect_equal(res, list(5L, 2L, integer()))

    res <- matchSimilar(1:3, c(1.1, 2, 3.1, 2.1, 1), tolerance = c(0.1, 0, 0))
    expect_equal(res, list(c(1L, 5L), 2L, integer()))
})
