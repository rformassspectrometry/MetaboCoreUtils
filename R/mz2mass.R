#' @title Calculate neutral mass
#'
#' @description
#'
#' `mz2mass` calculates the neutral mass from a given m/z value and adduct
#' definition.
#'
#' Custom adduct definitions can be passed to the `adduct` parameter in form of
#' a `data.frame`. This `data.frame` is expected to have columns `"mass_add"`
#' and `"mass_multi"` defining the *additive* and *multiplicative* part of the
#' calculation. See [adducts()] for examples.
#'
#' @param x `numeric` m/z value for which the neutral mass shall be calculated.
#'
#' @inheritParams mass2mz
#'
#' @return numeric `matrix` with same number of rows than elements in `x` and
#'     number of columns being equal to the length of `adduct` (adduct names
#'     are used as column names. Each column thus represents the neutral mass
#'     of `x` for each defined `adduct`.
#'
#' @author Michael Witting, Johannes Rainer
#'
#' @seealso [mass2mz()] for the reverse calculation, [adductNames()] for
#'     supported adduct definitions.
#'
#' @export
#'
#' @examples
#'
#' ion_mass <- c(100, 200, 300)
#' adduct <- "M+H"
#'
#' ## Calculate m/z of [M+H]+ adduct from neutral mass
#' mz2mass(ion_mass, adduct)
#'
#' ion_mass <- 100
#' adduct <- "M+Na"
#'
#' ## Calculate m/z of [M+Na]+ adduct from neutral mass
#' mz2mass(ion_mass, adduct)
#'

mz2mass <- function(x, adduct = "M+H") {
    # if the user provides a custom adduct, use that
    if (!is.null(custom_adduct)) {
        adduct_definition = custom_adduct
    } 
    # otherwise, use the adduct definition in the package
    else {
        data(adduct_definition)
        adduct_definition = adduct_definition %>% filter(name %in% adduct)
    }

    # calculate the adduct mass in a wide format
    res <- outer(x, adduct_definition$mass_add, "-") /
        rep(adduct_definition$mass_multi, each = length(x))

    colnames(res) <- adduct_definition$name

    return(res)
}
