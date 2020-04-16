#' @title Parse a chemical formula into a named vector
#'
#' @description
#'
#' `countElements` This function parses a chemical into a named vector
#'
#' @param x `character` Single string with chemical
#'
#' @return `numeric` A named list containing the parsed chemical formula
#'
#' @author Michael Witting
#' 
#' @importFrom stringr str_extract_all str_extract
#'
#' @export
#'
#' @examples
#'
#' countElements("C6H12O6")
#' countElements("C11H12N2O2")
countElements <- function(x) {
  
  # regex pattern to isolate all elements
  element_pattern <- "([A][cglmrstu]|[B][aehikr]?|[C][adeflmnorsu]?|[D][bsy]|[E][rsu]|[F][elmr]?|[G][ade]|[H][efgos]?|[I][nr]?|[K][r]?|[L][airuv]|[M][cdgnot]|[N][abdehiop]?|[O][gs]?|[P][abdmortu]?|[R][abefghnu]|[S][bcegimnr]?|[T][abcehilms]|[U]|[V]|[W]|[X][e]|[Y][b]?|[Z][nr])([0-9]*)"
  
  # extract all matching pattern
  regexMatch <- stringr::str_extract_all(x, element_pattern)
  
  # get individual elements and their count
  elements <- stringr::str_extract(regexMatch[[1]], "[aA-zZ]+")
  numbers <- as.numeric(stringr::str_extract(regexMatch[[1]], "[0-9]+"))
  
  # replace NAs with 1 for elements which have a count of one
  numbers[is.na(numbers)] <- 1
  
  # create named vector for return
  formula_list <- numbers
  names(formula_list) <- elements
  
  # remove atoms that might have a count of 0
  formula_list <- formula_list[which(formula_list >= 0)]
  
  formula_list
}

#' @title Create chemical formula from a named vector
#'
#' @description
#'
#' `pasteElements` This function creates a chemical formula from a parsed list
#'
#' @param x `character` A named vector containing the number of elements
#'
#' @return `character` Single string with the chemical formula
#'
#' @author Michael Witting
#' 
#' @importFrom  stringr str_extract_all str_extract
#'
#' @export
#'
#' @examples
#' 
#' elements <- c("C" = 6, "H" = 12, "O" = 6)
#' pasteElements(elements)
pasteElements <- function(x) {
  
  if (is.null(names(x))) stop("'x' should be a named vector")
  
  # create empty string to append parts of chem_formula
  chem_formula <- ""
  
  # first C H N O S P, then elements by alphabetical order
  for(atom in c("C", "H", "N", "O", "S", "P")) {
    
    if (atom %in% names(x) && x[[atom]] > 0) {
      if (x[[atom]] == 1) {
        chem_formula <- paste0(chem_formula, atom)
      } else {
        chem_formula <- paste0(chem_formula, atom, x[atom])
      }
    }
  }
  
  # get all remaining elements
  restElements <- names(x)
  restElements <- restElements[!restElements %in% c("C", "H", "N", "O", "S", "P")]
  
  # iterate through all remaining elements in alphabetical order
  for (atom in sort(restElements)) {
    if(x[[atom]] > 0) {
      if (x[[atom]] == 1) {
        chem_formula <- paste0(chem_formula, atom)
      } else {
        chem_formula <- paste0(chem_formula, atom, x[atom])
      }
    }
  }
  
  # return chem_formula
  chem_formula
}

#' @title Create chemical formula from a named vector
#'
#' @description
#'
#' `standardizeFormula` standardizes a supplied chemical chem_formula according to the Hill notation system.
#'
#' @param x `character` Single string with the chemical formula to standardize
#'
#' @return `character` Single string with the standardized chemical formula
#'
#' @author Michael Witting
#' 
#' @import stringr str_extract_all str_extract
#'
#' @export
#'
#' @examples
#' 
#' standardizeFromula("C6O6H12")
standardizeFormula <- function(chem_formula) {
  
  # parse and reconstruct
  formula_list <- countElements(chem_formula)
  pasteElements(formula_list)

}
