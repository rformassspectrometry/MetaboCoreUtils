

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
x <- data.frame(a= 1:5, b= 3)
table <- data.frame(c= 2:6,d=4:8)
ppm <- 0.5

# ## little benchmark on rep vs replicate vs apply = rep
# microbenchmark(
#   abs(as.matrix(table) - matrix(do.call(rbind, rep(x1, nrow(table))),
#          ncol = ncol(table), byrow =TRUE)),
#   abs(as.matrix(table) - as.matrix(do.call(rbind, 
#                                            replicate(n = nrow(table), x1, 
#                                                      simplify = FALSE)))),
#   t(apply(table, MARGIN = 1, function(z) z - x2)) # x2 <- as.numeric(x1)


mclosest <- function(x, 
                     table, 
                     ppm = 0, 
                     tolerance = Inf) {
  
  # sanity checks
  if (!is.array(x))  
    # I also tried dimnames == NULL but my table do not work (get logical(0))
    # here either. but do we want to make it work for table?
    # i am a bit confused by that, is the ideal to make is work for everything ? 
    stop("'x' needs to be an array")
  if (!is.array(table))
    stop("'table' needs to be an array")
  if (ncol(x) != ncol(table))
    stop(" 'x' and 'table' need ot have same number of columns")
  if (length(ppm) != ncol(x))
    ppm <- seq(ppm, by = 0 , along.with = x[1,]) #works but maybe better way
  
  for (i in 1:nrow(x)) { 
    x1 <- x[i,, drop=FALSE]
    x1<- matrix(do.call
                (rbind, rep(x1, nrow(table))), 
                ncol = ncol(table), byrow =TRUE)
    abdiff <- abs(as.matrix(table) - x1)
    ranked <- apply(abdiff, ncol(abdiff), rank)
    rowProd <- apply(ranked, 1, prod)
    return(which.min(rowProd))
  }
  
  ...
}

#' Used apply twice, but for now cannot find anything better using basic function 
#' 