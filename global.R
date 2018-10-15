#Los datos vienen de éste sitio:
# http://www.humaneborders.info/app/map.asp

#Este trabajo se ha hecho por https://humaneborders.org/

#Four states are border with Mexico
#California
#Arizona
#New Mexico
# Texas

library(tidyverse)

getwd()

#setwd("~/Dropbox/JANO/2018/MexicanBorders/")
dir()

Tabla1 <- read.delim("ogis_migrant_deaths1.csv", sep = "," ,header = T)
#names(Tabla1)[1:10] <- c("lat", "lng", "Altitude", "Precision", "Fecha", "Edo", "Municipio", "Nombre", "Altura", "NScientific")

Today <- as.Date(Tabla1$Reporting_Date, "%m/%d/%y")

Today1 <- data.frame(date = Today,
                     year = as.numeric(format(Today, format = "%Y")),
                     month = as.numeric(format(Today, format = "%m")),
                     day = as.numeric(format(Today, format = "%d")))

Tabla1 <- data.frame(Tabla1, Today1)
dim(Tabla1)
head(Tabla1)

summary(Tabla1)

names(Tabla1)

Tabla2 <- Tabla1 %>%
  select(Latitude, Longitude, Sex, Age, Surface_Management, Corridor, Cause_of_Death,
         State, County, ML_Number, year, month, day) %>%
  #na.omit(Age) %>%
  dplyr::mutate(County = recode(County,"PIMA" = "Pima", "SANTA CRUZ" = "Santa Cruz", "PINAL" = "Pinal", "COCHISE" = "Cochise")) %>%
  dplyr::mutate(Cause_of_Death = recode(Cause_of_Death,"Other injury" = "Other Injury", "Not Reported" = "Not_Reported")) %>%
  dplyr::mutate(Sex = recode(Sex,"undetermined" = "Undetermined")) %>%
  distinct()


Tabla2[Tabla2$Cause_of_Death == "Not_Reported",]
Tabla2[2847:2849,]
Tabla2[Tabla2$Sex == "Undetermined",]


names(Tabla2) <- c("lat", "lng", "Sex", "Age", "Surface_management", "Corridor",
                        "Cause_of_death", "State", "County", "ML_Number", "Year", "Month",
                        "Day")

Tabla2.1 <- data.frame(Tabla2, val = 1)
