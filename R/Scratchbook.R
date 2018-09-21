#
# require(rChange)
# require(rQuant)
# require(plyr)
# require(rAPI)
# require(odbc)
# kucoinAPI <- initKucoinAPI()
# kucoin <- initKucoin(kucoinAPI)
#
# dataHistorical <- kucoin$getAllCoinsHistorical(save = TRUE)
#
# coinGeckoAPI <- initCoinGeckoAPI()
# result <- coinGeckoAPI$ping()
#
# con <- DBI::dbConnect(odbc::odbc(), "cryptonoi.se")
#
# cryptoCompareAPI <- initCryptoCompareAPI()
# response2 <- cryptoCompareAPI$histoDay(toTs = 1534006799, e="Cryptopia")
# d <- rbind(response$content$parsed$Data, response2$content$parsed$Data)
# asFrame <- do.call("rbind.fill", lapply(response$content$parsed$Data, function(x) as.data.frame(x, stringsAsFactors = FALSE)))
# data <- DBI::dbWriteTable(con, "cryptocompare_coinList", asFrame)
# asFrame$Nam
#
# cryptoCompare <- initCryptoCompare()
# cryptoCompare$refreshCoinInDb()
# response2 <- cryptoCompare$getAllHisto(cryptoCompare$API$histoDay, exchange="Cryptopia", currency="BTC")
# response3 <- cryptoCompare$getAllCoinsHisto(cryptoCompare$API$histoDay, exchange="Cryptopia", currency="BTC")
# con <- DBI::dbConnect(odbc::odbc(), "cryptonoi.se")
# data <- DBI::dbWriteTable(con, "cryptocompare_histoDay", response3)
# res <- cryptoCompare$getCoins()
# markets <- cryptoCompare$getMarkets(exchangesFilter = c("Cryptopia"), currenciesFilter = c("BTC"))
#
# library(websocket)
# ws <- WebSocket$new("wss://streamer.cryptocompare.com/", autoConnect = FALSE)
# ws$onOpen(function(event) {
#   cat("Connection opened\n")
# })
# ws$onMessage(function(event) {
#   cat("Client got msg: ", event$data, "\n")
# })
# ws$onClose(function(event) {
#   cat("Client disconnected with code ", event$code,
#       " and reason ", event$reason, "\n", sep = "")
# })
# ws$onError(function(event) {
#   cat("Client failed to connect: ", event$message, "\n")
# })
# ws$send("hello")
# ws$connect()
#
# require(rChange)
# require(rQuant)
# require(plyr)
# require(rAPI)
# require(odbc)
# kucoinAPI <- initKucoinAPI()
# kucoin <- initKucoin(kucoinAPI)
#
# dataHistorical <- kucoin$getAllCoinsHistorical(save = TRUE)
#
# coinGeckoAPI <- initCoinGeckoAPI()
# result <- coinGeckoAPI$ping()
#
# con <- DBI::dbConnect(odbc::odbc(), "cryptonoi.se")
#
# cryptoCompareAPI <- initCryptoCompareAPI()
# response2 <- cryptoCompareAPI$histoDay(toTs = 1534006799, e="Cryptopia")
# d <- rbind(response$content$parsed$Data, response2$content$parsed$Data)
# asFrame <- do.call("rbind.fill", lapply(response$content$parsed$Data, function(x) as.data.frame(x, stringsAsFactors = FALSE)))
# data <- DBI::dbWriteTable(con, "cryptocompare_coinList", asFrame)
# asFrame$Nam
#
# cryptoCompare <- initCryptoCompare()
# cryptoCompare$initDb()
# cryptoCompare$refreshDb()
# cryptoCompare$refreshCoinInDb(coin="ETH")
# response2 <- cryptoCompare$getAllHisto(cryptoCompare$API$histoDay, exchange="Cryptopia", currency="BTC")
# response3 <- cryptoCompare$getAllCoinsHisto(cryptoCompare$API$histoDay, exchange="Cryptopia", currency="BTC")
# con <- DBI::dbConnect(odbc::odbc(), "cryptonoi.se")
# data <- DBI::dbWriteTable(con, "cryptocompare_histoDay", response3)
# res <- cryptoCompare$getCoins()
# markets <- cryptoCompare$getMarkets(exchangesFilter = c("Cryptopia"), currenciesFilter = c("BTC"))
#rData <- init_rData()
#rData$cryptoCompare$refreshDb()
