library(shiny)
#library(leaflet)
library(grid)
library(vcd)
#library(plotly)
#library(ggplot2)
#library(googleVis)
library(plyr)
library(dplyr)

dir()
TableP <- read.csv("PGM_update2017.csv", head = T, sep = ",")

TTabla <- TableP %>%
  dplyr::filter(!is.na(Raza_primaria)) %>%
  dplyr::filter(!is.na(Latitud)) %>%
  dplyr::filter(Estado != "ND") %>%
  dplyr::filter(Raza_primaria != "ND")
  #dplyr::filter(Complejo_racial != "No asociada a un grupo racial")
TTabla
dim(TTabla)
TTabla <- droplevels.data.frame(TTabla)
levels(TTabla$Estado)
levels(TTabla$Complejo_racial)
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
  #dplyr::mutate(Estado = revalue(Estado,c("BAJA CALIFORNIA" = "Baja California"))) %>%
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

summary(TTabla$Complejo_racial) 
#TTabla <- droplevels(TTabla$Complejo_racial)
names(TTabla)
head(TTabla)
summary(TTabla)
names(TTabla)[20] <- c("longitude")
names(TTabla)[21] <- c("latitude")
head(TTabla)



dim(TTabla)
nrow(TTabla)

#Ventana 1 Mapa
TableL <- TTabla

RatingCol <- as.character(TableL$Raza_primaria)

TableL <- data.frame(TableL, RatingCol)
#dim(TableL)
#names(TableL)[32] <- c("RatingCol")
head(TableL)
summary(TableL$RatingCol)
TableL <- TableL %>%
  #Conicos
  dplyr::mutate(RatingCol = revalue(RatingCol,c("Arrocillo Amarillo" = "#00441b", "Cacahuacintle" = "#006d2c",
                                                "Chalqueño" = "#238b45", "Cónico" = "#41ae76", "Cónico Norteño" = "#66c2a4",
                                                "Dulce" = "#99d8c9", "Elotes Cónicos" = "#004529", "Mixteco" = "#006837",
                                                "Mushito" = "#238443", "Negrito" = "#41ab5d", "Palomero de Chihuahua" = "#78c679",
                                                "Palomero de Jalisco" = "#addd8e", "Palomero Toluqueño" = "#d9f0a3", "Uruapeño" = "#f7fcb9"))) %>%
    #Chapalotes
  dplyr::mutate(RatingCol = revalue(RatingCol,c("Chapalote" = "#0868ac", "Dulcillo del Noroeste" = "#2b8cde",
                                                "Elotero de Sinaloa" = "#4eb3d3", "Reventador" = "#7bccc4"))) %>%
  #Tropicales precoces
  dplyr::mutate(RatingCol = revalue(RatingCol,c("Conejo" = "#4d004b", "Nal-tel" = "#810f7c", "Ratón" = "#88419d",
                                                "Zapalote Chico" = "#8c6bb1"))) %>%
  #Ocho hileras
  dplyr::mutate(RatingCol = revalue(RatingCol,c("Ancho" = "#7f0000", "Blando" = "#b30000", "Bofo" = "#d7301f",
                                                "Bolita" = "#ef6548", "Elotes Occidentales" = "#fc8d59",
                                                "Harinoso de Ocho" = "#fdbb84", "Jala" = "#662506", "Onaveño" = "#993404",
                                                "Tablilla de Ocho" = "#cc4c02", "Tabloncillo" = "#ec7014", "Tabloncillo Perla" = "#fe9929",
                                                "Zamorano Amarillo" = "#fec44f"))) %>%
  #Sierra de Chihuahua
  dplyr::mutate(RatingCol = revalue(RatingCol,c("Apachito" = "#67001f", "Azul" = "#980043", "Serrano de Jalisco" = "#ce1256",
                                                "Cristalino de Chihuahua" = "#e7298a", "Gordo" = "#df65b0", "Mountain Yellow" = "#c994c7"))) %>%
  #Maduración tardía
  dplyr::mutate(RatingCol = revalue(RatingCol,c( "Comiteco" = "#081d58", "Coscomatepec" = "#253494", "Dzit Bacal" = "#225ea8", "Mixeño" = "#1d91c0",
                                                 "Motozinteco" = "#41b6c4",  "Negro de Chimaltenango" = "#7fcdbb", "Olotillo" = "#2171b5",
                                                 "Olotón" = "#4292c6", "Quicheño" = "#6baed6", "Serrano" = "#9ecae1",
                                                 "Serrano Mixe" = "#c6dbef", "Tehua" = "#deebf7"))) %>%
  #Dentados Tropicales
  dplyr::mutate(RatingCol = revalue(RatingCol,c("Celaya" = "#67000d", "Chiquito" = "#a50f15", "Choapaneco" = "#cb181d",
                                                "Cubano Amarillo" = "#ef3b2c", "Nal-tel de Altura" = "#fb6a4a",
                                                "Pepitilla" = "#fc9272", "Tepecintle" = "#fcbba1", "Tuxpeño" = "#fed976",
                                                "Tuxpeño Norteño" = "#bd0026", "Vandeño" = "#e31a1c", 
                                                "Zapalote Grande" = "#fc4e2a")))
  

dim(TableL)
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

head(TTabla)
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

TableL2 <- TableL1[,c(27,28,17,32)]


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
