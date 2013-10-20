#First we download the SPSS data files and use the syntax file to convert to Stata. From Stata we can open the data in a spreadsheet like format and save as CSV. We only use March data and years from 1997-2012. We cannot combine the data directly in R because the variable names (column names) are not entirely consistent in their naming, and the ordering is different from year to year. For this reason we cannot make a huge csv file for all the years: the variables are in different orderings and the many of the 79 variables have different names over time. Since we are only interested in a few variables, the best way to do this is to clean each dataset individually and then combine them. This can be done in Excel or R.

library(plyr)
library(ggplot2)

LFS97 <- read.csv(file="97.csv")
LFS98 <- read.csv(file="98.csv")
LFS99 <- read.csv(file="99.csv")
LFS00 <- read.csv(file="00.csv")
LFS01 <- read.csv(file="01.csv")
LFS02 <- read.csv(file="02.csv")
LFS03 <- read.csv(file="03.csv")
LFS04 <- read.csv(file="04.csv")
LFS05 <- read.csv(file="05.csv")
LFS06 <- read.csv(file="06.csv")
LFS07 <- read.csv(file="07.csv")
LFS08 <- read.csv(file="08.csv")
LFS09 <- read.csv(file="09.csv")
LFS10 <- read.csv(file="10.csv")
LFS11 <- read.csv(file="11.csv")
LFS12 <- read.csv(file="12.csv")
LFS13 <- read.csv(file="13.csv")

data <- list(LFS97, LFS98, LFS99, LFS00, LFS01, LFS02, LFS03, LFS04, LFS05, LFS06, LFS07, LFS08, LFS09, LFS10, LFS11, LFS12, LFS13)
columnKeep <- c("SURVYEAR", "LFSSTAT", "PROV", "AGE_12", "SEX", "EDUC90", "TENURE", "UNION", "HRLYEARN", "ATOTHRS")
keep <- function(x) {
    x<-subset(x, select=columnKeep)
    return(x)
}
LFSraw <- ldply(data, keep)

# Let's only keep BC, Alberta, Ontario and Québec, and drop anyone not in labour force.
provinces <- c("Alberta", "British Co", "Ontario", "Québec")
LFS <- droplevels(subset(LFSraw, PROV %in% provinces & LFSSTAT != "Not in lab"))

# Look how difficult it is to read `EDUC90', let's change that. Also `British Co' is not desired, nor do we want to be dealing with the accent on Quebec, let's replace them with abbreviations. Similarily let's change `Union` and rename Hours worked.
head(LFS)

names(LFS)[names(LFS) == 'ATOTHRS']<-"HOURS"

newEducation <- function(x){
  if(x=="0 to 8 yea" | x=="Some secon")
   return("HS Dropout")
  if(x=="Grade 11 t")
    return("HS Grad")
  if(x=="Post secon" | x=="Some post")
    return("Some PS")
  else
    return("BA or More")
}

newUnion <- function(x){
  if(x=="Union memb")
   return("Yes")
  if(x=="Not member")
    return("No")
  else
    return("NA")
}

newProv <- function(x){
  if(x=="British Co")
   return("BC")
  if(x=="Alberta")
    return("AL")
  if(x=="Ontario")
    return("ON")
  else
    return("QU")
}

newAge <- function(x){
  if(x=="15 to 19" | x=="20 to 24" | x=="25 to 29")
   return("15-29")
  if(x=="30 to 34" | x=="35 to 39" | x=="40 to 44")
    return("30-44")
  if(x=="45 to 49" | x=="50 to 54" | x=="55 to 59")
   return("45-59")
  else
    return("60+")
}

# Create the new variables. Some reason I could not use `ddply` and create them, I will resort to `sapply`
LFS$EDUC <- as.factor(sapply(LFS$EDUC90, newEducation))
LFS$PROV <- as.factor(sapply(LFS$PROV, newProv))
LFS$UNION<- as.factor(sapply(LFS$UNION, newUnion))
LFS$AGE <- as.factor(sapply(LFS$AGE_12, newAge))

# Let's drop EDUC90 variable
LFS<-LFS[,!names(LFS) %in% c("EDUC90", "AGE_12")]

str(LFS)

# I want to create a random sample of 1000 observations for each year.
set.seed(123)
random <- function(x){
  samples<-sample(1:nrow(x), 1000)
  set <- x[samples,]
}

LFS<-ddply(LFS, ~SURVYEAR, random)

write.table(LFS, "LFS.csv", quote=FALSE, sep="\t", row.names=FALSE)
