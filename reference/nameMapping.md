# Get mapping vector between two software

Get a named `character` vector that defines the mapping between names of
two software based on the mapping schema. The names of the returned
vector are the names of the `from` software and the values are the
corresponding names of the `to` software.

## Usage

``` r
nameMapping(
  from = character(),
  to = character(),
  map = softwareMappingSchema()
)
```

## Arguments

- from:

  `character(1)` with the name of the source software.

- to:

  `character(1)` with the name of the target software.

- map:

  Optional `data.frame` with a custom mapping schema. If not provided,
  the default mapping schema defined in the package will be used. The
  `data.frame` must contain the `from` and `to` parameter as columns
  names.

## Value

A named `character` vector with the mapping between the two software.

## See also

Other name translation functions:
[`guessSource()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/guessSource.md),
[`softwareMapping()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/softwareMapping.md),
[`softwareMappingSchema()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/softwareMappingSchema.md),
[`translate()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/translate.md)

## Author

Gabriele Tomè

## Examples

``` r

nameMapping(from = "MS-Dial", to = "mzTab-M")
#>                      Alignment ID                        Average Mz 
#>                          "SMF_ID"              "exp_mass_to_charge" 
#>                    MS/MS included                   Average Rt(min) 
#>                                NA       "retention_time_in_seconds" 
#>                              <NA>                              <NA> 
#> "retention_time_in_seconds_start"   "retention_time_in_seconds_end" 
#>                              <NA>                   Metabolite name 
#>              "abundance_assay[1]"                   "chemical_name" 
#>                              <NA>                              <NA> 
#>             "database_identifier"                           "inchi" 
#>                          INCHIKEY                            SMILES 
#>                                NA                          "smiles" 
#>                              <NA>                            Fill % 
#>                "chemical_formula"                                NA 
#>                              LINK                       Dot product 
#>                                NA                                NA 
#>               Reverse dot product               Fragment presence % 
#>                                NA                                NA 
#>      Spectrum reference file name 
#>                                NA 
```
