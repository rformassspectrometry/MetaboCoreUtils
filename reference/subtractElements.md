# subtract two chemical formula

`subtractElements` subtracts one chemical formula from another.

## Usage

``` r
subtractElements(x, y)
```

## Arguments

- x:

  `character` strings with chemical formula

- y:

  `character` strings with chemical formula that should be subtracted
  from `x`

## Value

`character` Resulting formula

## Author

Michael Witting and Sebastian Gibb

## Examples

``` r

subtractElements("C6H12O6", "H2O")
#> [1] "C6H10O5"

subtractElements("C6H12O6", "NH3")
#> [1] NA
```
