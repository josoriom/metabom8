#' OPLS model predictions
#' @export
#' @description Calculation of OPLS model predictions using new data
#' @aliases pred.opls
#' @param opls_model OPLS model (regression of discriminant analysis) of class \code{OPLS_MetaboMate}.
#' @param newdata NMR data matrix or dataframe with rows representing spectra and identical features in columns as data matrix used to calculate original OPLS model.
#' @param idx_scale int vector, row-indices of newdata used to subselect samples to determine scale and center pars. Recommded: set to NULL: use center and scaling parameters from opsl training data
#' @return Returned is a list with the following elements:
#' \describe{
#' \item{Y_predicted}{Class or numeric outcome predictions for discriminant analysis or regression, repspectively.}
#' \item{t_pred}{Predicted OPLS model scores for predictive component(s).}
#' \item{t_orth}{Predicted OPLS model scores for orthogonal component(s).}
#' \item{t_orth_pca}{Scores of a PCA model (first component) calculated using all predicted OPLS orthogonal component scores - only done when there are more than one orthogonal components in \code{opls_model}.}
#' }
#' @details Class predictions for discriminant analysis are not adjusted for unbalanced sample sizes and therefore, predictions can be biased towards the group with the largest number of samples. The list element \code{t_orth_pca} represent scores of the first principal component of a PCA model caclulated with all orthogonal components, therefore, summarises all orthogonal components into a single one. This can only be done if there are more than one orthogonal components in \code{opls_modelel}, otherwise this list element is \code{NULL}.
#' @references Trygg J. and Wold, S. (2002) Orthogonal projections to latent structures (O-PLS). \emph{Journal of Chemometrics}, 16.3, 119-128.
#' @references Geladi, P and Kowalski, B.R. (1986), Partial least squares and regression: a tutorial. \emph{Analytica Chimica Acta}, 185, 1-17.
#' @author \email{torben.kimhofer@@murdoch.edu.au}
#' @seealso \code{\link{opls}}
#' @examples
#' data(covid)
#' model=opls(X, Y=an$type)
#' preds=predict_opls(model, X)
#' table(preds$Y_predicted, an$type)
#' @family NMR ++
#' @export
predict_opls <- function(opls_model, newdata, idx_scale = NULL) {
    
    if (!"OPLS_metabom8" %in% is(opls_model)) {
        stop("Model input does not belong to class OPLS_Torben!")
        return(NULL)
    }
    
    
    if (length(unique(opls_model@Y$ori)) != 2) {
        stop("Predictions implemented only for regression or 2-class outcomes.")
        return(NULL)
    }
    
    # In case of one sample scenario: define X as column vector
    if (is.null(ncol(newdata))) {
        X <- rbind(newdata)
    } else {
        X <- newdata
    }
    
    # check if dimensions X match to opls_model X
    if (length(opls_model@X_mean) != ncol(newdata)) {
        stop("Newdata argument does not match training data.")
    }
    
    
    if (!is.null(idx_scale)) {
        # use provided scaling vector define scale type
        map_scale <- c(none = 0L, UV = 1L)
        map_scale[match(opls_model@Parameters$scale, names(map_scale))]
        # browser()
        sc_res <- .scaleMatRcpp(X, idx_scale - 1, center = opls_model@Parameters$center, 
            scale_type = map_scale[match(opls_model@Parameters$scale, names(map_scale))])
        X <- sc_res$X_prep
    } else {
        # use model paramters for scaling
        if (all(!is.null(opls_model@X_mean) & !is.na(opls_model@X_mean)) && all(!is.null(opls_model@X_sd) & 
            !is.na(opls_model@X_sd))) {
            Xmc <- sweep(X, 2, opls_model@X_mean, FUN = "-")
            X <- sweep(Xmc, 2, opls_model@X_sd, FUN = "/")
        }
    }
    
    # center and scale X<-scale(newdata, center=opls_model@Xcenter,
    # scale=opls_model@Xscale) iteratively remove all orthogonal components from
    # prediction data set
    e_new_orth <- X
    
    t_orth <- matrix(NA, nrow = nrow(X), ncol = opls_model@nPC - 1)
    for (i in seq_len(opls_model@nPC - 1)) {
        t_orth[, i] <- e_new_orth %*% t(t(opls_model@p_orth[i, ]))/drop(crossprod(t(t(opls_model@p_orth[i, 
            ]))))
        e_new_orth <- e_new_orth - (cbind(t_orth[, i]) %*% t(opls_model@p_orth[i, 
            ]))
    }
    # summarise orth component in case nc_orth > 2
    if ((opls_model@nPC - 1) > 1) {
        pc.orth <- pca(t_orth, pc = 1, scale = "UV")
        t_orth_pca <- pc.orth@t[, 1]
    } else {
        t_orth_pca <- NULL
    }
    
    # calc predictive component score predictions and residuals
    t_pred <- e_new_orth %*% t(opls_model@p_pred)
    # E_h <- e_new_orth - (t_pred %*% opls_model@p_pred)
    betas <- opls_model@betas_pred
    q_h <- opls_model@Qpc
    res <- matrix(NA, nrow = nrow(X), ncol = ncol(opls_model@t_pred))
    for (i in seq_len(ncol(opls_model@t_pred))) {
        opts <- t(cbind(betas[i]) %*% t_pred[, i]) %*% rbind(q_h[, i])
        res[, i] <- apply(opts, 1, sum)
    }
    totalPrediction <- apply(res, 1, sum)  # sum over all components
    Y_predicted <- (totalPrediction * opls_model@Y_sd) + opls_model@Y_mean
    if (opls_model@type == "DA") {
        
        # TODO: adjust class predictions to unequal group sizes of training set (decision
        # boundary shifting)
        cs <- table(opls_model@Y$ori, opls_model@Y$dummy)
        levs <- data.frame(Original = rownames(cs), Numeric = as.numeric(colnames(cs)), 
            stringsAsFactors = FALSE, row.names = NULL)
        Y_predicted <- levs$Original[apply(vapply(levs$Numeric, function(x, y = Y_predicted) {
            abs(x - y)
        }, Y_predicted), 1, which.min)]
    }
    
    
    out <- list(Y_predicted = Y_predicted, t_pred = t_pred, t_orth = t_orth, t_orth_pca = t_orth_pca)
    return(out)
}
