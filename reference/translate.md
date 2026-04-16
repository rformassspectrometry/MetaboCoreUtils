# Translate names based on a provided mapping

Map names from one software to another. The function replaces elements
in the input vector `x` with their corresponding values in the mapping
if a match is found. If an element in `x` does not have a corresponding
mapping, it is returned unchanged with a warning.

## Usage

``` r
translate(x = character(), mapping = NULL)
```

## Arguments

- x:

  `character` vector of names to be translated.

- mapping:

  A named `character` vector that defines the mapping for translation.
  The names of the vector should be the original names and the values
  should be the translated names.

## Value

A `character` vector with the translated names.

## See also

Other name translation functions:
[`guessSource()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/guessSource.md),
[`nameMapping()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/nameMapping.md),
[`softwareMapping()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/softwareMapping.md),
[`softwareMappingSchema()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/softwareMappingSchema.md)

## Author

Gabriele Tomè

## Examples

``` r

## MS-Dial names
x <- c("Average Rt(min)", "Alignment ID", "Average Mz")
map_vec <- nameMapping(from = "MS-Dial", to = "mzTab-M")
translate(x, mapping = map_vec)
#>             Average Rt(min)                Alignment ID 
#> "retention_time_in_seconds"                    "SMF_ID" 
#>                  Average Mz 
#>        "exp_mass_to_charge" 
```
