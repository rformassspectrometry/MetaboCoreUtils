#'@title Extract closest values in a pairwise manner between two matrices
#'
#' @description
#'
#' `mclosest` functions calculate the closest rows in a pairwise manner.
#' It returns the index of the closest row in 'table' for each row in 'x'. 
#'
#' @param x `numeric`  matrix or data frame representing the query data. each 
#' row will be compared to 'table'. Need to have the same numbers of rows and in 
#' the same order as 'table'.
#'
#' @param table `numeric` matrix or data frame containing the reference data to 
#' be matched with each row of 'x'. Need to have the same numbers of rows and in 
#' the same order as 'x'.
#'
#' @param ppm `numeric` representing a relative, value-specific 
#' parts-per-million (PPM) tolerance that is added to tolerance (default is 0). 
#'
#' @param tolerance `numeric` accepted tolerance.
#'
#' @return `numeric` vector of indices indicating the closest row of 'table' for
#' each row of 'x'.
#' 
#' @details
#' If, for a row of 'x', 2 rows of 'table' are closest only the index of first 
#' row will be returned. 
#' 
#' For both the 'tolerance' and 'ppm' arguments, if their length is different to 
#' the number of rows of 'x' and 'table', the input argument will be replicated 
#' to match it. 
#' 
#'
#' @author Philippine Louail
#' 
#' @importFrom MsCoreUtils ppm
#'
#' @export 
#'
#' @examples
#'x <- data.frame(a = 1:5, b = 3:7)
#'table <- data.frame(c = c(11, 23, 3, 5, 1), d = c(32:35, 45))
#'ppm <- 0.5
#'tolerance <- 25
#'

mclosest <- function(x,
                     table,
                     ppm = 0,
                     tolerance = Inf) {
  ## sanity checks
  if (is.null(dim(x)))
    stop("'x' needs to be an array")
  if (is.null(dim(table)))
    stop("'table' needs to be an array")
  if (ncol(x) != ncol(table))
    stop("'x' and 'table' need to have same number of columns")
  if (!is.matrix(x))
    x <- as.matrix(x)
  if (!is.matrix(table))
    table <- as.matrix(table)
  nc <- ncol(x)
  nr <- nrow(table)
  if (length(ppm) != nc)
   ppm <- rep(ppm[1], nc)
  if (length(tolerance) != nc)
   tolerance <- rep(tolerance[1], nc)

  ## Initialize a vector to store closest row indices
  closest_indices <- rep(NA_integer_ , nrow(x))
  for (i in seq_len(nrow(x))) {
    abdiff <- abs(table - rep(x[i, ], each = nr))
    ## Remove differences lower than tolerance
    abdiff[abdiff > rep((tolerance + ppm(x[i,], ppm)), each = nr)] <- NA
    ranked <- apply(abdiff, 2, rank, na.last="keep")
    rowProd <- apply(ranked, 1, prod)
    res <- which.min(rowProd)
    if (length(res)) 
    closest_indices[i] <- res
  }
  closest_indices
}



    
