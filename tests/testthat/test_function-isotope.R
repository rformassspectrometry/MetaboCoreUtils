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

test_that("isotopicSubstitutionMatrix works", {
    expect_error(isotopicSubstitutionMatrix("other"))
    res <- isotopicSubstitutionMatrix("HMDB")
    expect_true(is.data.frame(res))
})

test_that("compare performance on a real spectrum", {
    library(msdata)
    library(microbenchmark)
    library(testthat)
    library(MsCoreUtils)
    fl <- dir(system.file("sciex", package = "msdata"), full.names = TRUE)[1L]
    library(Spectra)
    library(MetaboCoreUtils)
    sps <- pickPeaks(Spectra(fl))

    ## Get spectrum close to rt 181 (serine)
    sp <- peaksData(sps[which.min(abs(181 - rtime(sps)))])[[1L]]

    subst <- isotopicSubstitutionMatrix()
    substm <- as.matrix(subst[, -1])
    a <- .isotope_peaks(sp, subst, tolerance = 0, ppm = 10)
    b <- .isotope_peaks2(sp, subst, tolerance = 0, ppm = 10)
    d <- .isotope_peaks3(sp, subst, tolerance = 0, ppm = 10)
    e <- .isotope_peaks_exhaustive(sp, subst, tolerance = 0, ppm = 10)
    f <- .isotope_peaks_reverse(sp, subst, tolerance = 0, ppm = 10)

    expect_equal(a, b)
    expect_equal(a, d)
    expect_equal(a, f)
    expect_true(length(e) > length(a))

    plotSpectra(sps[which.min(abs(181 - rtime(sps)))])
    lapply(a, function(z) {
        points(sp[z, "mz"], sp[z, "intensity"], col = "red", type = "h")
    })

    ## Comparing matrix vs data.frame
    microbenchmark(
        .isotope_peaks(sp, subst, tolerance = 0, ppm = 10),
        .isotope_peaks2(sp, subst, tolerance = 0, ppm = 10),
        .isotope_peaks(sp, substm, tolerance = 0, ppm = 10),
        .isotope_peaks2(sp, substm, tolerance = 0, ppm = 10),
        .isotope_peaks3(sp, substm, tolerance = 0, ppm = 10),
        .isotope_peaks_reverse(sp, substm, tolerance = 0, ppm = 10)
    )
    ## No difference between implementations. matrix is faster.

    ## Exhaustive
    microbenchmark(
        .isotope_peaks_exhaustive(sp, substm, tolerance = 0, ppm = 10),
        .isotope_peaks_exhaustive2(sp, substm, tolerance = 0, ppm = 10)
    )

    ## Unit: milliseconds
    ##                                                            expr      min
    ##   .isotope_peaks_exhaustive(sp, subst, tolerance = 0, ppm = 10) 344.9644
    ##  .isotope_peaks_exhaustive(sp, substm, tolerance = 0, ppm = 10) 263.6216
    ##        lq     mean   median       uq      max neval cld
    ##  363.9536 389.3214 380.3355 402.7342 615.2361   100   b
    ##  279.5471 298.4994 288.4216 303.0251 538.1835   100  a

    fl <- proteomics(full.names = TRUE)[3L]
    sps <- filterMsLevel(Spectra(fl))
    sp2 <- peaksData(sps[1L])[[1L]]

    microbenchmark(
        .isotope_peaks(sp2, subst, tolerance = 0, ppm = 10),
        .isotope_peaks2(sp2, subst, tolerance = 0, ppm = 10),
        .isotope_peaks_logical(sp2, subst, tolerance = 0, ppm = 10),
        .isotope_peaks(sp2, substm, tolerance = 0, ppm = 10),
        .isotope_peaks2(sp2, substm, tolerance = 0, ppm = 10),
        .isotope_peaks_logical(sp2, substm, tolerance = 0, ppm = 10)
    )
    ## Unit: milliseconds
    ##                                                          expr      min       lq
    ##           .isotope_peaks(sp2, subst, tolerance = 0, ppm = 10) 544.5807 615.8860
    ##          .isotope_peaks2(sp2, subst, tolerance = 0, ppm = 10) 555.2936 628.7274
    ##   .isotope_peaks_logical(sp2, subst, tolerance = 0, ppm = 10) 654.1140 731.2242
    ##          .isotope_peaks(sp2, substm, tolerance = 0, ppm = 10) 466.7915 537.1365
    ##         .isotope_peaks2(sp2, substm, tolerance = 0, ppm = 10) 480.3685 551.4879
    ##  .isotope_peaks_logical(sp2, substm, tolerance = 0, ppm = 10) 564.3864 649.0987
    ##      mean   median       uq      max neval  cld
    ##  647.0624 623.2351 632.2186 885.4975   100  b
    ##  660.3847 634.7336 643.5690 866.0924   100  bc
    ##  793.5531 740.4309 933.1952 969.0602   100    d
    ##  564.3956 544.7219 553.9129 783.2536   100 a
    ##  587.3211 555.5120 564.8337 791.1891   100 a
    ##  690.4921 655.5835 670.1336 897.7859   100   c

    microbenchmark(
        .isotope_peaks_exhaustive(sp2, subst, tolerance = 0, ppm = 10),
        .isotope_peaks_exhaustive(sp2, substm, tolerance = 0, ppm = 10)
    )
    ## Unit: seconds
    ##                                                             expr      min
    ##   .isotope_peaks_exhaustive(sp2, subst, tolerance = 0, ppm = 10) 11.39473
    ##  .isotope_peaks_exhaustive(sp2, substm, tolerance = 0, ppm = 10) 10.92748
    ##        lq     mean   median       uq      max neval cld
    ##  13.21374 13.93961 13.47114 14.01568 20.95427   100   b
    ##  11.98549 12.60931 12.25350 12.60493 17.72926   100  a

})
