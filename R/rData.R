source("R/CryptoCompare/CryptoCompare.R")
init_rData <- function () {
	rData <- list()
	rData$cryptoCompare <- initCryptoCompare()

	return (rData)
}
