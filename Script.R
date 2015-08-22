# ----------------------------------------------------------
# Script week 1
# ----------------------------------------------------------

setwd("~/Dropbox/Datascience/Universite_Johns-Hopkins/Obtenir_et_trier_les_donnees/Repo")
# Absolute  ou relative setwd("./")  setwd("../") ou "~/" relative au user...
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
?download.file

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

#       Writing Excel files : write.xlsx
#       read.xls2 faster but instable for subset
#       XLconnect package ... more options

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
class(iris2)
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
DT[,c(2,33)]   
# ie collection of statement enclosed in curly bracket
{
  x=1
  y=2
}
k = {print(10); 5}
print(k)

DT[,list(mean(x),sum(z))]   #   liste de function avec les colonnes concern??es
DT[,table(y)]
table(DF$y)

#     Adding new column
DT[,w:=z^2]
DT

DT3 <- DT   # Attention copie non effectu??e ... bien pour memoire mais
# changements de DT changent DT3
DT[, y:=2]

tables()
DT
DT3
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
#created = h5createFile("example.h5")

#created
#created = h5createGroup("example.h5","foo")
#created = h5createGroup("example.h5","baa")
#created = h5createGroup("example.h5","foo/foobaa")
#h5ls("example.h5")

A = matrix(1:10,nr=5,nc=2)

A
#h5write(A,"example.h5,"foo/A"")
B = array(seq(0.1,2.0,by = 0.1),dim=c(5,2,2))
B
# h5write(B,"example.h5,"foo/foobaa/B"")
# h5ls("example.h5")

# df = data.frame(1L:5L,seq(0,1,length.out=5), c("ab","cde","fghi","a","s"), stringAsFactors=FALSE)
# df
# h5write(df,"example.h5,"df")
#readA = h5read("example.h5","foo/A")
#readB = h5read("example.h5","foo/foobaa/B")
#readA = h5read("example.h5","df")

#readA
#h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
#h5read("example.h5","foo/A")

# ----------------------------------------------------------
#       Web - API, authentification - Webscraping
# ----------------------------------------------------------

con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode
class(htmlCode)
length(htmlCode)

con = url("http://www.duclert.org/Aide-memoire-R/Le-langage/Chaines-de-caracteres.php")
htmlCode = readLines(con)
close(con)
htmlCode
class(htmlCode)
length(htmlCode)

?readLines
# Read Text Lines from a Connection

#h5write(df,"example.h5,"df")

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
class(content2)
length(content2)
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


# foreign package
# read.octave(Octave)
# read.spss(SPSS)
# ...

# Other... ACESS, MongoDB

# Read images
# jpeg
# readbitmap
# png

# Read musical data
# tuneR
# seewave

# ----------------------------------------------------------
#       Quizz week 2 - Question 1
#
# Register an application with the Github API here 
# https://github.com/settings/applications. 
# Access the API to get information on your instructors repositories 
# (hint: this is the url you want 
# "https://api.github.com/users/jtleek/repos"). 
# Use this data to find the time that the datasharing repo was created. 
# What time was it created? 
# This tutorial may be useful 
# (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
# You may also need to run the code in the base R package and not R studio.
# ----------------------------------------------------------

library(httr)
library(httpuv)
library(jsonlite)
oauth_endpoints("github")

Url <- "https://api.github.com/users/jtleek/repos"

myapp = oauth_app("github",
                  key="41abbfa5f1896cba36b7",
                  secret="71c4dcb1a7d935e34367584057f9f2f16673f0f1")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API (?? lancer depuis R... pour inter..)
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/rate_limit", gtoken)
stop_for_status(req)
content(req)



request <- GET("https://api.github.com/users/jtleek/repos", 
               config(token = github_token))

myjson <- content(request)
myjson2 <- jsonlite::fromJSON(toJSON(myjson))
View(myjson2)
myjson2
names(myjson2)
# homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json",sig)
myjson2[myjson2$name=="datasharing",]$created_at

