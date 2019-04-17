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
completeDetailsList <- list()

urlVK <- "http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=V"
urlL <- "http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=L"
urlA <- "http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=A"


  detailsList <- data.frame()
  longDLists <- list()
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
      
      #CREATE LISTS
      centerNodes <-  html_nodes(html, "center")
      centerNodes <- sapply(centerNodes, function(x){
        t <- cleanFun(x)
        t <- str_replace_all(t, "[\r\n]" , "")
        t <- trimws(t)
      })
      notAllowed <- head(centerNodes, 4)
      centerNodes <- as.data.frame(centerNodes)
      centerNodes <- centerNodes[!(centerNodes$centerNodes %in% notAllowed),]
      
      dateT <- data.frame()
      amount <- data.frame()
      for(x in centerNodes[38:57]){
        t <- as.character(x)
        t <- as.data.frame(t)
        if(grepl("-", t$t)){
          dateT <- rbind(dateT, t)
        } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
          amount <- rbind(amount, t)
        }
      }
      bakken <- cbind(dateT, amount)
      if(nrow(bakken != 0)){
        names(bakken) <- c("date", "amount")
      }
      
      
      dateT <- data.frame()
      amount <- data.frame()
      for(x in centerNodes[61:80]){
        t <- as.character(x)
        t <- as.data.frame(t)
        if(grepl("[0-9]+[.[0-9]+]?", t$t) && grepl("\\.", t$t)){
          amount <- rbind(amount, t)
        } else if(!t$t == "/") {
          dateT <- rbind(dateT, t)
        }
      }
      andereKosten <- cbind(dateT, amount)
      if(nrow(andereKosten != 0)){
        names(andereKosten) <- c("date", "amount")
      }
      
      dateT <- data.frame()
      amount <- data.frame()
      for(x in centerNodes[84:103]){
        t <- as.character(x)
        t <- as.data.frame(t)
        if(grepl("-", t$t)){
          dateT <- rbind(dateT, t)
        } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
          amount <- rbind(amount, t)
        }
      }
      betalingen <- cbind(dateT, amount)
      if(nrow(betalingen != 0)){
        names(betalingen) <- c("date", "amount")
      }
      
      countR <- data.frame()
      dateT <- data.frame()
      amount <- data.frame()
      for(x in centerNodes[5:34]){
        t <- as.character(x)
        t <- as.data.frame(t)
        if(grepl("-", t$t)){
          dateT <- rbind(dateT, t)
        } else if(!grepl("/", t$t) && grepl("\\.", t$t)) {
          countR <- rbind(countR, t)
        } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
          amount <- rbind(amount, t)
        }
      }
      rondjes <- cbind(dateT, countR, amount)
      if(nrow(rondjes != 0)){
        names(rondjes) <- c("date", "count", "amount")
      }
      
      tablesList <- list("totem" = totem, "price" = price, "name" = name, "rondjes" = list(rondjes),"bakken" = list(bakken), "andereKosten" = list(andereKosten), "betalingen" = list(betalingen))
      longDLists[[length(longDLists)+1]] <- tablesList
      row <- cbind(totem, price)
      row <- cbind(row, name)

      detailsList <- rbind(detailsList, as.data.frame(row))
    }
    rem_dr$navigate(urlVK)
  }
  
completeDetailsList <- append(completeDetailsList, longDLists)

