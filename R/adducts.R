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
    outer(x, arg$mult) +
        rep(unname(arg$add), each = length(x))
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
    outer(x, arg$add, "-") /
        rep(unname(arg$mult), each = length(x))
}

.process_adduct_arg <- function(adduct) {
    if (is.character(adduct)) {
        idx <- match(adduct, names(.ADDUCTS_ADD))
        if (any(is.na(idx)))
            stop("Unknown adduct: ", paste0(adduct[is.na(idx)], collapse = ";"))
        list(add = .ADDUCTS_ADD[idx], mult = .ADDUCTS_MULT[idx])
    } else if (is.data.frame(adduct)) {
        if (!all(c("mass_add", "mass_multi") %in% colnames(adduct)))
            stop("columns \"mass_add\" and \"mass_multi\" not found")
        add <- adduct$mass_add
        names(add) <- rownames(adduct)
        mult <- adduct$mass_multi
        names(mult) <- rownames(adduct)
        list(add = add, mult = mult)
    } else stop("'adduct' should be either a name of an adduct or a ",
                "data.frame with the adduct definition")
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
