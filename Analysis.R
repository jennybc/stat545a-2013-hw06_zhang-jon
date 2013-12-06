LFS <- read.delim("LFS.tsv")

library(plyr)
library(ggplot2)
library(gridExtra)


wageByYear <- ddply(LFS, .(SURVYEAR, PROV, EDUC), summarize,
                    AvgWage=mean(HRLYEARN, na.rm=TRUE))
p <- ggplot(wageByYear, aes(x = SURVYEAR, y = AvgWage, color=EDUC))
p + geom_point(cex=3) + geom_line(lwd=1) + facet_wrap(~PROV)

ggsave("AvgWagebyProv.png")

## Are there differences in wage between genders?
wageBySex <- ddply(LFS, .(SURVYEAR, SEX), summarize, AvgWage=mean(HRLYEARN, na.rm=TRUE))
ggplot(wageBySex, aes(x=SURVYEAR, y=AvgWage, col=SEX)) + geom_point(cex=4) + geom_line(lwd=1.5)

ggsave("AvgWagebySex.png")

## Hourly Earnings by Education level over time

subset(LFS, EDUC=="BA or more" | EDUC=="HS Dropout")

ggplot(droplevels(subset(LFS, EDUC %in% c("BA or More", "HS Dropout"))), aes(x=EDUC, y=HRLYEARN)) + geom_jitter(na.rm=TRUE) + facet_wrap(~SURVYEAR) + geom_line(stat = "summary", fun.y = "median", col = "red", lwd = 1, aes(group=SURVYEAR), na.rm=TRUE)

ggsave("EarningsbyEduc.png")

## Unemployment ratios?
ratio <- function(x,y){
  sum(x=="Unemployed")/length(y)
}

unemploymentRate <- ddply(LFS, .(SURVYEAR, PROV, EDUC), summarize, UnemploymentRate=ratio(LFSSTAT,PROV), 
                          count=sum(LFSSTAT=="Unemployed"))

ggplot(unemploymentRate, aes(x=SURVYEAR, y=UnemploymentRate, color=EDUC)) +geom_point()+geom_line()+facet_wrap(~PROV)+scale_fill_brewer(type = "qual", palette = 7)

ggsave("unemploymentRate.png")

## Effects of Union

unionizedlfs<-subset(LFS, !(subset=is.na(UNION)))

png("UnionPlots.png", width=720, height=16*72)

a <- ggplot(unionizedlfs, aes(x = HOURS, color=UNION)) + geom_density(lwd = 1) + facet_wrap(~SEX)
b <- ggplot(unionizedlfs, aes(x = HRLYEARN, color=UNION)) + geom_density(lwd = 1) + facet_wrap(~SEX)
c <- ggplot(unionizedlfs, aes(x = TENURE, color=UNION)) + geom_density(lwd = 1) + facet_wrap(~SEX)

grid.arrange(a, b, c, ncol=1)

dev.off()

## Regression on returns to education. Only a table, nothing to really plot
EducReg <- function(x) {
  Coefs <- coef(lm(HRLYEARN ~ factor(EDUC), x))
  names(Coefs) <- c("Intercept", "HS Dropout", "HS Grad", "Some PS")
  return(Coefs)
}

ReturnsToEducation <- ddply(LFS, ~SURVYEAR, EducReg)

## Box whisker plots of hourly earnings over time by Province.
smallset <- subset(LFS, subset=SURVYEAR %in% c("1997", "2002", "2007", "2012"))

ggplot(smallset, aes(x = PROV, y = HRLYEARN, fill = PROV)) + geom_boxplot(alpha = 0.2, na.rm=TRUE) + facet_wrap(~SURVYEAR) + ggtitle("Boxplot of Earnings by Province")

ggsave("earningsBoxplot.png")

## Distribution of Earnings and Tenure

ggplot(smallset, aes(x = HRLYEARN, color = SEX)) + geom_density(lwd = 1, na.rm=TRUE) + facet_wrap(~SURVYEAR) +ggtitle("Density of Earnings")

ggsave("earningsDensity.png")

ggplot(LFS, aes(x=TENURE, color=AGE)) + geom_density(lwd=1.5, na.rm=TRUE) 

ggsave("tenureDensity.png")
