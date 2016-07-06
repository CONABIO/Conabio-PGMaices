library(shiny)
library(leaflet)
library(dplyr)

setwd("~/Dropbox/JANO/2016/Conabio/Github/shiny_maiz/")
TableP<-read.table("RawData.txt", head=T, sep="\t")

dim(TableP)
names(TableP)
TTabla <- TableP%>%
  filter(!is.na(Raza_primaria))%>%
  filter(!is.na(Latitud))
dim(TTabla)
names(TTabla)
TTabla$Anhio_Colecta <- as.factor(TTabla$Anhio_Colecta)
#TTabla[Tabla$Estado=="ND",]
str(TTabla)
TableL<-TTabla%>%
  select(IdEjemplar,Raza_primaria,Complejo_racial, Anhio_Colecta, Periodo_Colecta, Estado,Municipio, Altitud,Localidad, longitude=Longitud,latitude=Latitud,
    Longitud_de_mazorca,Diametro_de_mazorca,Hileras_por_mazorca,Granos_por_hilera, Altura_de_planta,Dias_a_floracion_masculina,
    Dias_a_floracion_femenina,Altura_de_mazorca,Mazorcas_por_planta)

#TableL1<-TTabla%>%
#  select(Raza_primaria,Complejo_racial, Estado, Municipio, Localidad,Anhio_Colecta, Periodo_Colecta)
#head(TableL1)
#TableL1<- TableL1[order(TableL1$Estado),]
#head(TableL1)
#dim(TableL1)
#TableL1 <- data.frame(TableL1, rep(1,nrow(TableL1)))
#head(TableL1)
#names(TableL1)[8] <- c("Valores")
#TableL1 <- TableL1[,c(1,3,8)]
#names(TableL1)
#levels(TableL1$Raza_primaria)




