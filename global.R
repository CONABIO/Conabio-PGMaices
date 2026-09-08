# ---------------------------------------------------------------------------
# LOCALE — esto va antes que nada, incluso antes de los library().
#
# Los datos vienen de un .xlsx y traen sus cadenas marcadas con Encoding()
# "UTF-8". Los literales acentuados escritos en este archivo ("Cónico",
# "Tuxpeño", "Chalqueño"...) quedan marcados como "unknown". En un locale UTF-8
# R los compara sin problema; en un locale C o Latin-1 NO los considera iguales
# aunque los bytes sean idénticos.
#
# Comprobado: "Cónico" en los datos y en el literal tienen los mismos bytes
# (43 c3 b3 6e 69 63 6f) y aun así %in% devuelve FALSE en locale C.
#
# Lo que se rompe si el servidor no arranca en UTF-8, TODO en silencio y sin un
# solo error en el log:
#   - RatingCol: 11,233 de 21,408 registros (52.5%) se quedan sin color y salen
#     negros en el mapa
#   - El revalue de Complejo_racial deja de aplicarse
#   - El resaltado por complejo de la pestaña de Altitud no resalta nada
#   - Los títulos de las gráficas salen "ma..z" y "monta..a"
#
# shinyapps.io —donde se publica esta app— no siempre arranca en UTF-8.
#
# Se prueban varios nombres porque no todos existen en todos los sistemas:
# es_MX.UTF-8 suele faltar en Linux, donde lo seguro es C.UTF-8.
# ---------------------------------------------------------------------------
local({
  if (grepl("UTF-8", Sys.getlocale("LC_CTYPE"), ignore.case = TRUE)) return(invisible())
  for (loc in c("es_MX.UTF-8", "es_MX.utf8", "en_US.UTF-8", "en_US.utf8",
                "C.UTF-8", "C.utf8")) {
    if (suppressWarnings(Sys.setlocale("LC_CTYPE", loc)) != "") {
      message("global.R: LC_CTYPE fijado en ", loc)
      return(invisible())
    }
  }
  warning("No se pudo fijar un locale UTF-8 (LC_CTYPE = ",
          Sys.getlocale("LC_CTYPE"), "). El mapa va a perder ~52% de sus ",
          "colores y los acentos de los títulos. Ver informacion_adicional.md, ",
          "sección 1.", call. = FALSE)
})

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
# ---------------------------------------------------------------------------
# Base de altitud por raza, CON estado, que alimenta el perfil altitudinal.
#
# Sale de TTabla y no de TableP porque ahí los nombres de estado ya vienen
# normalizados ("COAHUILA DE ZARAGOZA" -> "Coahuila"). No se pierde ni un
# registro por el cambio: los 21,408 con altitud válida traen coordenadas, que
# es lo único que TTabla exige de más.
#
# Se conservan a propósito los registros SIN altitud, para poder decir al pie
# de la gráfica qué razas quedaron fuera y por qué.
# ---------------------------------------------------------------------------
Mex3 <- TTabla %>%
  dplyr::select(Raza_primaria, AltitudProfundidad, Estado) %>%
  dplyr::rename(Raza = Raza_primaria, Altitud = AltitudProfundidad) %>%
  dplyr::filter(Raza != "ND", Estado != "ND") %>%
  dplyr::filter(is.na(Altitud) | Altitud <= 5000)
Mex3$Raza   <- as.character(Mex3$Raza)
Mex3$Estado <- factor(Mex3$Estado)

# Razas que pertenecen a cada complejo racial. Sirve para resaltar un complejo
# completo dentro del perfil altitudinal sin filtrar a las demás.
razas_por_complejo <- split(as.character(TablaPP$Raza_primaria),
                            as.character(TablaPP$Complejo_racial))
complejos_opciones <- sort(names(razas_por_complejo))

