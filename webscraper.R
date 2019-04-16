library(rvest)
library(selectr)
library(xml2)
library(stringr)
library(jsonlite)
library(dplyr)

numextract <- function(string){ 
 str_extract(string, "\\-*\\d+\\.*\\d*")
} 

cleanFun <- function(htmlString) {
  return(gsub("<.*?>", "", htmlString))
}

'%!in%' <- function(x,y)!('%in%'(x,y))

html <- read_html("http://scoutsjanbreydel.be/poefsite/index.php") 
total <- html_nodes(html, "h4 i")[1]
total <- numextract(as.character(total))

jsonFile <- toJSON(total, pretty = TRUE)
write(jsonFile, "dataHome.json")


#Get VK's
htmlVK <- read_html("http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=V")                                  
totems <- html_nodes(htmlVK, "option")
tValues <- sapply(totems, function(x){
  numextract(as.character(x))
})

totems <- sapply(totems, function(x){
  t <- cleanFun(x)
  t<- str_replace_all(t, "[\r\n]" , "")
  t <- gsub(",.*", "", t)
})


totems <- as.data.frame(totems)
tValues <- as.data.frame(tValues)
totems <- cbind(totems, tValues)
totems <- totems[totems$totems != "",]
totemNames <- NULL
totemNames <- sapply(totems$totems, function(x){
  t <- gsub("\\s+$", "", x)
  if(str_detect(t, " ")){
    append(totemNames, t)
  } else {
    "NA"
  }
})
totemNames <- as.data.frame(totemNames)
totemNames <- totemNames[totemNames$totemNames != "NA",]
totemNames <- as.data.frame(totemNames)
totemNamesFinal <- totems[totems$totems %in% totemNames$totemNames,]
totems <- totems[!(totems$totems %in% totemNames$totemNames),]

totems <- merge(totems, totemNamesFinal, by = "tValues", all = TRUE)
totems <- cbind(totems, "VK")


colnames(totems) <- c("Value", "Totem", "Naam", "Tak")

#Get Leiding
htmlL <- read_html("http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=L")                                  
totemsL <- html_nodes(htmlL, "option")
tValuesL <- sapply(totemsL, function(x){
  numextract(as.character(x))
})

totemsL <- sapply(totemsL, function(x){
  t <- cleanFun(x)
  t<- str_replace_all(t, "[\r\n]" , "")
})


totemsL <- as.data.frame(totemsL)
tValuesL <- as.data.frame(tValuesL)
totemsL <- cbind(totemsL, tValuesL)
totemsL <- totemsL[totemsL$totems != "",]

totemNames <- totemsL[unique(totemsL$tValuesL),]
totemNames <- as.data.frame(totemNames)
totemsL <- totemsL[!(totemsL$totemsL %in% totemNames$totemsL),]

totemsL <- merge(totemNames, totemsL, by = "tValuesL", all = TRUE)
totemsL <- cbind(totemsL, "L")

colnames(totemsL) <- c("Value", "Totem", "Naam", "Tak")
totems <- rbind(totems, totemsL)


#Get Andere
htmlA <- read_html("http://scoutsjanbreydel.be/poefsite/index.php?pagina=kiesNaam.php&tak=A")                                  
totemsA <- html_nodes(htmlA, "option")
tValuesA <- sapply(totemsA, function(x){
  numextract(as.character(x))
})

totemsA <- sapply(totemsA, function(x){
  t <- cleanFun(x)
  t<- str_replace_all(t, "[\r\n]" , "")
})


totemsA <- as.data.frame(totemsA)
tValuesA <- as.data.frame(tValuesA)
totemsA <- cbind(totemsA, tValuesA)
totemsA <- totemsA[totemsA$totemsA != "",]


totemNames <- totemsA[!(grepl(".*,.*", totemsA$totemsA)),]
totemNames <- as.data.frame(totemNames)
totemsA <- totemsA[!(totemsA$totemsA %in% totemNames$totemsA),]

totemsA <- merge(totemNames, totemsA, by = "tValuesA", all = TRUE)
totemsA <- cbind(totemsA, "A")

colnames(totemsA) <- c("Value", "Naam", "Totem", "Tak")
totems <- rbind(totems, totemsA)

totemsC <- sapply(totems$Totem, function(x){
  td <- strsplit(gsub(",", "", x), " ")
  td <- as.data.frame(td)
  if(is.na(td[2,])){
    td <- paste(td[1,], "")
  } 
  else if(td[2,] == "(v)"){
    td <- paste(td[1,], td[2,])
  } else {
    td <- paste(td[2,], td[1,])
  }
  
})
totemsC <- as.data.frame(totemsC)
totems$Totem <- totemsC$totemsC

jsonFile <- toJSON(totems, pretty = TRUE)
write(jsonFile, "dataTotems.json")
