test_that("getRT works", {
  
  # load test data
  rti <- data.frame(rtime = c(10,20,30,40,50,60,70,80,90,100),
                    intensity = c(50,50,100,180,200,200,90,50,50,50))
  
  expect_equal(getRtime(rti, minInt = 10), 55)
  expect_error(getRtime(rti, minInt = 300), "No peaks have been found. Align input parameters.")
  expect_error(getRtime(rti), "Missing minimum intensity 'minInt'")
  expect_error(getRtime(minInt = 300), "Missing data.frame with rtime and intensity")
  
  rti <- data.frame(rtime = c("A", "B", "C"),
                    intensity = c(50,50,100))
  
  expect_error(getRtime(rti, minInt = 10), "Column 'rtime', 'intensity' or both is not type 'numeric'")
  
  rti <- data.frame(A = c(10,20,30,40,50,60,70,80,90,100),
                    intensity = c(50,50,100,180,200,200,90,50,50,50))
  
  expect_error(getRtime(rti, minInt = 10), "Missing column 'rtime', 'intensity' or both")
  
  rti <- data.frame(rtime = c(10,20,30,40,50,60,70,80,90,100))
  expect_error(getRtime(rti, minInt = 10), "Missing column 'rtime', 'intensity' or both")
  
})
