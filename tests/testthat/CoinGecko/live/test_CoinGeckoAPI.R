context("[live] CoinGeckoAPI")
setwd("../../../../")
source("R/CoinGecko/CoinGeckoAPI.R")

coinGeckoAPI <- initCoinGeckoAPI()

test_that("can initialize CoinGeckoAPI properly", {
  expect_equal(class(coinGeckoAPI), "list")
})

test_that("CoinGeckoAPI$ping response_status is 200", {
  response <- coinGeckoAPI$ping()
  expect_equal(response$raw$status_code, 200)
})

test_that("CoinGeckoAPI$getMarket response_status is 200", {
  response <- coinGeckoAPI$getMarket()
  expect_equal(response$raw$status_code, 200)
})
