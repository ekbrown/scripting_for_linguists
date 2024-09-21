library("data.table")
library("tidyverse")

setwd("/pathway/to/dir/")

freqs_tidy <- read_csv("freqs.csv")
concord_tidy <- read_csv("concordances.csv")
freqs_dt <- fread("freqs.csv")
concord_dt <- fread("concordances.csv")

# tidyverse
for (i in 1:100) {
  
  ### tidyverse ###
  t1 <- Sys.time()
  concord_tidy <- left_join(concord_tidy, freqs_tidy, by = join_by(match == wd))
  dur_tidy <- Sys.time() - t1
  cat(str_c("Tidyverse,", i, ",", dur_tidy, "\n", sep = ""), file = "times.csv", append = T)
  
  ### data.table ###
  t2 <- Sys.time()
  concord_dt[freqs_dt, on = .(match = wd), freq := i.n]
  dur_dt <- Sys.time() - t2
  cat(str_c("data.table,", i, ",", dur_dt, "\n", sep = ""), file = "times.csv", append = T)
  
}