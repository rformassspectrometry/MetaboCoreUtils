#' @title Convert retention times to retention indices
#'
#' @description
#'
#' `rtimeIndexing` uses a list of known substances to convert retention times to
#'     retention indices. By default linear interpolation is performed.
#'
#' @param x `numeric` vector with retention times
#' 
#' @param y `data.frame`data.frame containing two columns, where the first 
#'     holds the retention times of the indexing substancs and the second the
#'    actual index value
#' 
#' @param FUN `function` function defining how the conversion is performed, 
#'     default is linear interpolation
#'
#' @return `numeric` vector of same length as x with retention indices
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
#' rtimeIndexing(rtime, rti)
#' 
rtimeIndexing <- function(x,
                          y,
                          FUN = rtiLinear) {
  
  unlist(lapply(x, FUN = FUN, rti = y))
  
}

# function for linear interpolation
rtiLinear <- function(x, rti) {
  
  approx(rti[,1],
         rti[,2],
         x,
         yleft = NA,
         yright = NA)$y
  
  
}
