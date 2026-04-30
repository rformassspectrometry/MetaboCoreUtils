# Fix short-hand charge notation in adduct definition

`standardizeSingleCharge()` replaces the short-hand notation of single
charges eventually present in adduct definition with the *standard*
notion, i.e., it replaces `"+"` with `"1+"` in e.g. `"[M+H]+"` and `"-"`
with `"1-"` in `"[M-H]-"`.

## Usage

``` r
standardizeSingleCharge(x)
```

## Arguments

- x:

  `character` with adduct definitions

## Value

`character` with standardized single charge definitions.

## See also

Other adduct related functions:
[`adductCharge()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductCharge.md),
[`adductFormula()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductFormula.md),
[`adductNames()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/adductNames.md),
[`formula2mz()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/formula2mz.md),
[`mass2mz()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/mass2mz.md),
[`mz2mass()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/mz2mass.md)

## Examples

``` r

a <- c("[M+H]+", "[M-H]-", "[M+H]1+")
standardizeSingleCharge(a)
#> [1] "[M+H]1+" "[M-H]1-" "[M+H]1+"
```
