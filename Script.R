# ----------------------------------------------------------
# Script week 1
# ----------------------------------------------------------

setwd("~/Dropbox/Datascience/Universite_Johns-Hopkins/Obtenir_et_trier_les_donnees/Repo")
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
download.file(fileUrl, destfile = "./data/cameras.csv", method = "curl")
list.files("./data")

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
#cameraData <- read.xlsx("./data/cameras.xlsx",sheetIndex=1,header=TRUE)
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

# ----------------------------------------------------------
#       Reading JSON (Javascript Object Notation)
#       Common format for Appli Prog Interf (ex for twitter facebook...)
#       Data stored as 
#       Numbers, 
#       String, 
#       Boolean, 
#       Array, 
#       Object
# ----------------------------------------------------------

#   Un document JSON ne comprend que deux types d'??l??ments structurels :
#   des ensembles de paires nom / valeur ;
#   des listes ordonn??es de valeurs.
#   Ces m??mes ??l??ments repr??sentent trois types de donn??es :
#     des objets ;
#     des tableaux ;
#     des valeurs g??n??riques de type tableau, objet, bool??en, nombre, cha??ne ou null.

library(jsonlite)

fileUrl <- "https://api.github.com/users/Greg131/repos"
jsonData <- fromJSON(fileUrl)
names(jsonData)
jsonData
class(jsonData)

names(jsonData$owner)
jsonData$owner$login


myjson <- toJSON(iris, pretty=TRUE)
class(myjson)
cat(myjson)

iris2 <- fromJSON(myjson)
head(iris2)

# ----------------------------------------------------------
#       Using data.table 
#       faster & more memory efficient than data frame
#       Much faster at subsetting, group, and updating
# ----------------------------------------------------------

library(data.table)

DF = data.frame(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(DF,3)
DF

DT = data.table(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(DT,3)
DT2 = data.table(x=rnorm(90000), y=rep(c("a","b","c"), each=30000), z=rnorm(90000))
head(DT2,3)
class(DT)

#     See all the data tables in memory
tables()

#     Subsetting rows 

DT[2,]
DT[DT$y=="a",]

#     Subsetting with only 1 index... data.table <> data.frame 

DT[c(2,3)]  # selectionne les lignes du data.table
DF[c(2,3)]  # selectionne les colonnes du data.frame

#     ? Subsetting col ??  data.table <divergence totale> data.frame 

DF[,c(2,3)]   #   Subsetting colonnes 2 et 3 du data.frame
DT[,c(2,3)]   #   the argument you pass is an "expression"
# ie collection of statement enclosed in curly bracket
{
  x=1
  y=2
}
k = {print(10); 5}
print(k)

DT[,list(mean(x),sum(z))]   #   liste de function avec les colonnes concern??es
DT[,table(y)]

#     Adding new column
DT[,w:=z^2]
DT

DT3 <- DT   # Attention copie non effectu??e ... bien pour memoire mais
# changements de DT changent DT3
DT[, y:=2]


#     Multiple operations
DT[,m:= {tmp <- (x+z); log2(tmp+5)}]
DT
DT[,a:=x>0]
DT
DT3
#     group by?..
DT[,b:= mean(x+w),by=a]
DT

# Special variables
# .N an interger, lengh 1, number of time a part group appear 
set.seed(123);
DT <- data.table(x=sample(letters[1:3],1E5,TRUE))
DT
DT[, .N, by=x]  # much faster...

#       Keys
DT = data.table(x=rep(c("a","b","c"), each=100), y=rnorm(300))
DT
setkey(DT,x)
DT['a']

#       Joins data.table
DT1 <- data.table(x=c("a","b","c","dt1"), y=1:4)
DT1
DT2 <- data.table(x=c("a","b","dt2"), z=5:7)
DT2
setkey(DT1,x); setkey(DT2,x)
merge(DT1,DT2)  #   construit un data.table avec x,y,z pour les val de cl?? communes

#       Fast reading

big_df <- data.frame(x=rnorm(1E6),y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE, col.names=TRUE, sep="\t",quote=FALSE)
system.time(fread(file))

system.time(read.table(file, header=TRUE,sep="\t"))


# ----------------------------------------------------------
#       Quizz1 : 
# ----------------------------------------------------------

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(fileUrl, destfile = "./data/HousingIdaho.csv", method = "curl")
dateDownloaded <- date()
dateDownloaded
HousingIdaho <- read.table("./data/HousingIdaho.csv", sep=",", header = TRUE)
tmp <- HousingIdaho[complete.cases(HousingIdaho$VAL),]
worthonemilion <- tmp[tmp$VAL==24,c("SERIALNO","VAL")]

HousingIdaho$FES

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = "./data/filequizz.xls", method = "curl")
dateDownloaded <- date()
dateDownloaded
library(xlsx)

test <- read.xlsx("./data/filequizz.xls",sheetIndex=1,header=TRUE)
class(test)
colIndex <- 7:15
rowIndex <- 18:23
colIndex
rowIndex
dat <- read.xlsx("./data/filequizz.xls",sheetIndex=1,header=TRUE, colIndex=colIndex, rowIndex=rowIndex)
sum(dat$Zip*dat$Ext,na.rm=T) 


#       XML

library(XML)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
download.file(fileUrl, destfile="./data/getdata-data-restaurants.xml", method="curl")
doc <- xmlTreeParse("./data/getdata-data-restaurants.xml", useInternal=TRUE)
class(doc)
doc 

?xmlTreeParse

# fileName <- system.file("exampleData", "./data/getdata-data-restaurants.xml", package="XML")
# parse the document and return it in its standard format.
# xmlTreeParse(fileName)


rootNode <- xmlRoot(doc)
class(rootNode)
rootNode
xmlName(rootNode)
names(rootNode)

rootNode[[1]]
rootNode[[1]][[1]]
rootNode[[1]][[2]]
xmlSApply(rootNode,xmlValue) # extrait les xmlValue du rootNode

zipcode <- xpathSApply(rootNode,"//zipcode",xmlValue)  #   xmlValue des noeuds names...
zipcode
sum(as.numeric(zipcode==21231))


# Question 5

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
?fread()
download.file(fileUrl, destfile = "./data/HousingIdaho.csv", method = "curl")
dateDownloaded <- date()
dateDownloaded
DT <- fread("./data/HousingIdaho.csv", sep=",", header = TRUE)

DT$pwgtp15

# faux
mean(DT$pwgtp15,by=DT$SEX)
system.time(mean(DT$pwgtp15,by=DT$SEX))

# faux
rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2])

