% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opls.R
\name{opls}
\alias{opls}
\title{Orthogonal-Partial Least Squares (O-PLS)}
\usage{
opls(
  X,
  Y,
  t_pred = 1,
  center = TRUE,
  scale = "UV",
  cv = list(method = "k-fold_stratified", k = 7, split = 2/3),
  maxPCo = 5,
  plotting = TRUE
)
}
\arguments{
\item{X}{Numeric input matrix or dataframe (usually measurements obtained through NMR spectroscopy or mass spectrometry) with each row representing an observation and each column a metabolic feature.}

\item{Y}{Response vector or matrix with same length or number of columns than rows in X, respectively. Y have multiple columns.}

\item{t_pred}{Parameter specifying the maximum number of predictive components (needed only for multi-factor Y)}

\item{center}{Logical value (TRUE or FALSE) indicating if features should be mean centered.}

\item{scale}{Desired scaling method (currently only no or unit variance scaling (UV) implemented).}

\item{cv}{Named list of cross-validation paramters to derive the optimal number of components: method, one of 'k-fold', 'k-fold_stratified', 'MC', 'MC_balanced' (see Details), split: fraction of observations used for model training, k: k-fold paramter, ie., the number of cross-validation sets. The latter depends on the number of observations in X but typically takes a value between 3 and 9.}

\item{maxPCo}{The maximum number of orthogonal components (in case stop criteria fail).}

\item{plotting}{Logical value (TRUE or FALSE) indicating if model parameters (R2X, Q2, etc) should be visualised once the model is trained.}
}
\value{
This function returns an metabom8 object (S4).
}
\description{
This function fits Orthogonal-Partial Least Squares (O-PLS) models for regression (R) or discriminant analysis (DA). The optimal number of components is determined automatically using automated stop criteria based on statistical cross validation indices.
}
\details{
Models are fully statistically validated, currently only k-fold cross validation (CV) and class-balanced k-fold cross validation is implemented. Further extensions, e.g. Monte-Carlo CV, are work in progress. Although the algorithm accepts three and more levels as Y, model interpretation is more straightforward for pairwise group comparisons.
}
\examples{
data(covid)
model=opls(X, Y=an$type)
plotscores(model, an=list(Class=an$type, Clinic=an$hospital, id=1:nrow(an)), pc=c(1,2))
}
\references{
Trygg J. and Wold, S. (2002) Orthogonal projections to latent structures (O-PLS). \emph{Journal of Chemometrics}, 16.3, 119-128.

Geladi, P and Kowalski, B.R. (1986), Partial least squares and regression: a tutorial. \emph{Analytica Chimica Acta}, 185, 1-17.
}
\author{
\email{torben.kimhofer@murdoch.edu.au}
}
