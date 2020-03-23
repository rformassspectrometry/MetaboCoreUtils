#' @title Calculate mass-to-charge ratio
#'
#' @description
#'
#' `mass2mz` calculates the m/z value from a neutral mass and an adduct 
#'      definition.
#'
#' @param x `numeric` neutral mass for which the adduct m/z shall be calculated.
#'
#' @param adduct `character` Valid adduct definition. valid adduct definition; 
#'     supported values are returned by [adductNames()]
#'
#' @return `numeric` m/z value calculated
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' exact_mass <- 100
#' adduct <- "[M+H]+"
#' 
#' ## Calculate m/z of [M+H]+ adduct from neutral mass
#' mass2mz(exact_mass, adduct)
#' 
#' exact_mass <- 100
#' adduct <- "[M+Na]+"
#' 
#' ## Calculate m/z of [M+Na]+ adduct from neutral mass
#' mass2mz(exact_mass, adduct)
mass2mz <- function(x, adduct = "[M+H]+") {
  
  adduct_rules_all <- c(.adductRules(polarity = "positive"),
                        .adductRules(polarity = "negative"))

  # check if adduct suppplied is in the list of valid adducts
  if(!adduct %in% names(adduct_rules_all)) {
    
    stop(paste0("Unknown adduct: ", adduct))
    
  }
  
  # retrieve multiplicative and additive part for calculation
  mass_multi <- adduct_rules_all[[adduct]]$mass_multi
  mass_add <- adduct_rules_all[[adduct]]$mass_add
  
  ion_mass <- x * mass_multi + mass_add
  
  ion_mass
  
}

#' @title Calculate neutral mass
#'
#' @description
#'
#' `mz2mass` calculates the neutral mass from a given m/z value and adduct 
#'      definition
#'
#' @param x `numeric` m/z value for which the neutral mass shall be calculated.
#'
#' @inheritParams mass2mz
#'
#' @return `numeric` neutral mass calculated
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' ion_mass <- 100
#' adduct <- "[M+H]+"
#' 
#' ## Calculate m/z of [M+H]+ adduct from neutral mass
#' mz2mass(ion_mass, adduct)
#' 
#' ion_mass <- 100
#' adduct <- "[M+Na]+"
#' 
#' ## Calculate m/z of [M+Na]+ adduct from neutral mass
#' mz2mass(ion_mass, adduct)
mz2mass <- function(x, adduct = "[M+H]+") {
  
  adduct_rules_all <- c(.adductRules(polarity = "positive"),
                        .adductRules(polarity = "negative"))
  
  # check if adduct suppplied is in the list of valid adducts
  if(!adduct %in% names(adduct_rules_all)) {
    
    stop("Unknown adduct: ", adduct)
    
  }
  
  # retrieve multiplicative and additive part for calculation
  mass_multi <- adduct_rules_all[[adduct]]$mass_multi
  mass_add <- adduct_rules_all[[adduct]]$mass_add
  
  exact_mass <- (x - mass_add) / mass_multi
  
  exact_mass
  
}

#' @title Retrieve names of adducts
#'
#' @description
#'
#' `adductNames` allows to retrieve all valid adduct names currently supported
#'
#' @param polarity `character` Definition of ion mode, either "positive" or "negative"
#'
#' @return `character` A vector of all valid adduct names for the selected ion
#'     mode
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' ## retrieve names of adduct names in positive ion mode
#' adductNames(polarity = "positive")
#' 
#' ## retrieve names of adduct names in negative ion mode
#' adductNames(polarity = "negative)
#' 
adductNames <- function(polarity = c("positive", "negative")) {
  
  polarity <- match.arg(polarity)
  
  if(polarity == "positive") {
    
    return(names(.adductRulesPos()))
    
  } else if(polarity == "negative") {
    
    return(names(.adductRulesNeg()))
    
  } 
}


#===============================================================================
# Private functions
#===============================================================================
.adductRules <- function(polarity = c("positive", "negative")) {
  
  # check polarity
  if(polarity == "positive") {
    
    adduct_list <- .adductRulesPos()
    
    return(adduct_list)
    
  } else if(polarity == "negative") {
    
    adduct_list <- .adductRulesNeg()
    
    return(adduct_list)
    
  } else {
    
    stop("Unknown value for parameter polarity, use either 'positive' or 'negative'")
    
  }
  
}

