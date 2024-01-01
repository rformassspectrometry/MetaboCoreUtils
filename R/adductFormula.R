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
