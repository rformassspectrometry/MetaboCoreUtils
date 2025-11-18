# Check if one formula is contained in another

`containsElements` checks if one sum formula is contained in another.

## Usage

``` r
containsElements(x, y)
```

## Arguments

- x:

  `character` strings with a chemical formula

- y:

  `character` strings with a chemical formula that shall be contained in
  `x`

## Value

`logical` TRUE if `y` is contained in `x`

## Author

Michael Witting and Sebastian Gibb

## Examples

``` r

containsElements("C6H12O6", "H2O")
#> [1] TRUE
containsElements("C6H12O6", "NH3")
#> [1] FALSE
```
