# 2-point correction of RIs

`correctRindex` performs correction of retention indices (RIs) based on
reference substances. Even after conversion of RTs to RIs slight
deviations might exist. These deviations can be further normalized, if
they are linear, by using two metabolites for which the RIs are known
(e.g. internal standards).

## Usage

``` r
correctRindex(x, y)
```

## Arguments

- x:

  `numeric` vector with retention indices, calculated by `indexRtime`

- y:

  `data.frame` containing two columns. The first is expected to contain
  the measured RIs of the reference substances and the second the
  reference RIs.

## Value

`numeric` vector of same length than `x` with corrected retention
indices. Values are floating point decimals. If integer values shall be
used conversion has to be performed manually.

## Author

Michael Witting

## Examples

``` r

ref <- data.frame(rindex = c(110, 210),
refindex = c(100, 200))
rindex <- c(110, 210)
correctRindex(rindex, ref)
#> [1] 100 200
```
