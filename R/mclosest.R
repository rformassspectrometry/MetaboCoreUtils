#'@title Extract closest values in a pairwise manner between two matrices
#'
#' @description
#'
#' `mclosest` functions calculate the closest rows in a pairwise manner.
#' It returns the index of the closest row in 'table' for each row in 'x'
#'
#' @param x `numeric`  matrix or data frame representing the query data.
#'
#' @param table `numeric` matrix or data frame containing the reference data.
#'
#' @param ppm `numeric` value specifying the parts per million tolerance for
#'             considering values as equal (default is 0).
#'
#' @param tolerance ...
#'
#' @return `numeric` vector of indices indicating the closest row of 'table' for each row of 'x'
#'
#' @author Philippine Louail
#'
#' @export
#'
#' @examples
x <- data.frame(a = 1:5, b = 3:7)
table <- data.frame(c = c(11, 23, 3, 5, 1), d = c(32:35, 45))
ppm <- 0.5
#'

mclosest <- function(x,
                     table,
                     ppm = 0,
                     tolerance = Inf) {
  # sanity checks
  if (is.null(dim(x)))
    stop("'x' needs to be an array")
  if (is.null(dim(table)))
    stop("'table' needs to be an array")
  if (ncol(x) != ncol(table))
    stop(" 'x' and 'table' need ot have same number of columns")
  if (!is.matrix(x))
    x <- as.matrix(x)
  if (!is.matrix(table))
    table <- as.matrix(table)
  nr <- nrow(x)
  nc <- ncol(x)
  if (length(ppm) != nc)
   ppm <- rep(ppm[1], nc)
  if (length(tolerance) != nc)
   tolerance <- rep(tolerance[1], nc)

  # Initialize a vector to store closest row indices
  closest_indices <- numeric(nr)
  for (i in seq_len(nr)) {
    abdiff <- abs(table - rep(x[i, ], each = nr))
    ranked <- apply(abdiff, 2, rank)
    ## Remove differences larger than tolerance
    ranked[abdiff > rep(tolerance, each = nr)] <- NA
    rowProd <- apply(ranked, 1, prod)
    closest_indices[i] <- which.min(rowProd)
  }
  closest_indices
}
