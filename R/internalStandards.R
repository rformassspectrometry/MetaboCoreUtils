#' @title Get internal standards
#'
#' @description
#'
#' `internalStandards` returns a table with metabolite standards available 
#'     in commercial internal standard mixes
#'
#' @param mix `character` Name of the internal standard mix that shall be returned
#'
#' @return `data.frame` data on internal standards
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' internalStandards(mix = "QReSS")
#' internalStandards(mix = "UltimateSplashOne")
internalStandards <- function(mix = "QReSS") {
  
  isFile <- system.file("internalStandards/internalStandardMixes.txt",
                        package = "MetaboCoreUtils")
  
  isDf <- read.table(isFile,
                     sep = "\t",
                     header = TRUE,
                     stringsAsFactors = FALSE)
  
  isDf[which(isDf$mix == mix),]
  
  
}

#' @title Get names of internal standard mixes supported
#'
#' @description
#'
#' `mixNames` returns a table with metabolite standards available 
#'     in commercial internal standard mixes
#'
#' @return `character` names of available IS mixes
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' mixNames()
mixNames <- function() {
  
  isFile <- system.file("internalStandards/internalStandardMixes.txt",
                        package = "MetaboCoreUtils")
  
  isDf <- read.table(isFile,
                     sep = "\t",
                     header = TRUE,
                     stringsAsFactors = FALSE)
  
  unique(isDf$mix)
  
}