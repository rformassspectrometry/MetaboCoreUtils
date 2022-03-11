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
                    "[A][cglmrstu]|",
                    "[B][aehikr]?|",
                    "[C][adeflmnorsu]?|",
                    "[D][bsy]|",
                    "[E][rsu]|",
                    "[F][elmr]?|",
                    "[G][ade]|",
                    "[H][efgos]?|",
                    "[I][nr]?|",
                    "[K][r]?|",
                    "[L][airuv]|",
                    "[M][cdgnot]|",
                    "[N][abdehiop]?|",
                    "[O][gs]?|",
                    "[P][abdmortu]?|",
                    "[R][abefghnu]|",
                    "[S][bcegimnr]?|",
                    "[T][abcehilms]|",
                    "[U]|[V]|[W]|[X][e]|[Y][b]?|[Z][nr]"
                ),
                collapse = ""
            ),
        ")",
        "(?<Number>[0-9]*)"
    )
    rx <- gregexpr(pattern = element_pattern, text = x, perl = TRUE)

    mapply(function(xx, rr) {
        n <- length(rr)
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
    if (!is.character(names(x)))
        stop("element names missing")
    enms <- .sort_elements(names(x))
    y <- as.character(x[enms])
    y[y == "1"] <- ""
    paste0(enms, y, collapse = "")
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
    org <- c("C", "H", "N", "O", "S", "P")
    y <- c(org, sort(x[!x %in% org]))
    x[match(y, x, nomatch = 0L)]
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
            if (any(s < 0))
                NA_character_
            else
                .pasteElements(s)
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

#' @title Calculate exact mass
#'
#' @description
#'
#' `calculateMass` calculates the exact mass from a formula.
#'
#' @param x `character` representing chemical formula(s) or a `list ` of
#'     `numeric` with element counts such as returned by [countElements()].
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
calculateMass <- function(x) {
    if (is.character(x))
        x <- countElements(x)
    if (!is.list(x))
        stop("x must be either a character or a list with element counts.")
    vapply(x, function(z) {
        elements <- names(z)
        if (!all(elements %in% names(.MONOISOTOPES))) {
            message("not for all elements a monoisotopic mass is found")
            return(NA_real_)
        }
        sum(z * .MONOISOTOPES[elements])
        ## mass <- 0.0
        ## for (atom in elements) {
        ##     atom_mass <- .MONOISOTOPES[atom]
        ##     if(!is.na(atom_mass))
        ##         mass <- mass + atom_mass * z[atom]
        ## }
        ## unname(mass)
    }, numeric(1))
}
