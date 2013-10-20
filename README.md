Homework 6 by Jonathan Zhang

The data consists of 17 years, each year is approximately 30mb. Therefore the data could not be uploaded onto GitHub. It can be found here: [`LFS.raw`](https://www.dropbox.com/s/y02gt99rmwomy4m/lfS.zip).
My apologies for using Dropbox, however, I cannot come up with another way to provide data of that size. Good news is, the clean data is here: [`LFS.csv`] (https://github.com/jzhang722/stat545a-2013-hw06_zhang-jon/blob/master/LFS.csv).

The raw data was downloaded from ABACUS data library in SPSS format and converted in SPSS with its syntax file. 
Thus we arrive at 17 datasets: for the years 1997 to 2013. I only use the March data. Next I save the data into csv format, resulting in the 17 files in the zip file.
Each dataset has around 79 different variables. Most variables are redundant, for example three variables may describe the same thing but the variable names and conventions change over the years.
Because the data is extremely large (over 100,000 per dataset), and the ordering of variables and the variable names are not consistent, one must clean each individual dataset and then combine.
From the 79 variables I chose the more important ones and created a clean dataset. For more information see my RPubs: (http://rpubs.com/jzhang722/stat545a-2013-hw06_zhang-jon)

Here is the gist: https://gist.github.com/jzhang722/7074833#file-stat545a-2013-hw06_zhang-jon


How to replicate my analysis:

Download the zip file from the dropbox and extract all 17 files. The files are labeled 97, 98, 99, 00, etc for the years: 1997, 1998, 1999, 2000 and so on.

Save the R scripts: [`Clean.R`] (https://github.com/jzhang722/stat545a-2013-hw06_zhang-jon/blob/master/Clean.R), [`Analysis.R`] (https://github.com/jzhang722/stat545a-2013-hw06_zhang-jon/blob/master/Analysis.R) and [`makefile.R`] (https://github.com/jzhang722/stat545a-2013-hw06_zhang-jon/blob/master/makefile.R)

Run [`makefile.R`] (https://github.com/jzhang722/stat545a-2013-hw06_zhang-jon/blob/master/makefile.R)

My apologies for not using make, after many painful hours I could not get it working on my computer (Windows), I'm sure it is not that difficult...





