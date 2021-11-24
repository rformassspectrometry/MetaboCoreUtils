test_that("Migration time conversion works", {
  
  ## load test data
  rtime <- c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
  marker <- data.frame(markerID = c("marker1", "marker2"),
                       rtime = c(20, 80),
                       mobility = c(0, 2000))
  marker_E <- data.frame(markerID = c("marker1", "marker2"),
                       rt = c(20, 80),
                       mobility = c(0, 2000))
  marker_E2 <- data.frame(markerID = c("marker1", "marker2"),
                         rtime = c(20, 80),
                         mobility = c("A", "B"))
  marker_E3 <- data.frame(markerID = c("marker1", "marker2"),
                         rtime = c("A", "B"),
                         mobility = c(0, 2000))
  
  
  µ_s1 <- convertMT(rtime, marker[-2,], U = 30, L = 90)
  µ_m <-  convertMT(rtime, marker)
  
    
  expect_equal(length(µ_s1), length(rtime))
  expect_equal(length(µ_m), length(rtime))
  
  expect_true(is.numeric(µ_s1))
  expect_true(is.numeric(µ_m))
 
  expect_equal(sum(µ_s1), -55.91786, tolerance = 1e-06)
  expect_equal(sum(µ_m), 11045.5, tolerance = 1e-06)
  
  expect_error(convertMT(y = marker), 
               "Missing vector 'x' with migration times")
  expect_error(convertMT(rtime), 
               "Missing data.frame 'y' with marker information")
  expect_error(convertMT(rtime, marker_E), 
               "Missing column 'rtime', 'mobility' or all")
  expect_error(convertMT("X", marker), 
               "'x' needs to be numeric")
  expect_error(convertMT(rtime, marker_E2), 
               "'mobility' entries in 'y' needs to be numeric")
  expect_error(convertMT(rtime, marker_E3), 
               "'rtime' entries in 'y' needs to be numeric")
  expect_error(convertMT(rtime, marker[-1,], L = 90), 
               "'U' is missing")
  expect_error(convertMT(rtime, marker[-1,], U = 30), 
               "'L' is missing")
  expect_error(convertMT(rtime, marker[-c(1:2),]), 
               "'y' requires one or two entries")

})
