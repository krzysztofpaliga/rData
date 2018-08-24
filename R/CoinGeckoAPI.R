initCoinGeckoAPI <- function() {
  require(rAPI)

  rAPI <- init_rAPI(baseUrl = "https://api.coingecko.com/api/v3/")

  coinGeckoAPI <- list()

  coinGeckoAPI$ping <- function() {
    return (rAPI$api$generic(urlEndpointPart = "ping"))
  }

  coinGeckoAPI$getMarket <- function(vs_currency="BTC") {
    return (rAPI$api$generic(urlEndpointPart = "coins/markets"))
  }
  return(coinGeckoAPI)
}
