#' @title Calculate mass-to-charge ratio
#'
#' @description
#'
#' `mass2mz` calculates the m/z value from a neutral mass and an adduct
#' definition.
#'
#' Custom adduct definitions can be passed to the `custom_adduct` parameter in form of
#' a `data.frame`. This `data.frame` is expected to have columns `"name"`, `"mass_add"`
#' and `"mass_multi"` defining the *additive* and *multiplicative* part of the
#' calculation. See [adducts()] for examples.
#'
#' @param x `numeric` neutral mass for which the adduct m/z shall be calculated.
#'
#' @param adduct either a `character` specifying the name(s) of the adduct(s)
#'     for which the m/z should be calculated or a `data.frame` with the adduct
#'     definition. See [adductNames()] for supported adduct names and the
#'     description for more information on the expected format if a `data.frame`
#'     is provided.
#'
#' @return data frame with same number of rows than elements in `x` and
#'     number of columns being equal to the length of `adduct` (adduct names
#'     are used as column names). Each column thus represents the m/z of `x`
#'     for each defined `adduct`.
#'
#' @author James Zhan, Michael Witting, Johannes Rainer
#'
#' @seealso [mz2mass()] for the reverse calculation
#'
#' @export
#'
#' @examples
#'
#' exact_mass <- c(100, 200, 250)
#' adduct <- "M+H"
#'
#' ## Calculate m/z of [M+H]+ adduct from neutral mass
#' mass2mz(exact_mass, adduct)
#'
#' exact_mass <- 100
#' adduct <- "M+Na"
#'
#' ## Calculate m/z of M+Na adduct from neutral mass
#' mass2mz(exact_mass, adduct)
#'
#' ## Calculate m/z of multiple adducts from neutral mass
#' mass2mz(exact_mass, adduct = adductNames())
#'
#' ## Provide a custom adduct definition.
#' custom_adduct <- data.frame(name = c("a", "b", "c"), mass_add = c(1, 2, 3), mass_multi = c(1, 2, 0.5))
#' mass2mz(c(100, 200), custom_adduct=custom_adduct)
mass2mz <- function(x, adduct = "M+H", custom_adduct = NULL) {

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
    res <- outer(x, adduct_definition$mass_multi) +
        rep(adduct_definition$mass_add, each = length(x))

    # give the columns the name of the adduct
    colnames(res) <- adduct_definition$name

    # add the mass column
    res = cbind(mass = x, res) 

    res = as.data.frame(res) 

    res = res %>%
        select(mass, everything())

    # return the result
    return(res)
}
