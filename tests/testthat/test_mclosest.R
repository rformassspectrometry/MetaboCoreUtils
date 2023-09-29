#' define some variable for test 
x <- data.frame(a = 1:5, b = 3:7)
table <- data.frame(c = c(11, 23, 3, 5, 1), d = c(32:35, 45))
table_bigger <- data.frame(c = c(11, 23, 3, 5, 1), d = c(32:35, 45), c= (1:5))



test_that("closest checks format", {
    expect_error(mclosest(1:2, table), "'x' needs to be an array")
    expect_error(mclosest(x, "test" ), "'table' needs to be an array")
    expect_error(mclosest(x, table_bigger), "'x' and 'table' need to have same number of columns")
})

x <- x[1, drop = FALSE]
test_that("one row works", {
    expect_equal(mclosest(x1, table), 1)
})

test_that("loop works", {
   expect_equal(mclosest(x, table), c(1, 1, 1, 1, 1))
})
    
testthat("tolerance test", {
    expect_equal(mclosest(x, table, tolerance = 5), c(NA, NA, NA, NA, NA))
})   
