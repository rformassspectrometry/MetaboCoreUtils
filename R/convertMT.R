#' @title Convert migration times to effective mobility
#'
#' @description
#'
#' `convertMT` uses a list of known EOF markers with to convert migration times 
#' (MTs) to effective mobilities (µeff). By using the information of the EOF 
#' markers (which is their MT and µeff), it is possible to transform the MT-
#' scale (for consistency called rtime) into the µeff scale. This is used in 
#' CE-MS to overcome MT shifts originating from EOF fluctuations in different 
#' runs.
#'
#' @param x `numeric` vector with migration times in minutes.
#'
#' @param y `data.frame`data.frame containing minimum two columns, where one
#'     holds the determined migration time in minutes (here referred to as 
#'     `rtime`) of the EOF marker in the same run in which the migration time is 
#'     going to be transformed and the other column the respective mobility of 
#'     the EOF markers. Each row hold the values for one EOF marker. The minimum 
#'     of required markers is one. One or two entries are required for the 
#'     transformation and depending on the number of entries the transformation 
#'     will be performed either on one or both markers.
#'
#' @param FUN `function` function defining how the conversion is performed,
#'     either a single EOF marker is used (convertSingle) or multiple markers 
#'     (convertMultiple)
#'
#' @return `numeric` vector of same length as x with effective mobility values. 
#'
#' @author Liesa Salzer
#'
#' @export
#'
#' @examples
#' rtime <- c(10,20,30,40,50,60,70,80,90,100)
#' marker <- data.frame(markerID = c("marker1", "marker2"),
#'   rtime = c(20,80),
#'   mobility = c(0, 2000))
#' convertMT(rtime, marker)

convertMT <- function(x, y, ...) {
  ## sanity checks
  if (missing(x)) {
    stop("Missing vector 'x' with migration times")}
  if (missing(y)) {
    stop("Missing data.frame 'y' with marker information")}
  if (!all(c("rtime","mobility") %in% colnames(y))) {
    stop("Missing column 'rtime', 'mobility' or all")}
  if (nrow(y) == 0 | nrow(y) > 2) {
    stop("'y' requires one or two entries")}
  if (!is.numeric(x)) {
    stop("'x' needs to be numeric")}
  if (!is.numeric((y$rtime))) {
    stop("'rtime' entries in 'y' needs to be numeric")}
  if (!is.numeric((y$mobility))) {
    stop("'mobility' entries in 'y' needs to be numeric")}
  
  if (nrow(y) == 1) {
    FUN = convertSingle
    FUN <- match.fun(FUN)
  do.call(FUN, list(x = x,
                    y = y,
                    ...))
  } else { ## if "multiple" %in% method
    FUN = convertMultiple
    FUN <- match.fun(FUN)
    do.call(FUN, list(x = x,
                      y = y,
                      ...))
  } 
                                
}


#' function for MT transformation using single marker 
#' @noRd
#'
convertSingle <- function(x, y, 
                          tR = 0, U, L, ...) {
  ## sanity checks
  if (missing(U)) stop("'U' is missing")
  if (missing(L)) stop("'L' is missing")

  ## Calculate electrical field strength
  E <- U / L
  
  ## Extract MT and mobility for markerID
  tEOF <- y$rtime
  mEOF <- y$mobility
  
  ## Calculate mobility  
  mEOF + L / E * ((1 / (x - (tR / 2))) - (1 / (tEOF - (tR / 2))))

}



#' function for MT transformation using multiple markers 
#' @noRd
#'
convertMultiple <- function(x, y, tR = 0, ...) {
  ## sanity checks
  if (nrow(y) < 2) stop("'y' requires min 2 rows")
  
  ## Extract MT and mobility for markers 
  tEOF <- y[y$mobility == 0,]$rtime
  tA <- y[y$mobility != 0,]$rtime
  mA <- y[y$mobility != 0,]$mobility
  
  ## Calculate mobility   
  ((x - tEOF) / (tA - tEOF)) * 
    ((tA - (tR / 2)) / (x - (tR / 2))) * mA
  
}


