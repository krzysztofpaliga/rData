init_rData <- function () {
	source("R/CryptoCompare/CryptoCompare.R")
	rData <- list()
	rData$cryptoCompare <- initCryptoCompare()

	return (rData)
}
