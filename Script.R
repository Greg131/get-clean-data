# ----------------------------------------------------------
# Script week 1
# ----------------------------------------------------------

setwd("~/Dropbox/Datascience/Université Johns-Hopkins/Obtenir et trier les données")
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
dateDownloaded <- date()
dateDownloaded

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