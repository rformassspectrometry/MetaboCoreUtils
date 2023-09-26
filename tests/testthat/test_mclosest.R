test_that("mclosest works", {
  ## load test data
  x <- data.frame(a = 1:5, b = 3:7)
  table <- data.frame(c = c(11, 23, 3, 5, 1), d = c(32:35, 45))
  ppm <- 0.5
  mclosest(x, table, ppm = 0.5)
})


#testing format:checking error, checking equal  
# check for input one row (check_equal)
# check for multiple row (check_equal)