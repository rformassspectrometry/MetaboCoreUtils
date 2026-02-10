test_that("betaValues works", {
    res <- betaValues(1:10, zero.rm = FALSE)
    expect_true(is.numeric(res))
    expect_equal(names(res), c("best_cor", "beta_snr"))
    expect_lt(res[1L], 0.0001)
    expect_lt(res[2L], 2)
    res <- betaValues(1:10, zero.rm = TRUE)
    expect_true(is.numeric(res))
    expect_equal(names(res), c("best_cor", "beta_snr"))
    expect_lt(res[1L], 0.0001)
    expect_lt(res[2L], 2)

    ideal_beta <- dbeta(seq(0, 1, length.out = 10), 5, 5)
    res <- betaValues(ideal_beta, zero.rm = FALSE)
    expect_gte(res[1L], 1)
    expect_gte(res[2L], 16)
    res <- betaValues(ideal_beta, zero.rm = TRUE)
    expect_gte(res[1L], 0.97)
    expect_gte(res[2L], 1)

    skew_beta <- dbeta(seq(0, 1, length.out = 10), 3, 5)
    res <- betaValues(skew_beta, zero.rm = FALSE)
    expect_gte(res[1L], 1)
    expect_gte(res[2L], 16)
    res <- betaValues(skew_beta, zero.rm = TRUE)
    expect_gte(res[1L], 0.90)
    expect_gte(res[2L], 1)

    rightskew_beta <- dbeta(seq(0, 1, length.out = 10), 7, 5)
    res <- betaValues(rightskew_beta)
    expect_gt(res[1L], 0.75)
    expect_gt(res[2L], 0.95)
    res <- betaValues(rightskew_beta, zero.rm = FALSE)
    expect_gt(res[1L], 0.8)
    expect_gt(res[2L], 1)

    noise_beta <- dbeta(seq(0, 1, length.out=21), 5, 5)*10+runif(21)
    res <- betaValues(noise_beta)
    expect_gt(res[1L], 0.9)
    expect_gt(res[2L], 3)

    expect_no_error(betaValues(runif(1)))
    expect_no_error(betaValues(runif(10)))
    expect_no_error(betaValues(runif(100)))

    res <- betaValues(1)
    expect_true(all(is.na(res)))
})

test_that("betaValues works with chromatographic and MS data", {
    vals <- c(2, 3, 4, 6, 8, 10, 7, 6, 4, 3, 2)
    res <- betaValues(vals)
    ## intensity values with duplicated retention times
    vals <- c(2, 3, 4, 6, 2, 8, 10, 7, 6, 4, 3, 2)
    rts <- c(1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10)
    res_a <- betaValues(vals)
    expect_true(res_a[1L] < res[1L])
    ## WARNING: does not work if we have duplicated retention times!
    expect_warning(
        res_b <- betaValues(vals, rts)
    )
    expect_true(is.na(res_b[1L]))
})

test_that("betaValues with real peak data", {
    skinny_peak <- c(9107, 3326, 9523, 3245, 3429, 9394, 1123, 935, 5128, 8576,
                     2711, 3427, 7294, 8109, 9288, 6997, 9756, 8034, 1317, 8866,
                     13877, 14854, 28296, 57101, 92209, 151797, 222386, 299402,
                     365045, 394255, 402680, 363996, 293985, 222989, 147007,
                     94947, 52924, 32438, 11511, 10836, 8046, 601, 889, 5917,
                     2690, 5381, 9901, 8494, 3349, 8283, 3410, 5935, 3332,
                     7041, 3284, 7478, 76, 3739, 2158, 5507)
    skinny_peak_rt <- seq_along(skinny_peak)+100
    res <- betaValues(skinny_peak, skinny_peak_rt)

    res_2 <- betaValues(skinny_peak[20:40], skinny_peak_rt[20:40])
    expect_true(res[1L] < res_2[1L])
    expect_true(res[2L] < res_2[2L])
    expect_gt(res[1L], 0.7)
    expect_gt(res[2L], 0.9)

    noise_peak <- c(0.288, 0.788, 0.409, 0.883, 0.94, 0.046, 0.528, 0.892,
                    0.551, 0.457, 0.957, 0.453, 0.678, 0.573, 0.103, 0.9,
                    0.246, 0.042, 0.328, 0.955, 0.89, 0.693, 0.641, 0.994,
                    0.656, 0.709, 0.544, 0.594, 0.289, 0.147, 0.963, 0.902,
                    0.691, 0.795, 0.025, 0.478, 0.758, 0.216, 0.318, 0.232,
                    0.143, 0.415, 0.414, 0.369, 0.152, 0.139, 0.233, 0.466,
                    0.266, 0.858, 0.046, 0.442, 0.799, 0.122, 0.561, 0.207,
                    0.128, 0.753, 0.895, 0.374, 0.665, 0.095, 0.384, 0.274,
                    0.815, 0.449, 0.81, 0.812, 0.794, 0.44, 0.754, 0.629, 0.71,
                    0.001, 0.475, 0.22, 0.38, 0.613, 0.352, 0.111, 0.244, 0.668,
                    0.418, 0.788, 0.103, 0.435, 0.985, 0.893, 0.886, 0.175,
                    0.131, 0.653, 0.344, 0.657, 0.32, 0.188, 0.782, 0.094,
                    0.467, 0.512)
    noise_peak_rt <- seq_along(noise_peak) + 10
    res <- betaValues(noise_peak, noise_peak_rt)
    expect_lt(res[1L], 0.1)
    expect_lt(res[2L], 0.5)
})