# ---------------------------------------------------------------------------
# Gradiente altitudinal por raza — la segunda vista de Altitud, que NO resume.
#
# Sólo se ofrecen las razas con al menos MIN_ALTITUDES_GRADIENTE altitudes
# DISTINTAS: con dos o tres valores no hay gradiente que dibujar, sale ruido.
#
# El umbral cuenta altitudes distintas, no registros crudos, y la diferencia es
# enorme: las 3,922 colectas de Tuxpeño son 806 altitudes distintas, y cincuenta
# colectas a 100 m siguen siendo un solo punto. Con el umbral en 5 quedan 55 de
# las 63 razas.
# ---------------------------------------------------------------------------
MIN_ALTITUDES_GRADIENTE <- 5

razas_con_gradiente <- local({
  u <- dplyr::distinct(Mex3[!is.na(Mex3$Altitud), ], Raza, Altitud)
  n <- table(u$Raza)
  sort(names(n)[n >= MIN_ALTITUDES_GRADIENTE])
})

razas_totales_con_altitud <- length(unique(Mex3$Raza[!is.na(Mex3$Altitud)]))

# Par de arranque: Olotillo va del nivel del mar a 2,400 m y Cacahuacintle vive
# entre 1,820 y 2,926 m, así que apenas se traslapan y el contraste se explica
# solo. Se eligieron además SIN acentos a propósito: si la app llegara a correr
# en un locale que no sea UTF-8, un literal acentuado no empata con el dato y la
# pestaña arrancaría vacía sin decir por qué.
razas_gradiente_default <- c("Olotillo", "Cacahuacintle")

# Paleta ordenada de mayor a menor contraste (la "Paleta 2" de
# shiny-agro-phaseolus). Los colores se asignan por posición entre las razas
# ELEGIDAS, así que los primeros que se ven son siempre los más distinguibles.
paleta_razas <- c(
  "#3B9AB2", "#F21A00", "#00A08A", "#C93312", "#85D4E3", "#F98400",
  "#046C9A", "#E1AF00", "#5785C1", "#FBA72A", "#35274A", "#DD8D29",
  "#78B7C5", "#B40F20", "#0B775E", "#FD6467", "#3F5151", "#D67236",
  "#899DA4", "#A42820", "#CDC08C", "#5B1A18", "#E1BD6D", "#4E2A1E",
  "#F1BB7B", "#5F5647", "#D69C4E", "#F4B5BD", "#9C964A", "#CB7A5C"
)

