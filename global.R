library(shiny)
library(leaflet)
library(dplyr)

#For PC
#setwd("C:\\Users\\aponce\\Dropbox\\JANO\\2016\\Conabio\\Github\\shiny_maiz\\")

#For Mac
#setwd("~/Dropbox/JANO/2016/Conabio/Github/shiny_maiz/")

#TableP<-read.table("~/Dropbox/JANO/2016/Conabio/Github/shiny_maiz/RawData.txt", head=T, sep="\t")
TableP <- read.table("RawData.txt", head=T, sep= "\t", fileEncoding = "WINDOWS-1252")

dim(TableP)
names(TableP)
TTabla <- TableP %>%
  filter(!is.na(Raza_primaria)) %>%
  filter(!is.na(Latitud))
dim(TTabla)
names(TTabla)
TTabla$Anhio_Colecta <- as.factor(TTabla$Anhio_Colecta)
#TTabla[Tabla$Estado=="ND",]
str(TTabla)

names(TTabla)[11] <- c("longitude")
names(TTabla)[12] <- c("latitude")

TableL<-TTabla

#Not used
#TableL<-TTabla%>%
#  select(IdEjemplar,Raza_primaria,Complejo_racial, Anhio_Colecta, Periodo_Colecta, Estado,Municipio, Altitud,Localidad, longitude=Longitud,latitude=Latitud,
#         Longitud_de_mazorca,Diametro_de_mazorca,Hileras_por_mazorca,Granos_por_hilera, Altura_de_planta,Dias_a_floracion_masculina,
#         Dias_a_floracion_femenina,Altura_de_mazorca,Mazorcas_por_planta)


