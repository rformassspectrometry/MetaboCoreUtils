#' @title Convert retention times to retention indices
#'
#' @description
#'
#' `indexRtime` uses a list of known substances to convert retention times to
#'     retention indices. By default linear interpolation is performed.
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

#' function for linear interpolation
#' @noRd
rtiLinear <- function(x, rti, yleft = NA, yright = NA, ...) {
  
  approx(rti$rtime,
         rti$rindex,
         x,
         yleft = yleft,
         yright = yright,
         ...)$y
  
}
