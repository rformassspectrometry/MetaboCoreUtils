# Calculate mass-to-charge ratio

`mass2mz` calculates the m/z value from a neutral mass and an adduct
definition.

Custom adduct definitions can be passed to the `adduct` parameter in
form of a `data.frame`. This `data.frame` is expected to have columns
`"mass_add"` and `"mass_multi"` defining the *additive* and
*multiplicative* part of the calculation. See
[`adducts()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md)
for examples.

## Usage

``` r
mass2mz(x, adduct = "[M+H]+")
```

## Arguments

- x:

  `numeric` neutral mass for which the adduct m/z shall be calculated.

- adduct:

  either a `character` specifying the name(s) of the adduct(s) for which
  the m/z should be calculated or a `data.frame` with the adduct
  definition. See
  [`adductNames()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md)
  for supported adduct names and the description for more information on
  the expected format if a `data.frame` is provided.

## Value

numeric `matrix` with same number of rows than elements in `x` and
number of columns being equal to the length of `adduct` (adduct names
are used as column names). Each column thus represents the m/z of `x`
for each defined `adduct`.

## See also

[`mz2mass()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/mz2mass.md)
for the reverse calculation,
[`adductNames()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md)
for supported adduct definitions.

## Author

Michael Witting, Johannes Rainer

## Examples

``` r

exact_mass <- c(100, 200, 250)
adduct <- "[M+H]+"

## Calculate m/z of [M+H]+ adduct from neutral mass
mass2mz(exact_mass, adduct)
#>        [M+H]+
#> [1,] 101.0073
#> [2,] 201.0073
#> [3,] 251.0073

exact_mass <- 100
adduct <- "[M+Na]+"

## Calculate m/z of [M+Na]+ adduct from neutral mass
mass2mz(exact_mass, adduct)
#>       [M+Na]+
#> [1,] 122.9892

## Calculate m/z of multiple adducts from neutral mass
mass2mz(exact_mass, adduct = adductNames())
#>      [M+3H]3+ [M+2H+Na]3+ [M+H+Na2]3+ [M+Na3]3+ [M+2H]2+ [M+H+NH4]2+ [M+H+K]2+
#> [1,] 34.34061    41.66792    48.99524  56.32255 51.00728    59.52055  69.98522
#>      [M+H+Na]2+ [M+C2H3N+2H]2+ [M+2Na]2+ [M+C4H6N2+2H]2+ [M+C6H9N3+2H]2+
#> [1,]   61.99825       71.52055  72.98922        92.03383        112.5471
#>        [M+H]+  [M+Li]+ [M+2Li-H]+ [M+NH4]+ [M+H2O+H]+  [M+Na]+ [M+CH4O+H]+
#> [1,] 101.0073 107.0155   113.0236 118.0338   119.0178 122.9892    133.0335
#>        [M+K]+ [M+C2H3N+H]+ [M+2Na-H]+ [M+C3H8O+H]+ [M+C2H3N+Na]+ [M+2K-H]+
#> [1,] 138.9632     142.0338   144.9712     161.0648      164.0158   176.919
#>      [M+C2H6OS+H]+ [M+C4H6N2+H]+  [2M+H]+ [2M+NH4]+ [2M+Na]+  [2M+K]+
#> [1,]      179.0212      183.0604 201.0073  218.0338 222.9892 238.9632
#>      [2M+C2H3N+H]+ [2M+C2H3N+Na]+  [3M+H]+ [M+H-NH3]+ [M+H-H2O]+
#> [1,]      242.0338       264.0158 301.0073   83.98073   82.99671
#>      [M+H-Hexose-H2O]+ [M+H-H4O2]+ [M+H-CH2O2]+ [M]+
#> [1,]         -61.04555    64.98615      55.0018  100

## Provide a custom adduct definition.
adds <- data.frame(mass_add = c(1, 2, 3), mass_multi = c(1, 2, 0.5))
rownames(adds) <- c("a", "b", "c")
mass2mz(c(100, 200), adds)
#>        a   b   c
#> [1,] 101 202  53
#> [2,] 201 402 103
```
