# MetaboCoreutils 0.0

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
