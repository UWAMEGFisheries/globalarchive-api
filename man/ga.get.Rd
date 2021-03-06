% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ga.get.R
\name{ga.get}
\alias{ga.get}
\title{ga.get function}
\usage{
ga.get(api_endpoint, api_token, page = 1, q = "")
}
\arguments{
\item{api_endpoint}{api_endpoint}

\item{api_token}{api_token}

\item{page}{page optional, default=1}

\item{q}{optional, default=NULL}
}
\value{
A dataframe containing the json response from the API
}
\description{
Function that Performs HTTP GET request to  \code{\link{GlobalArchive}}
}
\examples{

}
