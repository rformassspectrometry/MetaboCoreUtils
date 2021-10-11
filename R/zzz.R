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
    
    substs_hmdb_neutral <-
        utils::read.table(system.file("substitutions/hmdb_subst_neutral.txt",
                                      package = "MetaboCoreUtils"),
                          sep = "\t", header = TRUE)
    assign(".SUBSTS_HMDB_NEUTRAL", substs_hmdb_neutral,
           envir = asNamespace(pkgname))
    
    substs_hmdb_positive <-
        utils::read.table(system.file("substitutions/hmdb_subst_positive.txt",
                                      package = "MetaboCoreUtils"),
                          sep = "\t", header = TRUE)
    assign(".SUBSTS_HMDB_POSITIVE", substs_hmdb_positive,
           envir = asNamespace(pkgname))
    
    substs_hmdb_negative <-
        utils::read.table(system.file("substitutions/hmdb_subst_negative.txt",
                                      package = "MetaboCoreUtils"),
                          sep = "\t", header = TRUE)
    assign(".SUBSTS_HMDB_NEGATIVE", substs_hmdb_negative,
           envir = asNamespace(pkgname))
}
