

@title 
#'
#' @description
#'
#' `mclosest` ...
#'
#' @param 
#'
#' @param 
#'
#' @return 
#'
#' @author Philippine Louail
#'
#' @export
#'
#' @examples
#' x <- data.frame(a = 1:5, b = 3:7)
#' table <- data.frame(c = c(11, 23, 3, 5, 1), d = c(32:35, 45))
#' ppm <- 0.5
#' mclosest(x, table, ppm = 0.5)


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
  if (length(ppm) != ncol(x))
   ppm <- rep(ppm[1], ncol(x))
  
  
  for (i in 1:nrow(x)) { 
    x1 <- x[i,, drop=FALSE]
    x1 <- matrix(rbind(rep(x1, nrow(table))), ncol = ncol(table), byrow = TRUE)
    abdiff <- abs(table - x1)
    ranked <- apply(abdiff, 2, rank)
    rowProd <- apply(ranked, 1, prod)
    return(which.min(rowProd))
  }
  ...
}

