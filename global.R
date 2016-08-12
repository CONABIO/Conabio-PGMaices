library(shiny)
library(leaflet)
library(dplyr)
library(plyr)
library(grid)
library(vcd)
library(plotly)
library(ggplot2)
library(ggplot2movies)


#For PC
#setwd("C:\\Users\\aponce\\Dropbox\\JANO\\2016\\Conabio\\Github\\shiny_maiz\\")

#For Mac
setwd("~/Dropbox/JANO/2016/Conabio/Github/shiny_maiz/")

#TableP<-read.table("~/Dropbox/JANO/2016/Conabio/Github/shiny_maiz/RawData.txt", head=T, sep="\t")
dir()
getwd()
#dir('./image')
TableP <- read.csv("RawData.csv", head = T, sep = ",")
str(TableP)

names(TableP)
TableP$Longitud
head(TableP)
dim(TableP)
names(TableP)
TableP$Estado
TTabla <- TableP %>%
  filter(!is.na(Raza_primaria)) %>%
  filter(!is.na(Latitud)) %>%
  filter(Estado != "ND")

levels(TTabla$Estado)
dim(TTabla)
names(TTabla)
TTabla$Anhio_Colecta <- as.factor(TTabla$Anhio_Colecta)
#TTabla[Tabla$Estado=="ND",]
str(TTabla)

levels(TTabla$Estado)
levels(TTabla$Complejo_racial)
levels(TTabla$Raza_primaria)


names(TTabla)
TTabla <- TTabla %>%
  mutate(Estado = revalue(Estado,c("AGUASCALIENTES" = "AGS"))) %>%
  mutate(Estado = revalue(Estado,c("BAJA CALIFORNIA" = "BC"))) %>%
  mutate(Estado = revalue(Estado,c("BAJA CALIFORNIA SUR" = "BCS"))) %>%
  mutate(Estado = revalue(Estado,c("CAMPECHE" = "CAMP"))) %>%
  mutate(Estado = revalue(Estado,c("CHIAPAS" = "CHPS"))) %>%
  mutate(Estado = revalue(Estado,c("CHIHUAHUA" = "CHIH"))) %>%
  mutate(Estado = revalue(Estado,c("COAHUILA DE ZARAGOZA" = "COAH"))) %>%
  mutate(Estado = revalue(Estado,c("COLIMA" = "COL"))) %>%
  mutate(Estado = revalue(Estado,c("DISTRITO FEDERAL" = "CDMX"))) %>%
  mutate(Estado = revalue(Estado,c("DURANGO" = "DGO"))) %>%
  mutate(Estado = revalue(Estado,c("ESTADO DE MÉXICO" = "MEX"))) %>%
  mutate(Estado = revalue(Estado,c("GUANAJUATO" = "GTO"))) %>%
  mutate(Estado = revalue(Estado,c("GUERRERO" = "GRO"))) %>%
  mutate(Estado = revalue(Estado,c("HIDALGO" = "HGO"))) %>%
  mutate(Estado = revalue(Estado,c("JALISCO" = "JAL"))) %>%
  mutate(Estado = revalue(Estado,c("MICHOACÁN DE OCAMPO" = "MICH"))) %>%
  mutate(Estado = revalue(Estado,c("MORELOS" = "MOR"))) %>%
  mutate(Estado = revalue(Estado,c("NAYARIT" = "NAY"))) %>%
  mutate(Estado = revalue(Estado,c("NUEVO LEÓN" = "NL"))) %>%
  mutate(Estado = revalue(Estado,c("OAXACA" = "OAX"))) %>%
  mutate(Estado = revalue(Estado,c("PUEBLA" = "PUE"))) %>%
  mutate(Estado = revalue(Estado,c("QUERÉTARO DE ARTEAGA" = "QRO"))) %>%
  mutate(Estado = revalue(Estado,c("QUINTANA ROO" = "QROO"))) %>%
  mutate(Estado = revalue(Estado,c("SAN LUIS POTOSÍ" = "SLP"))) %>%
  mutate(Estado = revalue(Estado,c("SINALOA" = "SIN"))) %>%
  mutate(Estado = revalue(Estado,c("SONORA" = "SON"))) %>%
  mutate(Estado = revalue(Estado,c("TABASCO" = "TAB"))) %>%
  mutate(Estado = revalue(Estado,c("TAMAULIPAS" = "TAM"))) %>%
  mutate(Estado = revalue(Estado,c("TLAXCALA" = "TLAX"))) %>%
  mutate(Estado = revalue(Estado,c("VERACRUZ DE IGNACIO DE LA LLAVE" = "VER"))) %>%
  mutate(Estado = revalue(Estado,c("YUCATÁN" = "YUC"))) %>%
  mutate(Estado = revalue(Estado,c("ZACATECAS" = "ZAC"))) %>%
 mutate(Complejo_racial = revalue(Complejo_racial,c("Chapalote" = "Chapalote"))) %>%
 mutate(Complejo_racial = revalue(Complejo_racial,c("Cónico" = "Cónico"))) %>%
  mutate(Complejo_racial = revalue(Complejo_racial,c("Dentados_tropicales" = "Den_Trop"))) %>%
  mutate(Complejo_racial = revalue(Complejo_racial,c("Ocho hileras" = "8_Hileras"))) %>%
  mutate(Complejo_racial = revalue(Complejo_racial,c("Sierra Chihuahua" = "S_Chih"))) %>%
  mutate(Complejo_racial = revalue(Complejo_racial,c("Tropicales precoces" = "Trop_Prec"))) %>%
  mutate(Complejo_racial = revalue(Complejo_racial,c("Tropicales tardíos" = "Trop_Tar")))

