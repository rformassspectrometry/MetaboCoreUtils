.onLoad <- function(libname, pkgname) {
    adds <- .load_adducts()
    assign(".ADDUCTS", adds, envir = .get_envir(pkgname))
    add_multi <- adds$mass_multi
    add_add <- adds$mass_add
    names(add_multi) <- rownames(adds)
    names(add_add) <- rownames(adds)
    assign(".ADDUCTS_MULT", add_multi, envir = .get_envir(pkgname))
    assign(".ADDUCTS_ADD", add_add, envir = .get_envir(pkgname))

    txts <- dir(system.file("substitutions", package = "MetaboCoreUtils"),
                full.names = TRUE, pattern = "txt$")
    for (txt in txts) {
        substs <- utils::read.table(txt, sep = "\t", header = TRUE)
        assign(paste0(".", toupper(sub(".txt", "", basename(txt)))),
               substs, envir = .get_envir(pkgname))
    }

    # get mono isotopes for exact mass calculation
    assign(".ISOTOPES", .load_isotopes(), envir = .get_envir(pkgname))
}

.get_envir <- function(x) {
    asNamespace(x)
}

.load_adducts <- function() {
    adds <- utils::read.table(system.file("adducts", "adduct_definition.txt",
                                          package = "MetaboCoreUtils"),
                              sep = "\t", header = TRUE)
    rownames(adds) <- adds$name
    adds
}

.load_isotopes <- function() {
    iso <- utils::read.table(
        system.file(
            "isotopes", "isotope_definition.txt", package = "MetaboCoreUtils"
        ),
        sep = "\t", header = TRUE
    )
    ## sort by rel_abundance
    iso <- iso[order(iso$element, -iso$rel_abundance),]
    ## swap numbers and elements names
    iso$isotope <- gsub("([A-z]+)([0-9]*)", "\\2\\1", iso$isotope)
    ## drop isotope number from most common isotope
    is_most_common <- !duplicated(iso$element)
    iso$isotope[is_most_common] <-
        gsub("^[0-9]+", "", iso$isotope[is_most_common])
    ## sort according to Hill notation
    org <- c("C", "H", "N", "O", "S", "P")
    iso$rank <- match(iso$element, org, nomatch = length(org) + 1L)
    ## reorder according to Hill notation and non-common isotopes first
    iso <- iso[order(iso$rank, iso$element, iso$isotope),]
    setNames(iso$exact_mass, iso$isotope)
}