# ----------------------------------------------------------
#       Quizz week 2 - Question 2
# The sqldf package allows for execution of SQL commands on R data frames. 
# We will use the sqldf package to practice the queries we might send 
# with the dbSendQuery command in RMySQL. 
# Download the American Community Survey data 
# and load it into an R object called acs
# ----------------------------------------------------------
library(sqldf)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./data/american_community_survey.csv", method = "curl")
acs <- read.table("./data/american_community_survey.csv", sep=",", header = TRUE)

names(acs)
sqldf("select pwgtp1 from acs where AGEP < 50")
result <- sqldf("select pwgtp1 from acs where AGEP < 50")
class(result)
names(result)
nrow(result)
View(result)
result2 <- acs[acs$AGEP<50,]$pwgtp1
View(result2)


# Autres faux
sqldf("select * from acs where AGEP < 50 and pwgtp1")
errdata <- sqldf("select * from acs where AGEP < 50 and pwgtp1")
nrow(errdata)
View(errdata)
# mais ram??ne l'ensemble des colonnes
sqldf("select * from acs")
# endemble
sqldf("select * from acs where AGEP < 50")
errdata2 <- sqldf("select * from acs where AGEP < 50")
View(errdata2)
nrow(errdata2)

# ----------------------------------------------------------
#       Quizz week 2 - Question 3
# Using the same data frame you created in the previous problem, 
# what is the equivalent function to unique(acs$AGEP)
# ----------------------------------------------------------

data <- unique(acs$AGEP)
data2 <- sqldf("select distinct AGEP from acs ")
length(data)
class(data2)
names(data2)
nrow(data2)
data <- as.data.frame(data)
names(data) <- "AGEP"
identical(data,data2)

# ----------------------------------------------------------
#       Quizz week 2 - Question 4
# How many characters are in the 10th, 20th, 30th and 100th 
# lines of HTML from this page: 
# http://biostat.jhsph.edu/~jleek/contact.html
# (Hint: the nchar() function in R may be helpful)
# ----------------------------------------------------------


con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
htmlCode
class(htmlCode)
?readLines

htmlCode[10]
htmlCode[20]
htmlCode[30]
htmlCode[100]

nchar(htmlCode[10])
nchar(htmlCode[20])
nchar(htmlCode[30])
nchar(htmlCode[100])


con = url("http://www.w3schools.com/xml/simple.xml")
xmlCode = readLines(con)
xmlCode
class(xmlCode)
xmlCode[10]
# En fait on peut lire les lignes ind??pendement du langage XML ou HTML utilise
# Le HTML et le XML ne sont pas comparables
# Le seul point commun entre le HTML et le XML est qu'ils sont issus tous deux de la m??me "m??re" soit le SGML 
# ...http://www.lehtml.com/xml/html.html


library(XML)

fileUrl <- "http://www.w3schools.com/xml/simple.xml"
docXML <- xmlTreeParse(fileUrl, useInternal=TRUE) # Parsing XML files
class(docXML)
docXML


names <- xpathSApply(docXML,"//name",xmlValue)  #   xmlValue des noeuds names...
names
prices <- xpathSApply(docXML,"//price",xmlValue)
prices 

rootNode <- xmlRoot(docXML)
class(rootNode)
rootNode
xmlName(rootNode)
names(rootNode)

rootNode[[1]]
rootNode[[1]][[1]]
rootNode[[1]][[2]]
xmlSApply(rootNode,xmlValue) # extrait les xmlValue du rootNode
names <- xpathSApply(rootNode,"//name",xmlValue)  #   xmlValue des noeuds names...
prices <- xpathSApply(rootNode,"//price",xmlValue)
names
prices
class(names)
class(prices)



fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
docHTML <- htmlTreeParse(fileUrl, useInternal=TRUE) # Parsing HTML files
docHTML
class(docHTML)
scores <- xpathSApply(docHTML,"//li[@class='score']",xmlValue)
teams <- xpathSApply(docHTML,"//li[@class='team-name']",xmlValue)
scores
teams


# ----------------------------------------------------------
#       Quizz week 2 - Question 5
# Read this data set into R 
# and report the sum of the numbers in the fourth of the nine columns. 
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
# ----------------------------------------------------------

con = url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")
?readLines
Code = readLines(con)
close(con)
Code
Code[1:10]
class(Code)
nchar(Code[1])
nchar(Code[20])
nchar(Code[23])
Code[2]
Code[3]
Code[4]
Code[5]


