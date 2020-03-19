library(metabolomicsUtils)
context("adduct format conversion")

## test for formula parsing
test_that("Correct conversion from Agilent adduct naming", {
  
  # positive mode
  expect_equal(get_adduct_synonym("(M+H)+", adduct_library = "Agilent", direction = "from"), "[M+H]+")
  expect_equal(get_adduct_synonym("(M+Na)+", adduct_library = "Agilent", direction = "from"), "[M+Na]+")
  expect_equal(get_adduct_synonym("[M+H]+", adduct_library = "Agilent", direction = "to"), "(M+H)+")
  expect_equal(get_adduct_synonym("[M+Na]+", adduct_library = "Agilent", direction = "to"), "(M+Na)+")
  
  # negative mode
  
})