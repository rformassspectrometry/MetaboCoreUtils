vals <- read.table(system.file("txt", "feature_values.txt",
                               package = "MetaboCoreUtils"), sep = "\t")
vals <- as.matrix(vals)
sdata <- data.frame(injection_index = seq_len(ncol(vals)))

test_that(".check_formula works", {
    .check_formula(y ~ x + a, data.frame(x = 1:3, a = 1:3))
    expect_error(.check_formula(i ~ x + a, data.frame(x = 1:3, a = 1:3)), "y ~")
    expect_error(.check_formula(y ~ x + a, data.frame(x = 1:3)), "present")
})

test_that("fit_lm works", {
    ## Check errors
    expect_error(fit_lm(), "'formula'")
    expect_error(fit_lm(y ~ x), "'data'")
    expect_error(fit_lm(y ~ x, data = 3), "'data'")
    expect_error(fit_lm(y ~ x, data = data.frame(x = 1:3)), "'y'")
    expect_error(fit_lm(y ~ x, data = data.frame(x = 1:3), y = 1:4), "rows")

    res <- fit_lm(y ~ injection_index, y = vals, data = sdata)
    expect_true(length(res) == nrow(vals))
    expect_true(is(res[[1L]], "lm"))

    rres <- fit_lm(y ~ injection_index, y = vals, data = sdata,
                   method = "lmrob")
    expect_true(length(rres) == nrow(vals))
    expect_true(is(rres[[1L]], "lmrob"))
    expect_equal(is.na(res), is.na(rres))
})

test_that(".fit_lm works", {
    y <- 1:5 + rnorm(5, sd = 0.2)
    data <- data.frame(injection_index = 1:5)
    res <- .fit_lm(y ~ injection_index, y = y, data = data, minVals = 4)
    expect_true(is(res, "lm"))

    y[c(2, 4)] <- NA
    res <- .fit_lm(y ~ injection_index, y = y, data = data, minVals = 4)
    expect_identical(res, NA)
})

test_that(".fit_lmrob works", {
    y <- 1:5 + rnorm(5, sd = 0.2)
    data <- data.frame(injection_index = 1:5)
    res <- .fit_lmrob(y ~ injection_index, y = y, data = data, minVals = 4)
    expect_true(is(res, "lmrob"))

    y[c(2, 4)] <- NA
    res <- .fit_lmrob(y ~ injection_index, y = y, data = data, minVals = 4)
    expect_identical(res, NA)
})

test_that(".adjust_with_lm works", {
    y <- vals[2, ]
    idx <- grep("POOL", colnames(vals))

    ## just on POOL
    mod <- lm(y ~ injection_index, data = data.frame(sdata, y = y)[idx, ])
    res <- MetaboCoreUtils:::.adjust_with_lm(y, sdata, mod)
    expect_identical(is.na(res), is.na(y))
    expect_identical(length(res), length(y))
    expect_true(abs(lm(y ~ sdata$injection_index)$coefficients[2L]) >
                abs(lm(res ~ sdata$injection_index)$coefficients[2L]))

    mod <- lm(y ~ injection_index, data = data.frame(sdata, y = log2(y))[idx, ])
    res <- MetaboCoreUtils:::.adjust_with_lm(y, sdata, mod)
    expect_identical(is.na(res), is.na(y))
    expect_identical(length(res), length(y))
    expect_true(abs(lm(y ~ sdata$injection_index)$coefficients[2L]) >
                abs(lm(res ~ sdata$injection_index)$coefficients[2L]))

    ## on full data. mean is expected to be the same.
    mod <- lm(y ~ injection_index, data = data.frame(sdata, y = y))
    res <- MetaboCoreUtils:::.adjust_with_lm(y, sdata, mod)
    expect_identical(is.na(res), is.na(y))
    expect_identical(length(res), length(y))
    expect_true(abs(lm(y ~ sdata$injection_index)$coefficients[2L]) >
                abs(lm(res ~ sdata$injection_index)$coefficients[2L]))
    expect_equal(mean(res, na.rm = TRUE), mean(y, na.rm = TRUE))

    expect_equal(.adjust_with_lm(y, sdata, NA), y)
})

test_that("adjust_lm works", {
    lms <- fit_lm(y ~ injection_index, vals, data = sdata)

    ## Error checks
    expect_error(adjust_lm(13, data = sdata, lm = lms), "numeric matrix")
    expect_error(adjust_lm(vals, data = 13, lm = lms), "data.frame")
    expect_error(adjust_lm(vals, data = sdata, lm = lms[1:3]), "number of rows")
    expect_error(adjust_lm(vals, data = sdata[1:3, , drop = FALSE],
                           lm = lms), "columns")
    res <- adjust_lm(vals, data = sdata, lm = lms)
    expect_true(is.matrix(res))
    expect_equal(dimnames(res), dimnames(vals))
    expect_equal(is.na(vals), is.na(res))

    nas <- is.na(lms)
    expect_equal(vals[nas, ], res[nas, ])

    ## Fit on a subset.
    idx <- grep("POOL", colnames(vals))
    lms <- fit_lm(y ~ injection_index, vals[, idx],
                  data = sdata[idx, , drop = FALSE])
    res2 <- adjust_lm(vals, data = sdata, lm = lms)
    expect_true(is.matrix(res2))
    expect_equal(dimnames(res2), dimnames(vals))
    expect_equal(is.na(res2), is.na(vals))

    nas <- is.na(lms)
    expect_equal(vals[nas, ], res2[nas, ])

    ref <- adjust_lm(vals, data = sdata, lm = lms)
    res <- adjust_lm(vals[1, , drop = FALSE], data = sdata, lm = lms[[1L]])
    expect_true(nrow(res) == 1)
    expect_equal(res, ref[1, , drop = FALSE])
})
