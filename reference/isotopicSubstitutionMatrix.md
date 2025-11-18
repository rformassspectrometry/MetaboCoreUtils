# Definitions of isotopic substitutions

In order to identify potential isotopologues based on only m/z and
intensity values with the
[`isotopologues()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/isotopologues.md)
function, sets of pre-calculated parameters are required. This function
returns such parameter sets estimated on different sources/databases.
The nomenclature used to describe isotopes follows the following
convention: the number of neutrons is provided in `[` as a prefix to the
element and the number of atoms of the element as suffix.
`[13]C2[37]Cl3` describes thus an isotopic substitution containing 2
`[13]C` isotopes and 3 `[37]Cl` isotopes.

Each row in the returned `data.frame` is associated with an isotopic
substitution (which can involve isotopes of several elements or
different isotopes of the same element). In general for each isotopic
substitution multiple rows are present in the `data.frame`. Each row
provides parameters to compute bounds (for the ratio between the
isotopologue peak and the monoisotopic one) on a certain mass range. The
provided isotopic substitutions are in general the most frequently
observed substitutions in the database (e.g. HMDB) on which they were
defined. Parameters (columns) defined for each isotopic substitution
are:

- `"minmass"`: the minimal mass of a compound for which the isotopic
  substitution was found. Peaks with a mass lower than this will most
  likely not have the respective isotopic substitution.

- `"maxmass"`: the maximal mass of a compound for which the isotopic
  substitution was found. Peaks with a mass higher than this will most
  likely not have the respective isotopic substitution.

- `"md"`: the mass difference between the monoisotopic peak and a peak
  of an isotopologue characterized by the respective isotopic
  substitution.

- `"leftend"`: left endpoint of the mass interval.

- `"rightend"`: right endpoint of the mass interval.

- `"LBint"`: intercept of the lower bound line on the mass interval
  whose endpoints are `"leftend"` and `"rightend"`.

- `"LBslope"`: slope of the lower bound line on the mass interval.

- `"UBint"`: intercept of the upper bound line on the mass interval.

- `"UBslope"`: slope of the upper bound line on the mass interval.

## Usage

``` r
isotopicSubstitutionMatrix(source = c("HMDB_NEUTRAL"))
```

## Arguments

- source:

  `character(1)` defining the set of predefined parameters and
  isotopologue definitions to return.

## Value

`data.frame` with parameters to detect the defined isotopic
substitutions

## Available pre-calculated substitution matrices

- `source = "HMDB"`: most common isotopic substitutions and parameters
  for these have been calculated for all compounds from the [Human
  Metabolome Database](https://hmdb.ca) (HMDB, July 2021). Note that the
  substitutions were calculated on the **neutral masses** (i.e. the
  chemical formulas of the compounds, not considering any adducts).

## Author

Andrea Vicini

## Examples

``` r

## Get the substitution matrix calculated on HMDB
isotopicSubstitutionMatrix("HMDB_NEUTRAL")
```
