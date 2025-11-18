# Basic quality assessment functions for metabolomics

The following functions allow to calculate basic quality assessment
estimates typically employed in the analysis of metabolomics data. These
functions are designed to be applied to entire rows of data, where each
row corresponds to a feature. Subsequently, these estimates can serve as
a foundation for feature filtering.

- `rsd` and `rowRsd` are convenience functions to calculate the relative
  standard deviation (i.e. coefficient of variation) of a numerical
  vector or for rows of a numerical matrix, respectively.

- `rowDratio` computes the D-ratio or *dispersion ratio*, defined as the
  standard deviation for QC (Quality Control) samples divided by the
  standard deviation for biological test samples, for each feature (row)
  in the matrix.

- `percentMissing` and `rowPercentMissing` determine the percentage of
  missing values in a vector or for each row of a matrix, respectively.

- `rowBlank` identifies rows (i.e., features) where the mean of test
  samples is lower than a specified multiple (defined by the `threshold`
  parameter) of the mean of blank samples. This can be used to flag
  features that result from contamination in the solvent of the samples.

These functions are based on standard filtering methods described in the
literature, and they are implemented to assist in preprocessing
metabolomics data.

## Usage

``` r
rsd(x, na.rm = TRUE, mad = FALSE)

rowRsd(x, na.rm = TRUE, mad = FALSE)

rowDratio(x, y, na.rm = TRUE, mad = FALSE)

percentMissing(x)

rowPercentMissing(x)

rowBlank(x, y, threshold = 2, na.rm = TRUE)
```

## Arguments

- x:

  `numeric` For `rsd`, a numeric vector; for `rowRsd`, `rowDratio`,
  `percentMissing` and `rowBlank`, a numeric matrix representing the
  biological samples.

- na.rm:

  `logical(1)` indicates whether missing values (`NA`) should be removed
  prior to the calculations.

- mad:

  `logical(1)` indicates whether the *Median Absolute Deviation* (MAD)
  should be used instead of the standard deviation. This is suggested
  for non-gaussian distributed data.

- y:

  `numeric` For `rowDratio` and `rowBlank`, a numeric matrix
  representing feature abundances in QC samples or blank samples,
  respectively.

- threshold:

  `numeric` For `rowBlank`, indicates the minimum difference required
  between the mean of a feature in samples compared to the mean of the
  same feature in blanks for it to not be considered a possible
  contaminant. For example, the default threshold of 2 signifies that
  the mean of the features in samples has to be at least twice the mean
  in blanks for it not to be flagged as a possible contaminant.

## Value

See individual function description above for details.

## Note

For `rsd` and `rowRsd` the feature abundances are expected to be
provided in natural scale and not e.g. log2 scale as it may lead to
incorrect interpretations.

## References

Broadhurst D, Goodacre R, Reinke SN, Kuligowski J, Wilson ID, Lewis MR,
Dunn WB. Guidelines and considerations for the use of system suitability
and quality control samples in mass spectrometry assays applied in
untargeted clinical metabolomic studies. Metabolomics. 2018;14(6):72.
doi: 10.1007/s11306-018-1367-3. Epub 2018 May 18. PMID: 29805336; PMCID:
PMC5960010.

## Author

Philippine Louail, Johannes Rainer

## Examples

``` r

## coefficient of variation
a <- c(4.3, 4.5, 3.6, 5.3)
rsd(a)
#> [1] 0.1580575

A <- rbind(a, a, a)
rowRsd(A)
#>         a         a         a 
#> 0.1580575 0.1580575 0.1580575 

## Dratio
x <- c(4.3, 4.5, 3.6, 5.3)
X <- rbind(a, a, a)
rowDratio(X, X)

#' ## Percent Missing
b <- c(1, NA, 3, 4, NA)
percentMissing(b)
#> [1] 40

B <- matrix(c(1, 2, 3, NA, 5, 6, 7, 8, 9), nrow = 3)
rowPercentMissing(B)
#> [1] 33.33333  0.00000  0.00000

## Blank Rows
test_samples <- matrix(c(13, 21, 3, 4, 5, 6), nrow = 2)
blank_samples <- matrix(c(0, 1, 2, 3, 4, 5), nrow = 2)
rowBlank(test_samples, blank_samples)
#> [1] FALSE FALSE
```
