test_that("adductNames works", {
    res <- adductNames()
    expect_equal(res, rownames(.ADDUCTS)[.ADDUCTS$positive])
    res <- adductNames("negative")
    expect_equal(res, rownames(.ADDUCTS)[!.ADDUCTS$positive])
})

test_that("correct calculation of adduct m/z", {
  # positive mode
  expect_equal(unname(round(mass2mz(180.0634, "[M+H]+"), 4)), 181.0707)
  expect_equal(unname(round(mass2mz(180.0634, "[M+Na]+"), 4)), 203.0526)
  expect_equal(unname(round(mass2mz(180.0634, "[M+NH4]+"), 4)), 198.0972)

  # negative mode
  expect_equal(unname(round(mass2mz(180.0634, "[M-H]-"), 4)), 179.0561)

  res <- mass2mz(4, adductNames("negative"))
  expect_equal(names(res), rownames(.ADDUCTS[!.ADDUCTS$positive, ]))

  expect_error(mass2mz(4, "some"), "Unknown adduct")
  expect_error(mass2mz(4, c("some", "[M+H]+")), "Unknown adduct")
})

test_that("correct calculation of neutral mass", {

  # positive mode
  expect_equal(unname(round(mz2mass(181.0707, "[M+H]+"), 4)), 180.0634)
  expect_equal(unname(round(mz2mass(203.0526, "[M+Na]+"), 4)), 180.0634)
  expect_equal(unname(round(mz2mass(198.0972, "[M+NH4]+"), 4)), 180.0634)

  # negative mode
  expect_equal(unname(round(mz2mass(179.0561, "[M-H]-"), 4)), 180.0634)

  res <- mz2mass(4, adductNames("negative"))
  expect_equal(names(res), rownames(.ADDUCTS[!.ADDUCTS$positive, ]))

  expect_error(mz2mass(4, "some"), "Unknown adduct")
  expect_error(mz2mass(4, c("some", "[M+H]+")), "Unknown adduct")
})
