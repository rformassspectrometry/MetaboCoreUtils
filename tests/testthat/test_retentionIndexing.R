test_that("retention indexing linear works", {
  
  # load test data
  rti <- read.table(system.file("retentionIndex",
                                "rti.txt",
                                package = "MetaboCoreUtils"),
                    header = TRUE,
                    sep = "\t")
  
  rtime <- read.table(system.file("retentionIndex",
                                  "metabolites.txt",
                                  package = "MetaboCoreUtils"),
                      header = TRUE,
                      sep = "\t")
  
  rtime$rindex_linear <- indexRtime(rtime$rtime, rti)
  
  expect_equal(round(rtime$rindex_manual, 0), round(rtime$rindex_linear, 0))
  
  rti <- data.frame(rt = c(1,2,3),
                    rti = c(100,200,300))
  
  expect_error(indexRtime(rtime$rtime, rti), "Missing column 'rtime', 'rindex' or both")
  expect_error(indexRtime(rtime$rime), "Missing data.frame with index data")

})

test_that("correcton of retention index works", {
  
  ref <- data.frame(rindex = c(110, 210),
                    refindex = c(100, 200))
  
  rindex <- c(110, 210)
  
  expect_equal(correctRindex(rindex, ref), c(100, 200))
  
  ref <- data.frame(ri = c(110,210,310),
                    ref = c(100,200,300))
  
  expect_error(correctRindex(rindex, ref), "y requires exact two rows")
  
  ref <- data.frame(ri = c(110,210),
                    ref = c(100,200))
  
  expect_error(correctRindex(rindex, ref), "Missing column 'rindex', 'refindex' or both")
  expect_error(correctRindex(rindex), "Missing data.frame with reference indices")
  
})