#Start of L
detailsList <- data.frame()
longDLists <- list()
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
    
    #CREATE LISTS
    centerNodes <-  html_nodes(html, "center")
    centerNodes <- sapply(centerNodes, function(x){
      t <- cleanFun(x)
      t <- str_replace_all(t, "[\r\n]" , "")
      t <- trimws(t)
    })
    notAllowed <- head(centerNodes, 4)
    centerNodes <- as.data.frame(centerNodes)
    centerNodes <- centerNodes[!(centerNodes$centerNodes %in% notAllowed),]
    
    dateT <- data.frame()
    amount <- data.frame()
    for(x in centerNodes[38:57]){
      t <- as.character(x)
      t <- as.data.frame(t)
      if(grepl("-", t$t)){
        dateT <- rbind(dateT, t)
      } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
        amount <- rbind(amount, t)
      }
    }
    bakken <- cbind(dateT, amount)
    if(nrow(bakken != 0)){
      names(bakken) <- c("date", "amount")
    }
    
    
    dateT <- data.frame()
    amount <- data.frame()
    for(x in centerNodes[61:80]){
      t <- as.character(x)
      t <- as.data.frame(t)
      if(grepl("[0-9]+[.[0-9]+]?", t$t) && grepl("\\.", t$t)){
        amount <- rbind(amount, t)
      } else if(!t$t == "/") {
        dateT <- rbind(dateT, t)
      }
    }
    andereKosten <- cbind(dateT, amount)
    if(nrow(andereKosten != 0)){
      names(andereKosten) <- c("date", "amount")
    }
    
    dateT <- data.frame()
    amount <- data.frame()
    for(x in centerNodes[84:103]){
      t <- as.character(x)
      t <- as.data.frame(t)
      if(grepl("-", t$t)){
        dateT <- rbind(dateT, t)
      } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
        amount <- rbind(amount, t)
      }
    }
    betalingen <- cbind(dateT, amount)
    if(nrow(betalingen != 0)){
      names(betalingen) <- c("date", "amount")
    }
    
    countR <- data.frame()
    dateT <- data.frame()
    amount <- data.frame()
    for(x in centerNodes[5:34]){
      t <- as.character(x)
      t <- as.data.frame(t)
      if(grepl("-", t$t)){
        dateT <- rbind(dateT, t)
      } else if(!grepl("/", t$t) && grepl("\\.", t$t)) {
        countR <- rbind(countR, t)
      } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
        amount <- rbind(amount, t)
      }
    }
    rondjes <- cbind(dateT, countR, amount)
    if(nrow(rondjes != 0)){
      names(rondjes) <- c("date", "count", "amount")
    }
    
    
    
    tablesList <- list("totem" = totem, "price" = price, "name" = name, "rondjes" = list(rondjes),"bakken" = list(bakken), "andereKosten" = list(andereKosten), "betalingen" = list(betalingen))
    longDLists[[length(longDLists)+1]] <- tablesList
    row <- cbind(totem, price)
    row <- cbind(row, name)
    
    detailsList <- rbind(detailsList, as.data.frame(row))
    
    
  }
  rem_dr$navigate(urlL)
}

completeDetailsList <- append(completeDetailsList, longDLists)

detailsList <- data.frame()  
longDLists <- list()
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
    
    #CREATE LISTS
    centerNodes <-  html_nodes(html, "center")
    centerNodes <- sapply(centerNodes, function(x){
      t <- cleanFun(x)
      t <- str_replace_all(t, "[\r\n]" , "")
      t <- trimws(t)
    })
    notAllowed <- head(centerNodes, 4)
    centerNodes <- as.data.frame(centerNodes)
    centerNodes <- centerNodes[!(centerNodes$centerNodes %in% notAllowed),]
    
    dateT <- data.frame()
    amount <- data.frame()
    for(x in centerNodes[38:57]){
      t <- as.character(x)
      t <- as.data.frame(t)
      if(grepl("-", t$t)){
        dateT <- rbind(dateT, t)
      } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
        amount <- rbind(amount, t)
      }
    }
    bakken <- cbind(dateT, amount)
    if(nrow(bakken != 0)){
      names(bakken) <- c("date", "amount")
    }
    
    
    dateT <- data.frame()
    amount <- data.frame()
    for(x in centerNodes[61:80]){
      t <- as.character(x)
      t <- as.data.frame(t)
      if(grepl("[0-9]+[.[0-9]+]?", t$t) && grepl("\\.", t$t)){
        amount <- rbind(amount, t)
      } else if(!t$t == "/") {
        dateT <- rbind(dateT, t)
      }
    }
    andereKosten <- cbind(dateT, amount)
    if(nrow(andereKosten != 0)){
      names(andereKosten) <- c("date", "amount")
    }
    
    dateT <- data.frame()
    amount <- data.frame()
    for(x in centerNodes[84:103]){
      t <- as.character(x)
      t <- as.data.frame(t)
      if(grepl("-", t$t)){
        dateT <- rbind(dateT, t)
      } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
        amount <- rbind(amount, t)
      }
    }
    betalingen <- cbind(dateT, amount)
    if(nrow(betalingen != 0)){
      names(betalingen) <- c("date", "amount")
    }
    
    countR <- data.frame()
    dateT <- data.frame()
    amount <- data.frame()
    for(x in centerNodes[5:34]){
      t <- as.character(x)
      t <- as.data.frame(t)
      if(grepl("-", t$t)){
        dateT <- rbind(dateT, t)
      } else if(!grepl("/", t$t) && grepl("\\.", t$t)) {
        countR <- rbind(countR, t)
      } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
        amount <- rbind(amount, t)
      }
    }
    rondjes <- cbind(dateT, countR, amount)
    if(nrow(rondjes != 0)){
      names(rondjes) <- c("date", "count", "amount")
    }
    
    
    tablesList <- list("totem" = totem, "price" = price, "name" = name, "rondjes" = list(rondjes),"bakken" = list(bakken), "andereKosten" = list(andereKosten), "betalingen" = list(betalingen))
    longDLists[[length(longDLists)+1]] <- tablesList
    
    row <- cbind(totem, price)
    row <- cbind(row, name)
    detailsList <- rbind(detailsList, as.data.frame(row))
  }
  rem_dr$navigate(urlA)
}

