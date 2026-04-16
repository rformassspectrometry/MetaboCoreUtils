# Get supported software for name translation

Get the names of the supported software defined in the default mapping
schema

## Usage

``` r
softwareMapping()
```

## Value

A `character` vector with the names of the supported software.

## See also

Other name translation functions:
[`guessSource()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/guessSource.md),
[`nameMapping()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/nameMapping.md),
[`softwareMappingSchema()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/softwareMappingSchema.md),
[`translate()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/translate.md)

## Author

Gabriele Tomè

## Examples

``` r

softwareMapping()
#>  [1] "RforMassSpectrometry" "MS-Dial"              "MetaboScape"         
#>  [4] "mzMine"               "mzTab-M"              "xcms"                
#>  [7] "Sirius <v6.0"         "Sirius >v6.0"         "MetFamily QFeatures" 
#> [10] "Ontology Term"       
```
