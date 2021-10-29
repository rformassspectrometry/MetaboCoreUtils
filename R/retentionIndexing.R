#' @title Convert retention times to retention indices
#'
#' @description
#'
#' `indexRtime` uses a list of known substances to convert retention times (RTs)
#'     to retention indices (RIs). By this retention information is normalized
#'     for differences in experimental settings, such as gradient delay volume,
#'     dead volume or flow rate. By default linear interpolation is performed,
#'     other ways of calculation can supplied as function.
#'
#' @param x `numeric` vector with retention times
#'
#' @param y `data.frame`data.frame containing two columns, where the first
#'     holds the retention times of the indexing substances and the second the
#'    actual index value
#'
#' @param FUN `function` function defining how the conversion is performed,
#'     default is linear interpolation
#'
#' @param ... additional parameter used by `FUN`
#'
#' @return `numeric` vector of same length as x with retention indices. Values
#'     floating point decimals. If integer values shall be used conversion has
#'     to be performed manually
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' rti <- data.frame(rtime = c(1,2,3),
#' rindex = c(100,200,300))
#' rtime <- c(1.5, 2.5)
#' indexRtime(rtime, rti)
#'
indexRtime <- function(x,
                       y,
                       FUN = rtiLinear,
                       ...) {

  # sanity checks
  if(missing(y)) {
    stop("Missing data.frame with index data")
  }

  if(!all(c("rtime", "rindex") %in% colnames(y))) {
    stop("Missing column 'rtime', 'rindex' or both")
  }

  FUN <- match.fun(FUN)
  do.call(FUN, list(x = x,
                    rti = y,
                    ...))

}

#' @title 2-point correction of RIs
#'
#' @description
#'
#' `correctRindex` performs correction of retention indices (RIs) based on
#' reference substances.
#' Even after conversion of RTs to RIs slight deviations might exist. These
#' deviations can be further normalized, if they are linear, by using two
#' metabolites for which the RIs are known (e.g. internal standards).
#'
#' @param x `numeric` vector with retention indices, calculated by `indexRtime`
#'
#' @param y `data.frame` containing two columns. The first is expected to
#'     contain the measured RIs of the reference substances and the second the
#'     reference RIs.
#'
#' @return `numeric` vector of same length than `x` with corrected retention
#'     indices. Values are floating point decimals. If integer values shall be
#'     used conversion has to be performed manually.
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' ref <- data.frame(rindex = c(110, 210),
#' refindex = c(100, 200))
#' rindex <- c(110, 210)
#' correctRindex(rindex, ref)
correctRindex <- function(x, y) {

  # sanity checks
  if(missing(y)) {
    stop("Missing data.frame with reference indices")
  }

  if(!nrow(y) == 2) {
    stop("y requires exact two rows")
  }

  if(!all(c("rindex", "refindex") %in% colnames(y))) {
    stop("Missing column 'rindex', 'refindex' or both")
  }

  s1 <- min(y$refindex)
  s2 <- max(y$refindex)

  m1 <- min(y$rindex)
  m2 <- max(y$rindex)

  s1 + (x - m1) * (s2 - s1) / (m2 - m1)


}

#' function for linear interpolation
#' @noRd
#'
#' @importFrom stats approx
rtiLinear <- function(x, rti, yleft = NA, yright = NA, ...) {

  approx(rti$rtime,
         rti$rindex,
         x,
         yleft = yleft,
         yright = yright,
         ...)$y

}
