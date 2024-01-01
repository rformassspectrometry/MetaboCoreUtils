#' @title Calculate mass-to-charge ratio from a formula
#'
#' @description
#'
#' `formula2mz` calculates the m/z values from a list of molecular formulas and
#' adduct definitions.
#'
#' Custom adduct definitions can be passed to the `adduct` parameter in form of
#' a `data.frame`. This `data.frame` is expected to have columns `"mass_add"`
#' and `"mass_multi"` defining the *additive* and *multiplicative* part of the
#' calculation. See [adducts()] for examples.
#'
#' @inheritParams mass2mz
#'
#' @param formula `character` with one or more valid molecular formulas for
#' which their adduct m/z shall be calculated.
#'
#' @param standardize `logical` whether to standardize the molecular formulas
#' to the Hill notation system before calculating their mass.
#'
#' @return Numeric `matrix` with same number of rows than elements in `formula`
#'   and number of columns being equal to the length of `adduct` (adduct names
#'   are used as column names). Each column thus represents the m/z of `formula`
#'   for each defined `adduct`.
#'
#' @author Roger Gine
#'
#' @export
#'
#' @examples
#' ## Calculate m/z values of adducts of a list of formulas
#' formulas <- c("C6H12O6", "C9H11NO3", "C16H13ClN2O")
#' ads <- c("[M+H]+", "[M+Na]+", "[2M+H]+", "[M]+")
#' formula2mz(formulas, ads)
#' formula2mz(formulas, adductNames()) #All available adducts
#'
#' ## Use custom-defined adducts as input
#' custom_ads <- data.frame(mass_add = c(1, 2, 3), mass_multi = c(1, 2, 0.5))
#' formula2mz(formulas, custom_ads)
#'
#' ## Use standardize = FALSE to keep formula unaltered
#' formula2mz("H12C6O6")
#' formula2mz("H12C6O6", standardize = FALSE)
formula2mz <- function(formula, adduct = "M+H", standardize = TRUE){
    if(standardize) {
        formula <- standardizeFormula(formula)
        names(formula) <- formula
    }
    masses <- calculateMass(formula)
    mass2mz(masses, adduct)
}
