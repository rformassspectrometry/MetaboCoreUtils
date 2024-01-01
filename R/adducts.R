#' @title Calculate mass-to-charge ratio
#'
#' @description
#'
#' `mass2mz` calculates the m/z value from a neutral mass and an adduct
#' definition.
#'
#' Custom adduct definitions can be passed to the `adduct` parameter in form of
#' a `data.frame`. This `data.frame` is expected to have columns `"mass_add"`
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
#' @return numeric `matrix` with same number of rows than elements in `x` and
#'     number of columns being equal to the length of `adduct` (adduct names
#'     are used as column names). Each column thus represents the m/z of `x`
#'     for each defined `adduct`.
#'
#' @author Michael Witting, Johannes Rainer
#'
#' @seealso [mz2mass()] for the reverse calculation, [adductNames()] for
#'     supported adduct definitions.
#'
#' @export
#'
#' @examples
#'
#' exact_mass <- c(100, 200, 250)
#' adduct <- "[M+H]+"
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
#' mass2mz(c(100, 200), adds)
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

    # return the result
    return(res)
}

mass2mz_df <- function(mass, adduct = "M+H") {
    data(adduct_definition)

    # create a dataframe with the mass and adduct columns
    mass_adduct = data.frame(mass=mass, adduct=adduct)

    # left join the mass_adduct dataframe with the adduct_definition dataframe
    mass_adduct_adduct_definition = left_join(mass_adduct, adduct_definition, by = c("adduct" = "name"))
    
    mass_adduct_adduct_definition$adduct_mass = (mass_adduct_adduct_definition$mass + mass_adduct_adduct_definition$mass_add) / mass_adduct_adduct_definition$mass_multi

    # select only the mass, adduct, and adduct_mass columns
    mass_adduct_adduct_definition = mass_adduct_adduct_definition %>% select(mass, adduct, adduct_mass)

    return(mass_adduct_adduct_definition)
}

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


#' @title Calculate a table of adduct (ionic) formulas
#'
#' @description
#'
#' `adductFormula` calculates the chemical formulas for the specified adducts
#' of provided chemical formulas.
#'
#' @param formulas `character` with molecular formulas for which adduct
#'     formulas should be calculated.
#'
#' @param adduct `character` or `data.frame` of valid adduct. to be used.
#'   Custom adduct definitions can be provided via a `data.frame` but its format
#'   must follow [adducts()]
#'
#' @param standardize `logical(1)` whether to standardize the molecular formulas
#'   to the Hill notation system before calculating their mass.
#'
#' @return `character` matrix with *formula* rows and *adducts* columns
#'   containing all ion formulas. In case an ion can't be generated (eg.
#'   \[M-NH3+H\]+ in a molecule that doesn't have nitrogen), a NA is returned
#'   instead.
#'
#' @seealso [adductNames()] for a list of all available predefined adducts and
#'   [adducts()] for the adduct `data.frame` definition style.
#'
#' @author Roger Gine
#'
#' @examples
#'
#' # Calculate the ion formulas of glucose with adducts [M+H]+, [M+Na]+ and [M+K]+
#' adductFormula("C6H12O6", c("[M+H]+", "[M+Na]+", "[M+K]+"))
#'
#' # > "[C6H13O6]+" "[C6H12O6Na]+" "[C6H12O6K]+"
#'
#' # Use a custom set of adduct definitions (For instance, a iron (Fe2+) adduct)
#' custom_ads <- data.frame(name = "[M+Fe]2+", mass_multi = 0.5, charge = 2,
#'                          formula_add = "Fe", formula_sub = "C0",
#'                          positive = "TRUE")
#' adductFormula("C6H12O6", custom_ads)
#'
#' @export
adductFormula <- function(formulas, adduct = "M+H", standardize = TRUE) {
    data(adduct_definition)
    
    adduct = adduct_definition %>% filter(name %in% adduct)

    if (standardize) {
        formulas <- lapply(formulas, standardizeFormula)
        if (all(formulas == "")) stop("No valid formulas")
        formulas <- formulas[!is.na(formulas)]
    }
    ionMatrix <- lapply(formulas, function(formula, adduct) {
        formulaAdduct <- apply(adduct, 1, function(x) {
            current_f <- formula

            multiplicity <- round(as.numeric(x["mass_multi"]) *
                                      as.numeric(x["charge"]))
            if (multiplicity != 1) {
                current_f <- multiplyElements(current_f, multiplicity)
            }
            if (x[["formula_add"]] != "C0"){
                current_f <- addElements(current_f, x[["formula_add"]])
            }
            if (x[["formula_sub"]] != "C0"){
                current_f <- subtractElements(current_f,  x[["formula_sub"]])
            }
            if (is.na(current_f)) return(NA)

            #Create a [FORMULA] CHARGE (+/-) format output
            sign <- ifelse(x[["positive"]] == "TRUE", "+", "-")
            charge <- x[["charge"]]
            current_f <- paste0(
                "[", current_f, "]",
                ifelse(abs(as.numeric(charge)) == 1,
                       sign,
                       ifelse(as.numeric(charge) > 0,
                              paste0(charge, sign),
                              c(strsplit(charge, "-")[[1]][2], sign))
                )
            )
            return(current_f)
        })
        names(formulaAdduct) <- adduct$name
        return(formulaAdduct)
    }, adduct = adduct)
    ionMatrix <- do.call(rbind, ionMatrix)
    rownames(ionMatrix) <- formulas
    colnames(ionMatrix) <- rownames(adduct)
    return(ionMatrix)
}
