#' @title Get supported software for column name translation
#'
#' @description
#'
#' Get the names of the supported software defined in the mapping schema
#'
#' @return A `character` vector with the names of the supported software.
#'
#' @export
#'
#' @author Gabriele Tomè
#'
#' @importFrom utils read.delim
#'
#' @examples
#'
#' softwareMapping()
#'
softwareMapping <- function() {
    mapping_df <- read.delim(system.file("mappingSchema", "mapping_schema.tsv",
                                         package = "MetaboCoreUtils"),
                             header = TRUE, sep = "\t", check.names = FALSE)
    names(mapping_df)
}

#' @title Get mapping schema for column name translation
#'
#' @description
#'
#' Get the mapping schema as a `data.frame` that defines the mapping between
#' column names of different software.
#'
#' @return A `data.frame` with the mapping schema.
#'
#' @export
#'
#' @author Gabriele Tomè
#'
#' @importFrom utils read.delim
#'
#' @examples
#'
#' mappingSchema()
#'
mappingSchema <- function() {
    mapping_df <- read.delim(system.file("mappingSchema", "mapping_schema.tsv",
                                         package = "MetaboCoreUtils"),
                             header = TRUE, sep = "\t", check.names = FALSE,
                             na.strings = "")
    mapping_df
}

#' @title Guess the source of column names
#'
#' @description
#'
#' Guess the source of column names based on predefined mappings. The function
#' counts how many elements in the input vector `x` match the column names
#' defined in the mapping schema for each software and returns the software with
#' the highest match count.
#'
#' @param x A `character` vector of column names for which the source should be
#' guessed.
#'
#' @return A `character(1)` with the name of the guessed source software.
#'
#' @export
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' ## MS-Dial names
#' x <- c("Average Rt(min)", "Alignment ID", "Average Mz")
#' guessSource(x)
#'
guessSource <- function(x = character()) {
    if (length(x) == 0) {
        stop("'x' must not be empty.")
    }

    mapping_df <- mappingSchema()

    ## Count matches for each mapping
    match_counts <- vapply(mapping_df, function(mapping) {sum(x %in% mapping)},
                           FUN.VALUE = numeric(1))

    ## Return the source with the highest match count
    names(match_counts)[which.max(match_counts)]
}

#' @title Get mapping vector between two software
#'
#' @description
#'
#' Get a named `character` vector that defines the mapping between column names
#' of two software based on the mapping schema. The names of the returned vector
#' are the column names of the `from` software and the values are the
#' corresponding column names of the `to` software.
#'
#' @param from `character(1)` with the name of the source software.
#'
#' @param to `character(1)` with the name of the target software.
#'
#' @return A named `character` vector with the mapping between the two software.
#'
#' @export
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' nameMapping(from = "MS-Dial", to = "mzTab-M")
#'
nameMapping <- function(from = character(), to = character()) {
    if (length(from) == 0 || length(to) == 0) {
        stop("Both 'from' and 'to' must be specified.")
    }

    if (from == to) {
        stop("'from' and 'to' must be different.")
    }

    if (!from %in% softwareMapping() || !to %in% softwareMapping()) {
        stop("Both 'from' and 'to' must be valid software names. Use ",
             "'softwareMapping()' to see available options.")
    }

    mapping_df <- mappingSchema()

    mapping <- setNames(mapping_df[[to]], mapping_df[[from]])
    mapping <- mapping[!(is.na(names(mapping)) & is.na(mapping))]
    mapping
}

#' @title Translate column names based on a provided mapping
#'
#' @description
#'
#' Map column names from one software to another. The function replaces elements
#' in the input vector `x` with their corresponding values in the mapping if a
#' match is found. If an element in `x` does not have a corresponding mapping,
#' it is returned unchanged with a warning.
#'
#' @param x `character` vector of column names to be translated.
#'
#' @param mapping A named `character` vector that defines the mapping for
#'     translation. The names of the vector should be the original column names
#'     and the values should be the translated column names.
#'
#' @return A `character` vector with the translated column names.
#'
#' @export
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' ## MS-D column names
#' x <- c("Average Rt(min)", "Alignment ID", "Average Mz")
#' map_vec <- nameMapping(from = "MS-Dial", to = "mzTab-M")
#' translate(x, mapping = map_vec)
#'
translate <- function(x = character(), mapping = NULL) {
    if (length(x) == 0) {
        stop("'x' must not be empty.")
    }

    if (is.null(mapping)) {
        stop("Mapping vector must be provided for translation. Use ",
             "'nameMapping()' to get the mapping.")
    }

    translated <- vapply(x, function(name) {
        if(name %in% names(mapping)) {
            if(is.na(mapping[[name]])) {
                warning(paste0("Mapping for: '", name, "' is \"NA\" - ",
                                "returning original name."))
                name
            } else {
                mapping[[name]]
            }
        } else{
            warning(paste0("No mapping found for: '", name, "' - ",
                            "returning original name."))
            name
        }
    }, FUN.VALUE = character(1))
    translated
}
