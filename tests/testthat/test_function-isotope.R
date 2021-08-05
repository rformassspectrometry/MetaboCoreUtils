library(testthat)

test_that(".isotope_peaks works", {

  ints <- c(1, 6, 3, 5, 15)
  mz <- 1:5
  x <- cbind(mz = mz, intensity = ints)
  # plot(x, type = "h")
  substDef <- cbind(md = c(1, 2),
                    subst_degree = c(1, 2),
                    min_slope = c(5, 1/2),
                    max_slope = c(7, 1))
  res <- .isotope_peaks(x, substDef)
  expect_equal(res, list(c(1, 2), c(3, 5)))

  res <- .isotope_peaks(x, substDef, seedMz = x[c(3), 1])
  expect_equal(res, list(c(3, 5)))
})

# New test (maybe more interpretable) that could replace the one before
test_that("isotopologues works", {
  substDef <- cbind(md = 1:5,
                    degree = 1:5,
                    min_slope = 1:5/5,
                    max_slope = 2:6/5)
  
  bp1 <- data.frame(mz = c(100), intensity = c(100))
  # select some substitutions
  sbst_i <- c(1, 3, 4)
  # construct mz's from md of above substitutions and corresponding intensities 
  # that should be accepted by construction 
  mid_slope <- (substDef[sbst_i, "min_slope"] + substDef[sbst_i, "max_slope"])/2
  intensity <- bp1$intensity*(bp1$mz*mid_slope)^substDef[sbst_i, "degree"]  
  p1 <- data.frame(mz = bp1$mz + substDef[sbst_i, "md"], intensity = intensity)
  
  bp2 <- data.frame(mz = c(110), intensity = c(50))
  sbst_i <- c(2, 5)
  mid_slope <- (substDef[sbst_i, "min_slope"] + substDef[sbst_i, "max_slope"])/2
  intensity <- bp2$intensity*(bp2$mz*mid_slope)^substDef[sbst_i, "degree"]  
  p2 <- data.frame(mz = bp2$mz + substDef[sbst_i, "md"], intensity = intensity)
  
  # peaks with incompatible mz
  pko <- data.frame(mz = bp1$mz + seq(5.1, 7.3, by = 1.1), 
                    intensity = rep(100, 3))
  
  # peak compatible with mz of substitution 2 but not with corresponding 
  # intensity bounds
  intko <- bp1$intensity *
    (bp1$mz * substDef[2, "max_slope"]) ^ substDef[2, "degree"] + 1
  pko <- rbind(pko, c(mz = bp1$mz + substDef[2, "md"], intensity = intko))
  x <- rbind(bp1, p1, bp2, p2, pko)
  x <- x[order(x$mz), ]
  
  # search for all the groups
  res <- isotopologues(x, substDef)
  expect_equal(res, list(c(1, 2, 4, 5), c(9, 10, 11)))
  
  # search for the group with mz compatible with seedMz
  res <- isotopologues(x, substDef, seedMz = bp2$mz)
  expect_equal(res, list(c(9, 10, 11)))
  res <- isotopologues(x, substDef, seedMz = c(bp1$mz, bp2$mz))
  expect_equal(res, list(c(1, 2, 4, 5), c(9, 10, 11)))
  
  # ppm and tolerance
  x[2, "mz"] <- x[2, "mz"] * (1 + 30 * 1e-06)
  res <- isotopologues(x, substDef, seedMz = c(bp1$mz, bp2$mz))
  expect_equal(res, list(c(1, 4, 5), c(9, 10, 11)))
  res <- isotopologues(x, substDef, seedMz = c(bp1$mz, bp2$mz), ppm = 40)
  expect_equal(res, list(c(1, 2, 4, 5), c(9, 10, 11)))
  res <- isotopologues(x, substDef, seedMz = c(bp1$mz, bp2$mz), tolerance = 1e-2)
  expect_equal(res, list(c(1, 2, 4, 5), c(9, 10, 11)))
  
  # charge = 2
  pz2 <- data.frame(mz = x[c(9, 10, 11), "mz"]/2, 
                    intensity = x[c(9, 10, 11), "intensity"])
  x <- rbind(pz2, x)
  res <- isotopologues(x, substDef, charge = 2)
  expect_equal(res, list(c(1, 2, 3)))
})

test_that("isotopicSubstitutionMatrix works", {
    expect_error(isotopicSubstitutionMatrix("other"))
    res <- isotopicSubstitutionMatrix("HMDB")
    expect_true(is.data.frame(res))
})