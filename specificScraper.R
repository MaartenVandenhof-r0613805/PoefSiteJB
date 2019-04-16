library(rvest)
library(selectr)
library(xml2)
library(stringr)
library(jsonlite)
library(dplyr)
library(RSelenium)

cleanFun <- function(htmlString) {
  return(gsub("<.*?>", "", htmlString))
}

numextract <- function(string){ 
  str_extract(string, "\\-*\\d+\\.*\\d*")
} 

rd <- rsDriver(port=4444L, browser = "chrome", chromever="73.0.3683.68")
rem_dr <- rd[["client"]]

url <- "http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=V"
rem_dr$navigate(url)


detailsList <- data.frame()
for(i in 1:length(webElem$text)){  #length(webElem$text)
  webElem <- rem_dr$findElement("name", "totem")
  webElem <-webElem$selectTag()
  sendBtn <- rem_dr$findElement("name", "totems")
  if(webElem$text[i] != ""){
    webElem$elements[[i]]$clickElement()
    sendBtn$clickElement()
    html <- read_html(rem_dr$getPageSource()[[1]])
    price <- html_nodes(html, "i")
    price <- sapply(price, function(x){
      t <- cleanFun(x)
      t<- str_replace_all(t, "[\r\n]" , "")
      t<- trimws(t)
    })
    
    price <- as.data.frame(price)
    price <- price[price != "",]
    price <- numextract(price)
    price <- as.data.frame(price)
    
    
    totem <- html_nodes(html, "h2")
    totem <- sapply(totem, function(x){
      t <- cleanFun(x)
      t<- str_replace_all(t, "[\r\n]" , "")
      t<- trimws(t)
    })
    totem <- sapply(strsplit(totem, split=' '), tail, 1L)
    totem <- as.data.frame(totem)
    
    name <- totems[totems$Totem == as.character(totem$totem),]
    name <- name$Naam
    name <- as.data.frame(name)
    name <- name[1,]
    
    row <- cbind(totem, price)
    row <- cbind(row, name)
    detailsList <- rbind(detailsList, as.data.frame(row))
  }
  rem_dr$navigate(url)
}

personDetails <- toJSON(detailsList, pretty = TRUE)
write(personDetails, "personDetails.json")
rem_dr$close()
rd$server$stop()

webElem$elements[[1]]$clickElement()
sendBtn$clickElement()
html <- read_html(rem_dr$getPageSource()[[1]])
name <- html_nodes(html, "center")
name <- sapply(name, function(x){
  t <- cleanFun(x)
  t<- str_replace_all(t, "[\r\n]" , "")
  t<- trimws(t)
})
name <- name[2]
name <- html_nodes(html, "h2")
price <- html_nodes(html, "i")
price <- sapply(price, function(x){
  t <- cleanFun(x)
  t<- str_replace_all(t, "[\r\n]" , "")
  t<- trimws(t)
})
price <- as.data.frame(price)
price <- price[price != "",]
price <- as.data.frame(price)