completeDetailsList <- append(completeDetailsList, longDLists)
personDetails <- toJSON(completeDetailsList, pretty = TRUE)
write(personDetails, "personDetails.json")


###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
###################################################









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
  
  
  
  
  dateT <- data.frame()
  amount <- data.frame()
  for(x in centerNodes[38:57]){
    t <- as.character(x)
    t <- as.data.frame(t)
    if(grepl("-", t$t)){
      dateT <- rbind(dateT, t)
    } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
      amount <- rbind(amount, t)
    }
  }
  bakken <- cbind(dateT, amount)
  names(bakken) <- c("date", "amount")
  
  dateT <- data.frame()
  amount <- data.frame()
  for(x in centerNodes[61:80]){
    t <- as.character(x)
    t <- as.data.frame(t)
    if(grepl("[a-zA-Z]", t$t)){
      dateT <- rbind(dateT, t)
    } else if(grepl("[0-9]+[.[0-9]+]?", t$t)) {
      amount <- rbind(amount, t)
    }
  }
  andereKosten <- cbind(dateT, amount)
  names(andereKosten) <- c("date", "amount")
  
  dateT <- data.frame()
  amount <- data.frame()
  for(x in centerNodes[84:103]){
    t <- as.character(x)
    t <- as.data.frame(t)
    if(grepl("-", t$t)){
      dateT <- rbind(dateT, t)
    } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
      amount <- rbind(amount, t)
    }
  }
  betalingen <- cbind(dateT, amount)
  names(betalingen) <- c("date", "amount")

jsonList <- toJSON(longDLists, pretty = TRUE, auto_unbox = TRUE)
write(jsonList, "testJsonList.json")






createTableLists <- function(){
  centerNodes <-  html_nodes(html, "center")
  centerNodes <- sapply(centerNodes, function(x){
    t <- cleanFun(x)
    t <- str_replace_all(t, "[\r\n]" , "")
    t <- trimws(t)
  })
  notAllowed <- head(centerNodes, 4)
  centerNodes <- as.data.frame(centerNodes)
  centerNodes <- centerNodes[!(centerNodes$centerNodes %in% notAllowed),]
  
  dateT <- data.frame()
  amount <- data.frame()
  for(x in centerNodes[38:57]){
    t <- as.character(x)
    t <- as.data.frame(t)
    if(grepl("-", t$t)){
      dateT <- rbind(dateT, t)
    } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
      amount <- rbind(amount, t)
    }
  }
  bakken <- cbind(dateT, amount)
  if(nrow(bakken != 0)){
    names(bakken) <- c("date", "amount")
  }
  
  
  dateT <- data.frame()
  amount <- data.frame()
  for(x in centerNodes[61:80]){
    t <- as.character(x)
    t <- as.data.frame(t)
    if(grepl("[0-9]+[.[0-9]+]?", t$t) && grepl("\\.", t$t)){
      amount <- rbind(amount, t)
    } else if(!t$t == "/") {
      dateT <- rbind(dateT, t)
    }
  }
  andereKosten <- cbind(dateT, amount)
  if(nrow(andereKosten != 0)){
    names(andereKosten) <- c("date", "amount")
  }
  
  dateT <- data.frame()
  amount <- data.frame()
  for(x in centerNodes[84:103]){
    t <- as.character(x)
    t <- as.data.frame(t)
    if(grepl("-", t$t)){
      dateT <- rbind(dateT, t)
    } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
      amount <- rbind(amount, t)
    }
  }
  betalingen <- cbind(dateT, amount)
  if(nrow(betalingen != 0)){
    names(betalingen) <- c("date", "amount")
  }
  
  countR <- data.frame()
  dateT <- data.frame()
  amount <- data.frame()
  for(x in centerNodes[5:34]){
    t <- as.character(x)
    t <- as.data.frame(t)
    if(grepl("-", t$t)){
      dateT <- rbind(dateT, t)
    } else if(!grepl("/", t$t) && grepl("\\.", t$t)) {
      countR <- rbind(countR, t)
    } else if(!grepl("/", t$t) && !grepl("-", t$t)) {
      amount <- rbind(amount, t)
    }
  }
  rondjes <- cbind(dateT, countR, amount)
  if(nrow(rondjes != 0)){
    names(rondjes) <- c("date", "count", "amount")
  }
}