# ---------------------------------------------------------------------------
# Altitud de las capitales de los 32 estados (metros sobre el nivel del mar).
# Sirven como línea de referencia en la gráfica de Altitud: la gente ubica su
# ciudad y ve de inmediato qué razas de maíz crecen a esa altura.
#
# FUENTE: INEGI, Catálogo Único de Claves de Áreas Geoestadísticas
# (archivo AGEEML, julio 2026), columna ALTITUD de la cabecera municipal
# (CVE_LOC = 0001) de cada capital. La columna `cvegeo` guarda la clave exacta
# de la localidad, así que cada número es rastreable hasta su renglón de origen.
#
# Dos precisiones:
#  - La Ciudad de México no existe como localidad única en el catálogo (está
#    partida en 16 alcaldías). Se usa Cuauhtémoc, que es donde está el Zócalo.
#  - `ciudad` y `estado` usan los nombres comunes que emplea la app. Ojo: aquí
#    el Estado de México va como "Estado de México" y no como "México", para
#    empatar con lo que produce el revalue de arriba (línea 29).
#
# Tabla traída de shiny-agro-phaseolus (global.R). Las altitudes siguen
# pendientes de verificar una por una contra INEGI.
# ---------------------------------------------------------------------------
capitales_altitud <- data.frame(
  ciudad = c(
    "Aguascalientes", "Mexicali",    "La Paz",       "Campeche",
    "Saltillo",       "Colima",      "Tuxtla Gutiérrez", "Chihuahua",
    "Ciudad de México", "Durango",   "Guanajuato",   "Chilpancingo",
    "Pachuca",        "Guadalajara", "Toluca",       "Morelia",
    "Cuernavaca",     "Tepic",       "Monterrey",    "Oaxaca de Juárez",
    "Puebla",         "Querétaro",   "Chetumal",     "San Luis Potosí",
    "Culiacán",       "Hermosillo",  "Villahermosa", "Ciudad Victoria",
    "Tlaxcala",       "Xalapa",      "Mérida",       "Zacatecas"
  ),
  estado = c(
    "Aguascalientes", "Baja California", "Baja California Sur", "Campeche",
    "Coahuila",       "Colima",      "Chiapas",      "Chihuahua",
    "Ciudad de México", "Durango",   "Guanajuato",   "Guerrero",
    "Hidalgo",        "Jalisco",     "Estado de México", "Michoacán",
    "Morelos",        "Nayarit",     "Nuevo León",   "Oaxaca",
    "Puebla",         "Querétaro",   "Quintana Roo", "San Luis Potosí",
    "Sinaloa",        "Sonora",      "Tabasco",      "Tamaulipas",
    "Tlaxcala",       "Veracruz",    "Yucatán",      "Zacatecas"
  ),
  cvegeo = c(
    "010010001", "020020001", "030030001", "040020001",
    "050300001", "060020001", "071010001", "080190001",
    "090150001", "100050001", "110150001", "120290001",
    "130480001", "140390001", "151060001", "160530001",
    "170070001", "180170001", "190390001", "200670001",
    "211140001", "220140001", "230040001", "240280001",
    "250060001", "260300001", "270040001", "280410001",
    "290330001", "300870001", "310500001", "320560001"
  ),
  altitud = c(
    1878,    0,   31,    6, 1600,  484,  522, 1421,
    2230, 1893, 2019, 1255, 2379, 1537, 2671, 1904,
    1523,  926,  536, 1542, 2141, 1831,    2, 1865,
      57,  200,   11,  322, 2228, 1393,   10, 2427
  ),
  stringsAsFactors = FALSE
)
# Se ordenan de menor a mayor altitud para que el selector sea más útil
capitales_altitud <- capitales_altitud[order(capitales_altitud$altitud), ]
capitales_opciones <- setNames(
  capitales_altitud$ciudad,
  paste0(capitales_altitud$ciudad, " (", capitales_altitud$altitud, " m)")
)


Size1 <- read.delim("RawData.csv", header = T, sep = ",", quote = "", fill = F) %>% 
  select(Raza_primaria, Longitud_de_mazorca, Estado) %>% 
  rename('Longitud' = Longitud_de_mazorca) %>% 
  rename('Raza' = Raza_primaria) %>% 
  # Piso de 5 cm y techo de 50. El techo ya estaba; el piso descarta TRES
  # registros imposibles que venían de errores de captura y que, al dibujarse
  # la mazorca de mínimo a máximo, le deformaban la figura a razas con más de
  # mil colectas:
  #   Cónico Norteño  1 cm (Chihuahua) y 2 cm (Zacatecas)  -> mínimo pasa a 8.2
  #   Tuxpeño         4 cm (Oaxaca)                        -> mínimo pasa a 6.4
  #
  # El corte va en 5 y no en 6 a propósito: hay dos registros de 6 cm, en
  # Nal-tel y Zapalote Chico, que SÍ son creíbles porque son razas de mazorca
  # genuinamente corta. Un piso de 6 se los llevaría.
  #
  # Se descartó usar percentiles 5-95: habrían recortado el mínimo más de 3 cm
  # en 15 de las 59 razas, quitando mazorcas pequeñas legítimas junto con los
  # errores, y habrían cambiado lo que afirma la figura ("mínimo y máximo"
  # pasaría a ser "rango habitual"). El problema eran tres renglones, no la
  # distribución.
  filter(Longitud >= 5, Longitud <= 50) %>% 
  drop_na()

