

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
x <- data.frame(a= 1:5, b= 3, colnames([a:e]))
table <- data.frame(c= 2,d=4:8)
ppm <- 0.5
#' 
#' ## take x row and get absulotue difference with every table row and get another table  
#' look for the outer 
#' take the first row of X - duplicate it s that it the lenght of the table argument then apply outer(X,Y, FUN=*-* or diff
#' maybe no need to replicate, i think it is within the function alreadz 
x1 <- x[1,]
x <- as.array(x)
outer(X = as.array(x),Y = as.array(table))

#' 
#'## looping through different rows of X  
#' 
#' ## rank / order the column of an array 
#' 
#' 
#' ## multiple these rank per row 
#'look for %*% (inner matrix vector multiplication)
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