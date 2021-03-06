% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R
\name{noise.est}
\alias{noise.est}
\title{Estimation of noise level of 1D proton spectrum}
\usage{
noise.est(X, ppm, where = c(14.6, 14.7))
}
\arguments{
\item{X}{num matrix of NMR data, rows representing spectra.}

\item{ppm}{num array describing chemical shift positions, its length equals to \code{nrow(X)}.}

\item{where}{Signal free region across all NMR spectra (see Details).}
}
\value{
Returned is a vector of noise levels for each spectrum.
}
\description{
Estimation of noise level of 1D proton spectrum
}
\details{
Estimation of noise level in NMR spectra. This is useful for quality control checks (e.g., before and after spectral normalisation). Noise estimation requires a signal-free ppm region across all spectra, usually this is at the extreme ends or the spectrum. This function requires a minimum number of 50 data points to robustly estimate noise levels.
}
\section{}{
NA
}

\examples{
load(covid)
noise.est(X, ppm)
}
\seealso{
Other NMR: 
\code{\link{alignSegment}()},
\code{\link{binning}()},
\code{\link{bline}()},
\code{\link{get.idx}()},
\code{\link{lw}()},
\code{\link{matspec}()},
\code{\link{plotload}()},
\code{\link{ppick}()},
\code{\link{read1d_raw}()},
\code{\link{read1d}()},
\code{\link{specload}()},
\code{\link{spec}()},
\code{\link{stocsy1d_metabom8-class}},
\code{\link{stocsy}()}
}
\author{
\email{torben.kimhofer@murdoch.edu.au}
}
\concept{NMR}
