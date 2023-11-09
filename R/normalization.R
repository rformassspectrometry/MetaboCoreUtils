#' Functions and utilities for adjustment of LC-MS/metabolomics-specific biases
#'
#' @noRd
NULL

#' @title Linear model-based normalization of abundance matrices
#'
#' @description
#'
#' The `fit_lm` and `adjust_lm` functions facilitate linear model-based
#' normalization of abundance matrices. The expected noise in a numeric
#' data matrix can be modeled with a linear regression model using the
#' `fit_lm` and the data can subsequently be adjusted (i.e., the modeled
#' noise can be removed from abundance values) using the `adjust_lm`
#' function. A typical use case would be to remove injection index
#' dependent signal drifts in a LC-MS derived metabolomics data set:
#' a linear model of the form `y ~ injection_index` would model the
#' measured abundances of each feature (each row in a data matrix) as a
#' function of the injection index in which a specific sample was measured
#' during a LC-MS measurement run. The fitted models can then be used to
#' adjust the abundance matrix by removing these dependencies from the
#' feature abundances using the `adjust_lm` function.
#'
#' The two functions are desribed in more details below:
#'
#' `fit_lm` allows to fit a linear regression model (defined with parameter
#' `formula`) to each row of the numeric data matrix submitted with parameter
#' `y`. Additional covariates used in each model are expected to be provided
#' as a `data.frame` with parameter `data`.
#'
#' The linear model is expected to be defined by a formula starting with
#' `y ~ `. To model for example an injection index dependency of values in
#' `y` a formula `y ~ injection_index` could be used, with values for the
#' injection index being provided as a column `"injection_index"` in the
#' `data` data frame. `fit_lm` would thus fit this model to each row of
#' `y`.
#'
#' Linear models can be fitted either with the standard least squares of
#' [lm()] by setting `method = "lm"` (the default), or with the more robust
#' methods from the *robustbase* package with `method = "lmrob"`.
#'
#' @return A `list` with linear models (either of type *lm* or *lmrob*) or
#'     length equal to the number of rows of `y`. `NA` is reported for rows
#'     with too few non-missing data points (depending on parameter
#'     `minValues`).
#'
#' @export
#'
#' @author Johannes Rainer
#'
#' @examples
#'
#' ## See also the vignette for more details and examples.
#'
#' ## Load a test matrix with abundances of features from a LC-MS experiment.
#' vals <- read.table(system.file("txt", "feature_values.txt",
#'                                 package = "MetaboCoreUtils"), sep = "\t")
#' vals <- as.matrix(vals)
#'
#' ## Define a data.frame with the covariates to be used to model the noise
#' sdata <- data.frame(injection_index = seq_len(ncol(vals)))
#'
#' ## Fit a simple linear model describing the feature abundances as a
#' ## function of the index in which samples were injected during the LC-MS
#' ## run. Note that such a model should **only** be fitted if the samples
#' ## were randomized, i.e. the injection index is independent of any
#' ## experimental covariate.
#' ii_lm <- fit_lm(y ~ injection_index, data = sdata, y = vals)
#'
#' ## The result is a list of linear models
#' ii_lm[[1]]
#'
#' ## Plotting the data for one feature:
#' plot(x = sdata$injection_index, y = vals[2, ])
#' grid()
#' ## plot also the fitted model
#' abline(ii_lm[[2]], lty = 2)
#'
#' ## For this feature (row) a decreasing signal intensity with injection
#' ## index was observed (and modeled).
#'
#' ## See the vignette for more details, examples and explanations.
fit_lm <- function(formula, data, y, method = c("lm", "lmrob"), control = NULL,
                   minVals = ceiling(nrow(data) * 0.75), model = TRUE, ...,
                   BPPARAM = BiocParallel::SerialParam()) {
    requireNamespace("BiocParallel", quietly = TRUE)
    method <- match.arg(method)
    if (missing(formula) || !is(formula, "formula"))
        stop("'formula' has to be defined and needs to be a formula")
    if (missing(data) || !is.data.frame(data))
        stop("'data' is required and has to be a data.frame")
    if (missing(y) || !is.numeric(y))
        stop("'y' has to be defined and needs to be either a numeric or matrix")
    if (!is.matrix(y))
        y <- matrix(y, nrow = 1)
    if (ncol(y) != nrow(data))
        stop("number columns of 'y' (or length of 'y') has to match number ",
             "of rows of 'data'")
    .check_formula(formula, data)
    y <- lapply(seq_len(nrow(y)), function(i) y[i, ])
    if (method == "lmrob") {
        requireNamespace("robustbase", quietly = TRUE)
        if (missing(control)) {
            ## Force use of the KS2014 settings in lmrob and increase the
            ## scale-finding iterations to avoid some of the warnings.
            control <- robustbase::lmrob.control("KS2014")
            control$maxit.scale <- 10000
            control$k.max <- 10000
            control$refine.tol <- 1e-7
        }
        res <- BiocParallel::bplapply(y, FUN = .fit_lmrob, formula = formula,
                                      data = data, minVals = minVals,
                                      model = model, BPPARAM = BPPARAM,
                                      control = control, ...)
    } else
        res <- BiocParallel::bplapply(y, FUN = .fit_lm, formula = formula,
                                      data = data, minVals = minVals,
                                      model = model, BPPARAM = BPPARAM, ...)
    res
}

#' Fit the model for a single row of data.
#'
#' @noRd
.fit_lm <- function(y, formula, data, minVals, model = TRUE, ...) {
    nna <- sum(!is.na(y))
    if (nna >= minVals) {
        data$y <- y
        lm(formula = formula, data = data, model = model, ...)
    } else NA
}
.fit_lmrob <- function(y, formula, data, minVals, model = TRUE, control, ...) {
    nna <- sum(!is.na(y))
    if (nna >= minVals) {
        data$y <- y
        robustbase::lmrob(formula = formula, data = data, model = model,
                          control = control, ...)
    } else NA
}

.check_formula <- function(formula, data) {
    vars <- all.vars(formula)
    if (vars[1] != "y")
        stop("'formula' should start with `y ~`")
    if (!all(vars[-1L] %in% colnames(data)))
        stop("All variables defined in 'formula' need to be present in 'data'")
}

adjust_lm <- function() {
    ## Check
    ## - all covariates available?

    ## Need to handle negative values? Maybe not directly in here?
}

#' Adjust values `y` based on the linear model provided with `lm`
#'
#' @param y `numeric` with abundances that should be adjusted.
#'
#' @param data `data.frame` with additional covariates for values in `y`. All
#'     covariates from the model `lm` need to be present.
#'
#' @param lm linear model (`lm` or `lmrob`) with which the values in `y` should
#'     be adjusted.
#'
#' @return `numeric` (same length than `y`) with the adjusted values.
#'
#' @author Johannes Rainer based on original code from Ron Wehrens from
#'         https://github.com/rwehrens/BatchCorrMetabolomics
#'
#' @noRd
.adjust_with_lm <- function(y, data, lm) {
    data$y <- y
    pred <- predict(lm, newdata = data)
    y - pred + mean(lm$fitted.values + lm$residuals)
}
