#' @title Get definitions for internal standards
#'
#' @description
#'
#' `internalStandards` returns a table with metabolite standards available
#' in commercial internal standard mixes. The returned data frame contains
#' the following columns:
#' - `"name"`: the name of the standard
#' - `"formula_salt"`: chemical formula of the salt that was used to produce
#'   the standard mix
#' - `"formula_metabolite"`: chemical formula of the metabolite in free form
#' - `"smiles_salt"`: SMILES of the salt that was used to produced the
#'   standard mix
#' - `"smiles_metabolite"`: SMILES of the metabolite in free form
#' - `"mol_weight_salt"`: molecular (average) weight of the salt (can be used
#'   for calculation of molar concentration, etc.)
#' - `"exact_mass_metabolite"`: exact mass of free metabolites
#' - `"conc"`: concentration of the metabolite in ug/mL (of salt form)
#' - `"mix"`: name of internal standard mix
#'
#' @param mix `character(1)` Name of the internal standard mix that shall be
#'    returned. One of [internalStandardMixNames()].
#'
#' @return `data.frame` data on internal standards
#'
#' @author Michael Witting
#'
#' @seealso [internalStandardMixNames()] for provided internal standard mixes.
#'
#' @importFrom utils read.table
#'
#' @export
#'
#' @examples
#'
#' internalStandards(mix = "QReSS")
#' internalStandards(mix = "UltimateSplashOne")
internalStandards <- function(mix = "QReSS") {
    if (!mix %in% internalStandardMixNames())
        stop("No standards with name '", mix, "' available. Please use one of",
             " the values returned by 'internalStandardMixNames()'.")
    read.table(system.file(paste0("internalStandards/", mix, ".txt"),
                           package = "MetaboCoreUtils"),
               sep = "\t",
               header = TRUE)
}

#' @title Get names of internal standard mixes provided by the package
#'
#' @description
#'
#' `internalStandardMixNames` returns available names of internal standard
#' mixes provided by the `MetaboCoreUtils` package.
#'
#' @return `character` names of available IS mixes
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' internalStandardMixNames()
internalStandardMixNames <- function() {
    gsub(".txt$", "",
         list.files(system.file("internalStandards/",
                                package = "MetaboCoreUtils"),
                    pattern = ".txt$"))
}
