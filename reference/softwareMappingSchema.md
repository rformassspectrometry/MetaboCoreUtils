# Get mapping schema for name translation

Get the mapping schema as a `data.frame` that defines the mapping
between names of different software.

## Usage

``` r
softwareMappingSchema(path = NULL)
```

## Arguments

- path:

  Optional `character(1)` with the path to a custom mapping schema file
  in TSV format. If not provided, the default mapping schema defined in
  the package will be used. The file must have a header row with
  software names as names and the corresponding names as values.

## Value

A `data.frame` with the mapping schema.

## See also

Other name translation functions:
[`guessSource()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/guessSource.md),
[`nameMapping()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/nameMapping.md),
[`softwareMapping()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/softwareMapping.md),
[`translate()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/translate.md)

## Author

Gabriele Tomè

## Examples

``` r

softwareMappingSchema()
#>    RforMassSpectrometry                      MS-Dial       MetaboScape mzMine
#> 1         organism_name                         <NA>              <NA>     NA
#> 2      organism_lineage                         <NA>              <NA>     NA
#> 3           sample_link                         <NA>              <NA>     NA
#> 4                sample                         <NA>              <NA>     NA
#> 5                  <NA>                 Alignment ID        Feature ID     NA
#> 6                  <NA>                   Average Mz         m/z meas.     NA
#> 7                  <NA>               MS/MS included             MS/MS     NA
#> 8        retention_time              Average Rt(min)          RT [min]     NA
#> 9                  <NA>                         <NA>              <NA>     NA
#> 10                 <NA>                         <NA>              <NA>     NA
#> 11      retention_index                         <NA>              <NA>     NA
#> 12            Abundance                         <NA>              <NA>     NA
#> 13                 name              Metabolite name              Name     NA
#> 14                 <NA>                         <NA>              <NA>     NA
#> 15                inchi                         <NA>              <NA>     NA
#> 16             inchikey                     INCHIKEY              <NA>     NA
#> 17               smiles                       SMILES              <NA>     NA
#> 18              formula                         <NA> Molecular Formula     NA
#> 19                 <NA>                       Fill %              <NA>     NA
#> 20                 <NA>                         LINK              <NA>     NA
#> 21                 <NA>                  Dot product              <NA>     NA
#> 22                 <NA>          Reverse dot product              <NA>     NA
#> 23                 <NA>          Fragment presence %              <NA>     NA
#> 24                 <NA> Spectrum reference file name              <NA>     NA
#> 25                 <NA>                         <NA>       Annotations     NA
#> 26                 <NA>                         <NA>                AQ     NA
#> 27                 <NA>                         <NA> Annotation Source     NA
#> 28                 <NA>                         <NA>           Boxplot     NA
#> 29                 <NA>                         <NA>             Flags     NA
#> 30                 <NA>                         <NA>           Include     NA
#>                            mzTab-M       xcms Sirius <v6.0 Sirius >v6.0
#> 1                             <NA>       <NA>         <NA>         <NA>
#> 2                             <NA>       <NA>         <NA>         <NA>
#> 3                             <NA>       <NA>         <NA>         <NA>
#> 4                             <NA>       <NA>         <NA>         <NA>
#> 5                           SMF_ID feature_id    irgendwas   wasanderes
#> 6               exp_mass_to_charge      mzmed         <NA>         <NA>
#> 7                             <NA>       <NA>         <NA>         <NA>
#> 8        retention_time_in_seconds      rtmed         <NA>         <NA>
#> 9  retention_time_in_seconds_start       <NA>         <NA>         <NA>
#> 10   retention_time_in_seconds_end       <NA>         <NA>         <NA>
#> 11                            <NA>       <NA>         <NA>         <NA>
#> 12              abundance_assay[1]       <NA>         <NA>         <NA>
#> 13                   chemical_name       <NA>         <NA>         <NA>
#> 14             database_identifier       <NA>         <NA>         <NA>
#> 15                           inchi       <NA>         <NA>         <NA>
#> 16                            <NA>       <NA>         <NA>         <NA>
#> 17                          smiles       <NA>         <NA>         <NA>
#> 18                chemical_formula       <NA>         <NA>         <NA>
#> 19                            <NA>       <NA>         <NA>         <NA>
#> 20                            <NA>       <NA>         <NA>         <NA>
#> 21                            <NA>       <NA>         <NA>         <NA>
#> 22                            <NA>       <NA>         <NA>         <NA>
#> 23                            <NA>       <NA>         <NA>         <NA>
#> 24                            <NA>       <NA>         <NA>         <NA>
#> 25                            <NA>       <NA>         <NA>         <NA>
#> 26                            <NA>       <NA>         <NA>         <NA>
#> 27                            <NA>       <NA>         <NA>         <NA>
#> 28                            <NA>       <NA>         <NA>         <NA>
#> 29                            <NA>       <NA>         <NA>         <NA>
#> 30                            <NA>       <NA>         <NA>         <NA>
#>    MetFamily QFeatures Ontology Term
#> 1                   NA            NA
#> 2                   NA            NA
#> 3                   NA            NA
#> 4                   NA            NA
#> 5                   NA            NA
#> 6                   NA            NA
#> 7                   NA            NA
#> 8                   NA            NA
#> 9                   NA            NA
#> 10                  NA            NA
#> 11                  NA            NA
#> 12                  NA            NA
#> 13                  NA            NA
#> 14                  NA            NA
#> 15                  NA            NA
#> 16                  NA            NA
#> 17                  NA            NA
#> 18                  NA            NA
#> 19                  NA            NA
#> 20                  NA            NA
#> 21                  NA            NA
#> 22                  NA            NA
#> 23                  NA            NA
#> 24                  NA            NA
#> 25                  NA            NA
#> 26                  NA            NA
#> 27                  NA            NA
#> 28                  NA            NA
#> 29                  NA            NA
#> 30                  NA            NA
```
