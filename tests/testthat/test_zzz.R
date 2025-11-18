test_that(".onLoad works", {
    ## MetaboCoreUtils:::.onLoad(pkgname = "MetaboCoreUtils")
    ## Check that we have .ADDUCTS_ADD
    res <- callr::r(function() loadNamespace("MetaboCoreUtils"))
    expect_true(length(get(".ADDUCTS_ADD", res)) > 0)

    expect_true(length(MetaboCoreUtils:::.ADDUCTS_ADD) > 0)

    my_env <- new.env()
    res <- with_mocked_bindings(
        ".get_envir" = function(x) my_env,
        code = .onLoad("MetaboCoreUtils", "MetaboCoreUtils")
    )
    expect_true(all(c(".ADDUCTS", ".ISOTOPES", ".HMDB") %in% names(my_env)))
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

test_that(".get_envir works", {
    res <- .get_envir("MetaboCoreUtils")
    expect_true(any(names(res) == ".HMDB"))
})
