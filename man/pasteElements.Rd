% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chemFormula.R
\name{pasteElements}
\alias{pasteElements}
\title{Create chemical formula from a named vector}
\usage{
pasteElements(x)
}
\arguments{
\item{x}{\code{integer} with element counts, names being individual elements.}
}
\value{
\code{character(1)} with the chemical formula.
}
\description{
\code{pasteElements} creates a chemical formula from element counts (such as
returned by \code{\link[=countElements]{countElements()}}).
}
\examples{

elements <- c("C" = 6, "H" = 12, "O" = 6)
pasteElements(elements)
}
\seealso{
\code{\link[=countElements]{countElements()}}
}
\author{
Michael Witting
}
