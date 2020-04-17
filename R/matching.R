#' @title Match numeric values allowing an acceptable difference
#'
#' @description
#'
#' `matchSimilar` allows to match values in `x` against values in `y` allowing
#' differences between values as specified with parameters `tolerance` and
#' `ppm`. Note that, in contrast to the [base::match()] function, indices of
#' **all** matches of each element in `x` in `y` is returned.
#'
#' By default the matching searches for differences that are `0` (+/- the
#' acceptable deviation defined by `tolerance` and `ppm`). Parameter
#' `difference` allows to define an alternative expected difference between
#' values.
#'
#' @param x `numeric` with values to match against `y`.
#'
#' @param y `numeric` with values to match elements in `x` against.
#'
#' @param tolerance `numeric` with an absolute acceptable difference of values
#'     to be considered matching. Has to be either a `numeric` of length 1 or
#'     length equal `length(x)` (to specify a different tolerance for each
#'     input value). Defaults to `tolerance = 0`.
#'
#' @param ppm `numeric(1)` defining a relative acceptable difference (in parts
#'     per million) for values to be considered matching. This is applied to
#'     values in `x`. Defaults to `ppm = 0`.
#'
#' @param difference `numeric(1)` defining the expected difference between
#'     values in `x` and `y`. Defaults to `0` to return only matches for values
#'     with differences equal to `0` (given the aceptable small deviation
#'     defined by `tolerance` and `ppm`). See below for examples.
#'
#' @return `list` (length equal length of `x`) with `integer` values. Each
#'     element in this returned `list` representing the index of the values in
#'     `y` that match the respective value in `x` given the acceptable
#'     differences defined by `tolerance` and `ppm`. For values in `x` that
#'     do not match any value in `y` `integer()` (integer of length 0) is
#'     returned.
#'
#' @author Johannes Rainer
#'
#' @importFrom MsCoreUtils ppm
#'
#' @export
#'
#' @examples
#'
#' yvals <- abs(rnorm(1000))
#' yvals[123] <- yvals[2] - yvals[2] * 10 * 1e-6
#' yvals[124] <- yvals[2] + yvals[2] * 10 * 1e-6
#' yvals[125] <- yvals[2] + yvals[2] * 12 * 1e-6
#' xvals <- yvals[c(2, 3, 3, 20, 21, 20)]
#' xvals[2] <- xvals[2] + (10 * xvals[2] / 1e6)
#' xvals[3] <- xvals[3] - (10 * xvals[3] / 1e6)
#' xvals[6] <- xvals[6] + (12 * xvals[6] / 1e6)
#'
#' ## Perfect matches:
#' matchSimilar(xvals, yvals)
#'
#' ## Match allowing +/- 10ppm difference
#' matchSimilar(xvals, yvals, ppm = 10)
#'
#' ## Match allowing +/- 20ppm difference
#' matchSimilar(xvals, yvals, ppm = 20)
#'
#' ## perfect matches only
#' matchSimilar(1:3, c(1.1, 2, 3.1, 2.1, 1))
#'
#' ## matches with a constant tolerance
#' matchSimilar(1:3, c(1.1, 2, 3.1, 2.1, 1), tolerance = 0.1)
#'
#' ## matches with a different tolerance for each
#' matchSimilar(1:3, c(1.1, 2, 3.1, 2.1, 1), tolerance = c(0.1, 0, 0.1))
matchSimilar <- function(x, y, tolerance = 0, ppm = 0, difference = 0) {
    x_l <- length(x)
    if (length(difference) != 1)
        stop("'difference' has to be of length 1")
    if (length(ppm) != 1)
        stop("'ppm' has to be of length 1")
    if (ppm > 0) {
        ppm <- ppm(x, ppm = ppm)
    } else ppm <- rep(0, x_l)
    tolerance_l <- length(tolerance)
    if (tolerance_l > 1 && tolerance_l != x_l)
        stop("length of 'tolerance' should be either 1 or equal length 'x'")
    tolerance <- tolerance + ppm + sqrt(.Machine$double.eps)
    res <- vector("list", x_l)
    for (i in seq_len(x_l))
        res[[i]] <- which(abs(abs(y - x[i]) - difference) <= tolerance[i])
    names(res) <- names(x)
    res
}

#' Compare each values in `x` with each other to group elements for which the
#' difference is smaller `ppm` and `tolerance`.
#' @examples
#'
#' x <- c(1.1, 1.2, 1.5, 1.6, 2, 2.1, 2.2, 2.3, 2.6)
#' res <- MsCoreUtils::group(x, tolerance = 0.1)
#'
#' library(microbenchmark)
#' microbenchmark(MsCoreUtils::group(rep(x, 200), tolerance = 0.1),
#'     groupSimilar(rep(x, 200), tolerance = MsCoreUtils::ppm(x, 0) + 0.1),
#'     matchSimilar(rep(x, 200), rep(x, 200), tolerance = 0.1),
#'     matchSimilar2(rep(x, 200), rep(x, 200), tolerance = 0.1))
#' a <- MsCoreUtils::group(x, tolerance = 0.1)
#' b <- groupSimilar(x, tolerance = MsCoreUtils::ppm(x, 0) + 0.1)
#' d <- matchSimilar(x, x, tolerance = 0.1)
#'
#' x_2 <- c(3.2, 3.3, 4.202, 5.204, 6)
#' groupSimilar(x_2)
#' groupSimilar(x_2, difference = 1.002)
#'
#' matchSimilar(x_2, x_2)
#' res <- matchSimilar(x_2, x_2, difference = 1.002)
#' idx <- which(lengths(res) > 0)
#' res_2 <- vector("list", length(idx))
#' for (i in idx) {
#'     if ()
#' }
groupSimilar <- function(x, tolerance = MsCoreUtils::ppm(x, 10) + 0,
                         difference = 0) {
    ## Have a matrix with 0 and 1 if two elements are similar.
    len_x <- length(x)
    if (length(difference) > 1 && length(difference) != len_x)
        stop("length of 'difference' has to be 1 or equal length of 'x'")
    tolerance <- tolerance + sqrt(.Machine$double.eps)
    mat <- matrix(0, ncol = len_x, nrow = len_x)
    for (i in seq_along(x)) {
        mat[i, abs(abs(x - x[i]) - difference) <= tolerance] <- 1
    }
    mat
}

#' pairwise difference.
#'
#' 1) calculate differnces between each.
#' 2) check if any of the differences match a possible adduct/isotope
#'    relationship
#' 3) clean possibilities.
pdiff <- function(x, y) {

}