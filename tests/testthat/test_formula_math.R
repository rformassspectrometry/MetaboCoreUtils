library(metabolomicsUtils)
context("formula mathematics")

## test for formula parsing
test_that("correct formula mathematics", {
  
  # check for sub formula
  expect_equal(contains_formula("C6H12O6", "H2O"), TRUE)
  expect_equal(contains_formula("C6H12O6", "NH3"), FALSE)
  
  # subtraction of formula
  expect_equal(formula_subtraction("C6H12O6", "H2O"), "C6H10O5")
  expect_error(formula_subtraction("C6H12O6", "NH3"))
  
  # addition of formula
  expect_equal(formula_addition("C6H10O5", "H2O"), "C6H12O6")

})

## tests for exact mass calculation
test_that("correct exact mass is calculated", {
  
  # non-charged formula
  expect_equal(round(formula_to_exactmass("C6H12O6"), 4), 180.0634)
  expect_equal(round(formula_to_exactmass("C11H12N2O2"), 4), 204.0899)
  
  # positivly charged formula
  expect_equal(round(formula_to_exactmass("C5H14NO", charge = 1), 4), 104.107)
  
})