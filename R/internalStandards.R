#' @title Get internal standards
#'
#' @description
#'
#' `internalStandards` returns a table with metabolite standards available 
#'     in commercial internal standard mixes. The returned data frame contains
#'     the following columns.
#'     - `"name"` name of the standard
#'     -  `"formula_salt"` chemical formula of the salt that was used to produce
#'     the standard mix
#'     - `"formula_metabolite"` chemical formula of the metabolite in free form
#'     - `"smiles_salt"` SMILES of the salt that was used to produced the 
#'     standard mix
#'     - `"smiles_metabolite"` SMILES of the metabolite in free form
#'     - `"mol_weight_salt"` molecular (average) weight of the salt (can be used
#'      for calculation of molar concentration, etc.)
#'      - `"exact_mass_metabolite"` exact mass of free metabolites
#'      - `"conc"` concentration of the metabolite in µg/mL (of salt form)
#'      - `"mix"` name of internal standard mix
#'
#' @param mix `character` Name of the internal standard mix that shall be returned
#'
#' @return `data.frame` data on internal standards
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' internalStandards(mix = "QReSS")
#' internalStandards(mix = "UltimateSplashOne")
internalStandards <- function(mix = "QReSS") {
  
  read.table(system.file(paste0("internalStandards/", mix, ".txt"),
                         package = "MetaboCoreUtils"),
             sep = "\t",
             header = TRUE,
             stringsAsFactors = FALSE)

  
}

#' @title Get names of internal standard mixes supported
#'
#' @description
#'
#' `mixNames` returns a table with metabolite standards available 
#'     in commercial internal standard mixes
#'
#' @return `character` names of available IS mixes
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' mixNames()
internalStandardMixNames <- function() {
  
  gsub(".txt", "",
       list.files(system.file("internalStandards/",
                              package = "MetaboCoreUtils"),
                  pattern = ".txt"))

  
}