levels(TTabla$Estado)

names(TTabla)[11] <- c("longitude")
names(TTabla)[12] <- c("latitude")

dim(TTabla)
nrow(TTabla)

#Ventana 1
TableL <- TTabla

#Ventana 2
TableL1 <- TTabla[,c(1:10,74:79)]
Val1 <- rep(1, nrow(TableL1))
TableL1 <- data.frame(TableL1, Val1)
rm(Val1)
names(TableL1)[3] <- c("Raza_Primaria")
names(TableL1)

attach(TableL1)
TableL1a <- aggregate(TableL1[,10:16], by = list(Raza_Primaria,Estado), FUN = mean, na.rm = T)
TableL1b <- aggregate(TableL1[,17], by = list(Raza_Primaria,Estado), FUN = sum, na.rm = T)

detach(TableL1)

TableL1c <- data.frame(TableL1a,TableL1b[,3])
names(TableL1c)[1] <- c("Raza_Primaria")
names(TableL1c)[2] <- c("Estado")
names(TableL1c)[10] <- c("Val1")


#Ventana 3
Val1 <- rep(1, nrow(TTabla))
TableLL <- data.frame(TTabla, Val1)
names(TableLL)
rm(Val1)
TableLL <- TableLL[,c(3,4,6,7,95)]

#names(TableLL)
#dim(TableLL)
#head(TableLL)
######################################################
######################################################
#For MosaicPlot
#TTabla2 <- TableLL %>%
#  filter(Estado == "AGS")
##attach(TTabla)

#Tabla1 <- xtabs(TTabla2$Val1~TTabla2$Raza_primaria + TTabla2$Complejo_racial)
#Tabla1
#detach(TTabla)

#Tabla4 <- Tabla1[apply(Tabla1,1,sum) > 0,apply(Tabla1,2,sum) > 0]
#assoc(Tabla4, gp = shading_hsv, labeling_args = list(rot_labels = c(left = 0, bottom = 270,right = 0), abbreviate = c(variable = TRUE)), zero_size = 0, main = "Mexico")

#####################