length(Code) # 1258 dont 4 ligne d'entete soit 1254
nrow <- length(Code) -4
nrow

?data.frame
df <- data.frame(date = NA, Nino1.2STT = rep(0,nrow), Nino1.2STTA = rep(0,nrow),
                 Nino3STT = rep(0,nrow), Nino3STTA = rep(0,nrow),
                 Nino3.4STT = rep(0,nrow),Nino3.4STTA = rep(0,nrow),
                 Nino4STT = rep(0,nrow), Nino4STTA = rep(0,nrow))

c(Code[5],"12345678901234567890123456789012345678901234567890")

for (i in 1:nrow) {
  df[i,1] <- substr(Code[i+4], 2, 10)
  df[i,2] <- as.numeric(substr(Code[i+4], 16,19))
  df[i,3] <- as.numeric(substr(Code[i+4], 20,24))
  df[i,4] <- as.numeric(substr(Code[i+4], 29, 32))
  df[i,5] <- as.numeric(substr(Code[i+4], 33, 36))
  df[i,6] <- as.numeric(substr(Code[i+4], 42, 45))
  df[i,7] <- as.numeric(substr(Code[i+4], 46, 49))
  df[i,8] <- as.numeric(substr(Code[i+4], 55, 58))
  df[i,9] <- as.numeric(substr(Code[i+4], 59, 62))
} 
names(df)
class(df$Nino3STT)
sum(df$Nino3STT)

summary(df)

sum <-0
for (i in 1:nrow) {
  tmp  <- as.numeric(substr(Code[i+4], 29, 32))
  sum <- sum + tmp
} 
sum


# ----------------------------------------------------------
#       Week 3
# ----------------------------------------------------------

#       Subsetting and sorting

set.seed(13435)
?sample()
sample(1:5)
sample(1:5,3)
sample(1:5,size=3, replace= T)

X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X
X <- X[sample(1:5),]
X
X$var2[c(1,3)] = NA
X

X[,1]
X[,"var1"]
X[,"var1", drop=F]
X[1:2,"var2"]
X[1:2,c("var2","var1")]

X[X$var1 <= 3 & X$var3 >11,]
X[X$var1 <= 3 | X$var3 >15,]

X
X[X$var2>8,]  # probl??mes avec les missing values NA
X[which(X$var2>8),] # elimine les NA...
?which() # NA are allowed and treated as False...

X$var1
sort(X$var1)
sort(X$var1,decreasing=TRUE)
?sort()
X
sort(X$var2)
sort(X$var2,na.last=TRUE)

X
order(X$var1) # retourne le vecteur d'indice dans l'odre de var1...

X[order(X$var1),] #ordonne dans l'ordre de la variable 1
X[order(X$var1,X$var3),] #ordonne dans l'ordre de la variable 1 puis 3 pour les 1 identiques

library(plyr)
X
arrange(X,var1)   # re ordonne suivant var1 
X
arrange(X,desc(var1))
?desc()
desc(var1)
arrange(X,var2) # traite les NA ?? la fin
arrange(X,desc(var2)) # traite les NA ?? la fin dans tous les cas

X$var4 <- rnorm(5)
X

Y <- cbind(X,rnorm(5))
Y
Y <- cbind(rnorm(5),X)
Y

Z <- rbind(rnorm(4),X) # conversion des types.... du coup...
Z
X

#       Summarize data set

fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/restaurants.csv", method = "curl")
list.files("./data")
?read.table()
restData <- read.csv("./data/restaurants.csv")
# restData2 <- read.table("./data/restaurants.csv", sep=",", header=T)
head(restData,n=3)
tail(restData,n=3) # les 3 dernieres lignes
summary(restData)
str(restData)
quantile(restData$councilDistrict,na.rm=T)  # Pour les variables quantitatives
quantile(restData$councilDistrict,probs=c(0.5,0.75,0.90),na.rm=T)  # Pour les variables quantitatives

table(restData$zipCode,useNA="ifany") # Add NA with number of missing value!


table(restData$councilDistrict,restData$zipCode)
table(restData$councilDistrict,restData$zipCode, useNA="ifany")

