# MetaboCoreutils 1.1

## MetaboCoreUtils 1.1.2

- Add already charged adduct/ion to the adduct definition.

## MetaboCoreUtils 1.1.1

- Add `correctRindex` function.
- Add `isotopologue` function to group isotopologues in MS spectra.

# MetaboCoreutils 0.99

## MetaboCoreUtils 0.99.1

- Add `[M+H-2(H2O)]+` adduct definition.

## MetaboCoreUtils 0.99.0

- Add package vignette and prepare for Bioconductor submission.

# MetaboCoreutils 0.0

## MetaboCoreUtils 0.0.3

- Add `internalStandards` and `internalStandardsNames` functions.

## MetaboCoreUtils 0.0.3

- Refactor `mass2mz` and `mz2mass` to support calculation of multiple adducts
  for multiple input values as well as user defined adduct definition.
- Add functions `adducts` to return a `data.frame` with the (built-in) adduct
  definitions.

## MetaboCoreUtils 0.0.2

- Vectorize `mass2mz` and `mz2mass` and additional performance improvement.

## MetaboCoreUtils 0.0.1

- Add utility functions to work with chemical formulas: `pasteElements`,
  `countElements` and `standardizeFormula`.
- Add utility functions to convert between m/z and monoisotopic masses based on
  provided ion adduct information.
