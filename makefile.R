## one script to rule them all

## clean out any previous work
outputs <- c("LFS.csv", # 01_filterReorder.R
             list.files(pattern = "*.png$"))
file.remove(outputs)

## run my scripts
source("Clean.R")
source("Analysis.R")