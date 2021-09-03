library(testthat)

test_that(".isotope_peaks works", {
  ints <- c(1, 6, 3, 5, 15)
  mz <- 1:5
  x <- cbind(mz = mz, intensity = ints)
  # plot(x, type = "h")
  substDef <- cbind(md = c(1, 2),
                    degree = c(1, 2),
                    min_slope = c(5, 1/2),
                    max_slope = c(7, 1))
  res <- .isotope_peaks(x, substDef)
  expect_equal(res, list(c(1, 2), c(3, 5)))

  res <- .isotope_peaks(x, substDef, seedMz = x[c(3), 1])
  expect_equal(res, list(c(3, 5)))
})

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

x <- read.table(system.file("exampleSpectra", "simulated_spectrum.txt",
                            package = "MetaboCoreUtils"))
frmls <- unique(x$frmls)
subst_def <- isotopicSubstitutionMatrix("HMDB")

test_that("isotopologues works on simulated spectra from HMDB", {
  expected_groups <- lapply(frmls, function(f) which(x[, "frmls"] == f))
  i_groups <- isotopologues(x[, 1:2], substDefinition = subst_def, ppm = 1)
  # expect_equal(i_groups, expected_groups) gives error. isotopologue
  # function doesn't put peak number 10 into group 2
  sbs <- closest(x[10, "mz"], subst_def$md + x[i_groups[[2]][1], "mz"] ,
                 ppm = 1, tolerance = 0)
  # peak 10 matches subst 2
  bi <- x[i_groups[[2]][1], "intensity"] *
    (x[i_groups[[2]][1], "mz"] *
       subst_def[sbs, c("min_slope", "max_slope")]) ^
    subst_def[sbs, "degree"]
  expect_true(bi[1] <= x[10, "intensity"] && bi[2] >= x[10, "intensity"])
  # the intensity of peak 10 is compatible.
  # A problem in closest with duplicates = "closest" (used by the function)
  # cause peak 2 not to be matched.
  # A part from this missed peak the found groups and the expected ones are
  # the same
  expect_equal(i_groups[-2], expected_groups[-2])
  expect_equal(i_groups[[2]], expected_groups[[2]][-2])
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
  i_groups <- isotopologues(x_n[, 1:2], substDefinition = subst_def, ppm = 2)
  expect_equal(i_groups, expected_groups_n) # all groups correctly identified

  ## higher ppm: some problems occur
  i_groups <- isotopologues(x_n[, 1:2], substDefinition = subst_def, ppm = 20)
  # Group 1 in additional to the expected peaks contains peaks c(20, 33, 39)
  expected_groups_n[[1]]
  i_groups[[1]]
  expect_true(all(expected_groups_n[[1]] %in% i_groups[[1]]))
  sbs <- closest(x_n[c(20, 33, 39), "mz"],
                 x_n[i_groups[[1]][1], "mz"] + subst_def$md, ppm = 20,
                 tolerance = 0, duplicates = "closest")
  subst_def[sbs, "name"]
  x_n[expected_groups_n[[1]][1], "frmls"]
  # The above mentioned peaks are matched to substitutions that are not possible
  # in the compound that originates the signal of the expected group.
  # Group 2 is composed of two noise peaks whose mz difference match one of the
  # substitutions
  i_groups[[2]]
  x_n[i_groups[[2]], "frmls"]
  closest(x_n[45, "mz"], subst_def$md + x_n[2, "mz"] , ppm = 20, tolerance = 0)
  # Expected 2nd group coincides with 3rd found group
  expect_equal(i_groups[[3]], expected_groups_n[[2]])
  # 4th found group contains all the peaks in expected group 3 except peaks 20,
  # 33, 39. These peaks were mistakenly assigned to the first group found and
  # therefore are no longer available in the subsequent searches
  # Group 5 is composed of two noise peaks whose mz difference match one of the
  # substitutions
  i_groups[[5]]
  x_n[i_groups[[5]], "frmls"]
  closest(x_n[66, "mz"], subst_def$md + x_n[13, "mz"] , ppm = 20, tolerance = 0)
  # 6th found group contains all the peaks in expected group 4 plus peak 77
  i_groups[[6]]
  expected_groups_n[[4]]
  sbs <- closest(x_n[77, "mz"],
                 x_n[i_groups[[6]][1], "mz"] + subst_def$md, ppm = 20,
                 tolerance = 0, duplicates = "closest")
  subst_def[sbs, "name"]
  x_n[expected_groups_n[[1]][1], "frmls"]
  # Again, peak 77 is matched to a substitution that is not possible in the
  # compound that originates the signal of the expected group 4.
  # The 7th group found contains all the peaks in expected group 5 except peak
  # 77 that was mistakenly assigned before
  i_groups[[7]]
  expected_groups_n[[5]]
  # The 8th group found is not expected and its first peak is a noise peak
  x_n[i_groups[[8]], "frmls"]
  # peaks 93 and 103 are grouped with the peak above because they are compatible
  # with it and some of the mass differences of substitutions
  # The 9th group found contains all the peaks in expected group 6 except peaks
  # 93 and 103 that was mistakenly assigned before
  i_groups[[9]]
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
    subst_def <- isotopicSubstitutionMatrix("HMDB")

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
    expect_true(all(i_groups[[3L]] %in% expected_groups[[3L]]))
})
