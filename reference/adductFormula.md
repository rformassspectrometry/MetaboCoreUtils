# Calculate a table of adduct (ionic) formulas

`adductFormula` calculates the chemical formulas for the specified
adducts of provided chemical formulas.

## Usage

``` r
adductFormula(formulas, adduct = "[M+H]+", standardize = TRUE)
```

## Arguments

- formulas:

  `character` with molecular formulas for which adduct formulas should
  be calculated.

- adduct:

  `character` or `data.frame` of valid adduct. to be used. Custom adduct
  definitions can be provided via a `data.frame` but its format must
  follow
  [`adducts()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md)

- standardize:

  `logical(1)` whether to standardize the molecular formulas to the Hill
  notation system before calculating their mass.

## Value

`character` matrix with *formula* rows and *adducts* columns containing
all ion formulas. In case an ion can't be generated (eg. \[M-NH3+H\]+ in
a molecule that doesn't have nitrogen), a NA is returned instead.

## See also

[`adductNames()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md)
for a list of all available predefined adducts and
[`adducts()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md)
for the adduct `data.frame` definition style.

## Author

Roger Gine

## Examples

``` r

# Calculate the ion formulas of glucose with adducts [M+H]+, [M+Na]+ and [M+K]+
adductFormula("C6H12O6", c("[M+H]+", "[M+Na]+", "[M+K]+"))
#>         [M+H]+       [M+Na]+        [M+K]+       
#> C6H12O6 "[C6H13O6]+" "[C6H12O6Na]+" "[C6H12O6K]+"

# > "[C6H13O6]+" "[C6H12O6Na]+" "[C6H12O6K]+"

# Use a custom set of adduct definitions (For instance, a iron (Fe2+) adduct)
custom_ads <- data.frame(name = "[M+Fe]2+", mass_multi = 0.5, charge = 2,
                         formula_add = "Fe", formula_sub = "C0",
                         positive = "TRUE")
adductFormula("C6H12O6", custom_ads)
#>         1              
#> C6H12O6 "[C6H12O6Fe]2+"
```
