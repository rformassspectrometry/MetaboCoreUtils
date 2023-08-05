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
#' adduct <- "[M+Na]+"
#'
#' ## Calculate m/z of [M+Na]+ adduct from neutral mass
#' mass2mz(exact_mass, adduct)
#'
#' ## Calculate m/z of multiple adducts from neutral mass
#' mass2mz(exact_mass, adduct = adductNames())
#'
#' ## Provide a custom adduct definition.
#' adds <- data.frame(mass_add = c(1, 2, 3), mass_multi = c(1, 2, 0.5))
#' rownames(adds) <- c("a", "b", "c")
#' mass2mz(c(100, 200), adds)
mass2mz <- function(x, adduct = "[M+H]+") {
    arg <- .process_adduct_arg(adduct)
    res <- outer(x, arg$mass_multi) +
        rep(arg$mass_add, each = length(x))
    colnames(res) <- rownames(arg)
    res
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
#'
#' ## Provide a custom adduct definition.
#' adds <- data.frame(mass_add = c(1, 2, 3), mass_multi = c(1, 2, 0.5))
#' rownames(adds) <- c("a", "b", "c")
#' mz2mass(c(100, 200), adds)
mz2mass <- function(x, adduct = "[M+H]+") {
    arg <- .process_adduct_arg(adduct)
    res <- outer(x, arg$mass_add, "-") /
        rep(arg$mass_multi, each = length(x))
    colnames(res) <- rownames(arg)
    res
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
formula2mz <- function(formula, adduct = "[M+H]+", standardize = TRUE){
    if(standardize) {
        formula <- standardizeFormula(formula)
        names(formula) <- formula
    }
    masses <- calculateMass(formula)
    mass2mz(masses, adduct)
}

.process_adduct_arg <- function(adduct, columns = c("mass_add", "mass_multi")) {
    if (is.character(adduct)) {
        idx <- match(adduct, names(.ADDUCTS_ADD))
        if (any(is.na(idx)))
            stop("Unknown adduct: ", paste0(adduct[is.na(idx)], collapse = ";"))
        output <- .ADDUCTS[idx, columns]
    } else if (is.data.frame(adduct)) {
        if (!all(columns %in% colnames(adduct)))
            stop("columns ", paste(columns, collapse = ", "), " not found")
        output <- adduct[, columns]
    } else stop("'adduct' should be either a name of an adduct or a ",
                "data.frame with the adduct definition")
    output
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
adductFormula <- function(formulas, adduct = "[M+H]+", standardize = TRUE) {
    adduct <- .process_adduct_arg(adduct,
                                  c("mass_multi", "charge", "formula_add",
                                    "formula_sub", "positive"))
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


#' @title Retrieve names of supported adducts
#'
#' @description
#'
#' `adductNames` returns all supported adduct definitions that can be used by
#' [mass2mz()] and [mz2mass()].
#'
#' `adducts` returns a `data.frame` with the adduct definitions.
#'
#' @param polarity `character(1)` defining the ion mode, either `"positive"` or
#'     `"negative"`.
#'
#' @return for `adductNames`: `character` vector with all valid adduct names
#'     for the selected ion mode. For `adducts`: `data.frame` with the adduct
#'     definitions.
#'
#' @author Michael Witting, Johannes Rainer
#'
#' @export
#'
#' @examples
#'
#' ## retrieve names of adduct names in positive ion mode
#' adductNames(polarity = "positive")
#'
#' ## retrieve names of adduct names in negative ion mode
#' adductNames(polarity = "negative")
adductNames <- function(polarity = c("positive", "negative")) {
    polarity <- match.arg(polarity)
    rownames(.ADDUCTS)[.ADDUCTS$positive == (polarity == "positive")]
}

#' @rdname adductNames
#'
#' @export
adducts <- function(polarity = c("positive", "negative")) {
    polarity <- match.arg(polarity)
    .ADDUCTS[.ADDUCTS$positive == (polarity == "positive"), ]
}
