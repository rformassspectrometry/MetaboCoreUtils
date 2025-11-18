# Convert retention times to retention indices

`indexRtime` uses a list of known substances to convert retention times
(RTs) to retention indices (RIs). By this retention information is
normalized for differences in experimental settings, such as gradient
delay volume, dead volume or flow rate. By default linear interpolation
is performed, other ways of calculation can supplied as function.

## Usage

``` r
indexRtime(x, y, FUN = rtiLinear, ...)
```

## Arguments

- x:

  `numeric` vector with retention times

- y:

  `data.frame`data.frame containing two columns, where the first holds
  the retention times of the indexing substances and the second the
  actual index value

- FUN:

  `function` function defining how the conversion is performed, default
  is linear interpolation

- ...:

  additional parameter used by `FUN`

## Value

`numeric` vector of same length as x with retention indices. Values
floating point decimals. If integer values shall be used conversion has
to be performed manually

## Author

Michael Witting

## Examples

``` r

rti <- data.frame(rtime = c(1,2,3),
rindex = c(100,200,300))
rtime <- c(1.5, 2.5)
indexRtime(rtime, rti)
#> [1] 150 250
```
