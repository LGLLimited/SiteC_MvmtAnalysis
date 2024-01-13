#Load Packages
library(DBI)
library(tidyverse)
library(lubridate)

#Connect to the SQL Database
con <- dbConnect(odbc::odbc(), 
                 Driver = "SQL Server", 
                 Server = "YAKIMA-SQL01", 
                 Database = "BCHydro_SiteCFishMovementAssessment")

#Check Database
con
dbListTables(con)

#Example1 - pull from DB using tidyverse 
test1 <- dbReadTable(con,"TaggedFish") %>% 
  as_tibble() %>%
  select(Tag_ID = TaggedFishID, Ch = Channel, Code = RadioTagCode, Species, LifeStage) %>%
  filter(Species == "Burbot" & Ch == 5)
test1

#Example2 - pull from DB using SQL
#Write SQL code in R
sql <- "
SELECT [TaggedFishID] AS [Tag_ID], [Channel] AS [Ch], [RadioTagCode] AS [Code], [Species], [LifeStage]
FROM [BCHydro_SiteCFishMovementAssessment].[dbo].[TaggedFish]
WHERE [Species] = 'Burbot' AND Channel = 5 
"

#Run that SQL code and pull from the Database
test2 <- dbGetQuery(con, sql) %>%
  as_tibble()
test2

#Compare data
test1 == test2

#Disconnect from Database
dbDisconnect(con)


