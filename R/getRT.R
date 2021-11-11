#' @title Get retention time value of highest intensity
#'
#' @description
#'
#' `getRtime` uses retention times (RTs) and their intensities to determine the 
#'     RT of the highest intensity within that RT range and below a defined 
#'     intensity threshold. The intensity threshold ensures that a real peak is 
#'     being picked and not any noise if no peak is present in that RT range.
#'     
#'
#' @param x `data.frame`data.frame containing two columns, where the first
#'     holds the retention times and the second the corresponding intensities
#'
#' @param minInt `numeric` a single numeric that defines the minimum intensity 
#'    a peak must have. If no peak is present in that RT range, or if its intensity 
#'    falls below the given threshold, an error is returned. 
#'
#' @return `numeric` a single numeric is returned, which holds the retention time 
#'    at the maximum of given intensity. 
#'
#' @author Liesa Salzer
#'
#' @export
#'
#' @examples
#'
#'rti <- data.frame(rtime = c(10,20,30,40,50,60,70,80,90,100),
#'                  intensity = c(50,50,100,180,200,200,90,50,50,50))
#'
#'getRtime(rti, minInt = 60)
#'
getRtime <- function(x, minInt) {
  
  # sanity checks
  if(missing(x)) {
    stop("Missing data.frame with rtime and intensity")
  }
  
  if(missing(minInt)) {
    stop("Missing minimum intensity 'minInt'")
  }
  
  if(!all(c("rtime", "intensity") %in% colnames(x))) {
    stop("Missing column 'rtime', 'intensity' or both")
  }
  
  if(!all(is.numeric(x$rtime) & is.numeric(x$intensity))) {
    stop("Column 'rtime', 'intensity' or both is not type 'numeric'")
  }
  
  
  
  rtime <- x[which(x$intensity == max(x$intensity)), "rtime"]
  # build mean of rtime if multiple datapoints have highest intensity
  rtime_mean <- mean(rtime)
  
  
  if (max(x$intensity) < minInt) {
    stop("No peaks have been found. Align input parameters.")
  }
  else {
    return(rtime_mean)
  }
  
}
