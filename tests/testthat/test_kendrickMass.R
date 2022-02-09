test_that("Correct KMD calculations", {
  
  exact_masses <- c(760.5851, 762.6007, 762.5280)
  
  ## check if Kendrick mass is calculated correct, default parameter
  expect_identical(round(calculateKm(exact_masses), 4),
                   c(759.7358, 761.7492, 761.6766))
  
  ## check if Kendrick mass is calculated correct, formula parameter
  expect_identical(round(calculateKm(exact_masses, fragment = "CH2"), 4),
                   c(759.7358, 761.7492, 761.6766))
  
  ## check if Kendrick mass defect is calculated correct, default parameter
  expect_identical(round(calculateKmd(exact_masses), 4),
                   c(0.7358 ,0.7492, 0.6766))
  
  ## check if Kendrick mass defect is calculated correct, formula parameter
  expect_identical(round(calculateKmd(exact_masses, fragment = "CH2"), 4),
                   c(0.7358 ,0.7492, 0.6766))
  
  ## check if referenced Kendrick mass defect is calculated correct,
  ## default parameter
  expect_identical(round(calculateRkmd(exact_masses, rkmd = 0.749206), 4),
                   c(-0.9987, -0.0024, -5.4222))
  
  ## check if referenced Kendrick mass defect is calculated correct,
  ## formula parameter
  expect_identical(round(calculateRkmd(exact_masses, fragment = "CH2",
                                       rkmd = 0.749206), 4),
                   c(-0.9987, -0.0024, -5.4222))
  
  ## check if referenced Kendrick mass defect is calculated correct
  rkmds <- calculateRkmd(exact_masses, rkmd = 0.749206)
  
  expect_identical(isRkmd(rkmds, rkmdTolerance = 0.1),
                   c(TRUE, TRUE, FALSE))

  

})
