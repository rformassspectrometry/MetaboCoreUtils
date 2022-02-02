#' @title Calculate Kendrick masses from exact masses
#'
#' @description
#'
#' `calculateKendrickMass` Calculates the Kendrick mass from exact masses.
#'
#' @param x `numeric` exact masses
#'
#' @return `numeric` calculated Kendrick masses
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' calculateKendrickMass(760.5851)
#'
calculateKendrickMass <- function(x) {
  
  x * (14.00000 / 14.01565)
  
}

#' @title Calculate Kendrick mass defects from exact masses
#'
#' @description
#'
#' `calculateKendrickMassDefect` Calculates the Kendrick mass defects from exact masses.
#'
#' @param x `numeric` exact masses
#'
#' @return `numeric` calculated kendrick mass defects
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' calculateKendrickMassDefect(760.5851)
#'
calculateKendrickMassDefect <- function(x) {
  
  kendrick <- calculateKendrickMass(x)
  nominalKendrick <- as.integer(kendrick)
  
  kendrick - nominalKendrick
  
  
}

#' @title Calculate referenced Kendrick mass defect from exact mass
#'
#' @description
#'
#' `calculateKendrickMassDefect` Calculates the referenced Kendrick mass defects
#'    from exact masses.
#'
#' @param x `numeric` exact masses
#' @param rkmd `numeric`Reference Kendrick mass defect to be used for calculation
#'
#' @return `numeric` calculated kendrick mass defects
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' calculateReferenceKendrickMassDefect(760.5851, rkmd = 0.749206)
#'
calculateReferencedKendrickMassDefect <- function(x, rkmd = 0.749206) {
  
  (calculateKendrickMassDefect(x) - rkmd) / 0.013399
  
}

#' @title Check if referenced Kendrick mass defect falls within a specific error
#'     range
#'
#' @description
#'
#' `calculateKendrickMassDefect` Calculates the Kendrick mass defects from exact masses.
#'
#' @param x `numeric` referenced Kendrick mass defects as calculated by 
#'     `calculateReferencedKendrickMassDefect()`
#' 
#' @param rkmdTolerance `numeric` tolerance for chekcking if reference Kendrick
#'     mass defect falls within a specific range
#'
#' @return `boolean` indicating if RKMD falls within range
#'
#' @author Michael Witting
#'
#' @export
#'
#' @examples
#'
#' calculateKendrickMassDefect(760.5851)
#'
isRkmd <- function(x, rkmdTolerance = 0.1) {
  
  abs(round(x, digits = 0) - x) < rkmdTolerance
  
}