# RawData.csv escribe los estados EN MAYÚSCULAS Y CON ACENTOS ("MICHOACÁN DE
# OCAMPO", "NUEVO LEÓN"), mientras el Excel del PGM los trae sin acento. Para no
# depender del locale al comparar —ver la sección 1 de informacion_adicional.md—
# la coincidencia se hace sobre una clave transliterada a ASCII puro. Los acentos
# sólo aparecen del lado del VALOR, que nunca se compara.
normalizar_estado_raw <- function(x) {
  clave <- toupper(stringi::stri_trans_general(as.character(x), "Latin-ASCII"))
  mapa <- c(
    "AGUASCALIENTES" = "Aguascalientes",
    "BAJA CALIFORNIA" = "Baja California",
    "BAJA CALIFORNIA SUR" = "Baja California Sur",
    "CAMPECHE" = "Campeche",
    "CHIAPAS" = "Chiapas",
    "CHIHUAHUA" = "Chihuahua",
    "COAHUILA DE ZARAGOZA" = "Coahuila",
    "COLIMA" = "Colima",
    "DISTRITO FEDERAL" = "Ciudad de México",
    "DURANGO" = "Durango",
    "ESTADO DE MEXICO" = "Estado de México",
    "GUANAJUATO" = "Guanajuato",
    "GUERRERO" = "Guerrero",
    "HIDALGO" = "Hidalgo",
    "JALISCO" = "Jalisco",
    "MICHOACAN DE OCAMPO" = "Michoacán",
    "MORELOS" = "Morelos",
    "NAYARIT" = "Nayarit",
    "NUEVO LEON" = "Nuevo León",
    "OAXACA" = "Oaxaca",
    "PUEBLA" = "Puebla",
    "QUERETARO DE ARTEAGA" = "Querétaro",
    "QUINTANA ROO" = "Quintana Roo",
    "SAN LUIS POTOSI" = "San Luis Potosí",
    "SINALOA" = "Sinaloa",
    "SONORA" = "Sonora",
    "TABASCO" = "Tabasco",
    "TAMAULIPAS" = "Tamaulipas",
    "TLAXCALA" = "Tlaxcala",
    "VERACRUZ DE IGNACIO DE LA LLAVE" = "Veracruz",
    "YUCATAN" = "Yucatán",
    "ZACATECAS" = "Zacatecas"
  )
  i <- match(clave, names(mapa))
  ifelse(is.na(i), as.character(x), unname(mapa[i]))
}
Size1$Estado <- normalizar_estado_raw(Size1$Estado)

# RawData.csv escribe tres razas distinto que el resto de la app: usa "nh" en lugar
# de "ñ", omite acentos y antepone "Complejo". Sin normalizarlas no se pueden ligar
# con su complejo racial y saldrían en gris.
Size1$Raza <- as.character(Size1$Raza)
Size1$Raza[Size1$Raza == "Complejo Serrano de Jalisco"] <- "Serrano de Jalisco"
Size1$Raza[Size1$Raza == "Palomero Toluquenho"]         <- "Palomero Toluqueño"
Size1$Raza[Size1$Raza == "Mushito de Michoacan"]        <- "Mushito de Michoacán"

# El resumen por raza ya NO se precalcula: depende de los estados elegidos, así
# que se arma en el server (ver mazorcas() en server.R). Aquí sólo queda la lista
# de estados que ofrece el selector.
estados_mazorca <- sort(unique(Size1$Estado))

# Color de cada raza, el MISMO que usa el mapa de distribución (RatingCol).
# Sirve para que la gráfica de registros por estado pinte sus barras del color
# con el que esa raza aparece en el mapa.
colores_raza <- setNames(as.character(TableL$RatingCol),
                         as.character(TableL$Raza_primaria))
colores_raza <- colores_raza[!duplicated(names(colores_raza))]

# Complejo racial de cada raza, para colorear las mazorcas por familia.
# "Mushito de Michoacán" no aparece en TablaPP, así que queda "Sin complejo".
mazorca_complejo <- setNames(as.character(TablaPP$Complejo_racial),
                             as.character(TablaPP$Raza_primaria))

# Un color por complejo, tomando el tono MEDIO de cada familia y no el más oscuro:
# a este tamaño los extremos oscuros de las rampas se leen todos como negro.
paleta_complejos <- c(
  "Cónicos"             = "#41ab5d",
  "Chapalotes"          = "#4eb3d3",
  "Tropicales precoces" = "#8c6bb1",
  "Ocho hileras"        = "#fc8d59",
  "Sierra de Chihuahua" = "#ce1256",
  "Maduración tardía"   = "#1d91c0",
  "Dentados tropicales" = "#cb181d",
  "Sin complejo"        = "#9e9e9e"
)
