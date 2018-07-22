library(shiny)
library(leaflet)
library(plyr)
library(dplyr)
library(grid)
library(vcd)
library(plotly)
library(ggplot2)
library(googleVis)

#library(ggplot2movies)

#For Mac
 
#setwd("~/Dropbox/GitHub/Conabio-PGMaices")

#TableP<-read.table("~/Dropbox/JANO/2016/Conabio/Github/shiny_maiz/RawData.txt", head=T, sep="\t")
dir()
#getwd()
#dir('./image')
#TableP <- read.csv("RawData.csv", head = T, sep = ",")
TableP <- read.csv("PGM_maices_Alex.csv", head = T, sep = ",")

#str(TableP)
names(TableP)
levels(TableP$Complejo_racial)
names(TableP)
TableP$Longitud
head(TableP)
dim(TableP)
names(TableP)
TableP$Estado
TTabla <- TableP %>%
  filter(!is.na(Raza_primaria)) %>%
  filter(!is.na(Latitud)) %>%
  filter(Estado != "ND") %>%
  filter(Raza_primaria != "ND")

levels(TTabla$Estado)
dim(TTabla)
names(TTabla)
TTabla$Anhio_Colecta <- as.factor(TTabla$Anhio_Colecta)
#TTabla[Tabla$Estado=="ND",]
str(TTabla)

levels(TTabla$Anhio_Colecta)
levels(TTabla$Estado)
levels(TTabla$Complejo_racial)
levels(TTabla$Raza_primaria)


names(TTabla)
TTabla <- TTabla %>%
  mutate(Estado = revalue(Estado,c("AGUASCALIENTES" = "Aguascalientes"))) %>%
  mutate(Estado = revalue(Estado,c("BAJA CALIFORNIA" = "Baja California"))) %>%
  mutate(Estado = revalue(Estado,c("BAJA CALIFORNIA SUR" = "Baja California Sur"))) %>%
  mutate(Estado = revalue(Estado,c("CAMPECHE" = "Campeche"))) %>%
  mutate(Estado = revalue(Estado,c("CHIAPAS" = "Chiapas"))) %>%
  mutate(Estado = revalue(Estado,c("CHIHUAHUA" = "Chihuahua"))) %>%
  mutate(Estado = revalue(Estado,c("COAHUILA DE ZARAGOZA" = "Coahuila"))) %>%
  mutate(Estado = revalue(Estado,c("COLIMA" = "Colima"))) %>%
  mutate(Estado = revalue(Estado,c("DISTRITO FEDERAL" = "Ciudad de México"))) %>%
  mutate(Estado = revalue(Estado,c("DURANGO" = "Durango"))) %>%
  mutate(Estado = revalue(Estado,c("MEXICO" = "México"))) %>%
  mutate(Estado = revalue(Estado,c("GUANAJUATO" = "Guanajuato"))) %>%
  mutate(Estado = revalue(Estado,c("GUERRERO" = "Guerrero"))) %>%
  mutate(Estado = revalue(Estado,c("HIDALGO" = "Hidalgo"))) %>%
  mutate(Estado = revalue(Estado,c("JALISCO" = "Jalisco"))) %>%
  mutate(Estado = revalue(Estado,c("MICHOACAN DE OCAMPO" = "Michoacán"))) %>%
  mutate(Estado = revalue(Estado,c("MORELOS" = "Morelos"))) %>%
  mutate(Estado = revalue(Estado,c("NAYARIT" = "Nayarit"))) %>%
  mutate(Estado = revalue(Estado,c("NUEVO LEON" = "Nuevo León"))) %>%
  mutate(Estado = revalue(Estado,c("OAXACA" = "Oaxaca"))) %>%
  mutate(Estado = revalue(Estado,c("PUEBLA" = "Puebla"))) %>%
  mutate(Estado = revalue(Estado,c("QUERETARO DE ARTEAGA" = "Querétaro"))) %>%
  mutate(Estado = revalue(Estado,c("QUINTANA ROO" = "Quintana Roo"))) %>%
  mutate(Estado = revalue(Estado,c("SAN LUIS POTOSI" = "San Luis Potosí"))) %>%
  mutate(Estado = revalue(Estado,c("SINALOA" = "Sinaloa"))) %>%
  mutate(Estado = revalue(Estado,c("SONORA" = "Sonora"))) %>%
  mutate(Estado = revalue(Estado,c("TABASCO" = "Tabasco"))) %>%
  mutate(Estado = revalue(Estado,c("TAMAULIPAS" = "Tamaulipas"))) %>%
  mutate(Estado = revalue(Estado,c("TLAXCALA" = "Tlaxcala"))) %>%
  mutate(Estado = revalue(Estado,c("VERACRUZ DE IGNACIO DE LA LLAVE" = "Veracruz"))) %>%
  mutate(Estado = revalue(Estado,c("YUCATAN" = "Yucatán"))) %>%
  mutate(Estado = revalue(Estado,c("ZACATECAS" = "Zacatecas"))) %>%
  mutate(Complejo_racial = revalue(Complejo_racial,c("Chapalote" = "Chapalotes"))) %>%
  mutate(Complejo_racial = revalue(Complejo_racial,c("Cónico" = "Cónicos"))) %>%
  mutate(Raza_primaria = revalue(Raza_primaria,c("Nal-Tel de Altura" = "Nal-tel de Altura"))) %>%
  mutate(Raza_primaria = revalue(Raza_primaria,c("Complejo Serrano de Jalisco" = "Serrano de Jalisco")))

 # mutate(Complejo_racial = revalue(Complejo_racial,c("Dentados_tropicales" = "Dentados tropicales")))
  #mutate(Raza_primaria = revalue(Raza_primaria,c("Palomero Toluqueño" = "Palomero Toluqueño")))

