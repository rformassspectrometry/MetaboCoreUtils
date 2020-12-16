#' @title Calculate mass-to-charge ratio
#'
#' @description
#'
#' `mass2mz` calculates the m/z value from a neutral mass and an adduct
#' definition.
#'
#' @param x `numeric` neutral mass for which the adduct m/z shall be calculated.
#'
#' @param adduct `character` specifying the name(s) of the adduct(s) for which
#'     the m/z should be calculated; supported values are returned by
#'     [adductNames()]
#'
#' @return numeric `matrix` with same number of rows than elements in `x` and
#'     number of columns being equal to the length of `adduct`. Each column
#'     thus represents the m/z of `x` for each defined `adduct`.
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
mass2mz <- function(x, adduct = "[M+H]+") {
    idx <- match(adduct, names(.ADDUCTS_ADD))
    if (any(is.na(idx)))
        stop("Unknown adduct: ", paste0(adduct[is.na(idx)], collapse = ";"))
    outer(x, .ADDUCTS_MULT[idx]) +
        rep(unname(.ADDUCTS_ADD[idx]), each = length(x))
}

#' @title Calculate neutral mass
#'
#' @description
#'
#' `mz2mass` calculates the neutral mass from a given m/z value and adduct
#' definition.
#'
#' @param x `numeric` m/z value for which the neutral mass shall be calculated.
#'
#' @inheritParams mass2mz
#'
#' @return numeric `matrix` with same number of rows than elements in `x` and
#'     number of columns being equal to the length of `adduct`. Each column
#'     thus represents the neutral mass of `x` for each defined `adduct`.
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
mz2mass <- function(x, adduct = "[M+H]+") {
    idx <- match(adduct, names(.ADDUCTS_ADD))
    if (any(is.na(idx)))
        stop("Unknown adduct: ", paste0(adduct[is.na(idx)], collapse = ";"))
    outer(x, .ADDUCTS_ADD[idx], "-") /
        rep(unname(.ADDUCTS_MULT[idx]), each = length(x))
}

#' @title Retrieve names of supported adducts
#'
#' @description
#'
#' `adductNames` returns all supported adduct definitions that can be used by
#' [mass2mz()] and [mz2mass()].
#'
#' @param polarity `character(1)` defining the ion mode, either `"positive"` or
#'     `"negative"`.
#'
#' @return `character` vector with all valid adduct names for the selected ion
#'     mode.
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
#' adductNames(polarity = "negative")
adductNames <- function(polarity = c("positive", "negative")) {
    polarity <- match.arg(polarity)
    rownames(.ADDUCTS)[.ADDUCTS$positive == (polarity == "positive")]
}