.adductRulesPos <- function() {
  
  ## create list with all the adduct definitoins
  adduct_list <- list(
    
    # triple charged -----------------------------------------------------------
    "[M+3H]3+"      = list(mass_multi = 1 / 3,
                           mass_add = 3 * 1.007276 / 3,
                           formula_add = "H3",
                           formula_sub = "C0",
                           charge = 3),
    "[M+2H+Na]3+"   = list(mass_multi = 1 / 3,
                           mass_add = (2 * 1.007276 + 1 * 22.98922) / 3,
                           formula_add = "H2Na",
                           formula_sub = "C0",
                           charge = 3),
    "[M+H+Na2]3+"   = list(mass_multi = 1 / 3,
                           mass_add = (1 * 1.007276 + 2 * 22.98922) / 3,
                           formula_add = "HNa2",
                           formula_sub = "C0",
                           charge = 3),
    "[M+Na3]3+"     = list(mass_multi = 1 / 3,
                           mass_add = (3 * 22.98922) / 3,
                           formula_add = "Na3",
                           formula_sub = "C0",
                           charge = 3),
    
    # double charged -----------------------------------------------------------
    "[M+2H]2+"      = list(mass_multi = 1 / 2,
                           mass_add = 2 * 1.007276 / 2,
                           formula_add = "H2",
                           formula_sub = "C0",
                           charge = 2),
    "[M+H+NH4]2+"   = list(mass_multi = 1 / 2,
                           mass_add = (1.007276 + 18.03383) / 2,
                           formula_add = "NH5",
                           formula_sub = "C0",
                           charge = 2),
    "[M+H+K]2+"     = list(mass_multi = 1 / 2,
                           mass_add = (1.007276 + 38.96316) / 2,
                           formula_add = "HK",
                           formula_sub = "C0",
                           charge = 2),
    "[M+H+Na]2+"    = list(mass_multi = 1 / 2,
                           mass_add = (1.007276 + 22.98922) / 2,
                           formula_add = "HNa",
                           formula_sub = "C0",
                           charge = 2),
    "[M+C2H3N+2H]2+"= list(mass_multi = 1 / 2,
                           mass_add = (2 * 1.007276 + 41.02655) / 2,
                           formula_add = "C2H5N",
                           formula_sub = "C0",
                           charge = 2),
    "[M+2Na]2+"     = list(mass_multi = 1 / 2,
                           mass_add = 2 * 22.98922 / 2,
                           formula_add = "Na2",
                           formula_sub = "C0",
                           charge = 2),
    "[M+C4H6N2+2H]2+"= list(mass_multi = 1 / 2,
                            mass_add = (2 * 1.007276 + 2 * 41.02655) / 2,
                            formula_add = "C4H8N2",
                            formula_sub = "C0",
                            charge = 2),
    "[M+C6H9N3+2H]2+" = list(mass_multi = 1 / 2,
                             mass_add = (2 * 1.007276 + 3 * 41.02655) / 2,
                             formula_add = "C6H11N3",
                             formula_sub = "C0",
                             charge = 2),
    
    # single charged -----------------------------------------------------------
    "[M+H]+"        = list(mass_multi = 1,
                           mass_add =  1.007276,
                           formula_add = "H",
                           formula_sub = "C0",
                           charge = 1),
    "[M+Li]+"       = list(mass_multi = 1,
                           mass_add =  7.015456,
                           formula_add = "Li",
                           formula_sub = "C0",
                           charge = 1),
    "[M+2Li-H]+"    = list(mass_multi = 1,
                           mass_add =  2 * 1.007276 -  1.007276,
                           formula_add = "Li2",
                           formula_sub = "H",
                           charge = 1),
    "[M+NH4]+"      = list(mass_multi = 1,
                           mass_add = 18.03383,
                           formula_add = "NH4",
                           formula_sub = "C0",
                           charge = 1),
    "[M+H2O+H]+"   = list(mass_multi = 1,
                          mass_add = 19.01784,
                          formula_add = "H3O",
                          formula_sub = "C0",
                          charge = 1),
    "[M+Na]+"       = list(mass_multi = 1,
                           mass_add = 22.98922,
                           formula_add = "Na",
                           formula_sub = "C0",
                           charge = 1),
    "[M+CH4O+H]+"  = list(mass_multi = 1,
                          mass_add = 1.007276 + 32.02621,
                          formula_add = "Na",
                          formula_sub = "C0",
                          charge = 1),
    "[M+K]+"        = list(mass_multi = 1,
                           mass_add = 38.96316,
                           formula_add = "K",
                           formula_sub = "C0",
                           charge = 1),
    "[M+C2H3N+H]+"  = list(mass_multi = 1,
                           mass_add = 1.007276 + 41.02655,
                           formula_add = "C2H4N",
                           formula_sub = "C0",
                           charge = 1),
    "[M+2Na-H]+"    = list(masS_multi = 1,
                           mass_add = 2 * 22.98922 - 1.007276,
                           formula_add = "Na2",
                           formula_sub = "H",
                           charge = 1),
    "[M+C3H8O+H]+"  = list(mass_multi = 1,
                           mass_add = 1.007276 + 60.05751,
                           formula_add = "C3H9O",
                           formula_sub = "C0",
                           charge = 1),
    "[M+C2H3N+Na]+"   = list(mass_multi = 1,
                             mass_add = 22.98922 + 41.02655,
                             formula_add = "C2H3NNa",
                             formula_sub = "C0",
                             charge = 1),
    "[M+2K-H]+"     = list(mass_multi = 1,
                           mass_add = 2 * 38.96316 - 1.007276,
                           formula_add = "K2",
                           formula_sub = "H",
                           charge = 1),
    "[M+C2H6OS+H]+"   = list(mass_multi = 1,
                             masS_add = 1.007276 + 78.01394,
                             formula_add = "C2H7OS",
                             formula_sub = "C0",
                             charge = 1),
    "[M+C4H6N2+H]+"   = list(mass_multi = 1,
                             mass_add = 1.007276 + 2 * 41.02655,
                             formula_add = "C2H4N",
                             formula_sub = "C0",
                             charge = 1),
    
    # dimers -------------------------------------------------------------------
    "[2M+H]+"       = list(mass_multi = 2,
                           mass_add = 1.007276,
                           formula_add = "H",
                           formula_sub = "C0",
                           charge = 1),
    "[2M+NH4]+"     = list(mass_multi = 2,
                           mass_add = 18.03383,
                           formula_add = "NH4",
                           formula_sub = "C0",
                           charge = 1),
    "[2M+Na]+"      = list(mass_multi = 2,
                           mass_add = 22.98922,
                           formula_add = "Na",
                           formula_sub = "C0",
                           charge = 1),
    "[2M+K]+"       = list(mass_multi = 2,
                           mass_add = 38.96316,
                           formula_add = "K",
                           formula_sub = "C0",
                           charge = 1),
    "[2M+C2H3N+H]+"   = list(mass_multi = 2,
                             mass_add = 1.007276 + 41.02655,
                             formula_add = "C2H4N",
                             formula_sub = "C0",
                             charge = 1),
    "[2M+C2H3N+Na]+"  = list(mass_multi = 2,
                             mass_add = 22.98922 + 41.02655,
                             formula_add = "C2H3NNa",
                             formula_sub = "C0",
                             charge = 1)
  )
  
  ## return values
  adduct_list
  
}

