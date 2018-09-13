initCryptoCompare <- function() {
  require(tidyverse)
  require(anytime)

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
        print(nextDf)
        df <- rbind(df, nextDf)
      }
      Sys.sleep(1)
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

  #TODO przelec przez day, hour, minute(?)
  cryptoCompare$getNewestHisto <- function(histoFunc = cryptoCompare$API$histoDay, exchange = "Cryptopia", coin = "ETH", currency = "BTC", exclusiveFrom = NULL) {
    if(is.null(exclusiveFrom)) {
      print("exclusiveFrom parameter cant be null")
      return (NULL)
    }


    newestResponse <- histoFunc(e = exchange, fsym = coin, tsym = currency)
    df <- newestResponse$content$parsed$Data
    df %>% select(time) %>% min() %>% anytime() -> minDate
    exclusiveFromDate <- anytime(exclusiveFrom)
    if (minDate > exclusiveFromDate) {
      while (TRUE) {
        nextToTs = min(df$time)-1
        if (!is.finite(nextToTs)) {
          break
        }
        nextResponse <- histoFunc(e = exchange, fsym = coin, tsym = currency, toTs = nextToTs)
        nextDf <- nextResponse$content$parsed$Data
        df %>% select(time) %>% min() %>% anytime() -> minDate
        if (minDate <= exclusiveFromDate) {
          break
        } else {
          print(nextDf)
          df <- rbind(df, nextDf)
        }
        Sys.sleep(1)
      }
    }
    df %>% filter(time > exclusiveFromDate) -> df
    return (df)
  }

  cryptoCompare$refreshCoinInDb <- function(odbcName = "cryptonoi.se", dbName = "cryptocompare_histoDay", histoFunc = cryptoCompare$API$histoDay,  coin = "ETH") {
    connection <- DBI::dbConnect(odbc::odbc(), odbcName)
    data <- tbl(connection, dbName)
    coinName <- coin
    data %>% filter(coin == coinName) %>% collect() -> coinData
    coinData %>% group_by(exchange, currency) %>% filter(time == max(time)) -> coinNewestRows
    for (i in 1:nrow(coinNewestRows)) {
      row = coinNewestRows[i,]
      cryptoCompare$refreshCoinInDbForExchangeAndCurrency(odbcName = odbcName,
                                                          dbName = dbName,
                                                          histoFunc = histoFunc,
                                                          exchange=row$exchange,
                                                          currency=row$currency,
                                                          coin=coin,
                                                          exclusiveFrom = row$time)
    }
  }

  cryptoCompare$refreshCoinInDbForExchangeAndCurrency <- function(odbcName, dbName, histoFunc, exchange, currency, coin, exclusiveFrom) {
    newestHisto <- cryptoCompare$getNewestHisto(exchange=exchange, currency=currency, histoFunc=histoFunc, coin=coin, exclusiveFrom=exclusiveFrom)
    connection <- DBI::dbConnect(odbc::odbc(), odbcName)
    DBI::dbWriteTable(connection, dbName, newestHisto, append = TRUE)
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
