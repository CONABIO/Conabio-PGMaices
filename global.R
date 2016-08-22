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


#For PC
#setwd("C:\\Users\\aponce\\Dropbox\\JANO\\2016\\Conabio\\Github\\shiny_maiz\\")

#For Mac
#setwd("~/Dropbox/JANO/2016/Conabio/Github/shiny_maiz/")

#TableP<-read.table("~/Dropbox/JANO/2016/Conabio/Github/shiny_maiz/RawData.txt", head=T, sep="\t")
#dir()
#getwd()
#dir('./image')
TableP <- read.csv("RawData.csv", head = T, sep = ",")
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
  filter(Estado != "ND")

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
  mutate(Complejo_racial = revalue(Complejo_racial,c("Chapalote" = "Chapalotes"))) %>%
  mutate(Complejo_racial = revalue(Complejo_racial,c("Cónico" = "Cónicos"))) %>%
  mutate(Complejo_racial = revalue(Complejo_racial,c("Dentados_tropicales" = "Dentados tropicales"))) %>%
  mutate(Raza_primaria = revalue(Raza_primaria,c("Palomero Toluquenho" = "Palomero Toluqueño")))

#  mutate(Complejo_racial = revalue(Complejo_racial,c("Dentados_tropicales" = "Den_Trop"))) %>%
#  mutate(Complejo_racial = revalue(Complejo_racial,c("Ocho hileras" = "8_Hileras"))) %>%
#  mutate(Complejo_racial = revalue(Complejo_racial,c("Sierra Chihuahua" = "S_Chih"))) %>%
#  mutate(Complejo_racial = revalue(Complejo_racial,c("Tropicales precoces" = "Trop_Prec"))) %>%
#  mutate(Complejo_racial = revalue(Complejo_racial,c("Tropicales tardíos" = "Trop_Tar")))

levels(TTabla$Estado)
levels(TTabla$Complejo_racial)

names(TTabla)[11] <- c("longitude")
names(TTabla)[12] <- c("latitude")

dim(TTabla)
nrow(TTabla)

#Ventana 1 Mapa
TableL <- TTabla

#Ventana 2 Foto y Cleveland Plot
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
head(TableL1c)


#Ventana 3 StrucPlot
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

#Ventana 2.1 Sankey plot

names(TableL)
Val1 <- rep(1, nrow(TableL))
TableL1 <- data.frame(TableL,Val1)
rm(Val1)
#levels(TableL$Complejo_racial)
#head(TableL1)
#Zodiac <- paste(TableL1[,4],TableL1[,3], sep = ";")

#levels(TableL1$Complejo_racial)
#TableL12 <- TableL1 %>%
#  filter(Complejo_racial == "Chapalotes")
#dim(TableL12)
#na.omit(TableL12)

TableL2 <- TableL1[,c(3,4,7,95)]
dim(TableL2)
head(TableL2,30)
#names(TableL2)
#levels(TableL2$Complejo_racial)


#attach(TableL2)
#TableLJJ <- aggregate($Val1 ~ $Complejo_racial + $Estado , FUN = sum, na.rm = T)
#TableLJJF <- aggregate(Val1 ~ Complejo_racial + Raza_primaria, FUN = sum, na.rm = T)

#names(TableLJJ)[1] <- c("origin")
#names(TableLJJ)[2] <- c("visit")
#head(TableLJJF)
#names(TableLJJF)[2] <- c("origin")
#names(TableLJJF)[1] <- c("visit")

#detach(TableL2)
#Katcha <- rbind(TableLJJ,TableLJJF)


#str(Katcha)
#levels(Katcha$origin)
#levels(Katcha$visit)

#head(Katcha,90)

#Katcha[1:39,]
#tail(Katcha,11)
#levels(Katcha$origin)
#levels(Katcha$visit)

#Katcha$origin <- as.factor(as.numeric(Katcha$origin))
#Katcha$visit <- as.factor(as.numeric(Katcha$visit))
#Katcha1 <- Katcha[-c(11),]

#Note: Avoid cycles in your data: if A links to itself, or links to B which links to C which links to A, your chart will not render.

#plot(
#  gvisSankey(Katcha, from = "origin", to = "visit", weight = "Val1",
#                options = list(height = 250, width = 250,
#                               sankey = "{link:{color:{fill:'lighblue'}}}"
#                      #         sankey = "{
#                      #         link:{color:{fill: 'red', fillOpacity: 0.7}},
#                      #         node:{nodePadding: 5, label:{fontSize: 12}, interactivity: true, width: 20},
#                      #         }"
#                               )
#               )
#      )



#plot(gvisSankey(Katcha, from = "origin", to = "visit", weight = "Val1",
#                options = list(height = 750, width = 950,
#                               sankey = "{
#                               link:{color:{fill: 'red', fillOpacity: 0.7}},
#                               node:{nodePadding: 5, label:{fontSize: 12}, interactivity: true, width: 20},
#                               }")
#               )
#     )



#library(networkD3)

## Load energy projection data
## Load energy projection data
#URL <- paste0(
#  "https://cdn.rawgit.com/christophergandrud/networkD3/",
#  "master/JSONdata/energy.json")
#URL
#Energy <- jsonlite::fromJSON(URL)
#
#
## Plot
#sankeyNetwork(Links = Energy$links, Nodes = Energy$nodes, Source = "source",
#              Target = "target", Value = "value", NodeID = "name",
#              units = "TWh", fontSize = 12, nodeWidth = 30)

