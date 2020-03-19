## functions for mass differences
massdiff_rules <- function() {
  
## list of mass differences
massdiff_list <- list(
    'trihexose' = list(formula = 'C18H30O15',
        mass = rcdk::get.formula('C18H30O15', charge = 0)@mass, polarity = '+'),
    'dihexose' = list(formula = "C12H20O10",
        mass = rcdk::get.formula('C12H20O10', charge = 0)@mass, polarity = '+'),
    'hexose' = list(formula = 'C6H10O5', 
        mass = rcdk::get.formula('C6H10O5', charge = 0)@mass, polarity = '+'),
    'Deoxyhexose (-H20)' = list(formula = 'C6H10O4',
              mass = rcdk::get.formula('C6H10O4', charge = 0)@mass, polarity = ''), 
    'pentose' = list(formula = 'C5H8O4',
        mass = rcdk::get.formula('C5H8O4', charge = 0)@mass, polarity = '+'),
    'Glucose-O-phosphate (-H2O)' = list(formula = 'C6H11O8P',
              mass = rcdk::get.formula('C6H11O8P', charge = 0)@mass, polarity = '+'), 
    'Hydrogenation' = list(formula = 'H2',
        mass = rcdk::get.formula('H2', charge = 0)@mass, polarity = '-'), 
    'Acetylation (-H)' = list(formula = 'C2H3O2',
        mass = rcdk::get.formula('C2H3O2', charge = 0)@mass, polarity = '-'), 
    'Acetylation (-H2O)' = list(formula = 'C2H2O',
        mass = rcdk::get.formula('C2H2O', charge = 0)@mass, polarity = '-'), 
    'Isoprene addition (-H)' = list(formula = 'C5H7',
        mass = rcdk::get.formula('C5H7', charge = 0)@mass, polarity = '-'), 
    'Ketol group (-H2O)' = list(formula = 'C2H2O',
        mass = rcdk::get.formula('C2H2O', charge = 0)@mass, polarity = '+'), 
    'Hydroxylation (-H)' = list(formula = 'O',
        mass = rcdk::get.formula('O', charge = 0)@mass, polarity = '+'), 
    'Malonyl group (-H2O)' = list(formula = 'C3H2O3',
        mass = rcdk::get.formula('C3H2O3', charge = 0)@mass, polarity = '-'), 
    'coumaroyl (-H2O)' = list(formula = 'C9H6O2',
        mass = rcdk::get.formula('C9H6O2', charge = 0)@mass, polarity = '-'), 
    'feruloyl (-H2O)' = list(formula = 'C9H6O2OCH2',
        mass = rcdk::get.formula('C9H6O2OCH2', charge = 0)@mass, polarity = '-'), 
    'sinapoyl (-H2O)' = list(formula = 'C9H6O2OCH2OCH2',
        mass = rcdk::get.formula('C9H6O2OCH2OCH2', charge = 0)@mass, polarity = '-'), 
    'quinic acid (-H2O)' = list(formula = 'C7H10O5',
        mass = rcdk::get.formula('C7H10O5', charge = 0)@mass, polarity = '+'), 
    'ellagic acid (-H2O)' = list(formula = 'C14H4O7',
        mass = rcdk::get.formula('C14H4O7', charge = 0)@mass, polarity = '+'), 
    'Urea addition (-H)' = list(formula = 'CH3N2O',
        mass = rcdk::get.formula('CH3N2O', charge = 0)@mass, polarity = '+'), 
    'Glucuronic acid (-H2O)' = list(formula = 'C6H8O6', 
        mass = rcdk::get.formula('C6H8O6', charge = 0)@mass, polarity = '+'))
  
}

#' @title Read mass differences from file
#' @details create a list from a user-input file that is in the same format as 
#' massdiff_list (see above)
#' 
read_massdiff_table <- function(file, ...) {
    
    ## read table 
    tbl <- read.table(file=file, header=TRUE, ...)
    
    ## check if tbl has the columns name, formula, polarity
    if (!all(c("name", "formula", "polarity") %in% colnames(tbl))) {
        stop("table has to contain the columns name, formula and polarity")
    }
    
    ## retrieve relavant information from tbl: name, formula, polarity
    name <- tbl[, "name"]
    formula <- tbl[, "formula"]
    polarity <- tbl[, "polarity"]
    
    ## write to list of lists
    res <- lapply(1:nrow(tbl), function(x) {
        list(formula = formula[x], 
             mass = rcdk:: get.formula(formula[x], charge)@mass, 
             polarity = polarity[x])
    })
    
    ## assign name to names of res
    names(res) <- name
    
    return(res)
}

