initCryptoCompare <- function() {
  require(tidyverse)
  cryptoCompare <- list()

  cryptoCompare$API <- initCryptoCompareAPI()

  cryptoCompare$getCoins <- function() {
    response <- cryptoCompare$API$coinList()
    df <- do.call("rbind.fill", lapply(response$content$parsed$Data, function(x) as.data.frame(x, stringsAsFactors = FALSE)))
    return (df)
  }

  cryptoCompare$getMarkets <- function(exchangesFilter = NULL, coinsFilter = NULL, currenciesFilter = NULL) {
    df <- data.frame(exchange=character(), coin=character(), currency=character(), stringsAsFactors = FALSE)
    response <- cryptoCompare$API$allExchanges()
    exchanges <- names(response$content$parsed)
    for(i in 1:length(exchanges)) {
      exchange = exchanges[i]
      if (is.null(exchangesFilter) || is.element(exchange, exchangesFilter)) {
        markets <- get(exchange, response$content$parsed)
        coins <- names(markets)
        if (length(coins)>0) {
          for (j in 1:length(coins)) {
            coin <- coins[j]
            if (is.null(coinsFilter) || is.element(coin, coinsFilter)) {
              coinMarkets <- get(coin, markets)
              for (coinMarket in coinMarkets) {
                if (is.null(currenciesFilter) || is.element(coinMarket, currenciesFilter)) {
                  df <- add_row(df, exchange = exchange, coin = coin, currency = coinMarket)
                }
              }
            }
          }
        }
      }
    }
    return (df)
  }

  cryptoCompare$getAllHisto <- function(histoFunction, exchange = NULL, coin = "ETH", currency = "BTC") {
    newestResponse <- histoFunction(e = exchange, fsym = coin, tsym = currency)
    df <- newestResponse$content$parsed$Data
    while (TRUE) {
      nextToTs = min(df$time)-1
      if (!is.finite(nextToTs)) {
        break
      }
      nextResponse <- histoFunction(e = exchange, fsym = coin, tsym = currency, toTs = nextToTs)
      if (all(nextResponse$content$parsed$Data$close == 0)) {
        break
      } else {
        nextDf <- nextResponse$content$parsed$Data
        df <- rbind(df, nextDf)
      }
    }

    df <- df[ rowSums(df[,2:7])!=0, ]

    if (nrow(df) == 0) {
      print("zero rows")
      return (df)
    }
    df$exchange <- exchange
    df$coin <- coin
    df$currency <- currency
    return (df)
  }

  cryptoCompare$getAllCoinsHisto <- function(histoFunction, exchange = "Cryptopia", currency = "BTC", partialCallback = NULL) {
    markets <- cryptoCompare$getMarkets(exchangesFilter = c(exchange), currenciesFilter = c(currency))
    markets %>%
      arrange(coin) %>%
      select(coin) ->
      allCoins
    df <- cryptoCompare$getAllHisto(histoFunction = histoFunction, exchange = exchange, coin = allCoins[1,], currency = currency)
    if (!is.null(partialCallback)) {
      partialCallback(df)
    }
    for (coin in allCoins[-1,]) {
      coinDf <- cryptoCompare$getAllHisto(histoFunction = histoFunction, exchange = exchange, coin = coin, currency = currency)
      if (!is.null(partialCallback)) {
        partialCallback(coinDf)
      }
      if (!is.null(coinDf)) {
        df <- rbind(df, coinDf)
      }
      Sys.sleep(0.5)
    }

    return (df)
  }

  return (cryptoCompare)
}
