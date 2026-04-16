# Guess the source of names

Guess the source of names based on predefined mappings. The function
counts how many elements in the input vector `x` match the names defined
in the mapping schema for each software and returns the software with
the highest match count.

## Usage

``` r
guessSource(x = character(), map = softwareMappingSchema())
```

## Arguments

- x:

  A `character` vector of names for which the source should be guessed.

- map:

  Optional `data.frame` with a custom mapping schema. If not provided,
  the default mapping schema defined in the package will be used. The
  `data.frame` must contain the software names as column names and the
  corresponding names as values.

## Value

A `character(1)` with the name of the guessed source software.

## See also

Other name translation functions:
[`nameMapping()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/nameMapping.md),
[`softwareMapping()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/softwareMapping.md),
[`softwareMappingSchema()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/softwareMappingSchema.md),
[`translate()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/translate.md)

## Author

Gabriele Tomè

## Examples

``` r

## MS-Dial names
x <- c("Average Rt(min)", "Alignment ID", "Average Mz")
guessSource(x)
#> [1] "MS-Dial"
```
