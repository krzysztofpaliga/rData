require(rChange)
require(rQuant)
require(plyr)

kucoinAPI <- initKucoinAPI()
kucoin <- initKucoin(kucoinAPI)

dataHistorical <- kucoin$getAllCoinsHistorical(save = TRUE)

coinGeckoAPI <- initCoinGeckoAPI()
result <- coinGeckoAPI$ping()

con <- DBI::dbConnect(odbc::odbc(), "cryptonoi.se")

cryptoCompareAPI <- initCryptoCompareAPI()
response2 <- cryptoCompareAPI$histoHour(toTs = 1534006799, e="Cryptopia")
d <- rbind(response$content$parsed$Data, response2$content$parsed$Data)
asFrame <- do.call("rbind.fill", lapply(response$content$parsed$Data, function(x) as.data.frame(x, stringsAsFactors = FALSE)))
data <- DBI::dbWriteTable(con, "cryptocompare_coinList", asFrame)
asFrame$Nam

cryptoCompare <- initCryptoCompare()
res <- cryptoCompare$getAllHistoHour(exchange="Cryptopia", currency="BTC")
res <- cryptoCompare$getCoins()
markets <- cryptoCompare$getMarkets(exchangesFilter = c("Cryptopia"), currenciesFilter = c("BTC"))
