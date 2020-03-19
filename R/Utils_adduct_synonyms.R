#'
#'
#' TODO user defined libraries?
#'
#' @export
get_adduct_synonym <- function(adduct, adduct_library = "Agilent", direction = "from") {
  
  # retrieve the different adduct definitions hardcoced
  if(adduct_library == "Agilent") {
    
    adduct_list <- .agilent_adduct_list(direction = direction)
    
  } else if(adduct_library == "Waters") {
    
    adduct_list <- .waters_adduct_list(direction = direction)
    
  } else if(adduct_library == "Sirius") {
    
    adduct_list <- .sirius_adduct_list(direction = direction)
    
  } else if(adduct_library == "") {
    
    adduct_list <- .massbank_adduct_list(direction = direction)
    
  } else {
    
    stop("Unknown adduct library")
    
  }
  
  # check if the adduct from the params is in the list
  if(!adduct %in% names(adduct_list)) {
    
    stop(paste0(adduct, " is not included in adduct library ", adduct_library))
    
  }
  
  # return results
  adduct_list[[adduct]]
  
}

#'
#'
#'
#'
.agilent_adduct_list <- function(direction = "from") {
  
  if(direction == "from") {
    
    agilent_adduct_list <- list(
      
      # Agilent to common, positive mode
      "(M+H)+" = "[M+H]+",
      "(M+Na)+" = "[M+Na]+"
      
    )
    
  } else if(direction == "to") {
    
    agilent_adduct_list <- list(
      
      # common to Agilent, positive mode
      "[M+H]+" = "(M+H)+",
      "[M+Na]+" = "(M+Na)+"
      
    )
    
  } else {
    
    stop("Unknown direction, select either 'from' or 'to'")
    
  }
  
  # return list
  agilent_adduct_list
  
}

#'
#'
#'
#'
.waters_adduct_list <- function(direction = "from") {
  
  if(direction == "from") {
    
    waters_adduct_list <- list(
      
      # Waters to common, positive mode
      "(M+H)+" = "[M+H]+",
      "(M+NH4)+" = "[M+NH4]+",
      "(M+Na)+" = "[M+Na]+",
      "(M+K)+" = "[M+K]+",
      "(M+CH3OH+H)+" = "[M+CH4O+H]+",
      "(M+ACN+H)+" = "[M+C2H3N+H]+",
      "(M+ACN+Na)+" = "[M+C2H3N+Na]+",
      "(M+DMSO+H)+" = "[M+C2H6OS+H]+",
      "(M+2ACN+H)+" = "[M+C4H6N+H]+",
      
      # Waters to common, negative mode
      "(M-H)-" = "[M-H]-"
      
    )
    
  } else if(direction == "to") {
    
    waters_adduct_list <- list(
      
      # common to Waters, positive mode
      "[M+H]+" = "(M+H)+",
      "[M+NH4]+" = "(M+NH4)+",
      "[M+Na]+" = "(M+Na)+",
      "[M+K]+" = "(M+K)+",
      "[M+CH4O+H]+" = "(M+CH3OH+H)+",
      "[M+C2H3N+H]+" = "(M+ACN+H)+",
      "[M+C2H3N+Na]+" = "(M+ACN+Na)+",
      "[M+C2H6OS+H]+" = "(M+DMSO+H)+",
      "[M+C4H6N+H]+" = "(M+2ACN+H)+",
      
      # common to Waters, negative mode
      "[M-H]-" = "(M-H)-"
      
    )
    
  } else {
    
    stop("Unknown direction, select either 'from' or 'to'")
    
  }
  
  # return list
  waters_adduct_list
  
}

#'
#'
#'
#'
.sirius_adduct_list <- function(direction = "from") {
  
  if(direction == "from") {
    
    sirius_adduct_list <- list(
      
      # Sirius to common, positive mode
      
    )
    
  } else if(direction == "to") {
    
    sirius_adduct_list <- list(
      
      # common to Sirius, positive mode
      
    )
    
  } else {
    
    stop("Unknown direction, select either 'from' or 'to'")
    
  }
  
  # return list
  sirius_adduct_list
  
}

#'
#'
#'
#'
.massbank_adduct_list <- function() {
  
}

