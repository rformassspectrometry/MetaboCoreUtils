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

    x <- c(a = 180.0634, b = 180.0634)
    adds <- c("[M+H]+", "[M+Na]+", "[M+NH4]+")
    res <- mass2mz(x, adds)
    expect_true(is.matrix(res))
    expect_equal(colnames(res), adds)
    expect_equal(rownames(res), c("a", "b"))
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

test_that("formula2mz works", {
    formulas <- c("C6H12O6", "[13C3]C3H12O6", "CHNOPS")
    masses <- formula2mz(formulas, adductNames())
    expect_equal(nrow(masses), length(formulas))
    expect_equal(ncol(masses), length(adductNames()))
    expect_true(is.matrix(masses))

    #Shoud we raise an error if all formulas are invalid?
    expect_warning(formula2mz("foo"))

    expect_warning(formula2mz(c(formulas, "foo")))
    expect_error(formula2mz(formulas, adduct = "bar"))
})

test_that("adductFormula works", {
    expect_error(adductFormula("a"), "No valid formulas")

    expect_equivalent(adductFormula("C6H12O6", c("[M+H]+", "[M+Na]+", "[M+K]+")),
                      c("[C6H13O6]+", "[C6H12O6Na]+", "[C6H12O6K]+"))

    # No valid formulas: warns that some are invalid and throws error if ALL
    # are invalid
    expect_error(expect_warning(adductFormula("foo", adduct = "[M+H]+")))
    expect_error(adductFormula("H2O", adduct = "bar")) #Invalid adduct

    # Removes bad formula and moves on
    expect_warning(bad <- adductFormula(c("foo", "H2O"), "[M+H]+"))
    expect_equivalent(bad, "[H3O]+")

    fs <- c("H2O", "C6H12O6", "[13C2]C4H12O6")

    # Raise warnings because NAs will be generated for some adducts
    expect_warning(output <- adductFormula(fs, adducts()))

    # Check dimension consistency
    expect_equal(nrow(output), length(fs))
    expect_equal(ncol(output), nrow(adducts()))

    # negative adducts works
    expect_equivalent(adductFormula("C6H12O6", c("[M-H]-", "[M+CHO2]-")),
                      c("[C6H11O6]-", "[C7H13O8]-"))

})

test_that("adducts works", {
    expect_error(adducts(polarity = "some"))
    res <- adducts()
    expect_true(is.data.frame(res))
    expect_equal(res, .ADDUCTS[.ADDUCTS$positive, ])
    res <- adducts(polarity = "negative")
    expect_true(is.data.frame(res))
    expect_equal(res, .ADDUCTS[!.ADDUCTS$positive, ])
})

test_that(".process_adduct_arg works", {
    expect_error(.process_adduct_arg(4), "data.frame")
    expect_error(.process_adduct_arg(data.frame()), "not found")

    res <- .process_adduct_arg(c("[M+H]+", "[M+Na]+"))
    expect_true(is.data.frame(res))
    adds <- adducts()[c("[M+H]+", "[M+Na]+"), ]
    res_exp <- data.frame(mass_add = adds$mass_add,
                          mass_multi = adds$mass_multi)
    rownames(res_exp) <- rownames(adds)
    expect_equal(res, res_exp)

    df <- data.frame(mass_multi = 1:3, mass_add = 4)
    rownames(df) <- c("a", "b", "c")
    res <- .process_adduct_arg(df)
    expect_equal(res, df[, c("mass_add", "mass_multi")])
})
