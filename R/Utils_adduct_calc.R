#' @title Calculate adduct mass from neutral exact mass
#' 
#' This function calculates the m/z from a given exact mass and a valid adduct defintion, e.g. [M+H]+
#' 
#' @param exact_mass neutral exact mass
#' @param adduct adduct definition, e.g. [M+H]+
#' 
#' @examples 
#' library(metabolomicsUtils)
#' calc_adduct_mass(731.5465, "[M+H]+")
#' 
#' @author Michael Witting, \email{michael.witting@@helmholtz-muenchen.de}
#'
#' @seealso \code{\link{calc_neutral_mass}}
#' @seealso \code{\link{create_ion_formula}}
#'
#' @export
calc_adduct_mass <- function(exact_mass, adduct) {
  
  # get all rules for adduct calculation
  adduct_rules_all <- adduct_rules_all()
  
  # check if adduct suppplied is in the list of valid adducts
  if(!adduct %in% names(adduct_rules_all)) {
    
    stop(paste0("Unknown adduct: ", adduct))
    
  }
  
  # retrieve multiplicative and additive part for calculation
  mass_multi <- adduct_rules_all[[adduct]]$mass_multi
  mass_add <- adduct_rules_all[[adduct]]$mass_add
  
  ion_mass <- exact_mass * mass_multi + mass_add
  
  return(ion_mass)
  
}

#' @title Calculate neutral exact mass from adduct m/z
#' 
#' This function calculates neutral exact mass from a given m/z and a valid adduct defintion, e.g. [M+H]+
#' 
#' @param exact_mass neutral exact mass
#' @param adduct adduct definition, e.g. [M+H]+
#' 
#' @examples 
#' library(metabolomicsUtils)
#' calc_neutral_mass(732.5538, "[M+H]+")
#' 
#' @author Michael Witting, \email{michael.witting@@helmholtz-muenchen.de}
#'
#' @seealso \code{\link{calc_adduct_mass}}
#' @seealso \code{\link{create_ion_formula}}
#'
#' @export
calc_neutral_mass <- function(ion_mass, adduct) {
  
  # get all rules for adduct calculation
  adduct_rules_all <- adduct_rules_all()
  
  # check if adduct suppplied is in the list of valid adducts
  if(!adduct %in% names(adduct_rules_all)) {
    
    stop(paste0("Unknown adduct: ", adduct))
    
  }
  
  # retrieve multiplicative and additive part for calculation
  mass_multi <- adduct_rules_all[[adduct]]$mass_multi
  mass_add <- adduct_rules_all[[adduct]]$mass_add
  
  exact_mass <- (ion_mass - mass_add) / mass_multi
  
  return(exact_mass)
  
}

#' @title Create ion formula from neutral formula and adduct
#' 
#' This function creates an ion formula from a neutral chemical formula and a valid adduct defintion, e.g. [M+H]+
#' 
#' @param exact_mass neutral exact mass
#' @param adduct adduct definition, e.g. [M+H]+
#' 
#' @examples 
#' library(metabolomicsUtils)
#' create_ion_formula("C6H12O6", "[M+H]+")
#' 
#' @author Michael Witting, \email{michael.witting@@helmholtz-muenchen.de}
#'
#' @seealso \code{\link{calc_adduct_mass}}
#' @seealso \code{\link{calc_neutral_mass}}
#'
#' @export
create_ion_formula <- function(chem_formula, adduct) {
  
  # get all adduct rules
  adduct_rules_all <- adduct_rules_all()
  
  # create ion formula
  ion_formula <- formula_addition(chem_formula, adduct_rules_all[[adduct]]$formula_add)
  ion_formula <- formula_subtraction(ion_formula, adduct_rules_all[[adduct]]$formula_sub)
  
  # add brackets and charge
  if(grepl("\\]\\+", adduct)) {
    
    ion_formula <- paste0("[", ion_formula, "]", abs(adduct_rules_all[[adduct]]$charge), "+")
    
  } else if(grepl("\\]\\-", adduct)) {
    
    ion_formula <- paste0("[", ion_formula, "]", abs(adduct_rules_all[[adduct]]$charge), "-")
    
  }

  # return result
  return(ion_formula)
}
