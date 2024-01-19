test_that("Metabolomics Filtering Functions", {

    # Define some sample data for testing
    a <- c(3.2, 4.1, 3.9, 4.8)
    A <- rbind(a, a, a)
    b <- c(2, NA, 1, 3, NA)
    B <- matrix(c(2, NA, 1, 3, NA, 6, 7, 8, 9, 12), nrow = 2)
    test_samples <- matrix(c(13, 21, 1, 3, 5, 6), nrow = 3)
    blank_samples <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 3)

    # Test rsd function
    expect_equal(rsd(a), sd(a) / mean(a))
    expect_equal(rowRsd(A), apply(A, 1, function(row) sd(row) / mean(row)))
    expect_equal(rsd(a, mad = TRUE), mad(a, na.rm = TRUE) /
                     abs(median(a, na.rm = TRUE)))
    expect_equal(rowRsd(A, mad = TRUE),
                 apply(A, 1, function(row) mad(row, na.rm = TRUE) /
                           abs(median(row, na.rm = TRUE))))


    # Test rowDratio function
    expect_equal(as.numeric(rowDratio(A, A)), rep(1, nrow(A)))
    expect_equal(as.numeric(rowDratio(A, A, mad = TRUE)), rep(1, nrow(A)))

    # Test percentMissing function
    expect_equal(percentMissing(b), 40)
    res <- c()
    expect_equal(rowPercentMissing(B), rep(20, nrow(B)))

    # Test rowBlank function
    expect_equal(rowBlank(test_samples, blank_samples), c(FALSE, FALSE, TRUE))
    })
