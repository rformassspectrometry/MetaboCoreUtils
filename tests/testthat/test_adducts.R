test_that("adductNames works", {
    res <- adductNames()
    expect_equal(res, rownames(.ADDUCTS)[.ADDUCTS$positive])
    res <- adductNames("negative")
    expect_equal(res, rownames(.ADDUCTS)[!.ADDUCTS$positive])
})

test_that("correct calculation of adduct m/z", {
    ## positive mode
    expect_equal(as.numeric(unname(round(mass2mz(180.0634, "[M+H]+"), 4))),
                 181.0707)
    expect_equal(as.numeric(unname(round(mass2mz(180.0634, "[M+Na]+"), 4))),
                 203.0526)
    expect_equal(as.numeric(unname(round(mass2mz(180.0634, "[M+NH4]+"), 4))),
                 198.0972)

    x <- c(180.0634, 180.0634)
    adds <- c("[M+H]+", "[M+Na]+", "[M+NH4]+")
    res <- mass2mz(x, adds)
    expect_true(is.matrix(res))
    expect_equal(colnames(res), adds)
    expect_true(nrow(res) == 2)
    expect_equal(res[1, ], res[2, ])
    expect_true(all(round(res[, 1], 4) == 181.0707))
    expect_true(all(round(res[, 2], 4) == 203.0526))
    expect_true(all(round(res[, 3], 4) == 198.0972))

    ## negative mode
    expect_equal(as.numeric(unname(round(mass2mz(180.0634, "[M-H]-"), 4))),
                 179.0561)

    res <- mass2mz(4, adductNames("negative"))
    expect_equal(colnames(res), rownames(.ADDUCTS[!.ADDUCTS$positive, ]))
    expect_true(nrow(res) == 1)

    expect_error(mass2mz(4, "some"), "Unknown adduct")
    expect_error(mass2mz(4, c("some", "[M+H]+")), "Unknown adduct")
})

test_that("correct calculation of neutral mass", {
    ## positive mode
    expect_equal(as.numeric(unname(round(mz2mass(181.0707, "[M+H]+"), 4))),
                 180.0634)
    expect_equal(as.numeric(unname(round(mz2mass(203.0526, "[M+Na]+"), 4))),
                 180.0634)
    expect_equal(as.numeric(unname(round(mz2mass(198.0972, "[M+NH4]+"), 4))),
                 180.0634)

    x <- rep(180.0634, 4)
    adds <- c("[M+H]+", "[M+Na]+", "[M+NH4]+")
    res <- mz2mass(x, adds)
    expect_true(is.matrix(res))
    expect_equal(colnames(res), adds)
    expect_true(nrow(res) == 4)
    expect_equal(res[1, ], res[2, ])
    expect_true(all(round(res[, 1], 4) == 179.0561))
    expect_true(all(round(res[, 2], 4) == 157.0742))
    expect_true(all(round(res[, 3], 4) == 162.0296))

    ## negative mode
    expect_equal(as.numeric(unname(round(mz2mass(179.0561, "[M-H]-"), 4))),
                 180.0634)

    res <- mz2mass(4, adductNames("negative"))
    expect_equal(colnames(res), rownames(.ADDUCTS[!.ADDUCTS$positive, ]))
    expect_true(nrow(res) == 1)

    x <- c(123, 453, 342)
    mzs <- mass2mz(x, "[M+H]+")
    expect_equal(x, mz2mass(mzs[, 1], "[M+H]+")[, 1])
    mzs <- mass2mz(x, "[M+Cl]-")
    expect_equal(x, mz2mass(mzs[, 1], "[M+Cl]-")[, 1])

    expect_error(mz2mass(4, "some"), "Unknown adduct")
    expect_error(mz2mass(4, c("some", "[M+H]+")), "Unknown adduct")
})