# Check for missing values
sum(is.na(restData$councilDistrict))

any(is.na(restData$councilDistrict))

all(restData$zipCode >0)
?all()
X
all(X$var2>0)
all(X$var2>0, na.rm=T)

class(is.na(restData))
# is.na(restData) renvoi une matrice logique de la taille du dataset
colSums(is.na(restData))
all(colSums(is.na(restData))==0) # si TRUE il n'y a aucunes missing values... sinon au moins une

table(restData$zipCode %in% c("21212"))

table(restData$zipCode %in% c("21212","21213"))

restData[restData$zipCode %in% c("21212","21213"),]


data(UCBAdmissions)
DF = as.data.frame(UCBAdmissions)
summary(DF)

# Cross Tab
?xtabs()
# Create a contingency table (optionally a sparse matrix) from cross-classifying factors, 
# usually contained in a data frame, using a formula interface
xt <- xtabs(Freq ~ Gender + Admit, data = DF)
xt
xt <- xtabs(Freq ~ Gender , data = DF)
xt
table(DF$Gender)
sum(DF[DF$Gender=="Male","Freq"])
sum(DF[DF$Gender=="Female","Freq"])

# Flat Tab
warpbreaks$replicate <- rep(1:9, len = 54)
xt <- xtabs(breaks ~ .,  data = warpbreaks)
xt
# somme des breaks... pour chaque combinaison des autres variables
# un peu difficille ?? lire

ftable(xt)  # concatenation de pusieurs variable (facteurs) sur les axes

# Size of data set

fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData),units="Mb")

# Creating new variable

# Missingness indicator / Cutting up quant var / Applying transform
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/restaurants.csv", method = "curl")
list.files("./data")
?read.table()
restData <- read.csv("./data/restaurants.csv")

s1 <- seq(1,10, by=2) ; s1
s2 <- seq(1,10, length=3) ; s2
x <- c(1,3,8,25,100); seq(along = x)

str(restData)
restData$nearMe = restData$neighborhood %in% c("Roland Park","Homeland")
table(restData$nearMe)
# then used for subsetting the data set
restData$zipWrong = ifelse(restData$zipCode <0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode <0)
?ifelse()

?cut()
restData$zipGroups = cut(restData$zipCode, breaks=quantile(restData$zipCode))
table(restData$zipGroups)
table(restData$zipGroups, restData$zipCode)
class(restData$zipGroups)
levels(restData$zipGroups)

library(Hmisc)
restData$zipGroups = cut2(restData$zipCode,g=4)
table(restData$zipGroups)
# plus simple ...pour diviser suivant les quantiles

# creation de facteurs

restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]
class(restData$zcf)

yesno <- sample(c("yes","no"),size = 10, replace = TRUE)
yesno
yesnofac = factor(yesno) # ordre alphab par defaut
yesnofac
yesnofac = factor(yesno, levels=c("yes","no"))
yesnofac


as.numeric(yesnofac)

# avec cut2 factor variable....

library(Hmisc); library(plyr)
restData2 = mutate(restData,zipGroups=cut2(zipCode,g=4))
table(restData2$zipGroups)


#   transformation
x=pi
x

abs(x)
sqrt(x)
ceiling(x)
floor(x)
round(x,digits=2)
signif(x,digits=2)
cos(x)
sin(x)
log(x)
log2(x)
log10(x)
exp(x)


# Reshaping the data
# to get tidy data

# 1 each variable forms a column
# 2 each obs forms a row
# 3 each table/file store data about one kind of obs

library(reshape2)
head(mtcars)

# Melting data frames

mtcars$carnames <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carnames","gear","cyl"),measure.vars=c("mpg","hp"))
head(carMelt,n=3)
tail(carMelt,n=3)

class(carMelt)
?melt()
# en gros cr??e une colonne variable, et pour chaque id, var donne une val
# empile les variables...
carMelt3 <- melt(mtcars, id=c("gear"),measure.vars=c("mpg","hp"))
head(carMelt3,n=3)
tail(carMelt3,n=3)

carMelt2 <- melt(mtcars, id=c("carnames"),measure.vars=c("mpg","hp"))
head(carMelt2,n=3)
tail(carMelt2,n=3)

