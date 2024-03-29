library(tidyverse)
library(lubridate)

rm(list = ls())

# Begin user input ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

username = "krshedd"  # LOKI username

password = readLines("~/../R/usr_pw.txt" , n = 2)[[2]]  # LOKI password

sillyvec <- c("PSPRIN14", "PSPRIN15")  # no otolith data for PSIWAS15 :(

# not_tissues = "Otolith"  # OceanAK has 1 row of data per tissue, including both otolith and genetic tissues, we do not want the otolith stuff (this is different than otolith reads)

source("~/../R/Functions.GCL.R")  # set to your own path as necessary

# End user input ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

start_time <- proc.time()

while(!require(RJDBC)){install.packages("RJDBC")}

if(!file.exists(path.expand("~/R"))){
  
  dir<-path.expand("~/R")
  
  dir.create(dir)
  
  bool <- file.copy(from="V:/Analysis/R files/OJDBC_Jar/ojdbc8.jar",to=path.expand("~/R/ojdbc8.jar"))
  
} else {
  
  if(!file.exists(path.expand("~/R/ojdbc8.jar"))){
    
    bool <- file.copy(from="V:/Analysis/R files/OJDBC_Jar/ojdbc8.jar",to=path.expand("~/R/ojdbc8.jar"))
    
  }
  
}

start.time <- Sys.time() 

options(java.parameters = "-Xmx10g")

if(file.exists("C:/Program Files/R/RequiredLibraries/ojdbc8.jar")) {
  
  drv <- JDBC("oracle.jdbc.OracleDriver",classPath="C:/Program Files/R/RequiredLibraries/ojdbc8.jar"," ")#https://blogs.oracle.com/R/entry/r_to_oracle_database_connectivity    C:/app/awbarclay/product/11.1.0/db_1/jdbc/lib
  
} else {
  
  drv <- JDBC("oracle.jdbc.OracleDriver",classPath=path.expand("~/R/ojdbc8.jar")," ")
  
}

url <-LOKI_URL.GCL()

con <- dbConnect(drv,url=url,user=username,password=password)

data_qry <-
  paste0(
    "SELECT * FROM AKFINADM.V_SALMON_BIO_FACT_GEN_TISS WHERE SILLY_CODE IN (",
    paste0("'", sillyvec, "'", collapse = ","),
    ")"
  )

dataAll0 <- dbGetQuery(con, data_qry)   

discon <- dbDisconnect(con)  # disconnect from OceanAK

proc.time() - start_time  # how long did it take?

glimpse(dataAll0)   # what does out data look like?

dataAll0 %>% 
  count(SILLY_CODE, TISSUE_TYPE)  # sample size by silly code and tissue type, should only be hearts and occasionally other random tissues


# Write out the data to "V:\Analysis\5_Coastwide\Multispecies\Alaska Hatchery Research Program\PWS Pink\OceanAK" with timestamp
write_csv(
  x = dataAll0,
  file = paste0(
    "data/Spring 2014-2015 AHRP Salmon Biological Data ",
    Sys.time() %>% str_remove_all(pattern = "-") %>% str_remove_all(pattern = ":") %>% str_replace(pattern = " ", replacement = "_"),
    ".csv"
  )
)
