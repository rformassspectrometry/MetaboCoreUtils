# Metabolomics adduct mass (m/z) and monoisotopic mass calculator

`MetaboCoreUtilsAdduct` main functions:
- Calculate adduct m/z using monoisotopic mass and adduct type in a long or wide format.
- Calculate m/z to monoisotopic mass using m/z and adduct type.
- Calculate monoisotopic mass using chemical formula
- Calculate adduct chemical formula using adduct type and neutral chemical formula


# Installation

The package can be installed with

```r
install.packages("devtools") #If you don't have "devtools" installed already
devtools::install_github("jamesjiadazhan/MetaboCoreUtilsAdduct") # Install the package from GitHub
```



Currently supported adduct types:
- [1] "M+3H"           "M+2H+Na"        "M+H+Na2"        "M+Na3"          "M+2H"           "M+H+NH4"        "M+H+K"          "M+H+Na"         "M+C2H3N+2H"    
- [10] "M+2Na"          "M+C4H6N2+2H"    "M+C6H9N3+2H"    "M+H"            "M+Li"           "M+2Li-H"        "M+NH4"          "M+H2O+H"        "M+Na"          
- [19] "M+CH4O+H"       "M+K"            "M+C2H3N+H"      "M+2Na-H"        "M+C3H8O+H"      "M+C2H3N+Na"     "M+2K-H"         "M+C2H6OS+H"     "M+C4H6N2+H"    
- [28] "2M+H"           "2M+NH4"         "2M+Na"          "2M+K"           "2M+C2H3N+H"     "2M+C2H3N+Na"    "3M+H"           "M-3H"           "M-2H"          
- [37] "M-H"            "M+Na-2H"        "M+Cl"           "M+K-2H"         "M+C2H3N-H"      "M+CHO2"         "M+C2H3O2"       "M+Br"           "M+C2F3O2"      
- [46] "2M-H"           "2M+CHO2"        "2M+C2H3O2"      "3M-H"           "M+H-NH3"        "M+H-H2O"        "M+H-Hexose-H2O" "M-H+HCOONa"     "M+H-H4O2"      
- [55] "M+H-CH2O2"      "M+H+2Na"        "M+3Na"          "M+ACN+2H"       "M+2ACN+2H"      "M+3ACN+2H"      "M+CH3OH+H"      "M+ACN+H"        "M+IsoProp+H"   
- [64] "M+ACN+Na"       "M+DMSO+H"       "M+2ACN+H"       "M+IsoProp+Na+H" "2M+ACN+H"       "2M+ACN+Na"      "M-H2O-H"        "M+FA-H"         "M+Hac-H"       
- [73] "M+TFA-H"        "2M+FA-H"        "2M+Hac-H"


## Below are examples of the functions in the MetaboCoreUtilsAdduct package. Leucine and taurine are used in the examples
![image](https://github.com/jamesjiadazhan/MetaboCoreUtilsAdduct/assets/108076575/0cc99bee-8796-4361-8254-351648d2b72d)
![image](https://github.com/jamesjiadazhan/MetaboCoreUtilsAdduct/assets/108076575/8c15e33e-0bc3-41c0-94bc-8dd8bbf4d3a2)



### mass2mz_df(): this function calculates theoretical adduct m/z and return the result in the long format. 
- This means you have to provide pairs of mass and adduct at the same time. There is no combination calculation here. It works best for data frames

mass is the column name with all monoisotopic mass values.
Adduct is the column name with all adduct types

```r

r$> masses <- c(131.0946, 125.0147)
    adducts <- c("M+Na", "M+H")
    mass2mz_df(masses, adducts)
      mass adduct adduct_mass
1 131.0946   M+Na    154.0838
2 125.0147    M+H    126.0220

```

### mass2mz(): this function calculates theoretical adduct m/z and return the result in the wide format. 
- Thus, if each mass is provided, all theoretical adduct m/z for different adduct types will be produced. This means you can do combination calculations here. It works best for individual data.
```
r$> masses <- c(131.0946, 125.0147)
    adducts <- c("M+Na", "M+H", "M+2H", "M+H-H2O")
    mass2mz(x=masses, adduct=adducts, custom_adduct = NULL)
      mass     M+2H      M+H     M+Na  M+H-H2O
1 131.0946 66.55458 132.1019 154.0838 114.0913
2 125.0147 63.51463 126.0220 148.0039 108.0114
```

- Advanced: you can provide your own custom adduct in the following format and pass it to the custom_adduct parameter
```
r$> adduct_definition
             name mass_multi    mass_add formula_add formula_sub charge positive
1            M+3H  0.3333333    1.007276          H3          C0      3     TRUE
2         M+2H+Na  0.3333333    8.334591        H2Na          C0      3     TRUE
3         M+H+Na2  0.3333333   15.661905        HNa2          C0      3     TRUE
4           M+Na3  0.3333333   22.989220         Na3          C0      3     TRUE
5            M+2H  0.5000000    1.007276          H2          C0      2     TRUE
6         M+H+NH4  0.5000000    9.520553         NH5          C0      2     TRUE
7           M+H+K  0.5000000   19.985218          HK          C0      2     TRUE
8          M+H+Na  0.5000000   11.998248         HNa          C0      2     TRUE
9      M+C2H3N+2H  0.5000000   21.520551       C2H5N          C0      2     TRUE
10          M+2Na  0.5000000   22.989220         Na2          C0      2     TRUE
11    M+C4H6N2+2H  0.5000000   42.033826      C4H8N2          C0      2     TRUE
12    M+C6H9N3+2H  0.5000000   62.547101     C6H11N3          C0      2     TRUE
13            M+H  1.0000000    1.007276           H          C0      1     TRUE
```


### mz2mass(): this function calculates monoisotopic mass using m/z and adduct type
```
r$> mz <- c(132.1019, 126.0220)
    adducts <- c("M+H")
    mz2mass(mz, adducts)
          M+H
[1,] 131.0946
[2,] 125.0147
```

### calculateMass(): this function calculates monoisotopic mass using chemical formula
```
r$> formula_exp = c("C6H13NO2", "C2H7NO3S")
    calculateMass(formula_exp)
C6H13NO2 C2H7NO3S 
131.0946 125.0147 
```

### formula2mz(): this function calcualtes m/z using chemical formula and adduct type
```
r$> formula_exp = c("C6H13NO2", "C2H7NO3S")
    adducts <- c("M+H")
    formula2mz(formula_exp, adducts)
             mass      M+H
C6H13NO2 131.0946 132.1019
C2H7NO3S 125.0147 126.0219
```

### adductFormula(): this function gets the adduct chemical formula for a given adduct type and neutral chemical formula. This may help distinguish those neutral monoisotopic masses from those "adduct monoisotopic mass" (M+ vs. M+H)
```
r$> formula_exp = c("C6H13NO2", "C2H7NO3S")
    adducts <- c("M+H")
    adductFormula(formula_exp, adducts)
         1            
C6H13NO2 "[C6H14NO2]+"
C2H7NO3S "[C2H8NO3S]+"
```


References:
- https://fiehnlab.ucdavis.edu/staff/kind/metabolomics/ms-adduct-calculator/
- https://github.com/rformassspectrometry/MetaboCoreUtils
