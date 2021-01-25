test_that("internalStandardMixNames works", {
    res <- internalStandardMixNames()
    expect_equal(res, c("QReSS", "UltimateSplashOne"))
})

test_that("internalStandards works", {
    expect_error(internalStandards("other"), "Please use one of")

    res <- internalStandards()
    expect_true(all(c("name", "formula_salt", "formula_metabolite",
                      "smiles_salt", "smiles_metabolite",
                      "exact_mass_metabolite", "conc") %in%
                    colnames(res)))
    res <- internalStandards(mix = "UltimateSplashOne")
    expect_true(all(c("name", "formula_salt", "formula_metabolite",
                      "smiles_salt", "smiles_metabolite",
                      "exact_mass_metabolite", "conc") %in%
                    colnames(res)))
})
