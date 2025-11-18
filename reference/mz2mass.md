# Calculate neutral mass

`mz2mass` calculates the neutral mass from a given m/z value and adduct
definition.

Custom adduct definitions can be passed to the `adduct` parameter in
form of a `data.frame`. This `data.frame` is expected to have columns
`"mass_add"` and `"mass_multi"` defining the *additive* and
*multiplicative* part of the calculation. See
[`adducts()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md)
for examples.

## Usage

``` r
mz2mass(x, adduct = "[M+H]+")
```

## Arguments

- x:

  `numeric` m/z value for which the neutral mass shall be calculated.

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
are used as column names. Each column thus represents the neutral mass
of `x` for each defined `adduct`.

## See also

[`mass2mz()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/mass2mz.md)
for the reverse calculation,
[`adductNames()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md)
for supported adduct definitions.

## Author

Michael Witting, Johannes Rainer

## Examples

``` r

ion_mass <- c(100, 200, 300)
adduct <- "[M+H]+"

## Calculate m/z of [M+H]+ adduct from neutral mass
mz2mass(ion_mass, adduct)
#>         [M+H]+
#> [1,]  98.99272
#> [2,] 198.99272
#> [3,] 298.99272

ion_mass <- 100
adduct <- "[M+Na]+"

## Calculate m/z of [M+Na]+ adduct from neutral mass
mz2mass(ion_mass, adduct)
#>       [M+Na]+
#> [1,] 77.01078

## Provide a custom adduct definition.
adds <- data.frame(mass_add = c(1, 2, 3), mass_multi = c(1, 2, 0.5))
rownames(adds) <- c("a", "b", "c")
mz2mass(c(100, 200), adds)
#>        a  b   c
#> [1,]  99 49 194
#> [2,] 199 99 394
```
