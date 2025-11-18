# Multiply chemical formulas by a scalar

`multiplyElements` Multiply the number of atoms of each element by a
constant, positive, integer

## Usage

``` r
multiplyElements(x, k)
```

## Arguments

- x:

  `character` strings with chemical formula

- k:

  `numeric(1)` positive integer by which each formula will be
  multiplied.

## Value

`character` strings with the standardized chemical formula.

## Author

Roger Gine

## Examples

``` r

multiplyElements("H2O", 3)
#> [1] "H6O3"

multiplyElements(c("C6H12O6", "Na", "CH4O"), 2)
#> [1] "C12H24O12" "Na2"       "C2H8O2"   
```
