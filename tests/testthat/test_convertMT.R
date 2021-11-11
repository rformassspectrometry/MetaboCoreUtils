test_that("Migration time conversion works", {
  
  # load test data
  rtime <- c(10,20,30,40,50,60,70,80,90,100)
  marker <- data.frame(markerID = c("marker1", "marker2"),
                       rtime = c(20,80),
                       mobility = c(0, 2000))
  marker_E <- data.frame(markerID = c("marker1", "marker2"),
                       rt = c(20,80),
                       mobility = c(0, 2000))
  marker_E2 <- data.frame(markerID = c("marker1", "marker2"),
                         rtime = c(20,80),
                         mobility = c("A","B"))
  marker_E3 <- data.frame(markerID = c("marker1", "marker2"),
                         rtime = c("A","B"),
                         mobility = c(0, 2000))
  
  
  µ_s1 <- convertMT(rtime, marker, method = "single", U = 30, L = 90, markerID = "marker1")
  µ_m <-  convertMT(rtime, marker, method = "multiple")
  
    
  expect_equal(length(µ_s1), length(rtime))
  expect_equal(length(µ_m), length(rtime))
  
  expect_true(is.numeric(µ_s1))
  expect_true(is.numeric(µ_m))
 
  expect_equal(sum(µ_s1), -3355.071, tolerance = 1e-06)
  expect_equal(sum(µ_s2), 22719.93, tolerance = 1e-06)
  expect_equal(sum(µ_m), 11045.5, tolerance = 1e-06)
  
  expect_error(convertMT(y = marker, method = "single", U = 30, L = 90, markerID = "marker1"), 
               "Missing vector 'x' with migration times")
  expect_error(convertMT(rtime, method = "single", U = 30, L = 90, markerID = "marker1"), 
               "Missing data.frame 'y' with marker information")
  expect_error(convertMT(rtime, marker[,-1], method = "single", U = 30, L = 90, markerID = "marker1"), 
               "'y' requires exact three columns")
  expect_error(convertMT(rtime, marker_E, method = "single", U = 30, L = 90, markerID = "marker1"), 
               "Missing column 'markerID', 'rtime', 'mobility' or all")
  expect_error(convertMT(rtime, marker, U = 30, L = 90, markerID = "marker1"), 
               "'method' is missing")
  expect_error(convertMT(rtime, marker, method = c("single","multiple"), U = 30, L = 90, markerID = "marker1"), 
               "Conversion method is either 'single' or 'multiple'")
  expect_error(convertMT(rtime, marker, method = "X", U = 30, L = 90, markerID = "marker1"), 
               "Conversion method is either 'single' or 'multiple'")
  expect_error(convertMT("X", marker, method = "single", U = 30, L = 90, markerID = "marker1"), 
               "'x' needs to be numeric")
  expect_error(convertMT(rtime, marker_E2, method = "single", U = 30, L = 90, markerID = "marker1"), 
               "'mobility' entries in 'y' needs to be numeric")
  expect_error(convertMT(rtime, marker_E3, method = "single", U = 30, L = 90, markerID = "marker1"), 
               "'rtime' entries in 'y' needs to be numeric")
  
  expect_error(convertMT(rtime, marker, method = "single", L = 90, markerID = "marker1"), 
               "'U' is missing")
  expect_error(convertMT(rtime, marker, method = "single", U = 30, markerID = "marker1"), 
               "'L' is missing")
  expect_error(convertMT(rtime, marker, method = "single", U = 30, L = 90), 
               "'markerID' is missing")
  expect_error(convertMT(rtime, marker[-c(1:2),], method = "single", U = 30, L = 90, markerID = "marker1"), 
               "'y' contains no entries")
  
  expect_error(convertMT(rtime, marker[-1,], method = "multiple"), 
               "'y' requires min 2 rows")

})
