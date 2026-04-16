test_that("softwareMapping works", {
    software <- softwareMapping()
    expect_true(is.character(software))
    expect_true(length(software) > 0)
})

test_that("softwareMappingSchema works", {
    expect_error(softwareMappingSchema(path = "non_existent_file.tsv"),
                 "The provided file does not exist")

    ## Test custom schema loading
    custom_schema <- data.frame(
        "MS-Dial" = c("Average Rt(min)", "Alignment ID", "Average Mz"),
        "custom" = c("custom_1", "custom_2", "custom_3"), check.names = FALSE
    )
    temp_file <- tempfile(fileext = ".tsv")
    write.table(custom_schema, temp_file, sep = "\t",)
    mapping_df <- softwareMappingSchema(path = temp_file)
    expect_true(is.data.frame(mapping_df))
    expect_equal(names(mapping_df), c("MS-Dial", "custom"))
    expect_equal(nrow(mapping_df), 3)

    ## Test default schema loading
    mapping_df <- softwareMappingSchema()
    expect_true(is.data.frame(mapping_df))
})

test_that("guessSource works", {
    ## Test default mapping schema
    x_ms_dial <- c("Average Rt(min)", "Alignment ID", "Average Mz")
    expect_equal(guessSource(x_ms_dial), "MS-Dial")

    ## Test default mapping schema with mix input vector
    x_mix <- c("organism_name", "organism_lineage", "mzmed", "Average Rt(min)")
    expect_equal(guessSource(x_mix), "RforMassSpectrometry")

    ## Test custom mapping schema
    expect_error(guessSource(x = c("custom_1", "custom_2"), map = "not_df"),
                 "'map' must be a data.frame")

    custom_schema <- data.frame(
        "MS-Dial" = c("Average Rt(min)", "Alignment ID", "Average Mz"),
        "custom" = c("custom_1", "custom_2", "custom_3"), check.names = FALSE
    )
    x_custom <- c("custom_1", "custom_3")
    expect_equal(guessSource(x_custom, map = custom_schema), "custom")
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

    ## Test default mapping schema
    map_vec <- nameMapping(from = "MS-Dial", to = "mzTab-M")
    expect_true(is.character(map_vec))
    expect_true(length(map_vec) > 0)

    ## Test custom mapping schema
    custom_schema <- data.frame(
        "MS-Dial" = c("Average Rt(min)", "Alignment ID", "Average Mz"),
        "custom" = c("custom_1", "custom_2", "custom_3"), check.names = FALSE
    )
    expect_error(nameMapping(from = "MS-Dial", to = "custom", map = "not_df"),
                 "'map' must be a data.frame")
    expect_error(nameMapping(from = "MS-Dial", to = "invalid",
                             map = custom_schema),
                 "must contain columns")
    expect_error(nameMapping(from = "invalid", to = "custom",
                             map = custom_schema),
                 "must contain columns")

    map_vec_custom <- nameMapping(from = "MS-Dial", to = "custom",
                                  map = custom_schema)
    expect_equal(map_vec_custom, c("Average Rt(min)" = "custom_1",
                                   "Alignment ID" = "custom_2",
                                   "Average Mz" = "custom_3"))
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