.adductRulesNeg <- function() {
  
  ## create list with all the adduct definitoins
  adduct_list <- list(
    # triple charged -----------------------------------------------------------
    "[M-3H]3-"      = list(mass_multi = 1 / 3,
                           mass_add = - 3 * 1.007276 / 3,
                           formula_add = "C0",
                           formula_sub = "H3",
                           charge = -3),
    
    # double charged -----------------------------------------------------------
    "[M-2H]2-"      = list(mass_multi = 1 / 2,
                           mass_add = - 2 * 1.007276 / 2,
                           formula_add = "C0",
                           formula_sub = "H2",
                           charge = -2),
    
    # single charged -----------------------------------------------------------
    "[M-H]-"        = list(mass_multi = 1 ,
                           mass_add = - 1.007276,
                           formula_add = "C0",
                           formula_sub = "H",
                           charge = -1),
    "[M+Na-2H]-"    = list(mass_multi = 1,
                           mass_add = - 2 * 1.007276 + 22.98922,
                           formula_add = "Na",
                           formula_sub = "H2",
                           charge = -1),
    "[M+Cl]-"       = list(mass_multi = 1,
                           mass_add = 34.9694,
                           formula_add = "Cl",
                           formula_sub = "C0",
                           charge = -1),
    "[M+K-2H]-"     = list(mass_multi = 1,
                           mass_add = - 2 * 1.007276 + 38.96316,
                           formula_add = "K",
                           formula_sub = "H2",
                           charge = -1),
    "[M+C2H3N-H]-"  = list(mass_multi = 1,
                           mass_add = 41.02655 - 1.007276,
                           formula_add = "C2H3N",
                           formula_sub = "H",
                           charge = -1),
    "[M+CHO2]-"     = list(mass_multi = 1,
                           mass_add = 44.9982,
                           formula_add = "CHO2",
                           formula_sub = "C0",
                           charge = -1),
    "[M+C2H3O2]-"    = list(mass_multi = 1,
                            mass_add = 59.01385,
                            formula_add = "C2H3O2",
                            formula_sub = "C0",
                            charge = -1),
    "[M+Br]-"       = list(mass_multi = 1,
                           mass_add = 78.91889,
                           formula_add = "Br",
                           formula_sub = "C0",
                           charge = -1),
    "[M+C2F3O2]-"= list(mass_multi = 1,
                        mass_add = 112.9856,
                        formula_add = "C2F3O2",
                        formula_sub = "C0",
                        charge = -1),
    
    # dimers -------------------------------------------------------------------
    "[2M-H]-"       = list(mass_multi = 2,
                           mass_add =  - 1.007276,
                           formula_add = "C0",
                           formula_sub = "H",
                           charge = -1),
    "[2M+CHO2]-" = list(mass_multi = 2,
                        mass_add = 44.9982,
                        formula_add = "CHO2",
                        formula_sub = "C0",
                        charge = -1),
    "[2M+C2H3O2]-"= list(mass_multi = 2,
                         mass_add = 59.01385,
                         formula_add = "C2H3O2",
                         formula_sub = "C0",
                         charge = -1),
    
    # trimers ------------------------------------------------------------------
    "[3M-H]-"      = list(mass_multi = 3 ,
                          mass_add = - 1.007276,
                          formula_add = "C0",
                          formula_sub = "H",
                          charge = -1))
  
  ## return values
  adduct_list
  
}

