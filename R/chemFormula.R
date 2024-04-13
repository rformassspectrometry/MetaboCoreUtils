#' @title Count elements in a chemical formula
#'
#' @description
#'
#' `countElements` parses strings representing a chemical formula into a named
#' vector of element counts.
#'
#' @param x `character()` representing a chemical formula.
#'
#' @return `list` of `integer` with the element counts (names being elements).
#'
#' @author Michael Witting and Sebastian Gibb
#'
#' @importFrom stats setNames
#'
#' @export
#'
#' @seealso [pasteElements()]
#'
#' @examples
#' countElements(c("C6H12O6", "C11H12N2O2"))
countElements <- function(x) {
    ## regex pattern to isolate all elements
    element_pattern <- paste0(
        "(?<Element>",
            paste0("[0-9]*",
                c(
                    "A[cglmrstu]|",
                    "B[aehikr]?|",
                    "C[adeflmnorsu]?|",
                    "D[bsy]|",
                    "E[rsu]|",
                    "F[elmr]?|",
                    "G[ade]|",
                    "H[efgos]?|",
                    "I[nr]?|",
                    "Kr?|",
                    "L[airuv]|",
                    "M[cdgnot]|",
                    "N[abdehiop]?|",
                    "O[gs]?|",
                    "P[abdmortu]?|",
                    "R[abefghnu]|",
                    "S[bcegimnr]?|",
                    "T[abcehilms]|",
                    "U|V|W|Xe|Yb?|Z[nr]"
                ),
                collapse = ""
            ),
        ")",
        "(?<Number>[0-9]*)"
    )

    rx <- gregexpr(pattern = element_pattern, text = x, perl = TRUE)

    mapply(function(xx, rr) {
        n <- length(rr)

        if (is.na(xx))
            return(NA_integer_)
        if (sum(attr(rr, "match.length")) != nchar(gsub("\\[|\\]", "", xx))) {
            warning("The given formula '", xx, "' contains invalid symbols.")
            return(NA_integer_)
        }

        start <- attr(rr, "capture.start")
        end <- start + attr(rr, "capture.length") - 1L
        sbstr <- substring(xx, start, end)
        ## set elements without a number in the formula to one
        sbstr[!nchar(sbstr)] <- 1L
        sl <- seq_len(n)
        nm <- sbstr[sl]
        r <- setNames(as.integer(sbstr[n + sl]), nm)
        valid <- .isValidElementName(nm)

        if (any(!valid)) {
            warning(
                "The following names are not valid and are dropped: ",
                paste0(names(r)[!valid], collapse = ", ")
            )
            r <- r[valid]
        }
        r
    }, xx = x, rr = rx, SIMPLIFY = FALSE, USE.NAMES = TRUE)
}

#' Validate element names/heavy isotopes
#'
#' @param x `character`, element/heavy isotope names
#' @return `logical`, `TRUE` for valid name, `FALSE` otherwise
#'
#' @noRd
.isValidElementName <- function(x) {
    x %in% names(.ISOTOPES)
}

#' @title Create chemical formula from a named vector
#'
#' @description
#'
#' `pasteElements` creates a chemical formula from element counts (such as
#' returned by [countElements()]).
#'
#' @param x `list`/`integer` with element counts, names being individual elements.
#'
#' @return `character()` with the chemical formulas.
#'
#' @author Michael Witting and Sebastian Gibb
#'
#' @export
#'
#' @seealso [countElements()]
#'
#' @examples
#'
#' elements <- c("C" = 6, "H" = 12, "O" = 6)
#' pasteElements(elements)
pasteElements <- function(x) {
    if (!is.list(x))
        x <- list(x)
    unlist(lapply(x, .pasteElements))
}
.pasteElements <- function(x) {
    if (anyNA(x))
        return(NA_character_)
    if (!is.character(names(x)))
        stop("element names missing")
    enms <- .sort_elements(names(x))
    y <- as.character(x[enms])
    y[y == "1"] <- ""
    y <- paste0(enms, y)
    ## brackets for heavy isotopes
    y <- gsub("^([0-9]+[A-z]+[0-9]*)", "[\\1]", y)
    paste0(y, collapse = "")
}

#' Sort elements starting with organic elements, according to the Hill notation
#' system.
#'
#' @param x `character`, element names
#' @return sorted `character`, start with C, H, N, O, S, P and all the other
#' elements in alphabetical order
#' @noRd
#' @examples
#' .sort_elements(c("H", "O", "S", "P", "C", "N", "Na", "Fe"))
.sort_elements <- function(x) {
    x[match(names(.ISOTOPES), x, nomatch = 0L)]
}

#' @title Standardize a chemical formula
#'
#' @description
#'
#' `standardizeFormula` standardizes a supplied chemical formula according
#' to the Hill notation system.
#'
#' @param x `character`, strings with the chemical formula to standardize.
#'
#' @return `character` strings with the standardized chemical formula.
#'
#' @author Michael Witting and Sebastian Gibb
#'
#' @export
#'
#' @seealso [pasteElements()] [countElements()]
#' @examples
#'
#' standardizeFormula("C6O6H12")
standardizeFormula <- function(x) {
    unlist(lapply(countElements(x), pasteElements))
}

#' sum elements
#'
#' @param x `character`, element names
#' @return named `integer`, names are element names and values the corresponding
#' number of atoms.
#' @noRd
#' @examples
#' .sum_elements(c(H = 6, C = 3, O = 6, C = 3, H = 6))
.sum_elements <- function(x) {
    if (anyNA(x))
        return(NA_integer_)
    if (!is.character(names(x)))
        stop("element names missing")
    unlist(lapply(split(x, names(x)), sum))
}

