#' @title Identfying isotopologue peaks in MS data
#'
#' @description
#'
#' Given a spectrum (i.e. a peak matrix with m/z and intensity values)
#' the function identifies groups potential isotopologue peaks based on
#' pre-defined mass differences and intensity (probability) ratios. These
#' parameters defining the isotopic substitutions characterizing the
#' isotopologues need to be passed to the function with parameter
#' `substDefinition`.
#'
#' @param x `matrix` with spectrum data (columns `mz` and `intensity`).
#'
#' @param substDefinition `matrix` or `data.frame` with definition of isotopic
#'     substitutions (columns `"name"`, `"degree"`, `"md"`, `"min_slope"`,
#'     `"max_slope"`). The rows in this matrix have to be ordered by column
#'     `md` in increasing order. See [isotopicSubstitutionMatrix()] for more
#'     information on the format and content.
#'
#' @param tolerance `numeric(1)` representing the absolute tolerance for the
#'     relaxed matching of m/z values of peaks. See [MsCoreUtils::closest()] for
#'     details.
#'
#' @param ppm `numeric(1)` representing a relative, value-specific
#'     parts-per-million (PPM) tolerance for the relaxed matching of m/z values
#'     of peaks. See [MsCoreUtils::closest()] for details.
#'
#' @param seedMz `numeric` vector of **ordered** m/z values. If provided,
#'     the function checks if there are peaks in `x` which m/z match them.
#'     Isotope groups are then defined only for this subset of peaks.
#'
#' @param charge `numeric(1)` representing the expected charge of the ionized
#'     compounds.
#'
#' @return `list` of `integer` vectors. Each `integer` vector contains the
#'     indixes of the rows in `x` with potential isotopologues of the same
#'     compound.
#'
#' @details
#'
#' The function iterates over the peaks (rows) in `x`. For each peak (which is
#' assumed to be the monoisotopic peak) it searches other peaks in `x` with a
#' difference in m/z matching (given `ppm` and `tolerance`) any of the
#' pre-defined mass differences in `substDefinitions` (column `"md"`).
#'
#' For matching peaks, the function next evaluates whether the intensity is
#' within the expected (pre-defined) intensity range. Using `"min_slope"` and
#' `"max_slope"` for the respective potentially matching isotopic substitution
#' in `substDefinition`, the function estimates a (m/z dependent) lower and
#' upper intensity ratio limit based on the peak's m/z.
#'
#' Peaks already assigned to an itotope group are not considered in  from
#' difference  if also their intensity is
#' compatible with them being part of a isotopic group and if so they are
#' grouped together. When some peaks are grouped together their indexes are
#' excluded from the set of indexes that are searched for further groups.
#'
#' @author Andrea Vicini
#'
#' @export
isotopologues <- function(x, substDefinition = isotopicSubstitutionMatrix(),
                          tolerance = 0, ppm = 20, seedMz = numeric(),
                          charge = 1) {
    .isotope_peaks(x, substDefinition, tolerance, ppm, seedMz, charge)
}

#' @importFrom MsCoreUtils closest
#'
#' @importFrom stats approx na.omit
#'
#' @noRd
.isotope_peaks <- function(x, substDefinition = isotopicSubstitutionMatrix(),
                           tolerance = 0, ppm = 20, seedMz = numeric(),
                           charge = 1) {
  wtt <- which(x[, 2] > 0)
  if (length(seedMz))
    idxs <- wtt[na.omit(closest(seedMz, x[wtt, 1], tolerance = tolerance,
                                 ppm = ppm, duplicates = "closest"))]
  else idxs <- wtt
  lst <- vector(mode = "list", length = length(idxs))
  mzd <- substDefinition[, "md"] / charge
  for (i in idxs) {
    if (!is.na(ii <- match(i, wtt))) {
      wtt <- wtt[-(1:ii)]
      cls <- closest(x[i, 1] + mzd, x[wtt, 1], tolerance = tolerance,
                     ppm = ppm, duplicates = "closest")
      int_ok <- .is_isotope_intensity_range(x[, 2][wtt[cls]], x[i, 1] * charge,
                                            x[i, 2], substDefinition)
      if (length(int_ok)) {
        lst[[i]] <- c(i, wtt[cls][int_ok])
        wtt <- wtt[-cls[int_ok]]
      }
    }
  }
  lst[lengths(lst) > 0]
}

