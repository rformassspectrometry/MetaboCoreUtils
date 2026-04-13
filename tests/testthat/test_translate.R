test_that("softwareMapping works", {
    software <- softwareMapping()
    expect_true(is.character(software))
    expect_true(length(software) > 0)
})

test_that("mappingSchema works", {
    mapping_df <- mappingSchema()
    expect_true(is.data.frame(mapping_df))
})

test_that("guessSource works", {
    x_ms_dial <- c("Average Rt(min)", "Alignment ID", "Average Mz")
    expect_equal(guessSource(x_ms_dial), "MS-Dial")

    x_mix <- c("organism_name", "organism_lineage", "mzmed", "Average Rt(min)")
    expect_equal(guessSource(x_mix), "RforMassSpectrometry")
})

test_that("nameMapping works", {
    expect_error(nameMapping(from = "MS-Dial"), "must be specified.")
    expect_error(nameMapping(to = "mzTab-M"), "must be specified.")
    expect_error(nameMapping(from = "MS-Dial", to = "MS-Dial"),
                 "must be different.")
    expect_error(nameMapping(from = "Invalid", to = "mzTab-M"),
                 "must be valid software names")
    expect_error(nameMapping(from = "MS-Dial", to = "Invalid"),
                 "must be valid software names")

    map_vec <- nameMapping(from = "MS-Dial", to = "mzTab-M")
    expect_true(is.character(map_vec))
    expect_true(length(map_vec) > 0)
})

test_that("translate works", {
    expect_error(translate(), "must not be empty.")
    expect_error(translate(x = c("Average Rt(min)", "Alignment ID")),
                 "Mapping vector must be provided")

    map_vec <- nameMapping(from = "MS-Dial", to = "mzTab-M")
    expect_warning(translate(x = c("Unknown Column", "Alignment ID"),
                             mapping = map_vec),
                   "No mapping found for:")
    expect_warning(translate(x = c("Average Mz", "MS/MS included"),
                             mapping = map_vec),
                   "Mapping for:")

    x <- c("Average Rt(min)", "Alignment ID", "Average Mz")
    translated <- translate(x, mapping = map_vec)
    expect_equal(translated, c("Average Rt(min)" = "retention_time_in_seconds",
                               "Alignment ID" = "SMF_ID",
                               "Average Mz" = "exp_mass_to_charge"))
})