# Pour chaque cyl, fonction sur les variables 
cylData <- dcast(carMelt, cyl ~ variable)
cylData
# count par defaut
cylData <- dcast(carMelt, cyl ~ variable, mean)
cylData



head(InsectSprays)
str(InsectSprays)
InsectSprays
tapply(InsectSprays$count,InsectSprays$spray,sum)
InsectSprays$count

spIns = split(InsectSprays$count,InsectSprays$spray)
spIns

sprCount = lapply(spIns,sum)
sprCount

unlist(sprCount)

sapply(spIns,sum)

# plyr package
library(plyr)
ddply(InsectSprays,.(spray),summarise,sum=sum(count))

spraySums <- ddply(InsectSprays,.(spray),summarise,sum=ave(count,FUN=sum))
?ave()
dim(spraySums)
head(spraySums)
spraySums


#--------------------------------
# dplyr : managing Dataframe
library(dplyr)
#--------------------------------
# arrange / filter / select / mutate / rename
# by Hadley Wickham
# provides a grammar for data manipulation

chicago <- readRDS("./data/chicago.rds") 

dim(chicago)
str(chicago)
names(chicago)

colSums(is.na(chicago))
all(colSums(is.na(chicago))==0)

summary(chicago)




# Select()

head(select(chicago,city:dptp))
class(select(chicago,city:dptp))
# donne les colonnes entre city & dptp
head(select(chicago,-(city:dptp)))
# except les col entre city  et dptp

# sinon
i <- match("city", names(chicago))
j <- match("dptp", names(chicago))
head(chicago[,i:j])


# filter()
chic.f <- filter(chicago, pm25tmean2 > 30)
head(chic.f,10)

X
test <- filter(X, var2 > 6)
test
# semble ne pas prendre les NA

chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
head(chic.f,10)
?filter()
# arrange

chicago <- arrange(chicago,date)
head(chicago)
tail(chicago)
chicago <- arrange(chicago,desc(date))
head(chicago)
tail(chicago)


# rename
chicago <- rename(chicago,pm25 = pm25tmean2, dewpoint = dptp)
head(chicago)

mean(chicago$pm25,na.rm = TRUE)
sd(chicago$pm25,na.rm = TRUE)

# mutate() (transform existing var / create new var)
chicago <- mutate(chicago, pm25detrend = pm25-mean(pm25, na.rm = TRUE)) # centrer la var
mean(chicago$pm25detrend,na.rm = TRUE)

chicago <- mutate(chicago, pm25detrend = (pm25-mean(pm25, na.rm = TRUE))/sd(pm25,na.rm = TRUE))
?sd()
head(chicago)
head(select(chicago,pm25, pm25detrend))

mean(chicago$pm25detrend,na.rm = TRUE)
sd(chicago$pm25detrend,na.rm = TRUE)

# group by
chicago <- mutate(chicago, tempcat = factor( 1 * (tmpd > 80), labels = c("cold","hot")))
table(chicago$tempcat)


