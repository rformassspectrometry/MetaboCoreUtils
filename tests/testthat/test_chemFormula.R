test_that("correct parsing of chemical formula", {
    ## formula to list
    formula_list <- countElements("C6H12O6")
    expect_equal(unname(formula_list["C"]), 6)
    expect_equal(unname(formula_list["H"]), 12)
    expect_equal(unname(formula_list["O"]), 6)

    expect_warning(countElements(c("C3H2O5", "H2O")))

    formula_list <- c("C" = 6,
                      "H" = 12,
                      "O" = 6)

    expect_equal(pasteElements(formula_list), "C6H12O6")

    ## standardize formula
    expect_equal(standardizeFormula("H12C6O6"), "C6H12O6")

    expect_equal(countElements(character()), integer())
})

test_that("correct formula mathematics", {
    ## check if formula contains specific sub formulae
    expect_equal(containsElements("C6H12O6", "H2O"), TRUE)
    expect_equal(containsElements("C6H12O6", "NH3"), FALSE)

    ## check formula subtraction (single formulae)
    expect_equal(subtractElements("C6H12O6", "H2O"), "C6H10O5")
    expect_equal(subtractElements("C6H12O6", "NH3"), NA_character_)

    ## check formula subtration (multiple formulae)
    expect_equal(subtractElements("C6H12O6", c("H2O", "H2O")), "C6H8O4")
    expect_equal(subtractElements("C6H12O6", c("H2O", "NH3")), NA_character_)

    ## check formula addition (single formula)
    expect_equal(addElements("C6H12O6", "Na"), "C6H12O6Na")

    ## check formula addition (multiple formulae)
    expect_equal(addElements(c("C6H12O6", "Na")), "C6H12O6Na")
    expect_equal(addElements("C6H12O6", c("H2O", "Na")), "C6H14O7Na")

    expect_equal(addElements(c("H2O", NA)), "H2O")
    expect_equal(addElements(c("H2O")), "H2O")
})

test_that("correct calculation of masses", {
    ## calculation of exact masses from character
    expect_equal(round(calcExactMass("C6H12O6"), 4), 180.0634)
    expect_equal(round(calcExactMass("C11H12N2O2"), 4), 204.0899)
  
    ## calculation of exact masses from named numeric vector
    expect_equal(round(calcExactMass(countElements("C6H12O6")), 4), 180.0634)
    expect_equal(round(calcExactMass(countElements("C11H12N2O2")), 4), 204.0899)
})