.isotope_peaks2 <- function(x, substDefinition = substDefinition(),
                           tolerance = 0, ppm = 20, seedMz = numeric(),
                           charge = 1) {
  to_test <- x[, 2] > 0
  idxs <- which(to_test)
  if (length(seedMz))
    idxs <- idxs[na.omit(closest(seedMz, x[to_test, 1], tolerance = tolerance,
                                 ppm = ppm, duplicates = "closest"))]
  lst <- vector(mode = "list", length = length(idxs))
  mzd <- substDefinition[, "md"] / charge
  for (i in idxs) {
    if (to_test[i]) {
      to_test[i] <- FALSE
      wtt <- which(to_test)
      cls <- closest(x[i, 1] + mzd, x[wtt, 1], tolerance = tolerance,
                     ppm = ppm, duplicates = "closest")
      int_ok <- .is_isotope_intensity_range(x[, 2][wtt[cls]], x[i, 1] * charge,
                                            x[i, 2], substDefinition)
      if (length(int_ok)) {
        lst[[i]] <- c(i, wtt[cls][int_ok])
        to_test[wtt[cls][int_ok]] <- FALSE
      }
    }
  }
  lst[lengths(lst) > 0]
}

#' @title Checking the intensity
#'
#' @param x intensity of the matching peaks. x has length equal to the number
#' of rows of substDefinition. The i-th element of x represent the intensity
#' associated to the peak whose m/z difference is associated to the i-th mzd in
#' substDefinition if any or NA.
#' @param m mass of the current (assumed monoisotopic) peak
#' @param intensity  intensity of the current (assumed monoisotopic) peak
#' @param substDefinition substitutions definition data.frame
#'
#' @return indexes of the intensities in x that are part of a isotopic group
#'
#' @noRd
.is_isotope_intensity_range <- function(x, m, intensity, substDefinition) {
  R_min <- (m * substDefinition[, "min_slope"]) ^ substDefinition[, "subst_degree"]
  R_max <- (m * substDefinition[, "max_slope"]) ^ substDefinition[, "subst_degree"]
  which(x >= R_min * intensity & x <= R_max * intensity)
}

#' @title Definitions of isotopic substitutions
#'
#' @description
#'
#' In order to identify potential isotopologues based on only m/z and intensity
#' values with the [isotopologues()] function, sets of pre-calculated parameters
#' are required. This function returns such parameter sets estimated on
#' different sources/databases. The nomenclature used to describe isotopes
#' follows the following convention: the number of neutrons is provided in `[`
#' as a prefix to the element and the number of atoms of the element as suffix.
#' `[13]C2[37]Cl3` describes thus an isotopic substitution containing 2 `[13]C`
#' isotopes and 3 `[37]Cl` isotopes.
#'
#' Each row in the returned `data.frame` characterizes an isotopic substitution
#' (which can involve isotopes of several elements or different isotopes of the
#' same element). The provided isotopic substitutions are in general the most
#' frequently observed substitutions in the database (e.g. HMDB) on which they
#' were defined. Parameters (columns) defined for each isotopic substitution
#' are:
#'
#' - `"degree"`: the *degree* of the isotopic substitution. Isotopic
#'   substitutions with a single element (such as `[15]N1` or `[13]C1`) are of
#'   degree 1 while isotopic substitutions with more isotopes are of a higher
#'   degree (`[37]Cl5` and `[34]S1[37]Cl4` are e.g. both of degree 5).
#' - `"minmass"`: the minimal mass of a compound for which the isotopic
#'   substitution was found. Peaks with a mass lower than this will most likely
#'   not have the respective isotopic substitution.
#' - `"md"`: the mass difference between the monoisotopic peak and a peak of an
#'   isotopologue characterized by the respective isotopic substitution.
#' - `"min_slope"`: used to calculate the lower expected intensity
#'   bound for the respective isotopic substitution based on the peak's m/z. The
#'   probability of an isotopic substitution (and hence also its intensity)
#'   increases with the number of atoms (of the elements part of the isotopic
#'   substitution) of the measured compound. For more frequent elements a
#'   linear relationship can be assumed between the compound's mass and the
#'   number of atoms of the element and hence also the probability (intensity)
#'   of the isotopologue.
#' - `"max_slope"`: used to calculate the expected upper intensity bound.
#'
#' @param source `character(1)` defining the set of predefined parameters and
#'     isotopologue definitions to return.
#'
#' @return `data.frame` with parameters to detect the defined isotopic
#'     substitutions
#'
#' @author Andrea Vicini
#'
#' @export
isotopicSubstitutionMatrix <- function(source = c("HMDB")) {
    source <- match.arg(source)
    get(paste0(".SUBSTS_", toupper(source)))
}
