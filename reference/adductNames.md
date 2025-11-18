# Retrieve names of supported adducts

`adductNames` returns all supported adduct definitions that can be used
by
[`mass2mz()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/mass2mz.md)
and
[`mz2mass()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/mz2mass.md).

`adducts` returns a `data.frame` with the adduct definitions.

## Usage

``` r
adductNames(polarity = c("positive", "negative"))

adducts(polarity = c("positive", "negative"))
```

## Arguments

- polarity:

  `character(1)` defining the ion mode, either `"positive"` or
  `"negative"`.

## Value

for `adductNames`: `character` vector with all valid adduct names for
the selected ion mode. For `adducts`: `data.frame` with the adduct
definitions.

## Author

Michael Witting, Johannes Rainer

## Examples

``` r

## retrieve names of adduct names in positive ion mode
adductNames(polarity = "positive")
#>  [1] "[M+3H]3+"          "[M+2H+Na]3+"       "[M+H+Na2]3+"      
#>  [4] "[M+Na3]3+"         "[M+2H]2+"          "[M+H+NH4]2+"      
#>  [7] "[M+H+K]2+"         "[M+H+Na]2+"        "[M+C2H3N+2H]2+"   
#> [10] "[M+2Na]2+"         "[M+C4H6N2+2H]2+"   "[M+C6H9N3+2H]2+"  
#> [13] "[M+H]+"            "[M+Li]+"           "[M+2Li-H]+"       
#> [16] "[M+NH4]+"          "[M+H2O+H]+"        "[M+Na]+"          
#> [19] "[M+CH4O+H]+"       "[M+K]+"            "[M+C2H3N+H]+"     
#> [22] "[M+2Na-H]+"        "[M+C3H8O+H]+"      "[M+C2H3N+Na]+"    
#> [25] "[M+2K-H]+"         "[M+C2H6OS+H]+"     "[M+C4H6N2+H]+"    
#> [28] "[2M+H]+"           "[2M+NH4]+"         "[2M+Na]+"         
#> [31] "[2M+K]+"           "[2M+C2H3N+H]+"     "[2M+C2H3N+Na]+"   
#> [34] "[3M+H]+"           "[M+H-NH3]+"        "[M+H-H2O]+"       
#> [37] "[M+H-Hexose-H2O]+" "[M+H-H4O2]+"       "[M+H-CH2O2]+"     
#> [40] "[M]+"             

## retrieve names of adduct names in negative ion mode
adductNames(polarity = "negative")
#>  [1] "[M-3H]3-"      "[M-2H]2-"      "[M-H]-"        "[M+Na-2H]-"   
#>  [5] "[M+Cl]-"       "[M+K-2H]-"     "[M+C2H3N-H]-"  "[M+CHO2]-"    
#>  [9] "[M+C2H3O2]-"   "[M+Br]-"       "[M+C2F3O2]-"   "[2M-H]-"      
#> [13] "[2M+CHO2]-"    "[2M+C2H3O2]-"  "[3M-H]-"       "[M-H+HCOONa]-"
#> [17] "[M]-"         
```
