# Combine chemical formulae

`addElements` Add one chemical formula to another.

## Usage

``` r
addElements(x, y)
```

## Arguments

- x:

  `character` strings with chemical formula

- y:

  `character` strings with chemical formula that should be added from
  `x`

## Value

`character` Resulting formula

## Author

Michael Witting and Sebastian Gibb

## Examples

``` r

addElements("C6H12O6", "Na")
#> [1] "C6H12O6Na"

addElements("C6H12O6", c("Na", "H2O"))
#> [1] "C6H12O6Na" "C6H14O7"  
```
