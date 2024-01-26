mass2mz <- function(x, adduct = "M+H", custom_adduct = NULL) {

    # if the user provides a custom adduct, use that
    if (!is.null(custom_adduct)) {
        adduct_definition = custom_adduct
    } 
    # otherwise, use the adduct definition in the package
    else {
        data(adduct_definition)
        adduct_definition = adduct_definition %>% 
            filter(name %in% adduct)
    }

    # calculate the adduct mass in a wide format
    res <- outer(x, adduct_definition$mass_multi) +
        rep(adduct_definition$mass_add, each = length(x))

    # give the columns the name of the adduct
    colnames(res) <- adduct_definition$name

    # add the mass column
    res = cbind(mass = x, res) 

    res = as.data.frame(res) 

    res = res %>%
        select(mass, everything())

    # return the result
    return(res)
}
