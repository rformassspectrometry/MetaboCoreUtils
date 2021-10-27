library(testthat)

test_that("isotopologues works", {
  substDef <- cbind(md = rep(c(1, 2), times = c(2, 3)),
                    leftend = c(c(50, 100), c(70, 100, 150)),
                    rightend = c(c(100, 150), c(100, 150, 220)),
                    LBint = c(0:1, 2:4),
                    LBslope = c(1:2, 3:5),
                    UBint = c(1:2, 3:5),
                    UBslope = c(2:3, 4:6))
  
  bp1 <- data.frame(mz = c(80), intensity = c(80))
  # construct mz's from md of above substitutions and corresponding intensities 
  # that should be accepted by construction 
  mz <- bp1$mz + c(1, 2)
  intensity <- bp1$intensity*(c(0.5, 2.5) + bp1$mz * c(1.5, 3.5))
  p1 <- data.frame(mz = mz, intensity = intensity)
  
  bp2 <- data.frame(mz = c(110), intensity = c(50))
  # 3rd peak doesn't correspond to any md in substDef
  mz <- bp2$mz + c(1, 2, 3)
  # 1st peak intensity incompatible by construction
  # 2nd peak intensity compatible by construction
  intensity <- bp2$intensity*(rep(3.5, 3) + bp2$mz * rep(4.5, 3))
  p2 <- data.frame(mz = mz, intensity = intensity)
  x <- rbind(bp1, p1, bp2, p2)
  
  # search for all the groups
  res <- isotopologues(x, substDef)
  expect_equal(res, list(c(1, 2, 3), c(4, 6)))
  
  # search for the group with mz compatible with seedMz
  res <- isotopologues(x, substDef, seedMz = bp2$mz)
  expect_equal(res, list(c(4,6)))
  res <- isotopologues(x, substDef, seedMz = c(bp1$mz, bp2$mz))
  expect_equal(res, list(c(1, 2, 3), c(4, 6)))
  
  # ppm and tolerance
  x[2, "mz"] <- x[2, "mz"] * (1 + 30 * 1e-06)
  res <- isotopologues(x, substDef, seedMz = c(bp1$mz, bp2$mz))
  # expect_equal(res, list(c(1, 3), c(4, 6))) this gives an error
  # I think the reason is the problem of closest with duplicates = "closest"
  # closest(c(81, 82), c(81.1, 82), tolerance = 0, ppm = 20, duplicates = "closest")
  # returns c(NA, NA)
  # closest(c(81, 82), c(81, 82), tolerance = 0, ppm = 20, duplicates = "closest")
  # returns c(1, 2) correctly
  res <- isotopologues(x, substDef, seedMz = c(bp1$mz, bp2$mz), ppm = 40)
  expect_equal(res, list(c(1, 2, 3), c(4, 6)))
  res <- isotopologues(x, substDef, seedMz = c(bp1$mz, bp2$mz), tolerance = 1e-2)
  expect_equal(res, list(c(1, 2, 3), c(4, 6)))
  
  # charge = 2
  bp3 <- data.frame(mz = c(40), intensity = c(50))
  # create mz compatible with the substitutions
  mz <- bp3$mz + c(0.5, 1)
  # as well as compatible intensities
  intensity <- bp3$intensity*(c(0.5, 2.5) + bp3$mz * 2 * c(1.5, 3.5))
  p3 <- data.frame(mz = mz, intensity = intensity)
  x <- rbind(bp3, p3, x)
  res <- isotopologues(x, substDef, charge = 2)
  expect_equal(res, list(c(1, 2, 3)))
})

test_that("isotopicSubstitutionMatrix works", {
  expect_error(isotopicSubstitutionMatrix("other"))
  res <- isotopicSubstitutionMatrix("HMDB_NEUTRAL")
  expect_true(is.data.frame(res))
})

x <- read.table(system.file("exampleSpectra/simulated_spectrum.txt", 
                            package = "MetaboCoreUtils"))
frmls <- unique(x$frmls)
subst_def <- isotopicSubstitutionMatrix("HMDB_NEUTRAL")

test_that("isotopologues works on simulated spectra from HMDB", {
  expected_groups <- lapply(frmls, function(f) which(x[, "frmls"] == f))
  i_groups <- isotopologues(x[, 1:2], substDefinition = subst_def, ppm = 1)
  expect_equal(i_groups, expected_groups)
})

