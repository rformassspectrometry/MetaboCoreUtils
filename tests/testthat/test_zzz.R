test_that(".onLoad works", {
    ## MetaboCoreUtils:::.onLoad(pkgname = "MetaboCoreUtils")
    ## Check that we have .ADDUCTS_ADD
    expect_true(length(MetaboCoreUtils:::.ADDUCTS_ADD) > 0)
})

test_that(".load_adducts works", {
    adds <- .load_adducts()
    expect_true(is.data.frame(adds))
    expect_true(all(c("mass_multi", "mass_add") %in% colnames(adds)))
    expect_true(nrow(adds) > 0)
})

test_that(".load_isotopes works", {
    iso <- .load_isotopes()
    expect_equal(iso[c("H", "2H")], c(H = 1.007825032, "2H" = 2.014101778))
})
