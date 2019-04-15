library(rvest)
library(selectr)
library(xml2)
library(stringr)
library(jsonlite)
library(dplyr)
library(RSelenium)

rd <- rsDriver(port=4444L, browser = "internet explorer")
rem_dr <- rd[["client"]]

url <- "http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=V"
rem_dr$navigate(url)

rem_dr$close()
