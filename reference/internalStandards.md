# Get definitions for internal standards

`internalStandards` returns a table with metabolite standards available
in commercial internal standard mixes. The returned data frame contains
the following columns:

- `"name"`: the name of the standard

- `"formula_salt"`: chemical formula of the salt that was used to
  produce the standard mix

- `"formula_metabolite"`: chemical formula of the metabolite in free
  form

- `"smiles_salt"`: SMILES of the salt that was used to produced the
  standard mix

- `"smiles_metabolite"`: SMILES of the metabolite in free form

- `"mol_weight_salt"`: molecular (average) weight of the salt (can be
  used for calculation of molar concentration, etc.)

- `"exact_mass_metabolite"`: exact mass of free metabolites

- `"conc"`: concentration of the metabolite in ug/mL (of salt form)

- `"mix"`: name of internal standard mix

## Usage

``` r
internalStandards(mix = "QReSS")
```

## Arguments

- mix:

  `character(1)` Name of the internal standard mix that shall be
  returned. One of
  [`internalStandardMixNames()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/internalStandardMixNames.md).

## Value

`data.frame` data on internal standards

## See also

[`internalStandardMixNames()`](https://rformassspectrometry.github.io/MetaboCoreUtils/reference/internalStandardMixNames.md)
for provided internal standard mixes.

## Author

Michael Witting

## Examples

``` r

internalStandards(mix = "QReSS")
#>                                                              name
#> 1                                 L-Alanine (13C3, 99%; 15N, 99%)
#> 2                1,4-Butanediamine (putrescine)Â·2HCl (13C4, 99%)
#> 3                                   Creatinine (N-methyl-D3, 98%)
#> 4                             EthanolamineÂ·HCl (1,1,2,2-D4, 98%)
#> 5                                  GuanosineÂ·2H2O (15N5, 96-98%)
#> 6                                        Hypoxanthine (13C5, 99%)
#> 7                                           L-Leucine (13C6, 99%)
#> 8                                L-Phenylalanine (ring-13C6, 99%)
#> 9                                         Thymine (1,3-15N2, 98%)
#> 10                                      L-Tryptophan (13C11, 99%)
#> 11                                    L-Tyrosine (ring-13C6, 99%)
#> 12                          Vitamin B3 (nicotinamide) (13C6, 99%)
#> 13                         Citric acid (1,5,6-carboxyl-13C3, 99%)
#> 14                                       Fumaric acid (13C4, 99%)
#> 15                        Indole-3-acetic acid (phenyl-13C6, 99%)
#> 16 Î±-Ketoglutaric acid, disodium salt (1,2,3,4-13C4, 99%) CP 97%
#> 17                                Sodium palmitate (U-13C16, 98%)
#> 18                                    Sodium pyruvate (13C3, 99%)
#>      formula_salt formula_metabolite
#> 1     [13C]3H7NO2        [13C]3H7NO2
#> 2  [13C]4H14Cl2N2        [13C]4H12N2
#> 3       C4H4D3N3O          C4H4D3N3O
#> 4        C2H8ClNO             C2H7NO
#> 5  C10H17[15N]5O7     C10H13[15N]5O5
#> 6     [13C]5H4N4O        [13C]5H4N4O
#> 7    [13C]6H13NO2       [13C]6H13NO2
#> 8  C3[13C]6H11NO2     C3[13C]6H11NO2
#> 9    C5H6[15N]2O2       C5H6[15N]2O2
#> 10 [13C]11H12N2O2     [13C]11H12N2O2
#> 11 C3[13C]6H11NO3     C3[13C]6H11NO3
#> 12    [13C]6H5NO2        [13C]6H5NO2
#> 13   C3[13C]3H8O7       C3[13C]3H8O7
#> 14     [13C]4H4O4         [13C]4H4O4
#> 15  C4[13C]6H9NO2      C4[13C]6H9NO2
#> 16 C[13C]4H4Na2O5        C[13C]4H6O5
#> 17 [13C]16H31NaO2       [13C]16H32O2
#> 18   [13C]3H3NaO3         [13C]3H4O3
#>                                                                                                                     smiles_salt
#> 1                                                                                                   [13CH3][13C@H](N)[13C](O)=O
#> 2                                                                          [Cl-].[Cl-].[NH3+][13CH2][13CH2][13CH2][13CH2][NH3+]
#> 3                                                                                                [2H]C([2H])([2H])N1CC(=O)N=C1N
#> 4                                                                                           [Cl-].[H]C([H])([NH3+])C([H])([H])O
#> 5                                           O.O.[15NH2]C1=[15N]C2=C([15N]=C[15N]2[C@@H]2O[C@H](CO)[C@@H](O)[C@H]2O)C(=O)[15NH]1
#> 6                                                                                      O=[13C]1N=[13CH]N[13C]2=[13C]1N[13CH]=N2
#> 7                                                                             [13CH3][13CH]([13CH3])[13CH2][13C@H](N)[13C](O)=O
#> 8                                                                      N[C@@H](C[13C]1=[13CH][13CH]=[13CH][13CH]=[13CH]1)C(O)=O
#> 9                                                                                                    CC1=C[15NH]C(=O)[15NH]C1=O
#> 10                                           N[13C@@H]([13CH2][13C]1=[13CH]N[13C]2=[13C]1[13CH]=[13CH][13CH]=[13CH]2)[13C](O)=O
#> 11                                                                   N[C@@H](C[13C]1=[13CH][13CH]=[13C](O)[13CH]=[13CH]1)C(O)=O
#> 12                                                                                O[13C](=O)[13C]1=[13CH][13CH]=[13CH]N=[13CH]1
#> 13                                                                                       O[13C](=O)CC(O)(C[13C](O)=O)[13C](O)=O
#> 14                                                                                        O[13C](=O)\\[13CH]=[13CH]\\[13C](O)=O
#> 15                                                                         OC(=O)CC1=CN[13C]2=[13CH][13CH]=[13CH][13CH]=[13C]12
#> 16                                                                    [Na+].[Na+].[O-]C(=O)[13CH2][13CH2][13C](=O)[13C]([O-])=O
#> 17 [Na+].[13CH3][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13C]([O-])=O
#> 18                                                                                          [Na+].[13CH3][13C](=O)[13C]([O-])=O
#>                                                                                                      smiles_metabolite
#> 1                                                                                          [13CH3][13C@H](N)[13C](O)=O
#> 2                                                                                       N[13CH2][13CH2][13CH2][13CH2]N
#> 3                                                                                       [2H]C([2H])([2H])N1CC(=O)N=C1N
#> 4                                                                                             [H]C([H])(N)C([H])([H])O
#> 5                                      [15NH2]C1=[15N]C2=C([15N]=C[15N]2[C@@H]2O[C@H](CO)[C@@H](O)[C@H]2O)C(=O)[15NH]1
#> 6                                                                             O=[13C]1N=[13CH]N[13C]2=[13C]1N[13CH]=N2
#> 7                                                                    [13CH3][13CH]([13CH3])[13CH2][13C@H](N)[13C](O)=O
#> 8                                                             N[C@@H](C[13C]1=[13CH][13CH]=[13CH][13CH]=[13CH]1)C(O)=O
#> 9                                                                                           CC1=C[15NH]C(=O)[15NH]C1=O
#> 10                                  N[13C@@H]([13CH2][13C]1=[13CH]N[13C]2=[13C]1[13CH]=[13CH][13CH]=[13CH]2)[13C](O)=O
#> 11                                                          N[C@@H](C[13C]1=[13CH][13CH]=[13C](O)[13CH]=[13CH]1)C(O)=O
#> 12                                                                       O[13C](=O)[13C]1=[13CH][13CH]=[13CH]N=[13CH]1
#> 13                                                                              O[13C](=O)CC(O)(C[13C](O)=O)[13C](O)=O
#> 14                                                                               O[13C](=O)\\[13CH]=[13CH]\\[13C](O)=O
#> 15                                                                OC(=O)CC1=CN[13C]2=[13CH][13CH]=[13CH][13CH]=[13C]12
#> 16                                                                             OC(=O)[13CH2][13CH2][13C](=O)[13C](O)=O
#> 17 [13CH3][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13CH2][13C](O)=O
#> 18                                                                                          [13CH3][13C](=O)[13C](O)=O
#>    mol_weight_salt exact_mass_metabolite conc   mix
#> 1           92.071              92.05774  100 QReSS
#> 2          165.040              92.11347   10 QReSS
#> 3          116.138             116.07774  100 QReSS
#> 4           97.540              61.05276   10 QReSS
#> 5          324.240             288.07684    2 QReSS
#> 6          141.076             141.05528   10 QReSS
#> 7          137.129             137.11476    5 QReSS
#> 8          171.146             171.09911  100 QReSS
#> 9          128.101             128.03700   20 QReSS
#> 10         215.145             215.12678  100 QReSS
#> 11         187.145             187.09402  100 QReSS
#> 12         129.065             129.05216    5 QReSS
#> 13         195.100             195.03707   10 QReSS
#> 14         120.041             120.02438  100 QReSS
#> 15         181.141             181.08346    5 QReSS
#> 16         194.031             150.03494  100 QReSS
#> 17         294.289             272.29391   10 QReSS
#> 18         113.021              91.02611  100 QReSS
internalStandards(mix = "UltimateSplashOne")
#>                                 name    formula_salt formula_metabolite
#> 1               14:0-13:0-14:0 TG-d5      C44H79D5O6         C44H79D5O6
#> 2               14:0-15:1-14:0 TG-d5      C46H81D5O6         C46H81D5O6
#> 3               14:0-17:1-14:0 TG-d5      C48H85D5O6         C48H85D5O6
#> 4               16:0-15:1-16:0 TG-d5      C50H89D5O6         C50H89D5O6
#> 5               16:0-17:1-16:0 TG-d5      C52H93D5O6         C52H93D5O6
#> 6               16:0-19:2-16:0 TG-d5      C54H95D5O6         C54H95D5O6
#> 7               18:1-17:1-18:1 TG-d5      C56H97D5O6         C56H97D5O6
#> 8               18:1-19:2-18:1 TG-d5      C58H99D5O6         C58H99D5O6
#> 9               18:1-21:2-18:1 TG-d5     C60H103D5O6        C60H103D5O6
#> 10         14:1 cholesteryl-d7 ester      C41H63D7O2         C41H63D7O2
#> 11         16:1 cholesteryl-d7 ester      C43H67D7O2         C43H67D7O2
#> 12         18:1 cholesteryl-d7 ester      C45H71D7O2         C45H71D7O2
#> 13         20:3 cholesteryl-d7 ester      C47H71D7O2         C47H71D7O2
#> 14         22:4 cholesteryl-d7 ester      C49H73D7O2         C49H73D7O2
#> 15 C16:1 Ceramide-d7 (d18:1-d7/16:1)     C34H58D7NO3        C34H58D7NO3
#> 16 C18:1 Ceramide-d7 (d18:1-d7/18:1)     C36H62D7NO3        C36H62D7NO3
#> 17 C20:1 Ceramide-d7 (d18:1-d7/20:1)     C38H66D7NO3        C38H66D7NO3
#> 18 C22:1 Ceramide-d7 (d18:1-d7/22:1)     C40H70D7NO3        C40H70D7NO3
#> 19 C24:1 Ceramide-d7 (d18:1-d7/24:1)     C42H74D7NO3        C42H74D7NO3
#> 20           16:1 SM (d18:1/16:1)-d9   C39H68D9N2O6P      C39H68D9N2O6P
#> 21           18:1 SM (d18:1/18:1)-d9   C41H72D9N2O6P      C41H72D9N2O6P
#> 22           20:1 SM (d18:1/20:1)-d9   C43H76D9N2O6P      C43H76D9N2O6P
#> 23           22:1 SM (d18:1/22:1)-d9   C45H80D9N2O6P      C45H80D9N2O6P
#> 24           24:1 SM (d18:1/24:1)-d9   C47H84D9N2O6P      C47H84D9N2O6P
#> 25                   17:0-14:1 PC-d5    C39H71D5NO8P       C39H71D5NO8P
#> 26                   17:0-16:1 PC-d5    C41H75D5NO8P       C41H75D5NO8P
#> 27                   17:0-18:1 PC-d5    C43H79D5NO8P       C43H79D5NO8P
#> 28                   17:0-20:3 PC-d5    C45H79D5NO8P       C45H79D5NO8P
#> 29                   17:0-22:4 PC-d5    C47H81D5NO8P       C47H81D5NO8P
#> 30                   17:0-14:1 PE-d5    C36H65D5NO8P       C36H65D5NO8P
#> 31                   17:0-16:1 PE-d5    C38H69D5NO8P       C38H69D5NO8P
#> 32                   17:0-18:1 PE-d5    C40H73D5NO8P       C40H73D5NO8P
#> 33                   17:0-20:3 PE-d5    C42H73D5NO8P       C42H73D5NO8P
#> 34                   17:0-22:4 PE-d5    C44H75D5NO8P       C44H75D5NO8P
#> 35                   17:0-14:1 PG-d5  C37H65D5NaO10P       C37H66D5O10P
#> 36                   17:0-16:1 PG-d5  C39H69D5NaO10P       C39H70D5O10P
#> 37                   17:0-18:1 PG-d5  C41H73D5NaO10P       C41H74D5O10P
#> 38                   17:0-20:3 PG-d5  C43H73D5NaO10P       C43H74D5O10P
#> 39                   17:0-22:4 PG-d5  C45H75D5NaO10P       C45H76D5O10P
#> 40                   17:0-14:1 PS-d5 C37H64D5NNaO10P      C37H65D5NO10P
#> 41                   17:0-16:1 PS-d5 C39H68D5NNaO10P      C39H69D5NO10P
#> 42                   17:0-18:1 PS-d5 C41H72D5NNaO10P      C41H73D5NO10P
#> 43                   17:0-20:3 PS-d5 C43H72D5NNaO10P      C43H73D5NO10P
#> 44                   17:0-22:4 PS-d5 C45H74D5NNaO10P      C45H75D5NO10P
#> 45                   17:0-14:1 DG-d5      C34H59D5O5         C34H59D5O5
#> 46                   17:0-16:1 DG-d5      C36H63D5O5         C36H63D5O5
#> 47                   17:0-18:1 DG-d5      C38H67D5O5         C38H67D5O5
#> 48                   17:0-20:3 DG-d5      C40H67D5O5         C40H67D5O5
#> 49                   17:0-22:4 DG-d5      C42H69D5O5         C42H69D5O5
#> 50                   17:0-14:1 PI-d5   C40H73D5NO13P      C40H73D5NO13P
#> 51                   17:0-16:1 PI-d5   C42H77D5NO13P      C42H77D5NO13P
#> 52                   17:0-18:1 PI-d5   C44H81D5NO13P      C44H81D5NO13P
#> 53                   17:0-20:3 PI-d5   C46H81D5NO13P      C46H81D5NO13P
#> 54                   17:0-22:4 PI-d5   C48H83D5NO13P      C48H83D5NO13P
#> 55                   15:0 Lyso PI-d5   C24H45D5NO12P      C24H45D5NO12P
#> 56                   17:0 Lyso PI-d5   C26H49D5NO12P      C26H49D5NO12P
#> 57                   19:0 Lyso PI-d5   C28H53D5NO12P      C28H53D5NO12P
#> 58                   15:0 Lyso PS-d5  C21H36D5NNaO9P       C21H37D5NO9P
#> 59                   17:0 Lyso PS-d5  C23H40D5NNaO9P       C23H41D5NO9P
#> 60                   19:0 Lyso PS-d5  C25H44D5NNaO9P       C25H45D5NO9P
#> 61                   15:0 Lyso PG-d5   C21H37D5NaO9P        C21H38D5O9P
#> 62                   17:0 Lyso PG-d5   C23H41D5NaO9P        C23H42D5O9P
#> 63                   19:0 Lyso PG-d5   C25H45D5NaO9P        C25H46D5O9P
#> 64                   15:0 Lyso PC-d5    C23H43D5NO7P       C23H43D5NO7P
#> 65                   17:0 Lyso PC-d5    C25H47D5NO7P       C25H47D5NO7P
#> 66                   19:0 Lyso PC-d5    C27H51D5NO7P       C27H51D5NO7P
#> 67                   15:0 Lyso PE-d5    C20H37D5NO7P       C20H37D5NO7P
#> 68                   17:0 Lyso PE-d5    C22H41D5NO7P       C22H41D5NO7P
#> 69                   19:0 Lyso PE-d5    C24H45D5NO7P       C24H45D5NO7P
#>                                                                                                                                                                            smiles_salt
#> 1                                                                                          [2H]C([2H])(OC(=O)CCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCC
#> 2                                                                                    [2H]C([2H])(OC(=O)CCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/CCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCC
#> 3                                                                                  [2H]C([2H])(OC(=O)CCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/CCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCC
#> 4                                                                                [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/CCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCC
#> 5                                                                              [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/CCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCC
#> 6                                                                        [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/C\\C=C/CCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCC
#> 7                                                                  [2H]C([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/CCCCCC)C([2H])([2H])OC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 8                                                            [2H]C([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/C\\C=C/CCCCC)C([2H])([2H])OC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 9                                                          [2H]C([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])(OC(=O)CCCCCCCCCC\\C=C/C\\C=C/CCCCC)C([2H])([2H])OC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 10                     [H][C@@](C)(CCCC([2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])[C@@]1([H])CC[C@@]2([H])[C@]3([H])CC=C4C[C@H](CC[C@]4(C)[C@@]3([H])CC[C@]12C)OC(=O)CCCCCCC\\C=C/CCCC
#> 11                   [H][C@@](C)(CCCC([2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])[C@@]1([H])CC[C@@]2([H])[C@]3([H])CC=C4C[C@H](CC[C@]4(C)[C@@]3([H])CC[C@]12C)OC(=O)CCCCCCC\\C=C/CCCCCC
#> 12                 [H][C@@](C)(CCCC([2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])[C@@]1([H])CC[C@@]2([H])[C@]3([H])CC=C4C[C@H](CC[C@]4(C)[C@@]3([H])CC[C@]12C)OC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 13       [H][C@@](C)(CCCC([2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])[C@@]1([H])CC[C@@]2([H])[C@]3([H])CC=C4C[C@H](CC[C@]4(C)[C@@]3([H])CC[C@]12C)OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC
#> 14 [H][C@@](C)(CCCC([2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])[C@@]1([H])CC[C@@]2([H])[C@]3([H])CC=C4C[C@H](CC[C@]4(C)[C@@]3([H])CC[C@]12C)OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC
#> 15                                                                     [H][C@@](O)(\\C=C\\CCCCCCCCCCC([2H])([2H])C([2H])([2H])C([2H])([2H])[2H])[C@]([H])(CO)NC(=O)CCCCCCC\\C=C/CCCCCC
#> 16                                                                   [H][C@@](O)(\\C=C\\CCCCCCCCCCC([2H])([2H])C([2H])([2H])C([2H])([2H])[2H])[C@]([H])(CO)NC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 17                                                                 [H][C@@](O)(\\C=C\\CCCCCCCCCCC([2H])([2H])C([2H])([2H])C([2H])([2H])[2H])[C@]([H])(CO)NC(=O)CCCCCCCCC\\C=C/CCCCCCCC
#> 18                                                               [H][C@@](O)(\\C=C\\CCCCCCCCCCC([2H])([2H])C([2H])([2H])C([2H])([2H])[2H])[C@]([H])(CO)NC(=O)CCCCCCCCCCC\\C=C/CCCCCCCC
#> 19                                                             [H][C@@](O)(\\C=C\\CCCCCCCCCCC([2H])([2H])C([2H])([2H])C([2H])([2H])[2H])[C@]([H])(CO)NC(=O)CCCCCCCCCCCCC\\C=C/CCCCCCCC
#> 20                                    [H][C@@](O)(\\C=C\\CCCCCCCCCCCCC)[C@]([H])(COP([O-])(=O)OCC[N+](C([2H])([2H])[2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])NC(=O)CCCCCCC\\C=C/CCCCCC
#> 21                                  [H][C@@](O)(\\C=C\\CCCCCCCCCCCCC)[C@]([H])(COP([O-])(=O)OCC[N+](C([2H])([2H])[2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])NC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 22                                [H][C@@](O)(\\C=C\\CCCCCCCCCCCCC)[C@]([H])(COP([O-])(=O)OCC[N+](C([2H])([2H])[2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])NC(=O)CCCCCCCCC\\C=C/CCCCCCCC
#> 23                              [H][C@@](O)(\\C=C\\CCCCCCCCCCCCC)[C@]([H])(COP([O-])(=O)OCC[N+](C([2H])([2H])[2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])NC(=O)CCCCCCCCCCC\\C=C/CCCCCCCC
#> 24                            [H][C@@](O)(\\C=C\\CCCCCCCCCCCCC)[C@]([H])(COP([O-])(=O)OCC[N+](C([2H])([2H])[2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])NC(=O)CCCCCCCCCCCCC\\C=C/CCCCCCCC
#> 25                                                                      [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 26                                                                    [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 27                                                                  [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 28                                                        [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 29                                                  [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 30                                                                           [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OP([O-])(=O)OCC[NH3+]
#> 31                                                                         [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OP([O-])(=O)OCC[NH3+]
#> 32                                                                       [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OP([O-])(=O)OCC[NH3+]
#> 33                                                             [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OP([O-])(=O)OCC[NH3+]
#> 34                                                       [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OP([O-])(=O)OCC[NH3+]
#> 35                                                                      [Na+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OP([O-])(=O)OCC(O)CO
#> 36                                                                    [Na+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OP([O-])(=O)OCC(O)CO
#> 37                                                                  [Na+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OP([O-])(=O)OCC(O)CO
#> 38                                                        [Na+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OP([O-])(=O)OCC(O)CO
#> 39                                                  [Na+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OP([O-])(=O)OCC(O)CO
#> 40                                                   [Na+].[H][C@]([NH3+])(COP([O-])(=O)OC([2H])([2H])[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C([O-])=O
#> 41                                                 [Na+].[H][C@]([NH3+])(COP([O-])(=O)OC([2H])([2H])[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C([O-])=O
#> 42                                               [Na+].[H][C@]([NH3+])(COP([O-])(=O)OC([2H])([2H])[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C([O-])=O
#> 43                                     [Na+].[H][C@]([NH3+])(COP([O-])(=O)OC([2H])([2H])[C@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C([O-])=O
#> 44                               [Na+].[H][C@]([NH3+])(COP([O-])(=O)OC([2H])([2H])[C@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C([O-])=O
#> 45                                                                                                [2H]C([2H])(O)[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC
#> 46                                                                                              [2H]C([2H])(O)[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC
#> 47                                                                                            [2H]C([2H])(O)[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC
#> 48                                                                                  [2H]C([2H])(O)[C@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC
#> 49                                                                            [2H]C([2H])(O)[C@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC
#> 50                                              [NH4+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OP([O-])(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 51                                            [NH4+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OP([O-])(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 52                                          [NH4+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OP([O-])(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 53                                [NH4+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OP([O-])(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 54                          [NH4+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OP([O-])(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 55                                                                      [NH4+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 56                                                                    [NH4+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 57                                                                  [NH4+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 58                                                                           [Na+].[H][C@]([NH3+])(COP([O-])(=O)OC([2H])([2H])[C@]([2H])(O)C([2H])([2H])OC(=O)CCCCCCCCCCCCCC)C([O-])=O
#> 59                                                                         [Na+].[H][C@]([NH3+])(COP([O-])(=O)OC([2H])([2H])[C@]([2H])(O)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C([O-])=O
#> 60                                                                       [Na+].[H][C@]([NH3+])(COP([O-])(=O)OC([2H])([2H])[C@]([2H])(O)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCCCC)C([O-])=O
#> 61                                                                                              [Na+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC(O)CO
#> 62                                                                                            [Na+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC(O)CO
#> 63                                                                                          [Na+].[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC(O)CO
#> 64                                                                                              [2H]C([2H])(OC(=O)CCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 65                                                                                            [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 66                                                                                          [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 67                                                                                                   [2H]C([2H])(OC(=O)CCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC[NH3+]
#> 68                                                                                                 [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC[NH3+]
#> 69                                                                                               [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC[NH3+]
#>                                                                                                                                                                      smiles_metabolite
#> 1                                                                                          [2H]C([2H])(OC(=O)CCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCC
#> 2                                                                                    [2H]C([2H])(OC(=O)CCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/CCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCC
#> 3                                                                                  [2H]C([2H])(OC(=O)CCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/CCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCC
#> 4                                                                                [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/CCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCC
#> 5                                                                              [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/CCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCC
#> 6                                                                        [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/C\\C=C/CCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCC
#> 7                                                                  [2H]C([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/CCCCCC)C([2H])([2H])OC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 8                                                            [2H]C([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])(OC(=O)CCCCCCCC\\C=C/C\\C=C/CCCCC)C([2H])([2H])OC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 9                                                          [2H]C([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])(OC(=O)CCCCCCCCCC\\C=C/C\\C=C/CCCCC)C([2H])([2H])OC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 10                     [H][C@@](C)(CCCC([2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])[C@@]1([H])CC[C@@]2([H])[C@]3([H])CC=C4C[C@H](CC[C@]4(C)[C@@]3([H])CC[C@]12C)OC(=O)CCCCCCC\\C=C/CCCC
#> 11                   [H][C@@](C)(CCCC([2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])[C@@]1([H])CC[C@@]2([H])[C@]3([H])CC=C4C[C@H](CC[C@]4(C)[C@@]3([H])CC[C@]12C)OC(=O)CCCCCCC\\C=C/CCCCCC
#> 12                 [H][C@@](C)(CCCC([2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])[C@@]1([H])CC[C@@]2([H])[C@]3([H])CC=C4C[C@H](CC[C@]4(C)[C@@]3([H])CC[C@]12C)OC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 13       [H][C@@](C)(CCCC([2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])[C@@]1([H])CC[C@@]2([H])[C@]3([H])CC=C4C[C@H](CC[C@]4(C)[C@@]3([H])CC[C@]12C)OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC
#> 14 [H][C@@](C)(CCCC([2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])[C@@]1([H])CC[C@@]2([H])[C@]3([H])CC=C4C[C@H](CC[C@]4(C)[C@@]3([H])CC[C@]12C)OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC
#> 15                                                                     [H][C@@](O)(\\C=C\\CCCCCCCCCCC([2H])([2H])C([2H])([2H])C([2H])([2H])[2H])[C@]([H])(CO)NC(=O)CCCCCCC\\C=C/CCCCCC
#> 16                                                                   [H][C@@](O)(\\C=C\\CCCCCCCCCCC([2H])([2H])C([2H])([2H])C([2H])([2H])[2H])[C@]([H])(CO)NC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 17                                                                 [H][C@@](O)(\\C=C\\CCCCCCCCCCC([2H])([2H])C([2H])([2H])C([2H])([2H])[2H])[C@]([H])(CO)NC(=O)CCCCCCCCC\\C=C/CCCCCCCC
#> 18                                                               [H][C@@](O)(\\C=C\\CCCCCCCCCCC([2H])([2H])C([2H])([2H])C([2H])([2H])[2H])[C@]([H])(CO)NC(=O)CCCCCCCCCCC\\C=C/CCCCCCCC
#> 19                                                             [H][C@@](O)(\\C=C\\CCCCCCCCCCC([2H])([2H])C([2H])([2H])C([2H])([2H])[2H])[C@]([H])(CO)NC(=O)CCCCCCCCCCCCC\\C=C/CCCCCCCC
#> 20                                    [H][C@@](O)(\\C=C\\CCCCCCCCCCCCC)[C@]([H])(COP([O-])(=O)OCC[N+](C([2H])([2H])[2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])NC(=O)CCCCCCC\\C=C/CCCCCC
#> 21                                  [H][C@@](O)(\\C=C\\CCCCCCCCCCCCC)[C@]([H])(COP([O-])(=O)OCC[N+](C([2H])([2H])[2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])NC(=O)CCCCCCC\\C=C/CCCCCCCC
#> 22                                [H][C@@](O)(\\C=C\\CCCCCCCCCCCCC)[C@]([H])(COP([O-])(=O)OCC[N+](C([2H])([2H])[2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])NC(=O)CCCCCCCCC\\C=C/CCCCCCCC
#> 23                              [H][C@@](O)(\\C=C\\CCCCCCCCCCCCC)[C@]([H])(COP([O-])(=O)OCC[N+](C([2H])([2H])[2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])NC(=O)CCCCCCCCCCC\\C=C/CCCCCCCC
#> 24                            [H][C@@](O)(\\C=C\\CCCCCCCCCCCCC)[C@]([H])(COP([O-])(=O)OCC[N+](C([2H])([2H])[2H])(C([2H])([2H])[2H])C([2H])([2H])[2H])NC(=O)CCCCCCCCCCCCC\\C=C/CCCCCCCC
#> 25                                                                      [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 26                                                                    [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 27                                                                  [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 28                                                        [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 29                                                  [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 30                                                                                   [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OP(O)(=O)OCCN
#> 31                                                                                 [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OP(O)(=O)OCCN
#> 32                                                                               [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OP(O)(=O)OCCN
#> 33                                                                     [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OP(O)(=O)OCCN
#> 34                                                               [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OP(O)(=O)OCCN
#> 35                                                                               [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OP(O)(=O)OCC(O)CO
#> 36                                                                             [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OP(O)(=O)OCC(O)CO
#> 37                                                                           [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OP(O)(=O)OCC(O)CO
#> 38                                                                 [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OP(O)(=O)OCC(O)CO
#> 39                                                           [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OP(O)(=O)OCC(O)CO
#> 40                                                                    [H][C@](N)(COP(O)(=O)OC([2H])([2H])[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C(O)=O
#> 41                                                                  [H][C@](N)(COP(O)(=O)OC([2H])([2H])[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C(O)=O
#> 42                                                                [H][C@](N)(COP(O)(=O)OC([2H])([2H])[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C(O)=O
#> 43                                                      [H][C@](N)(COP(O)(=O)OC([2H])([2H])[C@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C(O)=O
#> 44                                                [H][C@](N)(COP(O)(=O)OC([2H])([2H])[C@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C(O)=O
#> 45                                                                                                [2H]C([2H])(O)[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC
#> 46                                                                                              [2H]C([2H])(O)[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC
#> 47                                                                                            [2H]C([2H])(O)[C@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC
#> 48                                                                                  [2H]C([2H])(O)[C@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC
#> 49                                                                            [2H]C([2H])(O)[C@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC
#> 50                                                      N.[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCC)C([2H])([2H])OP(O)(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 51                                                    N.[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCC)C([2H])([2H])OP(O)(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 52                                                  N.[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCC\\C=C/CCCCCCCC)C([2H])([2H])OP(O)(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 53                                        N.[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCCCCCC\\C=C/C\\C=C/C\\C=C/CC)C([2H])([2H])OP(O)(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 54                                  N.[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(OC(=O)CCCCC\\C=C/C\\C=C/C\\C=C/C\\C=C/CCCCC)C([2H])([2H])OP(O)(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 55                                                                              N.[2H]C([2H])(OC(=O)CCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP(O)(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 56                                                                            N.[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP(O)(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 57                                                                          N.[2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP(O)(=O)O[C@H]1C(O)C(O)C(O)[C@@H](O)C1O
#> 58                                                                                            [H][C@](N)(COP(O)(=O)OC([2H])([2H])[C@]([2H])(O)C([2H])([2H])OC(=O)CCCCCCCCCCCCCC)C(O)=O
#> 59                                                                                          [H][C@](N)(COP(O)(=O)OC([2H])([2H])[C@]([2H])(O)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCC)C(O)=O
#> 60                                                                                        [H][C@](N)(COP(O)(=O)OC([2H])([2H])[C@]([2H])(O)C([2H])([2H])OC(=O)CCCCCCCCCCCCCCCCCC)C(O)=O
#> 61                                                                                                       [2H]C([2H])(OC(=O)CCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP(O)(=O)OCC(O)CO
#> 62                                                                                                     [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP(O)(=O)OCC(O)CO
#> 63                                                                                                   [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP(O)(=O)OCC(O)CO
#> 64                                                                                              [2H]C([2H])(OC(=O)CCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 65                                                                                            [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 66                                                                                          [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP([O-])(=O)OCC[N+](C)(C)C
#> 67                                                                                                           [2H]C([2H])(OC(=O)CCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP(O)(=O)OCCN
#> 68                                                                                                         [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP(O)(=O)OCCN
#> 69                                                                                                       [2H]C([2H])(OC(=O)CCCCCCCCCCCCCCCCCC)[C@@]([2H])(O)C([2H])([2H])OP(O)(=O)OCCN
#>    mol_weight_salt exact_mass_metabolite conc
#> 1          714.181              713.6582   25
#> 2          740.219              739.6738   50
#> 3          768.273              767.7051   75
#> 4          796.327              795.7364  100
#> 5          824.381              823.7677  125
#> 6          850.419              849.7834  100
#> 7          876.457              875.7990   75
#> 8          902.495              901.8147   50
#> 9          930.549              929.8460   25
#> 10         602.052              601.5815   25
#> 11         630.106              629.6128   50
#> 12         658.160              657.6441   75
#> 13         682.182              681.6441   50
#> 14         708.220              707.6598   25
#> 15         542.941              542.5404   75
#> 16         570.995              570.5717   50
#> 17         599.049              598.6030   25
#> 18         627.103              626.6343   50
#> 19         655.157              654.6656   75
#> 20         710.082              709.6084   75
#> 21         738.136              737.6397   50
#> 22         766.190              765.6710   25
#> 23         794.244              793.7023   50
#> 24         822.298              821.7336   75
#> 25         723.040              722.5622   50
#> 26         751.094              750.5935  100
#> 27         779.148              778.6248  150
#> 28         803.170              802.6248  100
#> 29         829.208              828.6405   50
#> 30         680.959              680.5153   25
#> 31         709.013              708.5466   50
#> 32         737.067              736.5779   75
#> 33         761.089              760.5779   50
#> 34         787.127              786.5935   25
#> 35         733.951              711.5099   25
#> 36         762.005              739.5412   50
#> 37         790.059              767.5725   75
#> 38         814.081              791.5725   50
#> 39         840.119              817.5881   25
#> 40         746.950              724.5051   25
#> 41         775.004              752.5364   50
#> 42         803.058              780.5677   75
#> 43         827.080              804.5677   50
#> 44         853.118              830.5834   25
#> 45         557.912              557.5068   25
#> 46         585.966              585.5381   50
#> 47         614.020              613.5694   75
#> 48         638.042              637.5694   50
#> 49         664.080              663.5850   25
#> 50         817.062              816.5525   25
#> 51         845.116              844.5838   50
#> 52         873.170              872.6151   75
#> 53         897.192              896.6151   50
#> 54         923.230              922.6307   25
#> 55         580.663              580.3384   25
#> 56         608.717              608.3697   50
#> 57         636.771              636.4010   25
#> 58         510.551              488.2911   25
#> 59         538.605              516.3224   50
#> 60         566.659              544.3537   25
#> 61         497.552              475.2959   25
#> 62         525.606              503.3272   50
#> 63         553.660              531.3585   25
#> 64         486.641              486.3482   25
#> 65         514.695              514.3795   50
#> 66         542.749              542.4108   25
#> 67         444.560              444.3013   25
#> 68         472.614              472.3326   50
#> 69         500.668              500.3639   25
```
