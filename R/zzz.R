.onLoad <- function(libname, pkgname) {
    adds <- utils::read.table(system.file("adducts/adduct_definition.txt",
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
    
    substs_hmdb <- utils::read.table(system.file("substitutions/hmdb.txt",
                                            package = "MetaboCoreUtils"),
                                sep = "\t", header = TRUE)
    assign(".SUBSTS_HMDB", substs_hmdb, envir = asNamespace(pkgname))
}
