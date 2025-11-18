# Calculate mass-to-charge ratio from a formula

`formula2mz` calculates the m/z values from a list of molecular formulas
and adduct definitions.

Custom adduct definitions can be passed to the `adduct` parameter in
form of a `data.frame`. This `data.frame` is expected to have columns
`"mass_add"` and `"mass_multi"` defining the *additive* and
*multiplicative* part of the calculation. See
[`adducts()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md)
for examples.

## Usage

``` r
formula2mz(formula, adduct = "[M+H]+", standardize = TRUE)
```

## Arguments

- formula:

  `character` with one or more valid molecular formulas for which their
  adduct m/z shall be calculated.

- adduct:

  either a `character` specifying the name(s) of the adduct(s) for which
  the m/z should be calculated or a `data.frame` with the adduct
  definition. See
  [`adductNames()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md)
  for supported adduct names and the description for more information on
  the expected format if a `data.frame` is provided.

- standardize:

  `logical` whether to standardize the molecular formulas to the Hill
  notation system before calculating their mass.

## Value

Numeric `matrix` with same number of rows than elements in `formula` and
number of columns being equal to the length of `adduct` (adduct names
are used as column names). Each column thus represents the m/z of
`formula` for each defined `adduct`.

## Author

Roger Gine

## Examples

``` r
## Calculate m/z values of adducts of a list of formulas
formulas <- c("C6H12O6", "C9H11NO3", "C16H13ClN2O")
ads <- c("[M+H]+", "[M+Na]+", "[2M+H]+", "[M]+")
formula2mz(formulas, ads)
#>               [M+H]+  [M+Na]+  [2M+H]+     [M]+
#> C6H12O6     181.0707 203.0526 361.1341 180.0634
#> C9H11NO3    182.0812 204.0631 363.1551 181.0739
#> C16H13N2OCl 285.0789 307.0609 569.1506 284.0716
formula2mz(formulas, adductNames()) #All available adducts
#>             [M+3H]3+ [M+2H+Na]3+ [M+H+Na2]3+ [M+Na3]3+  [M+2H]2+ [M+H+NH4]2+
#> C6H12O6     61.02841    68.35572    75.68303  83.01035  91.03897    99.55225
#> C9H11NO3    61.36524    68.69256    76.01987  83.34718  91.54422   100.05750
#> C16H13N2OCl 95.69782   103.02514   110.35245 117.67977 143.04310   151.55637
#>             [M+H+K]2+ [M+H+Na]2+ [M+C2H3N+2H]2+ [M+2Na]2+ [M+C4H6N2+2H]2+
#> C6H12O6      110.0169   102.0299       111.5522  113.0209        132.0655
#> C9H11NO3     110.5222   102.5352       112.0575  113.5262        132.5708
#> C16H13N2OCl  162.0210   154.0341       163.5564  165.0250        184.0696
#>             [M+C6H9N3+2H]2+   [M+H]+  [M+Li]+ [M+2Li-H]+ [M+NH4]+ [M+H2O+H]+
#> C6H12O6            152.5788 181.0707 187.0788   193.0870 198.0972   199.0812
#> C9H11NO3           153.0840 182.0812 188.0893   194.0975 199.1077   200.0917
#> C16H13N2OCl        204.5829 285.0789 291.0871   297.0953 302.1055   303.0895
#>              [M+Na]+ [M+CH4O+H]+   [M+K]+ [M+C2H3N+H]+ [M+2Na-H]+ [M+C3H8O+H]+
#> C6H12O6     203.0526    213.0969 219.0265     222.0972   225.0346     241.1282
#> C9H11NO3    204.0631    214.1074 220.0371     223.1077   226.0451     242.1387
#> C16H13N2OCl 307.0609    317.1051 323.0348     326.1055   329.0428     345.1364
#>             [M+C2H3N+Na]+ [M+2K-H]+ [M+C2H6OS+H]+ [M+C4H6N2+H]+  [2M+H]+
#> C6H12O6          244.0792  256.9824      259.0846      263.1238 361.1341
#> C9H11NO3         245.0897  257.9929      260.0951      264.1343 363.1551
#> C16H13N2OCl      348.0874  360.9907      363.0929      367.1320 569.1506
#>             [2M+NH4]+ [2M+Na]+  [2M+K]+ [2M+C2H3N+H]+ [2M+C2H3N+Na]+  [3M+H]+
#> C6H12O6      378.1606 383.1160 399.0899      402.1606       424.1425 541.1974
#> C9H11NO3     380.1816 385.1370 401.1109      404.1816       426.1636 544.2290
#> C16H13N2OCl  586.1771 591.1325 607.1064      610.1771       632.1591 853.2222
#>             [M+H-NH3]+ [M+H-H2O]+ [M+H-Hexose-H2O]+ [M+H-H4O2]+ [M+H-CH2O2]+
#> C6H12O6       164.0441   163.0601          19.01783    145.0495     135.0652
#> C9H11NO3      165.0546   164.0706          20.02834    146.0600     136.0757
#> C16H13N2OCl   268.0524   267.0684         123.02609    249.0578     239.0734
#>                 [M]+
#> C6H12O6     180.0634
#> C9H11NO3    181.0739
#> C16H13N2OCl 284.0716

## Use custom-defined adducts as input
custom_ads <- data.frame(mass_add = c(1, 2, 3), mass_multi = c(1, 2, 0.5))
formula2mz(formulas, custom_ads)
#>                    1        2         3
#> C6H12O6     181.0634 362.1268  93.03169
#> C9H11NO3    182.0739 364.1478  93.53695
#> C16H13N2OCl 285.0716 570.1433 145.03582

## Use standardize = FALSE to keep formula unaltered
formula2mz("H12C6O6")
#>           [M+H]+
#> C6H12O6 181.0707
formula2mz("H12C6O6", standardize = FALSE)
#>           [M+H]+
#> H12C6O6 181.0707
```
