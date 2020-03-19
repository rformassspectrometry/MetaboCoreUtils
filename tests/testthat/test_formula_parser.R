library(lipidomicsUtils)
context("formula parsing")

## tests for exact mass to ion mass --------------------------------------------
test_that("correct formula parsing", {
  
  # formula to list
  expect_equal(formula_to_list("C6H12O6"), c("C" = 6, "H" = 12, "O" = 6))
  expect_equal(formula_to_list("CHCl3"), c("C" =1, "H" = 1, "Cl" = 3))
  
  # list to formula
  expect_equal(list_to_formula(c("C" = 6, "H" = 12, "O" = 6)), "C6H12O6")
  expect_equal(list_to_formula(c("C" =1, "H" = 1, "Cl" = 3)), "CHCl3")
  
  # standardizing of chemical formula
  expect_equal(standardize_formula("Cl3CH"), "CHCl3")
  
})