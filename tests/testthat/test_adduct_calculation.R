library(metabolomicsUtils)
context("adduct calculation")

## test for formula parsing
test_that("correct calculation of adduct m/z", {

  # positive mode
  expect_equal(round(calc_adduct_mass(180.0634, "[M+H]+"), 4), 181.0707)
  expect_equal(round(calc_adduct_mass(180.0634, "[M+Na]+"), 4), 203.0526)
  expect_equal(round(calc_adduct_mass(180.0634, "[M+NH4]+"), 4), 198.0972)
  
  # negative mode
  expect_equal(round(calc_adduct_mass(180.0634, "[M-H]-"), 4), 179.0561)
  
})

test_that("correct calculation of neutral mass", {
  
  # positive mode
  expect_equal(round(calc_neutral_mass(181.0707, "[M+H]+"), 4), 180.0634)
  expect_equal(round(calc_neutral_mass(203.0526, "[M+Na]+"), 4), 180.0634)
  expect_equal(round(calc_neutral_mass(198.0972, "[M+NH4]+"), 4), 180.0634)
  
  # negative mode
  expect_equal(round(calc_neutral_mass(179.0561, "[M-H]-"), 4), 180.0634)
  
})

test_that("correction ion formula is generated", {
  
  # positive mode
  expect_equal(create_ion_formula("C11H12N2O2", "[M+H]+"), "[C11H13N2O2]1+")
  expect_equal(create_ion_formula("C6H12O6", "[M+Na]+"), "[C6H12O6Na]1+")
  
  # negative mode
  expect_equal(create_ion_formula("C6H12O6", "[M-H]-"), "[C6H11O6]1-")
})