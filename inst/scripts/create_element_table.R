library(xml2)

# xml file with isotopes can be retrieved from
# https://github.com/BlueObelisk/bodr/blob/master/bodr/isotopes/isotopes.xml

pg <- read_xml("E:/Project Data/Bio-Chemoinformatics/R/Packages/MetaboCoreUtils/inst/isotopes/isotopes.xml")

# get all the <record>s
elements <- xml_find_all(pg, "//d1:isotopeList")

element_df <- data.frame()

for(element in elements) {

  element_name <- xml_attr(element, "id")
  isotopes <- xml_children(element)
  
  isotope_names <- xml_attr(isotopes, "id")
  
  for(isotope in isotopes) {

    
    isotope_name <- xml_attr(isotope, "id")
    data <- xml_children(isotope)
    
    exactMass <- as.numeric(xml_text(data[xml_attr(data, "dictRef") == "bo:exactMass"]))
    relAbundance <- as.numeric(xml_text(data[xml_attr(data, "dictRef") == "bo:relativeAbundance"]))
    
    if(length(relAbundance) == 0) {
      relAbundance <- NA_real_
    }
    
    element_df <- rbind.data.frame(element_df, cbind.data.frame(element = element_name,
                                                                isotope = isotope_name,
                                                                exact_mass = exactMass,
                                                                rel_abundance = relAbundance))
    
    
    
  }
}

element_df <- element_df[which(!is.na(element_df$rel_abundance)),]

write.table(element_df, file = "../isotopes/isotope_definition.txt", sep = "\t",
            row.names = FALSE)
