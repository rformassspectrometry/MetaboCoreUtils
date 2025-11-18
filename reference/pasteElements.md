# Create chemical formula from a named vector

`pasteElements` creates a chemical formula from element counts (such as
returned by
[`countElements()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/countElements.md)).

## Usage

``` r
pasteElements(x)
```

## Arguments

- x:

  `list`/`integer` with element counts, names being individual elements.

## Value

[`character()`](https://rdrr.io/r/base/character.html) with the chemical
formulas.

## See also

[`countElements()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/countElements.md)

## Author

Michael Witting and Sebastian Gibb

## Examples

``` r

elements <- c("C" = 6, "H" = 12, "O" = 6)
pasteElements(elements)
#> [1] "C6H12O6"
```
