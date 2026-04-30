# Get the charge of an adduct

`adductCharge()` returns the charge of an adduct.

## Usage

``` r
adductCharge(x)
```

## Arguments

- x:

  `character` with the adduct definition

## Value

`integer` of length equal to `x` with the charge of the adduct/ion.

## See also

Other adduct related functions:
[`adductFormula()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductFormula.md),
[`adductNames()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md),
[`formula2mz()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/formula2mz.md),
[`mass2mz()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/mass2mz.md),
[`mz2mass()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/mz2mass.md),
[`standardizeSingleCharge()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/standardizeSingleCharge.md)

## Examples

``` r

a <- c("[M+3H]3+", "[M+H]+", "[M-2H]2-", "[M-H]-")
adductCharge(a)
#> [1]  3  1 -2 -1
```
