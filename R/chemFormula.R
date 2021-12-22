#' @title Count elements in a chemical formula
#'
#' @description
#'
#' `countElements` parses a string representing a chemical formula into a named
#' vector of element counts.
#'
#' @param x `character(1)` representing a chemical formula.
#'
#' @return `integer` with the element counts (names being elements).
#'
#' @author Michael Witting
#'
#' @importFrom stringr str_extract_all str_extract
#'
#' @export
#'
#' @seealso [pasteElements()]
#'
#' @examples
#'
#' countElements("C6H12O6")
#' countElements("C11H12N2O2")
countElements <- function(x) {
    x <- x[!is.na(x)]
    lx <- length(x)
    if (!lx)
        return(integer())
    if (lx > 1) {
        warning("'countElements' supports only a single character string as ",
                "input. Returning result for 'x[1]'.")
        x <- x[1L]
    }
    ## regex pattern to isolate all elements
    element_pattern <- "([A][cglmrstu]|[B][aehikr]?|[C][adeflmnorsu]?|[D][bsy]|[E][rsu]|[F][elmr]?|[G][ade]|[H][efgos]?|[I][nr]?|[K][r]?|[L][airuv]|[M][cdgnot]|[N][abdehiop]?|[O][gs]?|[P][abdmortu]?|[R][abefghnu]|[S][bcegimnr]?|[T][abcehilms]|[U]|[V]|[W]|[X][e]|[Y][b]?|[Z][nr])([0-9]*)"
    ## extract all matching pattern
    regexMatch <- str_extract_all(x, element_pattern)
    ## get individual elements and their count
    elements <- str_extract(regexMatch[[1]], "[aA-zZ]+")
    numbers <- as.numeric(str_extract(regexMatch[[1]], "[0-9]+"))
    ## replace NAs with 1 for elements which have a count of one
    numbers[is.na(numbers)] <- 1
    ## create named vector for return
    formula_list <- numbers
    names(formula_list) <- elements
    ## remove atoms that might have a count of 0
    formula_list <- formula_list[which(formula_list >= 0)]
    formula_list
}

#' @title Create chemical formula from a named vector
#'
#' @description
#'
#' `pasteElements` creates a chemical formula from element counts (such as
#' returned by [countElements()]).
#'
#' @param x `integer` with element counts, names being individual elements.
#'
#' @return `character(1)` with the chemical formula.
#'
#' @author Michael Witting
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
    if (is.null(names(x))) stop("'x' should be a named vector")
    ## create empty string to append parts of chem_formula
    chem_formula <- ""
    ## first C H N O S P, then elements by alphabetical order
    for (atom in c("C", "H", "N", "O", "S", "P")) {
        if (atom %in% names(x) && x[[atom]] > 0) {
            if (x[[atom]] == 1) {
                chem_formula <- paste0(chem_formula, atom)
            } else {
                chem_formula <- paste0(chem_formula, atom, x[atom])
            }
        }
    }
    ## get all remaining elements
    restElements <- names(x)
    restElements <- restElements[
        !restElements %in% c("C", "H", "N", "O", "S", "P")]
    ## iterate through all remaining elements in alphabetical order
    for (atom in sort(restElements)) {
        if (x[[atom]] > 0) {
            if (x[[atom]] == 1) {
                chem_formula <- paste0(chem_formula, atom)
            } else {
                chem_formula <- paste0(chem_formula, atom, x[atom])
            }
        }
    }
    chem_formula
}

#' @title Standardize a chemical formula
#'
#' @description
#'
#' `standardizeFormula` standardizes a supplied chemical chem_formula according
#' to the Hill notation system.
#'
#' @param x `character` Single string with the chemical formula to standardize.
#'
#' @return `character` Single string with the standardized chemical formula.
#'
#' @author Michael Witting
#'
#' @importFrom stringr str_extract_all str_extract
#'
#' @export
#'
#' @seealso [pasteElements()] [countElements()]
#' @examples
#'
#' standardizeFormula("C6O6H12")
standardizeFormula <- function(x) {
    formula_list <- countElements(x)
    pasteElements(formula_list)
}

#' @title Check if one formula is contained in another
#'
#' @description
#'
#' `containsElements` checks if one sum formula is contained in another.
#'
#' @param x `character` Single string with a chemical formula
#'
#' @param y `character` Single string with a chemical formula that shall be
#'     contained in `x`
#'
#' @return `logical` TRUE if `y` is contained in `x`
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' containsElements("C6H12O6", "H2O")
#' containsElements("C6H12O6", "NH3")
containsElements <- function(x, y) {
    ## parse both formmula
    x <- countElements(x)
    y <- countElements(y)
    formula_concat <- c(x, y * -1)
    ## subtract formula from each other
    result <- tapply(formula_concat, names(formula_concat), sum)
    all(result >= 0)
}

#' @title subtract two chemical formula
#'
#' @description
#'
#' `subtractElements` subtracts one chemical formula from another.
#'
#' @param x `character` Single string with chemical formula
#' @param y `character`  Single or multiple strings with chemical formula that
#'     should be subtracted from `x`
#'
#' @return `character` Resulting formula
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' subtractElements("C6H12O6", "H2O")
#'
#' subtractElements("C6H12O6", "NH3")
subtractElements <- function(x, y) {
    if (length(y) > 1)
        y <- addElements(y)
    ## sanity checks for formulas
    if (!containsElements(x, y))
        return(NA_character_)
    ## parse both formmula
    x <- countElements(x)
    y <- countElements(y)
    formula_concat <- c(x, y * -1)
    ## subtract formula from each other
    result <- tapply(formula_concat, names(formula_concat), sum)
    pasteElements(result)
}

#' @title Combine chemical formulae
#'
#' @description
#'
#' `addElements` Add one chemical formula to another.
#'
#' @param x `character` Vector with 1 or more chemical formulae to be added
#'
#' @param y `character` Vector with 1 or more chemical formulae to be added
#'
#' @return `character` Resulting formula
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' addElements("C6H12O6", "Na")
#'
#' addElements("C6H12O6", c("Na", "H2O"))
addElements <- function(x, y = NA_character_) {
    x <- unlist(lapply(c(x, y), countElements))
    result <- tapply(x, names(x), sum)
    pasteElements(result)
}

#' @title Calculate exact mass
#'
#' @description
#'
#' `calcExactMass` calculates the exact mass from a formula.
#'
#' @param x `character` or `numeric ` single character or named numeric
#'
#' @return `numeric` Resulting exact mass
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' calcExactMass("C6H12O6")
calcExactMass <- function(x) {
  # sanity checks of input
  if(is.character(x)) {
    x <- countElements(x)
  } else if(is.numeric(x) && is.null(names(x))) {
    stop("x must be either a character or a named numeric vector")
  } 
  ## get all elements
  elements <- names(x)
  ## check that all elements are contained in element table
  if(!all(elements %in% .MONOISOTOPES$element)) {
    message("not for all elements a monoisotopic mass is found")
    return(NA_real_)
  }
  mass <- 0.0
  ## iterate through all elements and add to mass
  for (atom in elements) {
    atom_mass <- .MONOISOTOPES$exact_mass[which(.MONOISOTOPES$element == atom)]
    if(!is.na(atom_mass)) {
      if (x[[atom]] > 0) {
        if (x[[atom]] == 1) {
          mass <- mass + atom_mass
        } else {
          mass <- mass + atom_mass * x[atom]
        }
      }
    }
  }
  unname(mass)
}
