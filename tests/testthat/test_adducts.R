test_that("correct calculation of adduct m/z", {

  # positive mode
  expect_equal(round(mass2mz(180.0634, "[M+H]+"), 4), 181.0707)
  expect_equal(round(mass2mz(180.0634, "[M+Na]+"), 4), 203.0526)
  expect_equal(round(mass2mz(180.0634, "[M+NH4]+"), 4), 198.0972)

  # negative mode
  expect_equal(round(mass2mz(180.0634, "[M-H]-"), 4), 179.0561)

})

test_that("correct calculation of neutral mass", {

  # positive mode
  expect_equal(round(mz2mass(181.0707, "[M+H]+"), 4), 180.0634)
  expect_equal(round(mz2mass(203.0526, "[M+Na]+"), 4), 180.0634)
  expect_equal(round(mz2mass(198.0972, "[M+NH4]+"), 4), 180.0634)

  # negative mode
  expect_equal(round(mz2mass(179.0561, "[M-H]-"), 4), 180.0634)

})
