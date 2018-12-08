context("[live] CryptoCompareAPI")
setwd("../../../")
source("R/CryptoCompareAPI.R")

cryptoCompareAPI <- initCryptoCompareAPI()

test_that("can initialize CryptoCompareAPI properly", {
  expect_equal(class(cryptoCompareAPI), "list")
})

test_that("CryptoCompareAPI$coinList response_status is 200", {
  response <- cryptoCompareAPI$coinList()
  expect_equal(response$raw$status_code, 200)
})

test_that("CryptoCompareAPI$allExchanges response_status is 200", {
  response <- cryptoCompareAPI$allExchanges()
  expect_equal(response$raw$status_code, 200)
})

test_that("CryptoCompareAPI$histoHour with default parameters response_status is 200", {
  response <- cryptoCompareAPI$histoHour()
  expect_equal(response$raw$status_code, 200)
})

test_that("CryptoCompareAPI$histoMinute with default parameters response_status is 200", {
  response <- cryptoCompareAPI$histoMinute()
  expect_equal(response$raw$status_code, 200)
})
