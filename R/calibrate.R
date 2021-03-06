#' Spectral calibration to a chemical shift reference (1D NMR)
#' @export
#' @aliases calibrate
#' @description Spectral calibration to a chemical shift reference.
#' @param X num matrix, NMR data matrix with rows representing spectra and columns representing chemical shift position
#' @param ppm num vector, matched to columns of X
#' @param type str or num. Str: Either 'tsp' or 'glucose' for urine or blood-derived spectra, respectively (see Details). Num: ppm range of max height signal that will be used to reference to zero
#' @details Spectral calibration to a chemical shift reference. If \code{type='tsp'} calibration will be performed using highest peak in interval -0.2 ppm to +0.2 ppm 0 ppm (Trimethylsilylpropanoic acid resonance). If \code{type='glucose'}, the glucose doublet (alphanomeric proton with J const within 3.6 and 4.2 Hz) will be centered at 5.23 pmm , originating from the alpha anomer of glucose, will be used for calibration. \strong{Blood serum-derived spectra} can also be calibrated with input argument \code{type='Plasma'}.
# @return Returned is the calibrated NMR data matrix.
#' @return num matrix X, calibrated NMR data matrix.
#' @references Dona, A.C., \emph{et al.} (2014) Precision high-throughput proton NMR spectroscopy of human urine, serum, and plasma for large-scale metabolic phenotyping. \emph{Analytical Chemistry}. 86.19. 9887-94.
#' @examples
#' data(covid_raw)
#' matspec(X, ppm, shift=c(-0.1,0.1))
#' X_tsp=calibrate(X, ppm, type='tsp')
#' matspec(X, ppm, shift=c(-0.1,0.1))
#'
#' # calibrate with glucose (blood plasma)
#' matspec(X, ppm, shift=c(5.15, 5.3))
#' X_tsp=calibrate(X, ppm, type='glucose')
#' matspec(X, ppm, shift=c(5.15, 5.3))
#'
#' @author \email{torben.kimhofer@@gmail.com}


calibrate <- function(X, ppm, type = "glucose") {
    
    rnam <- rownames(X)
    cnam <- colnames(X)
    
    if (type == "tsp") {
        idx <- get.idx(c(-0.2, 0.2), ppm)
        zero.ppm <- which.min(abs(ppm[idx]))
        maxInt <- array()
        for (i in seq_len(nrow(X))) {
            maxInt[i] <- which.max(X[i, idx])
        }
        
        Int.corr <- zero.ppm - maxInt
        # if Int.corr<0: shift is > zero
        for (i in seq_len(nrow(X))) {
            x <- X[i, ]
            if (Int.corr[i] < 0) {
                x <- c(x[-c(seq_len(abs(Int.corr[i])))], rep(0, abs(Int.corr[i])))
            }
            if (Int.corr[i] > 0) {
                x <- c(rep(0, abs(Int.corr[i])), x)
            }
            X[i, ] <- x[seq_len(length(ppm))]
        }
    }
    
    
    
    if (type == "glucose") {
        X <- .calibrate1d_gluc(X, ppm)
    }
    rownames(X) <- rnam
    colnames(X) <- cnam
    return(X)
}
