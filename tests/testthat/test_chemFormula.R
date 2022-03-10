test_that("correct formula mathematics", {
    ## check if formula contains specific sub formulae
    expect_identical(containsElements("C6H12O6", "H2O"), TRUE)
    expect_identical(containsElements("C6H12O6", "NH3"), FALSE)
    expect_identical(containsElements("C10H10F3N3", "F"), TRUE)
    expect_identical(containsElements("C10H10F3N3", "F1"), TRUE)
    expect_identical(containsElements("C10H10F3N3", "F2"), TRUE)
    expect_identical(containsElements("C10H10F3N3", "F3"), TRUE)
    expect_identical(containsElements("C10H10F3N3", "F4"), FALSE)

    ## check formula subtraction (single formulae)
    expect_identical(subtractElements("C6H12O6", "H2O"), "C6H10O5")
    expect_identical(subtractElements("C6H12O6", "NH3"), NA_character_)

    ## check formula subtration (multiple formulae)
    expect_identical(
        subtractElements("C6H12O6", c("H2O", "H2O")),
        c("C6H10O5", "C6H10O5")
    )
    expect_identical(
        subtractElements("C6H12O6", c("H2O", "NH3")),
        c("C6H10O5", NA_character_)
    )

    ## check formula addition (single formula)
    expect_identical(addElements("C6H12O6", "Na"), "C6H12O6Na")

    ## check formula addition (multiple formulae)
    expect_identical(addElements("C6H12O6", "Na"), "C6H12O6Na")
    expect_identical(
        addElements("C6H12O6", c("H2O", "Na")),
        c("C6H14O7", "C6H12O6Na")
    )
})

test_that("countElements", {
    expect_identical(
        countElements("C6H12O6"),
        list(C6H12O6 = c(C = 6L, H = 12L, O = 6L))
    )
    expect_identical(
        countElements(c("C6H12O6", "H2O")),
        list(C6H12O6 = c(C = 6L, H = 12L, O = 6L), H2O = c(H = 2L, O = 1L))
    )
    expect_identical(
        countElements(c("[13C3]C3H12O6", "[2H2]O")),
        list(
            "[13C3]C3H12O6" = c("13C" = 3L, C = 3L, H = 12L, O = 6L),
            "[2H2]O" = c("2H" = 2L, O = 1L)
        )
    )
})

test_that(".isValidElementName",
    expect_equal(
        .isValidElementName(c("13C", "45C", "2H", "10H")),
        c(TRUE, FALSE, TRUE, FALSE)
    )
)

test_that("pasteElements", {
    expect_identical(pasteElements(c(C = 6, O = 6, H = 12)), "C6H12O6")
    expect_identical(pasteElements(c(C = 1, O = 1, H = 3)), "CH3O")
    expect_identical(
        pasteElements(list(c(C = 6, O = 6, H = 12), c(H = 2, O = 1))),
        c("C6H12O6", "H2O")
    )
})

test_that(".sort_elements", {
    expect_identical(
        .sort_elements(c("H", "O", "S", "P", "C", "N", "Na", "Fe")),
        c("C", "H", "N", "O", "S", "P", "Fe", "Na")
    )
})

test_that("standardizeFormula", {
    expect_identical(
        standardizeFormula(c("C6O6H12", "OH2")),
        c(C6O6H12 = "C6H12O6", OH2 = "H2O")
    )
})

test_that("containsElements", {
    expect_true(containsElements("C6H12O6", "H2O"))
    expect_false(containsElements("C6H12O6", "NH3"))
    expect_identical(
        containsElements("C6H12O6", c("H2O", "NH3")),
        c(TRUE, FALSE)
    )
})

test_that("subtractElements", {
    expect_identical(subtractElements("C6H12O6", "H2O"), "C6H10O5")
    expect_identical(
        subtractElements(c("C6H12O6", "C6H12O6"), c("H2O", "NH3")),
        c("C6H10O5", NA_character_)
    )
    expect_identical(
        subtractElements("C6H12O6", c("H2O", "NH3")),
        c("C6H10O5", NA_character_)
    )
})

test_that("addElements", {
    expect_identical(addElements("C6H12O6", "H2O"), "C6H14O7")
    expect_identical(
        addElements(c("C6H12O6", "C6H12O6"), c("H2O", "NH3")),
        c("C6H14O7", "C6H15NO6")
    )
    expect_identical(
        addElements("C6H12O6", c("H2O", "NH3")),
        c("C6H14O7", "C6H15NO6")
    )
})

test_that("correct calculation of masses", {
    ## calculation of exact masses from character
    expect_equal(unname(round(calculateMass("C6H12O6"), 4)), 180.0634)
    expect_equal(unname(round(calculateMass("C11H12N2O2"), 4)), 204.0899)
    expect_equal(
        round(unname(calculateMass(c("C6H12O6", "C11H12N2O2", "blabla"))), 4),
        c(180.0634, 204.0899, NA))

    ## calculation of exact masses from named numeric vector
    expect_equal(unname(round(calculateMass(countElements("C6H12O6")), 4)),
                 180.0634)
    expect_equal(unname(round(calculateMass(countElements("C11H12N2O2")), 4)),
                 204.0899)
})