hotcold <- group_by(chicago, tempcat)
hotcold
class(hotcold)
summarise(hotcold)
summary(hotcold)
summarise(hotcold, pm25 = mean(pm25), o3 = max(o3tmean2), no2 = median(no2tmean2))
summarise(hotcold, pm25 = mean(pm25,na.rm=TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

summarize(hotcold, pm25 = mean(pm25,na.rm=TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

summarize(hotcold, sum(!is.na(pm25)), o3 = max(o3tmean2), no2 = median(no2tmean2))


chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years <- group_by(chicago,year)
summarise(years, pm25 = mean(pm25,na.rm=TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# special operator %>% pipe line
chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarise(pm225 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))




# Merging Data???

if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 = "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile="./data/reviews.csv",method="curl")
download.file(fileUrl2,destfile="./data/solutions.csv",method="curl")
reviews = read.csv("./data/reviews.csv"); solutions <- read.csv("./data/solutions.csv")
head(reviews,2)

names(reviews)
names(solutions)

# important parameters x,y,by,by.x,by.y,all
mergedData = merge(reviews,solutions,by.x="solution_id",by.y="id", all = TRUE) # all pour ajouter row avec de NA si dans un seul..
head(mergedData)

intersect(names(solutions),names(reviews))
mergedData2 = merge(reviews,solutions,all=TRUE)
head(mergedData2)
mergedData3 = merge(reviews,solutions,all=FALSE)
head(mergedData3)

# Using Join in the plyr package
# faster but less full featured

df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
arrange(join(df1,df2),id)
# les nom doivent etre dans le 2 data set

df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
df3 = data.frame(id=sample(1:10),z=rnorm(10))
dfList = list(df1,df2,df3)
join_all(dfList)
# id commun le 3 data set

# ----------------------------------------------------------
#       Quizz Week 3
# ----------------------------------------------------------

# The American Community Survey distributes downloadable data 
# about United States communities. 
# Download the 2006 microdata survey about housing for the state 
# of Idaho using download.file() from here:  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
# and load the data into R. 
# The code book, describing the variable names is here: 
#  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 

# Create a logical vector that identifies the households on 
# greater than 10 acres who sold more than $10,000 worth of 
# agriculture products. Assign that logical vector to the variable 
# agricultureLogical. Apply the which() function like this to 
# identify the rows of the data frame where the logical vector is TRUE. 
# which(agricultureLogical) What are the first 3 values that result?

if (!file.exists("data"))       {
  dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,"./data/housing2006idaho.csv", method = "curl")
housing <- read.csv("./data/housing2006idaho.csv")

str(housing)
agricultureLogical <- (housing$ACR == 3 ) & (housing$AGS == 6 )
which(agricultureLogical)



# Question 2
# Using the jpeg package read in the following picture of your instructor into R 
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg 
# Use the parameter native=TRUE. What are the 30th and 80th quantiles 
# of the resulting data? 
# (some Linux systems may produce an answer 638 different for the 30th quantile)

library(jpeg)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileUrl,"./data/image.jpg", method = "curl")

image <- readJPEG("./data/image.jpg", native = TRUE)
class(image)
class(unclass(image))
dim(image)
?quantile()
quantile(image, probs=c(0,0.3,0.8,1))
quantile(image, probs=c(0.3,0.8))


# Question 3
# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
#  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Load the educational data from this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
# Match the data based on the country shortcode. 
# How many of the IDs match? Sort the data frame in descending 
# order by GDP rank (so United States is last). 
# What is the 13th country in the resulting data frame? 

# Original data sources: 
#  http://data.worldbank.org/data-catalog/GDP-ranking-table 
#  http://data.worldbank.org/data-catalog/ed-stats

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl,"./data/GDP.csv", method = "curl")
GDP <- read.csv("./data/GDP.csv",skip = 4,nrow = 231)


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl,"./data/edu.csv", method = "curl")
edu <- read.csv("./data/edu.csv")


names(edu)
names(GDP)

library(dplyr)
GDP <- rename(GDP,CountryCode = X, Rank = X.1, Name = X.3, gdp = X.4)
summary(GDP$Rank)
GDP <- GDP[!is.na(GDP$Rank),]

GDPEDU = merge(GDP,edu,by.x="CountryCode",by.y="CountryCode", all = FALSE) 
head(GDPEDU)
GDPEDU <- arrange(GDPEDU,desc(Rank))


# Question 4

?table()
table(GDPEDU$Income.Group,useNA="ifany")
summary(GDPEDU$Income.Group)
str(GDPEDU$Income.Group)

tapply(GDPEDU$Rank,GDPEDU$Income.Group,mean)


#GDPEDU$RankGroups = cut(GDPEDU$Rank, breaks=quantile(GDPEDU$Rank))
GDPEDU$RankGroups = cut(GDPEDU$Rank, breaks=quantile(GDPEDU$Rank, probs=c(0,0.2,0.4,0.6,0.8,1),na.rm=T))
table(GDPEDU$RankGroups)
levels(GDPEDU$RankGroups)
GDPEDU$gdp
answer <- group_by(GDPEDU, Income.Group)
summarize(answer,nb = mean(gdp))

names(GDPEDU)
table(GDPEDU$Income.Group,GDPEDU$RankGroups)