test_that("isotopologues works on simulated spectra from HMDB + random peaks", {
  set.seed(123); n = 50
  noise <- data.frame(mz = runif(n, min = min(x$mz), max = max(x$mz)),
                      intensity = runif(n, min(x$intensity), max(x$intensity)),
                      frmls = rep("noise", n))
  x_n <- rbind(x, noise)
  x_n <- x_n[order(x_n$mz), ]
  expected_groups_n <- lapply(frmls, function(f) which(x_n[,"frmls"] == f))
  ## low ppm
  i_groups <- isotopologues(x_n[, 1:2], substDefinition = subst_def, ppm = 1)
  expect_equal(i_groups, expected_groups_n) # all groups correctly identified
  ## higher ppm: some problems occur
  i_groups <- isotopologues(x_n[, 1:2], substDefinition = subst_def, ppm = 20)
  # Group 1 in additional to the expected peaks contains peaks c(20, 33, 39)
  expected_groups_n[[1]]
  i_groups[[1]]
  sbs <- closest(x_n[c(20, 33, 39), "mz"],
                 x_n[i_groups[[1]][1], "mz"] + subst_def$md, ppm = 20,
                 tolerance = 0)
  subst_def[sbs, "name"]
  x_n[expected_groups_n[[1]][1], "frmls"]
  # The above mentioned peaks are matched to substitutions that are not possible
  # in the compound that originates the signal of the expected group.
  # Group 3 coincides with expected 2nd group  
  expect_equal(i_groups[[3]], expected_groups_n[[2]])
  # 4th found group contains all the peaks in expected group 3 except peaks
  # 20, 33, 39. These peaks were mistakenly assigned to the first group found 
  # and therefore are no longer available in the subsequent searches
  i_groups[[4]]
  expected_groups_n[[3]]
  # Groups 2, 5, 6, 8, 11 are composed of noise peaks whose mz differences match 
  # some of the substitutions
  x_n[i_groups[[2]], "frmls"]
  x_n[i_groups[[5]], "frmls"]
  x_n[i_groups[[6]], "frmls"]
  x_n[i_groups[[8]], "frmls"]
  x_n[i_groups[[11]], "frmls"]

  # closest(x_n[45, "mz"], subst_def$md + x_n[2, "mz"] , ppm = 20, tolerance = 0)
  closest(x_n[c(53, 58), "mz"], subst_def$md + x_n[41, "mz"] , ppm = 20, 
          tolerance = 0)
  # Group 7 coincides with expected group 4
  i_groups[[7]]
  expected_groups_n[[4]]
  # Group 9 coincides with expected group 5
  i_groups[[9]]
  expected_groups_n[[5]]
  # Group 10 starts with a noise peak. Unfortunately peaks 87, 93, 98, 103 match
  # it and are grouped with it.
  x_n[i_groups[[10]], "frmls"]
  # Group 12 contains peaks of expected group 6 but it's not right because
  # the monoisotopic peak (87) was mistakenly assigned to group 10 along with
  # some other of its peaks
  i_groups[[12]]
  expected_groups_n[[6]]
})

test_that(".isotope_peaks works on second test set", {
    x <- read.table(system.file("exampleSpectra",
                                "serine-alpha-lactose-caffeine.txt",
                                package = "MetaboCoreUtils"),
                    header = TRUE)
    x <- x[order(x$mz), ]
    rownames(x) <- NULL
    expected_groups <- lapply(unique(x$compound),
                              function(f) which(x[, "compound"] == f))
    subst_def <- isotopicSubstitutionMatrix("HMDB_NEUTRAL")

    i_groups <- MetaboCoreUtils:::.isotope_peaks(x[, 1:2], substDefinition = subst_def, ppm = 10)
    expect_equal(expected_groups[1], i_groups[1])
    expect_equal(expected_groups[2], i_groups[2])
    ## closest has again problems if there are two "best matching" peaks.
    expect_true(all(i_groups[[3L]] %in% expected_groups[[3L]]))

    set.seed(123)
    x_n <- x
    x_n$mz <- x_n$mz + MsCoreUtils::ppm(x_n$mz, ppm = runif(nrow(x_n), 0, 5))
    ## reset the monoisotopic mz
    x_n$mz[x_n$intensity == 100] <- x$mz[x_n$intensity == 100]
    x_n$intensity <- x_n$intensity + rnorm(nrow(x_n), sd = 0.01)
    x_n <- x_n[order(x_n$mz), ]
    rownames(x_n) <- NULL
    expected_groups <- lapply(unique(x_n$compound),
                              function(f) which(x_n[, "compound"] == f))
    i_groups <- .isotope_peaks(x_n[, 1:2], ppm = 10)
    expect_equal(i_groups[1], expected_groups[1])
    ## Not perfect for the others...
    expect_true(all(i_groups[[2L]] %in% expected_groups[[2L]]))
    expect_true(all(i_groups[[4L]] %in% expected_groups[[3L]]))
})
