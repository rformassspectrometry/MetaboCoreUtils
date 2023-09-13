

@title 
#'
#' @description
#'
#' `mclosest` ...
#'
#' @param x `numeric` vector with migration times in minutes.
#'
#' @param rtime `numeric` vector that holds the migration times (in minutes) of
#' either one or two EOF markers in the same run of which the migration time is
#' going to be transformed.
#'
#' @return `numeric` vector of same length as x with effective mobility values.
#'
#' @author Philippine Louail
#'
#' @export
#'
#' @examples

#' 
#' ## short code test
#'
x <- data.frame(a= c(2,6), b= c(1,1))
table <- data.frame(c= c(1,2),d=  c(3,4))
ppm <- 0.5
#' 
#' take x row and get absulotue difference with every table row and get another table  

#' 
#'looping through different rows of X  
#' 
#' rank / order the column of an array 
#' 
#' 
#' multiple these rank per row 
#' 
#' 
#' get index for the minimum
#' 
#' 
#' 
mclosest <- function(x, 
                     table, 
                     ppm = 0, 
                     tolerance = Inf) {
  
  # sanity checks
  if (dimnames(x) == NULL) # no clue why 
    stop("'x' need to be an array")
  if (dimnames(table) == NULL) # no clue why 
    stop("'table' need to be an array")
  if (ncol(x) != ncol(table)) #works
    stop(" 'x' and 'table' need ot have same number of columns")
  if (length(ppm) != ncol(x))
    ppm <- seq(ppm, by = 0 , along.with = x[1,]) #works but maybe better way
  
  
  
  
  ...
}