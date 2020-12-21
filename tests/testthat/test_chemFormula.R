test_that("correct parsing of chemical formula", {

  # formula to list
  formula_list <- countElements("C6H12O6")

  expect_equal(formula_list[["C"]], 6)
  expect_equal(formula_list[["H"]], 12)
  expect_equal(formula_list[["O"]], 6)

  # list to formula
  formula_list <- c("C" = 6,
                    "H" = 12,
                    "O" = 6)

  expect_equal(pasteElements(formula_list), "C6H12O6")

  # standardize formula
  expect_equal(standardizeFormula("H12C6O6"), "C6H12O6")

})

test_that("correct formula mathematics", {

  # check if formula contains specific sub formulae
  expect_equal(containsElements("C6H12O6", "H2O"), TRUE)
  expect_equal(containsElements("C6H12O6", "NH3"), FALSE)

  # check formula subtraction
  expect_equal(subtractElements("C6H12O6", "H2O"), "C6H10O5")
  expect_equal(subtractElements("C6H12O6", "NH3"), NA_character_)

  # check formula addition
  expect_equal(addElements("C6H12O6", "Na"), "C6H12O6Na")

})
