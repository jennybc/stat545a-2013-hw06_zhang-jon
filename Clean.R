#First we download the SPSS data files and use the syntax file to convert to Stata. From Stata we can open the data in a spreadsheet like format and save as CSV. We only use March data and years from 1997-2012. We cannot combine the data directly in R because the variable names (column names) are not entirely consistent in their naming, and the ordering is different from year to year. For this reason we cannot make a huge csv file for all the years: the variables are in different orderings and the many of the 79 variables have different names over time. Since we are only interested in a few variables, the best way to do this is to clean each dataset individually and then combine them. This can be done in Excel or R.

library(plyr)
library(car)

rawFiles <- list.files("rawData", full.names = TRUE)

columnKeep <- c('SURVYEAR', 'LFSSTAT', 'PROV', 'AGE_12', 'SEX',
                'EDUC90', 'TENURE', 'UNION', 'HRLYEARN', 'ATOTHRS')
provinces <- c("Al", "Br", "On", "Qu")
n <- 1000

set.seed(123)
lfsDat <- adply(rawFiles, 1, function(x) {
  cat(x, "\n")
  y <- read.csv(x)
  y <- subset(y, select = columnKeep)
  y$PROV <- factor(as.character(substr(y$PROV, 1, 2)))
  y <- droplevels(subset(y, PROV %in% provinces & LFSSTAT != "Not in lab"))
  y <- y[sample(nrow(y), n), ]
  y
})
lfsDat <- subset(lfsDat, select = -X1)
str(lfsDat)

## rename some variables
nameOrama <-        c(  'HOURS',   'EDUC',    'AGE')
names(nameOrama) <- c('ATOTHRS', 'EDUC90', 'AGE_12')
lfsDat <- rename(lfsDat, nameOrama)
str(lfsDat)

## recode some factors
lfsDat$EDUC <- recode(lfsDat$EDUC,
              "c('0 to 8 yea', 'Some secon')='HS Dropout'; 'Grade 11 t'='HS Grad'; c('Post secon', 'Some post')='Some PS'; else='BA or More'",
              levels = c('HS Dropout', 'HS Grad', 'Some PS', 'BA or More'))
summary(lfsDat$EDUC)

lfsDat$UNION <- recode(lfsDat$UNION, "'Union memb'='Yes'; 'Not member'='No'; else=NA")
summary(lfsDat$UNION)

lfsDat$AGE <- recode(lfsDat$AGE, 
                     "c('15 to 19', '20 to 24', '25 to 29')='15-29';c('30 to 34', '35 to 39', '40 to 44')='30-44'; c('45 to 49', '50 to 54', '55 to 59')='45-59'; else='60+'")
summary(lfsDat$AGE)

lfsDat$PROV <- recode(lfsDat$PROV, "'Br'='BC'; 'Al'='AL'; 'On'='ON'; else='QU'")
summary(lfsDat$PROV)

lfsDat <- arrange(lfsDat, SURVYEAR, PROV, EDUC, AGE)

write.table(lfsDat, "LFS.tsv", quote=FALSE, sep="\t", row.names=FALSE)