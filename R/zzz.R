.onLoad <- function(libname, pkgname) {
    adds <- utils::read.table(system.file("adducts", "adduct_definition.txt",
                                          package = "MetaboCoreUtils"),
                              sep = "\t", header = TRUE)
    rownames(adds) <- adds$name
    assign(".ADDUCTS", adds, envir = asNamespace(pkgname))
    add_multi <- adds$mass_multi
    add_add <- adds$mass_add
    names(add_multi) <- rownames(adds)
    names(add_add) <- rownames(adds)
    assign(".ADDUCTS_MULT", add_multi, envir = asNamespace(pkgname))
    assign(".ADDUCTS_ADD", add_add, envir = asNamespace(pkgname))

    txts <- dir(system.file("substitutions", package = "MetaboCoreUtils"),
                full.names = TRUE, pattern = "txt$")
    for (txt in txts) {
        substs <- utils::read.table(txt, sep = "\t", header = TRUE)
        assign(paste0(".", toupper(sub(".txt", "", basename(txt)))),
               substs, envir = asNamespace(pkgname))
    }

    # get mono isotopes for exact mass calculation
    mono <- utils::read.table(system.file("isotopes", "isotope_definition.txt",
                                          package = "MetaboCoreUtils"),
                              sep = "\t", header = TRUE)
    mono <- split(mono, mono$element)
    mono <- vapply(mono, function(z) {
        z$exact_mass[which.max(z$rel_abundance)]
    }, numeric(1))
    assign(".MONOISOTOPES", mono, envir = asNamespace(pkgname))
}
