library(shiny)
library(grid)
library(vcd)
library(plyr)
library(tidyverse)
library(readxl)

TableP <- read_excel("PGM_update2017.xlsx", sheet = "PGM_maices_Alex", col_names = T)

TTabla <- TableP %>%
  dplyr::filter(!is.na(Raza_primaria)) %>%
  dplyr::filter(!is.na(Latitud)) %>%
  dplyr::filter(Estado != "ND") %>%
  dplyr::filter(Raza_primaria != "ND")
TTabla <- droplevels.data.frame(TTabla)
TTabla$Anhio_Colecta <- base::as.factor(TTabla$Anhio_Colecta)

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

names(TTabla)[20] <- c("longitude")
names(TTabla)[21] <- c("latitude")

#Ventana 1 Mapa
TableL <- TTabla

RatingCol <- as.character(TableL$Raza_primaria)

TableL <- data.frame(TableL, RatingCol)
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
                                                "Zapalote Grande" = "#fc4e2a"))) %>% 
  dplyr::filter(AltitudProfundidad < 5000)


#Ventana 2 Foto y Cleveland Plot
TableL1 <- TTabla %>% 
  dplyr::mutate(Val1 = 1) %>% 
  dplyr::rename(Raza_Primaria = Raza_primaria) %>% 
  group_by(Raza_Primaria, Estado) %>% 
  summarise(Val1 = sum(Val1)) %>% 
  arrange(Estado) %>% 
  as.data.frame() %>% 
  mutate(Min = 0)
  
TableL1c <- TableL1

#Ventana 3 SankeyPlot

#TableLL <- TTabla %>% 
#  dplyr::mutate(Val1 = 1) %>% 
#  select(Raza_primaria, Complejo_racial, PeriodoColecta, Estado, Val1) %>% 
#  as.data.frame()

Val1 <- rep(1, nrow(TTabla))
TableLL <- data.frame(TTabla, Val1)
names(TableLL)
rm(Val1)
TableLL <- TableLL[,c(27,28,10,17,31)]
Val1 <- rep(1, nrow(TableL))
TableL1 <- data.frame(TableL,Val1)
TableL2 <- TableL1[,c(27,28,17,32)]

TablaPP <- TableL %>%
  dplyr::select(Raza_primaria, Complejo_racial) %>%
  distinct()


#Cargar los datos de Teocintle
Teocintle <- read.csv("Teocintle.csv", header = T, sep = ",")

Teocintle <- Teocintle %>%
  filter(!is.na(Latitud)) %>%
  distinct()

names(Teocintle)[15] <- c("longitude")
names(Teocintle)[16] <- c("latitude")
names(Teocintle)[14] <- c("Altitud")

#Cargar los datos de Teocintle
Tripsacum <- read.delim("Tripsacum.csv", header = T, sep = ",")
Tripsacum <- Tripsacum %>%
  dplyr::filter(!is.na(Latitud)) %>%
  distinct()
names(Tripsacum)[12] <- c("longitude")
names(Tripsacum)[13] <- c("latitude")
Tripsacum <- data.frame(Tripsacum, Tipo = "Tripsacum")
Teocintle <- data.frame(Teocintle, Tipo = "Teocintle")
Tripsacum <- Tripsacum %>%
  select(Tipo, longitude, latitude, Fuente, Taxa, Estado, Municipio)
Teocintle <- Teocintle %>%
  select(Tipo, longitude, latitude, Fuente, Taxa, Estado, Municipio)
Parientes <- rbind(Tripsacum, Teocintle)


Anexo6 <- read.csv("Anexo6_InfoMaices.csv", header = T, sep = ",")
Anexo6$Raza_Primaria <- as.character(Anexo6$Raza_Primaria)

#Anexo777 <- Anexo6 %>%
#  #drop_na() %>% 
#  dplyr::filter(Raza_Primaria == "Ancho") %>%
#  #mutate(NADA = NA) %>% 
#  #column_to_rownames(., var = "NADA") %>% 
#  dplyr::select(Informacion1) %>% 
#  remove_rownames()
#
#rownames(Anexo777) <- NULL


#Para la Altitud

Mex4 <- TableP %>% 
  select(Raza_primaria, AltitudProfundidad) %>% 
  rename('Altitud' = AltitudProfundidad) %>% 
  rename('Raza' = Raza_primaria) %>% 
  filter(Raza != 'ND') %>% 
  filter(Altitud <= 5000)

Mex5 <- Mex4 %>%
  select(Raza, Altitud) %>%
  group_by(Raza) %>%
  summarise(minimo = min(Altitud))

Mex5.1 <- Mex4 %>%
  select(Raza, Altitud) %>%
  group_by(Raza) %>%
  summarise(prom = mean(Altitud))


Mex6 <- Mex4 %>%
  select(Raza, Altitud) %>%
  filter(Altitud < 9000) %>%
  group_by(Raza) %>%
  summarise(maximo = max(Altitud)) %>%
  full_join(Mex5, by = "Raza") %>%
  full_join(Mex5.1, by = "Raza") %>%
  mutate(rango = maximo - minimo) %>%
  na.omit()

Mex7 <- Mex6 %>% 
  arrange(prom) %>% 
  mutate(ordenar1 = prom)

Mex8 <- Mex6 %>% 
  arrange(maximo) %>% 
  mutate(ordenar1 = maximo )

Mex9 <- Mex6 %>% 
  arrange(minimo) %>% 
  mutate(ordenar1 = minimo)

Size1 <- read.delim("RawData.csv", header = T, sep = ",", quote = "", fill = F) %>% 
  select(Raza_primaria, Longitud_de_mazorca) %>% 
  rename('Longitud' = Longitud_de_mazorca) %>% 
  rename('Raza' = Raza_primaria) %>% 
  filter(Longitud <= 50) %>% 
  drop_na()

Size5 <- Size1 %>%
  select(Raza, Longitud) %>%
  group_by(Raza) %>%
  summarise(minimo = min(Longitud))

Size5.1 <- Size1 %>%
  select(Raza, Longitud) %>%
  group_by(Raza) %>%
  summarise(prom = mean(Longitud))


Size6 <- Size1 %>%
  select(Raza, Longitud) %>%
  filter(Longitud < 9000) %>%
  group_by(Raza) %>%
  summarise(maximo = max(Longitud)) %>%
  full_join(Size5, by = "Raza") %>%
  full_join(Size5.1, by = "Raza") %>%
  mutate(rango = maximo - minimo) %>%
  na.omit()

Size7 <- Size6 %>% 
  arrange(prom) %>% 
  mutate(ordenar1 = prom)

Size8 <- Size6 %>% 
  arrange(maximo) %>% 
  mutate(ordenar1 = maximo )

Size9 <- Size6 %>% 
  arrange(minimo) %>% 
  mutate(ordenar1 = minimo)
