#' @title m/z matching
#'
#' @name calculateKendrickMass
#' 

#' @description
#'
#' Kendrick mass defect analysis is a way to analyze high-resolution MS data in
#' order to identify homologous series. The Kendrick mass (KM) is calculated by 
#' choosing a specific molecular fragment (e.g. CH2) and settings its mass to an
#' integer mass. In case of CH2 the mass of 14.01565 would be set to 14.The 
#' Kendrick mass defect (KMD) is defined as the difference between the KM and 
#' the nominial (integer) KM. All molecules of homologoues series, e.g. only 
#' differing in the number of CH2, will have an identical KMD. In an additional
#' step the KMD can be referenced to the mass defect of specific lipid backbone 
#' and by this normalize values to the referenced KMD (RKMD). This leads to 
#' values of 0 for saturated species or -1, -2, -3, etc for unsaturated species.
#' 
#' Available functoins are:
#' 
#' - `calculateKm`: calculates the Kendrick mass from an exact mass for a 
#'   specific molecular fragment, e.g. "CH2".
#' - `calculateKmd`: calculates the Kendrick mass defect from an exact mass for
#'   a specific molecular fragment, e.g. "CH2"
#' - `calculateRkmd`: calculates the referenced Kendrick mass defect from an 
#'   exact mass for a specific molecular fragment, e.g. "CH2", and a reference
#'   KMD.
#' - `isRkmd`: Checks if a calculated RKMD falls within a specific error range
#'   around an negative integer corresponding the number of double bonds, in 
#'   case of CH2 as fragment.
#'   
#' @param x `numeric` Vector with exact masses or calculated RKMDs in case of 
#'     `isRkmd`
#' @param framgent `numeric(1)` or `character(1)` corresponding factor or molecular
#'     formula of molecular fragment, e.g. 14  /14.01565 or "CH2" for CH2.
#' @param rkmd `numeric(1)` KMD used for referencing of KMDs
#' @param rkmdTolerance `numeric(1)` Tolerance to check if RKMD fall around a 
#'     negative integer corresponding to the number of double bonds
#' 
#' @return `numeric` or `boolean` All functions, except `isRkmd` return a numeric
#'     with same length as the input corresponding to the KM, KMD or RMKD. 
#'     `isRkmd` returns a list TRUE or FALSE indicating if the RKMD falls within
#'      a specific range around a negative integer corresponding to the number
#'      of double bonds
#' 
#' 
#' @author Michael Witting
#' 
#' @examples
#'
#' calculateKm(760.5851)
#'
#' calculateKmd(760.5851)
#'
#' calculateRkmd(760.5851, rkmd = 0.749206)
#' 
#' isRkmd(calculateRkmd(760.5851, rkmd = 0.749206))
#'
#'
NULL


#' @rdname calculateKendrickMass
#' 
#' @export
calculateKm <- function(x, fragment = 14.00000 / 14.01565) {
  if(is.numeric(fragment)) {
    x * fragment
  } else if(is.character(fragment)) {
    fragment <- calculateMass(fragment)
    fragment <- as.integer(fragment) / fragment
    x * fragment
  }
}

#' @rdname calculateKendrickMass
#' 
#' @export
calculateKmd <- function(x, fragment = 14.00000 / 14.01565) {
  kendrick <- calculateKm(x, fragment)
  kendrick - as.integer(kendrick)
}

#' @rdname calculateKendrickMass
#' 
#' @export
calculateRkmd <- function(x, fragment = 14.00000 / 14.01565, rkmd = 0.749206) {
  
  (calculateKendrickMassDefect(x) - rkmd) / 0.013399
  
}

#' @rdname calculateKendrickMass
#' 
#' @export
isRkmd <- function(x, rkmdTolerance = 0.1) {
  
  abs(round(x, digits = 0) - x) < rkmdTolerance
  
}