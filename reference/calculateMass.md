# Calculate exact mass

`calculateMass` calculates the exact mass from a formula. Isotopes are
also supported. For isotopes, the isotope type needs to be specified as
an element's prefix, e.g. `"[13C]"` for carbon 13 or `"[2H]"` for
deuterium. A formula with 2 carbon 13 isotopes and 3 carbons would thus
contain e.g. `"[13C2]C3"`.

## Usage

``` r
calculateMass(x)
```

## Arguments

- x:

  `character` representing chemical formula(s) or a `list ` of `numeric`
  with element counts such as returned by
  [`countElements()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/countElements.md).
  Isotopes and deuterated elements are supported (see examples below).

## Value

`numeric` Resulting exact mass.

## Author

Michael Witting

## Examples

``` r

calculateMass("C6H12O6")
#>  C6H12O6 
#> 180.0634 
calculateMass("NH3")
#>      NH3 
#> 17.02655 
calculateMass(c("C6H12O6", "NH3"))
#>   C6H12O6       NH3 
#> 180.06339  17.02655 

## Calculate masses for formulas containing isotope information.
calculateMass(c("C6H12O6", "[13C3]C3H12O6"))
#>       C6H12O6 [13C3]C3H12O6 
#>      180.0634      183.0735 

## Calculate mass for a chemical with 5 deuterium.
calculateMass("C11[2H5]H7N2O2")
#> C11[2H5]H7N2O2 
#>       209.1213 
```