#  mutate(Complejo_racial = revalue(Complejo_racial,c("Dentados_tropicales" = "Den_Trop"))) %>%
#  mutate(Complejo_racial = revalue(Complejo_racial,c("Ocho hileras" = "8_Hileras"))) %>%
#  mutate(Complejo_racial = revalue(Complejo_racial,c("Sierra Chihuahua" = "S_Chih"))) %>%
#  mutate(Complejo_racial = revalue(Complejo_racial,c("Tropicales precoces" = "Trop_Prec"))) %>%
#  mutate(Complejo_racial = revalue(Complejo_racial,c("Tropicales tardíos" = "Trop_Tar")))

levels(TTabla$Estado)
levels(TTabla$Complejo_racial)

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

#Ventana 2 Foto y Cleveland Plot
TableL1 <- TTabla
Val1 <- rep(1, nrow(TableL1))
TableL1 <- data.frame(TableL1[,-c(31,32)], Val1)
head(TableL1)
rm(Val1)
names(TableL1)[27] <- c("Raza_Primaria")
names(TableL1)

attach(TableL1)
TableL1a <- aggregate(TableL1[,31], by = list(Raza_Primaria,Estado), FUN = sum, na.rm = T)
#TableL1b <- aggregate(TableL1[,17], by = list(Raza_Primaria,Estado), FUN = sum, na.rm = T)
head(TableL1a)

names(TableL1a)
dim(TableL1a)

detach(TableL1)

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


names(TableL)
TablaPP <- TableL %>%
  select(Raza_primaria, Complejo_racial) %>%
  #filter(Altitud < 5000) %>%
  distinct()



#Cargar los datos de Teocintle
Teocintle <- read.csv("Teocintle.csv", head = T, sep = ",")
head(Teocintle)
dim(Teocintle)
summary(Teocintle)

Teo1 <- Teocintle %>%
  filter(!is.na(Latitud)) %>%
  distinct()

names(Teo1)[15] <- c("long")
names(Teo1)[16] <- c("lat")

dim(Teocintle)
dim(Teo1)

#Cargar los datos de Teocintle
Tripsacum <- read.delim("Tripsacum.csv", head = T, sep = ",")
head(Tripsacum)
dim(Tripsacum)
summary(Tripsacum)
str(Tripsacum)
Trip1 <- Tripsacum %>%
  #mutate(Altitud = as.numeric(Altitud)) %>%
  #mutate(Longitud = as.numeric(Longitud)) %>%
  #mutate(Latitud = as.numeric(Latitud)) %>%
  filter(!is.na(Latitud)) %>%
  distinct()

names(Trip1)
head(Trip1,25)

names(Trip1)[12] <- c("long")
names(Trip1)[13] <- c("lat")

#Trip2 <- data.frame()

Anexo6 <- read.csv("Anexo6_InfoMaices.csv", head = T, sep = ",")
Anexo6$Raza_Primaria <- as.character(Anexo6$Raza_Primaria)
#class(Anexo6)
#head(Anexo6)
#dim(Anexo6)
#names(Anexo6)

#Anexo6[45,3]
#Anexo6
#str(Anexo6)
#Anexo7 <- Anexo6 %>%
#  dplyr::filter(Raza_Primaria == "Chalqueño") %>%
#  dplyr::select(Informacion1)

#class(Anexo7)

#print(Anexo7)
#print(Anexo7[1,1])
#head(Anexo7)
#dim(Anexo7)
#Anexo6[Anexo6$Raza_Primaria == "Cónico"]
#Anexo6a <- Anexo6[Anexo6$Raza_Primaria %in% inorg,3]
#print(Anexo6a)

