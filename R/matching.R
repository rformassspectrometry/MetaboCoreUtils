#' @title Match numeric values allowing an acceptable difference
#'
#' @description
#'
#' `matchSimilar` allows to match values in `x` against values in `y` allowing
#' differences between values as specified with parameters `tolerance` and
#' `ppm`. Note that, in contrast to the [base::match()] function, indices of
#' **all** matches of each element in `x` in `y` is returned.
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
matchSimilar <- function(x, y, tolerance = 0, ppm = 0) {
    x_l <- length(x)
    if (length(ppm) != 1)
        stop("'ppm' has to be of length 1")
    if (ppm > 0) {
        ppm <- ppm(x, ppm = ppm)
    } else ppm <- rep(0, x_l)
    tolerance_l <- length(tolerance)
    if (tolerance_l > 1 && tolerance_l != x_l)
        stop("length of 'tolerance' should be either 1 or equal length 'x'")
    tolerance <- tolerance + ppm + sqrt(.Machine$double.eps)
    mapply(function(z, tol) {
        which(abs(z - y) <= tol)
    }, x, tolerance, SIMPLIFY = FALSE)
}
