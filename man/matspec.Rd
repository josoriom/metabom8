% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllViz.R
\name{matspec}
\alias{matspec}
\title{Simple plotting of multiple NMR spectra overlayed}
\usage{
matspec(X, ppm, shift = c(0, 9.5), add = F, ...)
}
\arguments{
\item{X}{NMR matrix with spectra represented in rows.}

\item{ppm}{ppm vector.}

\item{shift}{Chemical shift region to be plotted (in ppm).}

\item{add}{Logical indicating if spectra should be added to a current plot generated with \code{spec()} or \code{matspec()}.}

\item{...}{Additional parameters to be passed on to the plot function.}
}
\description{
Simple plotting of multiple NMR spectra overlayed
}
\details{
Low-level plotting function for NMR spectra.
}
\section{}{
NA
}

\seealso{
\code{\link{spec}} \code{\link{plot}}
}
\author{
Torben Kimhofer \email{torben.kimhofer@murdoch.edu.au}
}