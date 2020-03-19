#' @title Calculate adduct mass from neutral exact mass
#' 
#' This function calculates the m/z from a given exact mass and a adduct definition
#' defined by the user.
#' 
#' @param exact_mass neutral exact mass
#' @param adduct_definition
#' 
#' @examples 
#' library(metabolomicsUtils)
#' 
#' adduct_defintion <- list("[M+H]+" = list(mass_multi = 1,
#' mass_add =  1.007276,
#' formula_add = "H",
#' formula_sub = "C0",
#' charge = 1))#' 
#' 
#' calc_adduct_mass(731.5465, adduct_definition)
#' 
#' @author Michael Witting, \email{michael.witting@@helmholtz-muenchen.de}
#'
#' @seealso \code{\link{calc_neutral_mass_user}}
#' @seealso \code{\link{create_ion_formula_user}}
#'
#' @export
calc_adduct_mass_user <- function(exact_mass, adduct_definition) {

  # retrieve multiplicative and additive part for calculation
  mass_multi <- adduct_definition$mass_multi
  mass_add <- adduct_definition$mass_add
  
  ion_mass <- exact_mass * mass_multi + mass_add
  
  # return result
  ion_mass
  
}

#' @title Calculate neutral exact mass from adduct m/z
#' 
#' This function calculates neutral exact mass from a given m/z and a valid adduct defintion, e.g. [M+H]+
#' 
#' @param exact_mass neutral exact mass
#' @param adduct_definition
#' 
#' @examples 
#' library(metabolomicsUtils)
#' calc_neutral_mass(732.5538, "[M+H]+")
#' 
#' @author Michael Witting, \email{michael.witting@@helmholtz-muenchen.de}
#'
#' @seealso \code{\link{calc_adduct_mass_user}}
#' @seealso \code{\link{create_ion_formula_user}}
#'
#' @export
calc_neutral_mass_user <- function(ion_mass, adduct_definition) {

  # retrieve multiplicative and additive part for calculation
  mass_multi <- adduct_definition$mass_multi
  mass_add <- adduct_definition$mass_add
  
  exact_mass <- (ion_mass - mass_add) / mass_multi
  
  # return result
  exact_mass
  
}

#' @title Create ion formula from neutral formula and adduct
#' 
#' This function creates an ion formula from a neutral chemical formula and a valid adduct defintion, e.g. [M+H]+
#' 
#' @param exact_mass neutral exact mass
#' @param adduct_definition
#' 
#' @examples 
#' library(metabolomicsUtils)
#' create_ion_formula("C6H12O6", "[M+H]+")
#' 
#' @author Michael Witting, \email{michael.witting@@helmholtz-muenchen.de}
#'
#' @seealso \code{\link{calc_adduct_mass_user}}
#' @seealso \code{\link{calc_neutral_mass_user}}
#'
#' @export
create_ion_formula_user <- function(chem_formula, adduct_definition) {

  # create ion formula
  ion_formula <- formula_addition(chem_formula, adduct_definition$formula_add)
  ion_formula <- formula_subtraction(ion_formula, adduct_definition$formula_sub)
  
  # add brackets and charge
  if(grepl("\\]\\+", adduct)) {
    
    ion_formula <- paste0("[", ion_formula, "]", abs(adduct_definition$charge), "+")
    
  } else if(grepl("\\]\\-", adduct)) {
    
    ion_formula <- paste0("[", ion_formula, "]", abs(adduct_definition$charge), "-")
    
  }
  
  # return result
  ion_formula
}
