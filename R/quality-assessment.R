#' @title Basic quality assessment functions for metabolomics
#'
#' @description
#'
#' The following functions allow to calculate basic quality assessment estimates
#' typically employed in the analysis of metabolomics data. These functions are
#' designed to be applied to entire rows of data, where each row corresponds to
#' a feature. Subsequently, these estimates can serve as a foundation for
#' feature filtering.
#'
#' - `rsd` and `rowRsd` are convenience functions to calculate the relative
#'  standard deviation (i.e. coefficient of variation) of a numerical vector
#'  or for rows of a numerical matrix, respectively.
#'
#' - `rowDratio` computes the D-ratio or *dispersion ratio*, defined as the
#'  standard deviation for QC (Quality Control) samples divided by the
#'  standard deviation for biological test samples, for each feature (row) in
#'  the matrix.
#'
#' - `percentMissing` and `rowPercentMissing` determine the percentage of
#'  missing values in a vector or for each row of a matrix, respectively.
#'
#' - `rowBlank` identifies rows (i.e features) where the mean of test samples
#'  is lower than twice the mean of blank samples. This can be used to flag
#'  features that results from contamination in the solvent of the samples.
#'  Returns a `logical` vector of length equal to the number of rows of `x`.
#'
#' These functions are based on standard filtering methods described in the
#' literature, and they are implemented to assist in preprocessing metabolomics
#' data.
#'
#' @param x `numeric` For `rsd`, a numeric vector;
#'  for `rowRsd`, `rowDratio`, `percentMissing` and `rowBlank`, a numeric
#'  matrix representing the biological samples.
#'
#' @param y `numeric` For `rowDratio` and `rowBlank`, a numeric matrix
#'  representing feature abundances in QC samples or blank samples,
#'  respectively.
#'
#' @param na.rm `logical(1)` indicate whether missing values (`NA`) should be
#'  removed prior to the calculations.
#'
#' @param mad `logical(1)` indicate whether the *Median Absolute Deviation*
#'  (MAD) should be used instead of the standard deviation. This is suggested
#'  for non-gaussian distributed data.
#'
#' @note
#' For `rsd` and `rowRsd` the feature abundances are expected to be provided in
#' natural scale and not e.g. log2 scale as it may lead to incorrect
#' interpretations.
#'
#' @return  See individual function description above for details.
#'
#' @author Philippine Louail, Johannes Rainer
#'
#' @md
#'
#' @importFrom stats sd mad median
#'
#' @name quality_assessment
#'
#' @references
#'
#' Broadhurst D, Goodacre R, Reinke SN, Kuligowski J, Wilson ID, Lewis MR,
#' Dunn WB. Guidelines and considerations for the use of system suitability
#' and quality control samples in mass spectrometry assays applied in
#' untargeted clinical metabolomic studies. Metabolomics. 2018;14(6):72.
#' doi: 10.1007/s11306-018-1367-3. Epub 2018 May 18. PMID: 29805336;
#' PMCID: PMC5960010.
#'
#' @examples
#'
#' ## coefficient of variation
#' a <- c(4.3, 4.5, 3.6, 5.3)
#' rsd(a)
#'
#' A <- rbind(a, a, a)
#' rowRsd(A)
#'
#' ## Dratio
#' x <- c(4.3, 4.5, 3.6, 5.3)
#' X <- rbind(a, a, a)
#' rowDratio(X, X)
#'
#' #' ## Percent Missing
#' b <- c(1, NA, 3, 4, NA)
#' percentMissing(b)
#'
#' B <- matrix(c(1, 2, 3, NA, 5, 6, 7, 8, 9), nrow = 3)
#' rowPercentMissing(B)
#'
#' ## Blank Rows
#' test_samples <- matrix(c(13, 21, 3, 4, 5, 6), nrow = 2)
#' blank_samples <- matrix(c(0, 1, 2, 3, 4, 5), nrow = 2)
#' rowBlank(test_samples, blank_samples)
#'
NULL

#' @export
#' @rdname quality_assessment
rsd <- function(x, na.rm = TRUE, mad = FALSE) {
    if (mad)
        mad(x, na.rm = na.rm) / abs(median(x, na.rm = na.rm))
    else
        sd(x, na.rm = na.rm) / abs(mean(x, na.rm = na.rm))
}

#' @export
#' @rdname quality_assessment
rowRsd <- function(x, na.rm = TRUE, mad = FALSE)
    apply(x, MARGIN = 1, rsd, na.rm = na.rm, mad = mad)

#' @export
#' @rdname quality_assessment
rowDratio <- function(x, y, na.rm = TRUE, mad = FALSE){
    if (mad)
        vec <- apply(y, 1, mad, na.rm = na.rm) /
            apply(x, 1, mad, na.rm = na.rm)
    else
        vec <- apply(y, 1, sd, na.rm = na.rm) /
        apply(x, 1, sd, na.rm = na.rm)
}

#' @export
#' @rdname quality_assessment
percentMissing <- function(x){
   ((sum(is.na(x))) / length(x))*100
}

#' @export
#' @rdname quality_assessment
rowPercentMissing <- function(x){
    apply(x, MARGIN = 1, percentMissing)
}

#' @export
#' @rdname quality_assessment

rowBlank <- function(x, y, na.rm = TRUE){
    m_samples <- apply(x, 1, mean, na.rm = na.rm)
    m_blank <- apply(y, 1, mean, na.rm = na.rm)
    m_samples < 2 * m_blank
}
