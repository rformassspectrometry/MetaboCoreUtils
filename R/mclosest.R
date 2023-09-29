#'@title Extract closest values in a pairwise manner between two matrices
#'
#' @description
#'
#' The `mclosest` function calculates the closest rows between two matrices 
#' (or data frames) considering pairwise differences between values in columns 
#' of `x` and `table`. It returns the index of the closest row in `table` for 
#' each row in `x`. 
#'
#' @param x `numeric` matrix or data frame representing the query data. Each 
#' row in `x` will be compared to every row in `table`. Both `x` and `table` are 
#' expected to have the same number of columns, and the columns are expected to 
#' be in the same order.
#'
#' @param table `numeric` matrix or data frame containing the reference data to 
#' be matched with each row of `x`. Each row in `table` will be compared to 
#' every row in `x`. Both `table` and `x` are expected to have the same number 
#' of columns, and the columns are expected to be in the same order.
#'
#' @param ppm `numeric` representing a relative, value-specific 
#' parts-per-million (PPM) tolerance that is added to tolerance (default is 0). 
#'
#' @param tolerance `numeric` accepted tolerance. Defaults to `tolerance = Inf`, 
#' thus for each row in x the closest row in table is reported, regardless of 
#' the magnitude of the (absolute) difference.
#'
#' @return `integer` vector of indices indicating the closest row of `table` for
#' each row of `x`. If no suitable match is found for a row in `x` based on the 
#' specified `tolerance` and `ppm`, the corresponding index is set to `NA`.
#' 
#' @details
#' If, for a row of `x`, two rows of `table` are closest only the index of first 
#' row will be returned. 
#' 
#' For both the `tolerance` and `ppm` arguments, if their length is different to 
#' the number of columns of `x` and `table`, the input argument will be 
#' replicated to match it. 
#'
#' @author Philippine Louail
#' 
#' @importFrom MsCoreUtils ppm
#'
#' @export 
#'
#' @examples
#' x <- data.frame(a = 1:5, b = 3:7)
#' table <- data.frame(c = c(11, 23, 3, 5, 1), d = c(32:35, 45))
#'
#' ## Get for each row of `x` the index of the row in `table` with the smallest 
#' difference of values (per column)
#' mclosest(x, table)
#'
#' ## If the absolute difference is larger than `tolerance`, return `NA`. Note
#' ## that the tolerance value of `25` is used for difference for each pairwise 
#' ## column in `x` and `table`.
#' mclosest(x, table, tolerance = 25)
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



    