#' @title Check if one formula is contained in another
#'
#' @description
#'
#' `containsElements` checks if one sum formula is contained in another.
#'
#' @param x `character` strings with a chemical formula
#'
#' @param y `character` strings with a chemical formula that shall be
#'     contained in `x`
#'
#' @return `logical` TRUE if `y` is contained in `x`
#'
#' @author Michael Witting and Sebastian Gibb
#'
#' @export
#'
#' @examples
#'
#' containsElements("C6H12O6", "H2O")
#' containsElements("C6H12O6", "NH3")
containsElements <- function(x, y) {
    mapply(
        FUN = function(xx, yy)all(.sum_elements(c(xx, -yy)) >= 0),
        xx = countElements(x), yy = countElements(y),
        SIMPLIFY = TRUE, USE.NAMES = FALSE
    )
}

#' @title subtract two chemical formula
#'
#' @description
#'
#' `subtractElements` subtracts one chemical formula from another.
#'
#' @param x `character` strings with chemical formula
#' @param y `character` strings with chemical formula that
#'     should be subtracted from `x`
#'
#' @return `character` Resulting formula
#'
#' @author Michael Witting and Sebastian Gibb
#'
#' @export
#'
#' @examples
#'
#' subtractElements("C6H12O6", "H2O")
#'
#' subtractElements("C6H12O6", "NH3")
subtractElements <- function(x, y) {
    unlist(mapply(
        FUN = function(xx, yy) {
            s <- .sum_elements(c(xx, -yy))

            if (isTRUE(all(s >= 0)))
                .pasteElements(s[s > 0])
            else
                NA_character_
        },
        xx = countElements(x), yy = countElements(y),
        SIMPLIFY = FALSE, USE.NAMES = FALSE
    ))
}

#' @title Combine chemical formulae
#'
#' @description
#'
#' `addElements` Add one chemical formula to another.
#'
#' @param x `character` strings with chemical formula
#' @param y `character` strings with chemical formula that
#'     should be added from `x`
#'
#' @return `character` Resulting formula
#'
#' @author Michael Witting and Sebastian Gibb
#'
#' @export
#'
#' @examples
#'
#' addElements("C6H12O6", "Na")
#'
#' addElements("C6H12O6", c("Na", "H2O"))
addElements <- function(x, y) {
    unlist(mapply(
        FUN = function(xx, yy).pasteElements(.sum_elements(c(xx, yy))),
        xx = countElements(x), yy = countElements(y),
        SIMPLIFY = FALSE, USE.NAMES = FALSE
    ))
}

#' @title Multiply chemical formulas by a scalar
#'
#' @description
#'
#' `multiplyElements` Multiply the number of atoms of each element by a
#' constant, positive, integer
#'
#' @author Roger Gine
#'
#' @inheritParams addElements
#'
#' @param k `numeric(1)` positive integer by which each formula will be
#'   multiplied.
#'
#' @return `character` strings with the standardized chemical formula.
#'
#' @export
#'
#' @examples
#'
#' multiplyElements("H2O", 3)
#'
#' multiplyElements(c("C6H12O6", "Na", "CH4O"), 2)
#'
multiplyElements <- function(x, k) {
    if (length(k) != 1) stop("k must have length one (1)")
    if (!is.numeric(k) | k <= 0) stop("k must be a positive integer")
    vapply(countElements(x), function(xx){.pasteElements(xx * k)},
           FUN.VALUE = character(1),
           USE.NAMES = FALSE)
}

#' @title Calculate exact mass
#'
#' @description
#'
#' `calculateMass` calculates the exact mass from a formula. Isotopes are also
#' supported. For isotopes, the isotope type needs to be specified as an
#' element's prefix, e.g. `"[13C]"` for carbon 13 or `"[2H]"` for deuterium.
#' A formula with 2 carbon 13 isotopes and 3 carbons would thus contain e.g.
#' `"[13C2]C3"`.
#'
#' @param x `character` representing chemical formula(s) or a `list ` of
#'     `numeric` with element counts such as returned by [countElements()].
#'     Isotopes and deuterated elements are supported (see examples below).
#'
#' @return `numeric` Resulting exact mass.
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' calculateMass("C6H12O6")
#' calculateMass("NH3")
#' calculateMass(c("C6H12O6", "NH3"))
#'
#' ## Calculate masses for formulas containing isotope information.
#' calculateMass(c("C6H12O6", "[13C3]C3H12O6"))
#'
#' ## Calculate mass for a chemical with 5 deuterium.
#' calculateMass("C11[2H5]H7N2O2")
calculateMass <- function(x) {
    if (is.character(x))
        x <- countElements(x)
    if (!is.list(x))
        stop("x must be either a character or a list with element counts.")
    vapply(x, function(z) {
        isotopes <- names(z)
        if (!length(z) ||
            is.null(isotopes) ||
            !all(isotopes %in% names(.ISOTOPES))) {
            message("not for all isotopes a mass is found")
            return(NA_real_)
        }
        sum(z * .ISOTOPES[isotopes])
        ## mass <- 0.0
        ## for (atom in elements) {
        ##     atom_mass <- .MONOISOTOPES[atom]
        ##     if(!is.na(atom_mass))
        ##         mass <- mass + atom_mass * z[atom]
        ## }
        ## unname(mass)
    }, numeric(1))
}
