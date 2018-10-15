library(shiny)
#library(leaflet)
library(grid)
library(vcd)
#library(plotly)
#library(ggplot2)
#library(googleVis)
library(plyr)
library(dplyr)

#library(ggplot2movies)

#For Mac
 #setwd("~/Dropbox/GitHub/Conabio-PGMaices")

#TableP<-read.table("~/Dropbox/JANO/2016/Conabio/Github/shiny_maiz/RawData.txt", head=T, sep="\t")
dir()
#getwd()
#dir('./image')
#TableP <- read.csv("RawData.csv", head = T, sep = ",")
TableP <- read.csv("PGM_update2017.csv", head = T, sep = ",")

TTabla <- TableP %>%
  dplyr::filter(!is.na(Raza_primaria)) %>%
  dplyr::filter(!is.na(Latitud)) %>%
  dplyr::filter(Estado != "ND") %>%
  dplyr::filter(Raza_primaria != "ND")

levels(TTabla$Estado)
dim(TTabla)
names(TTabla)
TTabla$Anhio_Colecta <- base::as.factor(TTabla$Anhio_Colecta)
#TTabla[Tabla$Estado=="ND",]
str(TTabla)

levels(TTabla$Anhio_Colecta)
levels(TTabla$Estado)
levels(TTabla$Complejo_racial)
levels(TTabla$Raza_primaria)


names(TTabla)
TTabla <- TTabla %>%
  dplyr::mutate(Estado = revalue(Estado,c("AGUASCALIENTES" = "Aguascalientes"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("BAJA CALIFORNIA" = "Baja California"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("BAJA CALIFORNIA SUR" = "Baja California Sur"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("CAMPECHE" = "Campeche"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("CHIAPAS" = "Chiapas"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("CHIHUAHUA" = "Chihuahua"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("COAHUILA DE ZARAGOZA" = "Coahuila"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("COLIMA" = "Colima"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("DISTRITO FEDERAL" = "Ciudad de México"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("DURANGO" = "Durango"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("MEXICO" = "Estado de México"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("GUANAJUATO" = "Guanajuato"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("GUERRERO" = "Guerrero"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("HIDALGO" = "Hidalgo"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("JALISCO" = "Jalisco"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("MICHOACAN DE OCAMPO" = "Michoacán"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("MORELOS" = "Morelos"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("NAYARIT" = "Nayarit"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("NUEVO LEON" = "Nuevo León"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("OAXACA" = "Oaxaca"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("PUEBLA" = "Puebla"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("QUERETARO DE ARTEAGA" = "Querétaro"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("QUINTANA ROO" = "Quintana Roo"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("SAN LUIS POTOSI" = "San Luis Potosí"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("SINALOA" = "Sinaloa"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("SONORA" = "Sonora"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("TABASCO" = "Tabasco"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("TAMAULIPAS" = "Tamaulipas"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("TLAXCALA" = "Tlaxcala"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("VERACRUZ DE IGNACIO DE LA LLAVE" = "Veracruz"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("YUCATAN" = "Yucatán"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("ZACATECAS" = "Zacatecas"))) %>%
  dplyr::mutate(Complejo_racial = revalue(Complejo_racial,c("Chapalote" = "Chapalotes"))) %>%
  dplyr::mutate(Complejo_racial = revalue(Complejo_racial,c("Cónico" = "Cónicos"))) %>%
  dplyr::mutate(Raza_primaria = revalue(Raza_primaria,c("Nal-Tel de Altura" = "Nal-tel de Altura"))) %>%
  dplyr::mutate(Raza_primaria = revalue(Raza_primaria,c("Complejo Serrano de Jalisco" = "Serrano de Jalisco")))

 
names(TTabla)
head(TTabla)
summary(TTabla)
names(TTabla)[20] <- c("longitude")
names(TTabla)[21] <- c("latitude")

dim(TTabla)
nrow(TTabla)

#Ventana 1 Mapa
TableL <- TTabla
#TableL$Periodo <- as.character(TableL$Periodo)
str(TableL$Periodo)

names(TableL)
str(TableL)
#Ventana 2 Foto y Cleveland Plot
TableL1 <- TTabla
Val1 <- rep(1, nrow(TableL1))
TableL1 <- data.frame(TableL1[,-c(31,32)], Val1)
head(TableL1)
rm(Val1)
names(TableL1)[27] <- c("Raza_Primaria")
names(TableL1)

TableL1a <- stats::aggregate(TableL1[,31], by = list(TableL1$Raza_Primaria,TableL1$Estado), FUN = sum, na.rm = T)
#TableL1b <- aggregate(TableL1[,17], by = list(Raza_Primaria,Estado), FUN = sum, na.rm = T)
head(TableL1a)

#TableL1c <- data.frame(TableL1a,TableL1b[,3])
names(TableL1a)[1] <- c("Raza_Primaria")
names(TableL1a)[2] <- c("Estado")
names(TableL1a)[3] <- c("Val1")
head(TableL1a)

TableL1c <- TableL1a


#Ventana 3 StrucPlot
Val1 <- rep(1, nrow(TTabla))
TableLL <- data.frame(TTabla, Val1)
names(TableLL)
rm(Val1)
TableLL <- TableLL[,c(27,28,10,17,31)]


names(TableL)
Val1 <- rep(1, nrow(TableL))
TableL1 <- data.frame(TableL,Val1)
names(TableL1)

TableL2 <- TableL1[,c(27,28,17,31)]


#TablaPP <- select_all(TableL, Raza_primaria)
TablaPP <- TableL %>%
  dplyr::select(Raza_primaria, Complejo_racial) %>%
  #dplyr::select(!!Genero, !!Determinador) %>%
  distinct()

getwd()
#Cargar los datos de Teocintle
Teocintle <- read.csv("Teocintle.csv", head = T, sep = ",")

Teo1 <- Teocintle %>%
  filter(!is.na(Latitud)) %>%
  distinct()

names(Teo1)[15] <- c("longitude")
names(Teo1)[16] <- c("latitude")
names(Teo1)[14] <- c("Altitud")

dim(Teocintle)
dim(Teo1)

#Cargar los datos de Teocintle
Tripsacum <- read.delim("Tripsacum.csv", head = T, sep = ",")
Trip1 <- Tripsacum %>%
  #mutate(Altitud = as.numeric(Altitud)) %>%
  #mutate(Longitud = as.numeric(Longitud)) %>%
  #mutate(Latitud = as.numeric(Latitud)) %>%
  dplyr::filter(!is.na(Latitud)) %>%
  distinct()

names(Trip1)
head(Trip1,25)


names(Trip1)[12] <- c("longitude")
names(Trip1)[13] <- c("latitude")

Trip2 <- data.frame(Trip1, Tipo = "Tripsacum")

names(Teo1)

Teo2 <- data.frame(Teo1, Tipo = "Teocintle")

dim(Trip2)
dim(Teo2)

names(Trip2)
names(Teo2)
Trip2 <- Trip2 %>%
  select(Tipo, longitude, latitude, Fuente, Taxa, Estado, Municipio)
str(Trip2)
dim(Trip2)
Teo2 <- Teo2 %>%
  select(Tipo, longitude, latitude, Fuente, Taxa, Estado, Municipio)
dim(Teo2)


Parientes <- rbind(Trip2, Teo2)
str(Parientes)

#Parientes$longitude[!is.na(Parientes$longitude)]

Anexo6 <- read.csv("Anexo6_InfoMaices.csv", head = T, sep = ",")
Anexo6$Raza_Primaria <- as.character(Anexo6$Raza_Primaria)
