test_that(".onLoad works", {
    MetaboCoreUtils:::.onLoad(pkgname = "MetaboCoreUtils")
    ## Check that we have .ADDUCTS_ADD
    expect_true(length(MetaboCoreUtils:::.ADDUCTS_ADD) > 0)
})
