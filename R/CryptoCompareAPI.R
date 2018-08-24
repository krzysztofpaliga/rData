initCryptoCompareAPI <- function() {
  require(rAPI)

  rAPI <- init_rAPI(baseUrl = "https://min-api.cryptocompare.com/data/")

  cryptoCompareAPI <- list()

  cryptoCompareAPI$coinList <- function() {
    return (rAPI$api$generic(urlEndpointPart = "all/coinlist"))
  }

  cryptoCompareAPI$allExchanges <- function() {
    return (rAPI$api$generic(urlEndpointPart = "all/exchanges"))
  }

  cryptoCompareAPI$histoHour <- function(fsym = "ETH", tsym = "BTC", toTs = NULL, limit = 2000, e = NULL) {
    return(rAPI$api$generic(urlEndpointPart = "histohour"))
  }

  cryptoCompareAPI$histoDay <- function(fsym = "ETH", tsym = "BTC", toTs = NULL, limit = 2000, e = NULL) {
    return(rAPI$api$generic(urlEndpointPart = "histoday"))
  }

  cryptoCompareAPI$histoMinute <- function(fsym = "ETH", tsym = "BTC", toTs = NULL, limit = 2000, e = NULL) {
    return(rAPI$api$generic(urlEndpointPart = "histominute"))
  }
  return(cryptoCompareAPI)
}
