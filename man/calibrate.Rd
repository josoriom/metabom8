% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calibrate.R
\name{calibrate}
\alias{calibrate}
\title{Spectral calibration to a chemical shift reference (1D NMR)}
\usage{
calibrate(X, ppm, type = "glucose")
}
\arguments{
\item{X}{num matrix, NMR data matrix with rows representing spectra and columns representing chemical shift position}

\item{ppm}{num vector, matched to columns of X}

\item{type}{str or num. Str: Either 'tsp' or 'glucose' for urine or blood-derived spectra, respectively (see Details). Num: ppm range of max height signal that will be used to reference to zero}
}
\value{
num matrix X, calibrated NMR data matrix.
}
\description{
Spectral calibration to a chemical shift reference.
}
\details{
Spectral calibration to a chemical shift reference. If \code{type='tsp'} calibration will be performed using highest peak in interval -0.2 ppm to +0.2 ppm 0 ppm (Trimethylsilylpropanoic acid resonance). If \code{type='glucose'}, the glucose doublet (alphanomeric proton with J const within 3.6 and 4.2 Hz) will be centered at 5.23 pmm , originating from the alpha anomer of glucose, will be used for calibration. \strong{Blood serum-derived spectra} can also be calibrated with input argument \code{type='Plasma'}.
}
\examples{
data(covid_raw)
matspec(X, ppm, shift=c(-0.1,0.1))
X_tsp=calibrate(X, ppm, type='tsp')
matspec(X, ppm, shift=c(-0.1,0.1))

# calibrate with glucose (blood plasma)
matspec(X, ppm, shift=c(5.15, 5.3))
X_tsp=calibrate(X, ppm, type='glucose')
matspec(X, ppm, shift=c(5.15, 5.3))

}
\references{
Dona, A.C., \emph{et al.} (2014) Precision high-throughput proton NMR spectroscopy of human urine, serum, and plasma for large-scale metabolic phenotyping. \emph{Analytical Chemistry}. 86.19. 9887-94.
}
\author{
\email{torben.kimhofer@gmail.com}
}
