# Convert migration times to effective mobility

`convertMtime` performs effective mobility scale transformation of
CE(-MS) data, which is used to overcome variations of the migration
times, caused by differences in the Electroosmotic Flow (EOF) between
different runs. In order to monitor the EOF and perform the
transformation, neutral or charged EOF markers are spiked into the
sample before analysis. The information of the EOF markers (migration
time and effective mobility) will be then used to perform the effective
mobility transformation of the migration time scale.

## Usage

``` r
convertMtime(
  x = numeric(),
  rtime = numeric(),
  mobility = numeric(),
  tR = 0,
  U = numeric(),
  L = numeric()
)
```

## Arguments

- x:

  `numeric` vector with migration times in minutes.

- rtime:

  `numeric` vector that holds the migration times (in minutes) of either
  one or two EOF markers in the same run of which the migration time is
  going to be transformed.

- mobility:

  `numeric` vector containing the respective effective mobility (in in
  mm^2 / (kV \* min)) of the EOF markers. If two markers are used, one
  is expected to be the neutral marker, i.e. having a mobility of 0.

- tR:

  `numeric` a single value that defines the time (in minutes) of the
  electrical field ramp. The default is 0.

- U:

  `numeric` a single value that defines the voltage (in kV) applied.
  Note that for reversed polarity CE mode a negative value is needed. Is
  only used if the transformation is performed based on a single marker.

- L:

  `numeric` a single value that defines the total length (in mm) of the
  capillary that was used for CE(-MS) analysis. Is only used if the
  transformation is performed based on a single marker.

## Value

`numeric` vector of same length as x with effective mobility values.

## Author

Liesa Salzer

## Examples

``` r
 rtime <- c(10,20,30,40,50,60,70,80,90,100)
 marker_rt <-  c(20,80)
 mobility <- c(0, 2000)
 convertMtime(rtime, marker_rt, mobility)
#>  [1] -2666.6667     0.0000   888.8889  1333.3333  1600.0000  1777.7778
#>  [7]  1904.7619  2000.0000  2074.0741  2133.3333
```