# Pas mal
DT[,mean(pwgtp15),by=SEX]
system.time(DT[,mean(pwgtp15),by=SEX])

# yes...
sapply(split(DT$pwgtp15,DT$SEX),mean)
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))

# ca m'etonnerai
mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15))

# plus long
tapply(DT$pwgtp15,DT$SEX,mean)
system.time(tapply(DT$pwgtp15,DT$SEX,mean))


# ----------------------------------------------------------
#       Week2 : SQL,HDF5
# ----------------------------------------------------------

library(RMySQL)

ucscDb <- dbConnect(MySQL(), user="genome",
                    host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb,"show databases;"); dbDisconnect(ucscDb); # MySQL commamd passed
result
class(result)

hg19 <- dbConnect(MySQL(), user="genome",db="hg19",
                    host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
?dbListTables
allTables[1:5]

?dbListFields
dbListFields(hg19,"affyU133Plus2")

dbGetQuery(hg19,"select count(*) from affyU133Plus2")
affyData <- dbReadTable(hg19, "affyU133Plus2")
summary(affyData)
nrow(affyData)
names(affyData)

query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query)
nrow(affyMis)
quantile(affyMis$misMatches)

affMisSmall <- fetch(query, n=10)
nrow(affMisSmall)
dbClearResult(query)

dim(affMisSmall)


dbDisconnect(hg19)

# ----------------------------------------------------------
#       HDF5
# ----------------------------------------------------------

source("http://bioconductor.org/biocLite.R")
biocLite("rhdfs5")
library(rhdf5)
created = h5createFile("example.h5")
created

created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
created = h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")

A = matrix(1:10,nr=5,nc=2)

A
h5write(A,"example.h5,"foo/A"")
B = array(seq(0.1,2.0,by = 0.1),dim=c(5,2,2))
B
h5write(B,"example.h5,"foo/foobaa/B"")
h5ls("example.h5")

df = data.frame(1L:5L,seq(0,1,length.out=5), c("ab","cde","fghi","a","s"), stringAsFactors=FALSE)
df
h5write(df,"example.h5,"df")
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readA = h5read("example.h5","df")

readA
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
h5read("example.h5","foo/A")

# ----------------------------------------------------------
#       Web - API, authentification - Webscraping
# ----------------------------------------------------------

con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode

h5write(df,"example.h5,"df")
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)

xpathSApply(html,"//title",xmlValue)
xpathSApply(html,"//td[@id='col-citedby']",xmlValue)

url2 <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
html2 <- htmlTreeParse(url2, useInternalNodes=T)
class(html2)
html2
xpathSApply(html2,"//title",xmlValue)

library(httr)
html2 = GET(url)
content2 = content(html2,as="text")
parsedHtml = htmlParse(content2, asText=T)
xpathSApply(parsedHtml,"//title",xmlValue)

pp1 = GET("http://httpbin.org/basic-auth/user/passwd")
pp1

pp2 = GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user","passwd"))
pp2

names(pp2)

google = handle("http://google.com")
pg1 = GET(handle=google,path="/")
pg2 = GET(handle=google,path="search")
# save authent accros multiple acces

# www.r-bloggers.com   search Web Scrapping

# ----------------------------------------------------------
#       API
# ----------------------------------------------------------

myapp = oauth_app("twitter",
                  key="p0VwqpAdSAHIxqCzA2OCfJZAm",
                  secret="BbEauZP2fQe3xuNdI2hN4paBGqAjn4cgYes7C1q7leA29tX19a")

sig = sign_oauth1.0(myapp,
                    token = "77304605-IwwHuRITl8nenpykgdZiw2ZbzMPSYBsXCxyPDs7zm",
                    token_secret = "SQMcscNwnFEKVAqfFtfCgW8HQbq3UwL9gZZgE4stshW25")

homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json",sig)
library(jsonlite)

json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]

# ----------------------------------------------------------
#       other sources
# ----------------------------------------------------------


