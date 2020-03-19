#' @title Check if one formula is contained in another
#' 
#' This function checks if one sum formula is contained in another.
#' 
#' @param target_chem_formula Single string with chemical formula
#' @param query_chem_formula Single string with chemical formula that should be contained in the targetFormula
#' 
#' @examples
#' library(metabolomicsUtils)
#' contains_formula("C6H12O6", "H2O")
#' 
#' @author Michael Witting, \email{michael.witting@@helmholtz-muenchen.de}
#'
#' @seealso \code{\link{formula_subtraction}}
#' @seealso \code{\link{formula_addition}}
#' 
#' @export
contains_formula <- function(target_chem_formula, query_chem_formula) {
  
  # parse both formmula
  target_formula_list <- formula_to_list(target_chem_formula)
  query_formula_list <- formula_to_list(query_chem_formula)
  
  formula_concat <- c(target_formula_list, query_formula_list * -1)
  
  # subtract formula from each other
  result_formula_list <- tapply(formula_concat, names(formula_concat), sum)
  
  contains <- all(result_formula_list >= 0)
  
  return(contains)
}

#' @title subtract two chemical formula
#' 
#' This function subtracts one formula from another.
#' 
#' @param target_chem_formula Single string with chemical formula
#' @param query_chem_formula Single string with chemical formula that should be subtracted from the targetFormula
#' 
#' @examples
#' library(metabolomicsUtils)
#' formula_subtraction("C6H12O6", "H2O")
#' 
#' @author Michael Witting, \email{michael.witting@@helmholtz-muenchen.de}
#'
#' @seealso \code{\link{contains_formula}}
#' @seealso \code{\link{formula_addition}}
#' 
#' @export
formula_subtraction <- function(target_chem_formula, query_chem_formula) {
  
  # sanity checks for formulas
  if(!contains_formula(target_chem_formula, query_chem_formula)) {
    stop(paste0(query_chem_formula, " not contained in ", target_chem_formula))
  }
  
  # parse both formmula
  target_formula_list <- formula_to_list(target_chem_formula)
  query_formula_list <- formula_to_list(query_chem_formula)
  
  formula_concat <- c(target_formula_list, query_formula_list * -1)
  
  # subtract formula from each other
  result_formula_list <- tapply(formula_concat, names(formula_concat), sum)

  return(list_to_formula(result_formula_list))
  
}

#' @title add two chemical formula
#' 
#' This function add one formula to another.
#' 
#' @param target_chem_formula Single string with chemical formula
#' @param query_chem_formula Single string with chemical formula
#' 
#' @examples
#' library(metabolomicsUtils)
#' formula_addition("C6H12O6", "H2O")
#' 
#' @author Michael Witting, \email{michael.witting@@helmholtz-muenchen.de}
#'
#' @seealso \code{\link{contains_formula}}
#' @seealso \code{\link{formula_subtraction}}
#' 
#' @export
formula_addition <- function(target_chem_formula, query_chem_formula) {

  # parse both formmula
  target_formula_list <- formula_to_list(target_chem_formula)
  query_formula_list <- formula_to_list(query_chem_formula)
  
  formula_concat <- c(target_formula_list, query_formula_list)
  
  # subtract formula from each other
  result_formula_list <- tapply(formula_concat, names(formula_concat), sum)
  
  return(list_to_formula(result_formula_list))
  
}
