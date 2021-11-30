#' @title Convert migration times to effective mobility
#'
#' @description
#'
#' `convertMtime` performs effective mobility scale transformation of CE(-MS) 
#' data, which is used to overcome variations of the migration times, caused by 
#' differences in the Electroosmotic Flow (EOF) between different runs. 
#' In order to monitor the EOF and perform the transformation, neutral or 
#' charged EOF markers are spiked into the sample before analysis. The 
#' information of the EOF markers (migration time and effective mobility) will 
#' be then used to perform the  effective mobility transformation of the 
#' migration time scale. 
#'
#' @param x `numeric` vector with migration times in minutes.
#'
#' @param rtime `numeric` vector that holds the migration times (in minutes) of 
#' either one or two EOF markers in the same run of which the migration time is 
#' going to be transformed.
#' 
#' @param mobility `numeric` vector containing the respective effective mobility
#' (in in mm^2 / (kV * min)) of the EOF markers. If two markers are used, one is
#' expected to be the neutral marker, i.e. having a mobility of 0. 
#' 
#' @param tR `numeric` a single value that defines the time (in minutes) of the 
#' electrical field ramp. The default is 0. 
#' 
#' @param U `numeric` a single value that defines the voltage (in kV) applied. 
#' Note that for reversed polarity CE mode a negative value is needed.
#'  
#' @param L `numeric` a single value that defines the total length (in mm) of 
#' the capillary that was used for CE(-MS) analysis. 
#'
#' @return `numeric` vector of same length as x with effective mobility values. 
#'
#' @author Liesa Salzer
#'
#' @export
#'
#' @examples
#'  rtime <- c(10,20,30,40,50,60,70,80,90,100)
#'  marker_rt <-  c(20,80)
#'  mobility <- c(0, 2000) 
#'  convertMTime(rtime, marker_rt, mobility)

convertMTime <- function(x = numeric(), rtime = numeric(),
                         mobility = numeric(), tR = 0,
                         U = numeric(), L = numeric()) {
  ## sanity checks
  if (!length(x)) return(x)
  if (length(rtime) != length(mobility))
    stop("'rtime' and 'mobility' need to have the same length")
  if (!length(rtime) %in% c(1, 2))
    stop("'rtime' and 'mobility' are expected to have either length 1 or 2 but not ", 
         length(rtime))
  if (length(tR) != 1) {
    tR <- tR[1]
    warning("Length or parameter 'tR' > 1 but using only first element")
  }
  
  
  if (length(rtime) == 1) 
    convertSingle(x, rtime = rtime, mobility = mobility, 
                  tR = tR, U = U, L = L)
   else convertMultiple(x, rtime = rtime, mobility = mobility, tR = tR)
                               
}


#' function for MT transformation using single marker 
#' @noRd
#'
convertSingle <- function(x = numeric(), rtime = numeric(), 
                          mobility = numeric(), tR = 0, 
                          U = numeric(), L = numeric()) {
  
  ## sanity checks
  if (length(U) != 1 & length(L) != 1)
    stop("'U' and 'L' are expected to be of length 1.")
  
  ## Calculate mobility  
  mobility + ((L^2) / U) * 
    ((1 / (x - (tR / 2))) - (1 / (rtime - (tR / 2))))
  
}


#' function for MT transformation using multiple markers 
#' @noRd
#'
convertMultiple <- function(x = numeric(), rtime = numeric(), 
                            mobility = numeric(), tR = 0) {

  is_zero <- mobility == 0
  if (!any(is_zero))
    stop("One of the two provided mobility values is expected to be 0.")
  
  ## Calculate mobility   
  ((x - rtime[is_zero]) / (rtime[!is_zero] - rtime[is_zero])) * 
    ((rtime[!is_zero] - (tR / 2)) / (x - (tR / 2))) * mobility[!is_zero]
  
}


