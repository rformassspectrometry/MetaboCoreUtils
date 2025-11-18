# Standardize a chemical formula

`standardizeFormula` standardizes a supplied chemical formula according
to the Hill notation system.

## Usage

``` r
standardizeFormula(x)
```

## Arguments

- x:

  `character`, strings with the chemical formula to standardize.

## Value

`character` strings with the standardized chemical formula.

## See also

[`pasteElements()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/pasteElements.md)
[`countElements()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/countElements.md)

## Author

Michael Witting and Sebastian Gibb

## Examples

``` r

standardizeFormula("C6O6H12")
#>   C6O6H12 
#> "C6H12O6" 
```
