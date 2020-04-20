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

  expect_error(pasteElements(c(1, 4)), "named vector")
})