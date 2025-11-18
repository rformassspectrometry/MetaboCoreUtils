# Count elements in a chemical formula

`countElements` parses strings representing a chemical formula into a
named vector of element counts.

## Usage

``` r
countElements(x)
```

## Arguments

- x:

  [`character()`](https://rdrr.io/r/base/character.html) representing a
  chemical formula.

## Value

`list` of `integer` with the element counts (names being elements).

## See also

[`pasteElements()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/pasteElements.md)

## Author

Michael Witting and Sebastian Gibb

## Examples

``` r
countElements(c("C6H12O6", "C11H12N2O2"))
#> $C6H12O6
#>  C  H  O 
#>  6 12  6 
#> 
#> $C11H12N2O2
#>  C  H  N  O 
#> 11 12  2  2 
#> 
```
