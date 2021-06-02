test_that("adductNames works", {
  
  rti <- read.table(system.file("retentionIndex/rti.txt",
                                package = "MetaboCoreUtils"),
                    header = TRUE,
                    sep = "\t")
  
  rtime <- read.table(system.file("retentionIndex/metabolites.txt",
                                  package = "MetaboCoreUtils"),
                      header = TRUE,
                      sep = "\t")
  
  rtime$rindex2 <- rtimeIndexing(rtime$rtime, rti)
  
  expect_equal(round(rtime$rindex_manual, 0), round(rtime$rindex2, 0))

})
