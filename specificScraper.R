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
completeDetailsList <- data.frame("totem" = as.character(), "price" = as.character(), "name" = as.character())

urlVK <- "http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=V"
urlL <- "http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=L"
urlA <- "http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=A"


  detailsList <- data.frame()
  rem_dr$navigate(urlVK)
  webElem <- rem_dr$findElement("name", "totem")
  webElem <-webElem$selectTag()
  for(i in 1:length(webElem$text)){  #length(webElem$text)
    webElem <- rem_dr$findElement("name", "totem")
    webElem <-webElem$selectTag()
    sendBtn <- rem_dr$findElement("name", "totems")
    if(webElem$text[i] != ""){
      print(webElem$text[i])
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
        t<- sub('.*:\\s*', '', t)
      })
      totem <- as.data.frame(totem)
      
      name <- totems[trimws(tolower(totems$Totem)) == trimws(as.character(tolower(totem$totem))),]
      name <- name$Naam
      name <- as.data.frame(name)
      name <- name[1,]
      
      row <- cbind(totem, price)
      row <- cbind(row, name)
      detailsList <- rbind(detailsList, as.data.frame(row))
    }
    rem_dr$navigate(urlVK)
  }
  
completeDetailsList <- rbind(completeDetailsList, detailsList)


detailsList <- data.frame()
rem_dr$navigate(urlL)
webElem <- rem_dr$findElement("name", "totem")
webElem <-webElem$selectTag()
for(i in 1:length(webElem$text)){  #length(webElem$text)
  webElem <- rem_dr$findElement("name", "totem")
  webElem <-webElem$selectTag()
  sendBtn <- rem_dr$findElement("name", "totems")
  if(webElem$text[i] != ""){
    print(webElem$text[i])
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
      t<- sub('.*:\\s*', '', t)
    })
    totem <- as.data.frame(totem)
    
    name <- totems[trimws(tolower(totems$Totem)) == trimws(as.character(tolower(totem$totem))),]
    name <- name$Naam
    name <- as.data.frame(name)
    name <- name[1,]
    
    row <- cbind(totem, price)
    row <- cbind(row, name)
    detailsList <- rbind(detailsList, as.data.frame(row))
  }
  rem_dr$navigate(urlL)
}

completeDetailsList <- rbind(completeDetailsList, detailsList)


detailsList <- data.frame()
rem_dr$navigate(urlA)
webElem <- rem_dr$findElement("name", "totem")
webElem <-webElem$selectTag()
for(i in 1:length(webElem$text)){  #length(webElem$text)
  webElem <- rem_dr$findElement("name", "totem")
  webElem <-webElem$selectTag()
  sendBtn <- rem_dr$findElement("name", "totems")
  if(webElem$text[i] != ""){
    print(webElem$text[i])
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
      t<- sub('.*:\\s*', '', t)
    })
    totem <- as.data.frame(totem)
    
    name <- totems[trimws(tolower(totems$Totem)) == trimws(as.character(tolower(totem$totem))),]
    name <- name$Naam
    name <- as.data.frame(name)
    name <- name[1,]
    
    row <- cbind(totem, price)
    row <- cbind(row, name)
    detailsList <- rbind(detailsList, as.data.frame(row))
  }
  rem_dr$navigate(urlA)
}

completeDetailsList <- rbind(completeDetailsList, detailsList)

personDetails <- toJSON(completeDetailsList, pretty = TRUE)
write(personDetails, "personDetails.json")







rem_dr$navigate(urlL)
webElem <- rem_dr$findElement("name", "totem")
webElem <-webElem$selectTag()
sendBtn <- rem_dr$findElement("name", "totems")

  webElem$elements[[6]]$clickElement()
  sendBtn$clickElement()
  html <- read_html(rem_dr$getPageSource()[[1]])
  centerNodes <-  html_nodes(html, "center")
  centerNodes <- sapply(centerNodes, function(x){
    t <- cleanFun(x)
    t<- str_replace_all(t, "[\r\n]" , "")
    t<- trimws(t)
  })
  notAllowed <- head(centerNodes, 4)
  centerNodes <- as.data.frame(centerNodes)
  centerNodes <- centerNodes[!(centerNodes$centerNodes %in% notAllowed),]
  rondjes <- centerNodes[2:34]
  bakken <- centerNodes[36:57]
  andereKosten <- centerNodes[59:80]
  betalingen <- centerNodes[82:103]
