## one script to rule them all

## fine-tune the cleaning strategy to avoid this redoing this step in most
## scenarios; set nuke to TRUE if you want to re-clean and assemble the data
nuke <- TRUE

## clean out any previous work
if(nuke) {
  outputs <- c("LFS.tsv",
               list.files(pattern = "*.png$"))
} else {
  outputs <- c(list.files(pattern = "*.png$"))
}

file.remove(outputs)

## run my scripts
if(!file.exists("LFS.tsv")) source("Clean.R")
source("Analysis.R")