# ----------------------------------------------------------
# Script week 1
# ----------------------------------------------------------

setwd("~/Dropbox/Datascience/Universit?? Johns-Hopkins/Obtenir et trier les donn??es")
# Absolute setwd("../") ou relative setwd("./") ou ..~/ relative au user...
getwd() #       Get working directory

if (!file.exists("data"))       {
        dir.create("data")
}
# ----------------------------------------------------------
#       Downloading data from internet : 
#       download.file(Url, destile, method)
# ----------------------------------------------------------

#       Ex Baltimore fixed camera data
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"


#       If the url starts with http ... ok, 
#                       https -> need to set method="curl" with MAC

# ----------------------------------------------------------
#       Reading files : 
#       read.table() : flexible, robusf, req more param, slow read data in RAM big data cause pb 
#               file, header, sep; row names, nrows
#       read.csv(), read.csv2()
# ----------------------------------------------------------
?read.table()

#       cameraData <- read.table("./data/cameras.csv")
cameraData <- read.table("./data/cameras.csv", sep=",", header = TRUE)
cameraData <- read.csv("./data/cameras.csv")    # default sep "," header TRUE

#       quote, quote="" means no quotes (often resolves flag file with 'or ")
#       na.strings set caractere for missing value
#       nrows - how many rows to read
#       skip number of lines to skip before starting to read

# ----------------------------------------------------------
#       Reading Excel files : 
# ----------------------------------------------------------

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/cameras.xlsx", method = "curl")
dateDownloaded <- date()
dateDownloaded

library(xlsx)
cameraData <- read.xlsx("./data/cameras.xlsx",sheetIndex=1,header=TRUE)
colIndex <- 2:3
rowIndex <- 1:4
cameraDataSubset <- read.xlsx("./data/cameras.xlsx",sheetIndex=1,header=TRUE, colIndex=colIndex, rowIndex=rowIndex)
cameraData <- read.xlsx("./data/Baltimore_Fixed_Speed_Cameras.xls",sheetIndex=1,header=TRUE)
#colIndex <- 2:3
#rowIndex <- 1:4
#cameraDataSubset <- read.xlsx("./data/Baltimore_Fixed_Speed_Cameras.xls",sheetIndex=1,header=TRUE, colIndex=colIndex, rowIndex=rowIndex)


# ----------------------------------------------------------
#       Writing Excel files : write.xlsx
#       read.xls2 faster but instable for subset
#       XLconnect package ... more options
# ----------------------------------------------------------


# ----------------------------------------------------------
#       Reading XML
# ----------------------------------------------------------

#       Extensible markup language
#       Frequently used for wed scrapping
#       Markup / content
#       Tag
#       ex http://www.w3schools.com/xml/simple.xml
#
#       Start tags <section>  End tags </section>
#       Empty tags <line-break />
#       Attribute ... <step nb="3"> Connect A, B </step>
#       <img scr="jeff.jpg" alt="instructor" />


library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl, useInternal=TRUE)
class(doc)
doc
rootNode <- xmlRoot(doc)
class(rootNode)
rootNode
xmlName(rootNode)
names(rootNode)

rootNode[[1]]
rootNode[[1]][[1]]
rootNode[[1]][[2]]
xmlSApply(rootNode,xmlValue) # extrait les xmlValue du rootNode

#   XPath
#   Lire XML.pdf du r??pertoire

names <- xpathSApply(rootNode,"//name",xmlValue)  #   xmlValue des noeuds names...
prices <- xpathSApply(rootNode,"//price",xmlValue)
names
prices
class(names)
class(prices)


fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
#     parsing HTML file
doc <- htmlTreeParse(fileUrl, useInternal=TRUE)
doc
class(doc)
scores <- xpathSApply(doc,"//li[@class='score']",xmlValue)
teams <- xpathSApply(doc,"//li[@class='team-name']",xmlValue)
scores
teams

fileUrl <- "http://www.zonebourse.com"
doc <- htmlTreeParse(fileUrl, useInternal=TRUE)
FoLbullenoli <- xpathSApply(doc,"//li[@class='FoLbullenoli']",xmlValue)
FoLbullenoli
#     il faut <li class="xxxx"



