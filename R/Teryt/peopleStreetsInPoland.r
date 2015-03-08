#this script is reading Teryt data set containg information about Polish administrative division up to streets
#It also generates list of most popular people in polish streets names for every voivoideship
#It requires ULIX.xml that contains information about all streets in poland
#I took it from http://www.stat.gov.pl/broker/access/prefile/listPreFiles.jspa (ULIC file)
require(XML)
require(plyr)


#parsing xml with name of the streets
xmlfile <- xmlTreeParse("ULIC.xml", useInternalNodes = TRUE, encoding = "UTF-8");

#converting xml to data.frame
teryt <- data.frame(
  WOJ=sapply(xmlfile["//teryt/catalog/row/col[@name='WOJ']/text()"], xmlValue),
  POW=sapply(xmlfile["//teryt/catalog/row/col[@name='POW']/text()"], xmlValue),
  GMI=sapply(xmlfile["//teryt/catalog/row/col[@name='GMI']/text()"], xmlValue),
  RODZ_GMI=sapply(xmlfile["//teryt/catalog/row/col[@name='RODZ_GMI']/text()"], xmlValue),
  SYM=sapply(xmlfile["//teryt/catalog/row/col[@name='SYM']/text()"], xmlValue),
  SYM_UL=sapply(xmlfile["//teryt/catalog/row/col[@name='SYM_UL']/text()"], xmlValue),
  CECHA=sapply(xmlfile["//teryt/catalog/row/col[@name='CECHA']/text()"], xmlValue),
  NAZWA_1=sapply(xmlfile["//teryt/catalog/row/col[@name='NAZWA_1']/text()"], xmlValue),
STAN_NA=sapply(xmlfile["//teryt/catalog/row/col[@name='STAN_NA']/text()"], xmlValue));
streets <- count(teryt, c("NAZWA_1", "WOJ"));

#we are removing original data as they are too large to keep
rm(teryt);


#translation beetwen code and names of voivoidships
wojewodztwa <- read.csv("woj.csv", encoding = "UTF-8", colClasses=c("character", "character"), sep = ";");
#list of people
people <- readLines("people.csv")

#now we would like to check which people are the most popular in different voivoidships


splitedPeopleStreets <- split(peopleStreets, peopleStreets$WOJ);
splitedPeopleStreets <- lapply(splitedPeopleStreets, function(x) x[1:10, ]);
tenFirst <- sapply(splitedPeopleStreets, function(x) t(x)[1, ]);
transposedTenFirst <- t(tenFirst);
finalTable <- data.frame(matrix(unlist(transposedTenFirst), nrow=16))
colnames(finalTable) <- 1:10
finalTable$Wojewodztwo <- wojewodztwa$NWOJ

#and we have final table
finalTable <- finalTable[, c(11, 1:10)];

