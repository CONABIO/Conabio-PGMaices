library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinydashboardPlus)
library(shinythemes)
library(leaflet)
library(knitr)
library(plotly)
library(ggplot2)
library(tidyverse)
library(markdown)
library(plotly)
library(httr)
library(rgdal)
library(tableHTML)


#shinyUI(navbarPage(
#  theme = shinytheme("sandstone"),
#  title = "Proyecto Global de  Maíces", id = "nav",


dashboardPagePlus(
  skin = "yellow",
  sidebar_background = NULL,
  
  ## Dashboard Header
#  dashboardHeaderPlus(
#    title = span(img(src = "CONABIO_LOGO_14.png", width = 100, align = "left")),
#      #"Proyecto Global de  Maíces",
#    titleWidth = 200,
#    fixed = TRUE
#  ), # close dashboard header
#  
  dashboardHeaderPlus(
    title = tagList(
      span(class = "logo-lg", img(src = "CONABIO_LOGO_14.png", width = 150)), 
      img(src = "CONABIO_LOGO_15.png", height = 35, align = "center")),
  #  enable_rightsidebar = TRUE,
  #  rightSidebarIcon = "gears"
  titleWidth = 200,
  fixed = TRUE
  ),
   # titleWidth = 200,
  #  fixed = TRUE,
 
  ## Sidebar Menu
  dashboardSidebar(
    width = 200,
    shinyjs::useShinyjs(),
    collapsed = F,
    disable = F,
    sidebarMenu(
      id = "navbar",
      #shinyjs::useShinyjs(),
      
      menuItem("Introducción",
               tabName = "home",
               icon = icon("home")),
      menuItem("Distribución de maíces",
               tabName = "widgets",
               icon = icon("map")),
      menuItem("Diversidad de maíces",
               tabName = "widgets1",
               icon = icon("seedling")),
      menuItem("Altitud",
               tabName = "widgets2",
               icon = icon("layer-group")),
      menuItem("Tamaño mazorca",
               tabName = "widgets4",
               icon = icon("cloudversify")),
      menuItem("Gráfica de aluvial",
               tabName = "widgets3",
               icon = icon("align-right")),
      menuItem("Bibliografía", 
               tabName = "conabio", 
               icon = icon("book-open")),
      menuItem("Visualización", 
               tabName = "autor", 
               icon = icon("user"))
    )
  ),
 #close sidebar menu
  
  ##Dashboard body
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "home",
        br(),
        br(),
        br(),
        div(
          img(src = "plecaPGM_1200x175.jpg", width = "900"),
          style = "text-align: center;"
        ),
          br(),
          h2(strong("Introducción"), align = "center"), 
          h4(
            "El objetivo del Proyecto Global de Maíces (PGM), fue actualizar la
              información de maíces y sus parientes silvestres en México para
              la determinación de centros de diversidad genética del maíz."
          ), 
          br(),
          h4(
            "El proyecto fue liderado por ",
            tags$a(href = "http://www.conabio.gob.mx/",
                   "CONABIO") ,
            " y coordinado con el Instituto Nacional de Investigaciones Forestales, Agrícolas y Pecuarias (",
            tags$a(href = "https://www.gob.mx/inifap", "INIFAP"),") y el Instituto Nacional de Ecología y Cambio Climático (", tags$a(href = "https://www.gob.mx/inecc", "INECC") ,
            ")","."
          ),
          #br(),
          h4("El proyecto incluyó tres líneas de acción:"),
          h4("1. Generación de un documento sobre centros de origen y de diversidad genética del maíz"),
          h4("2. Computarización de colecciones científicas de maíz nativo, teocintle y tripsacum "),
          h4("3. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres a través de proyectos de colecta"),
          br(),
          h4("Los registros de maíces corresponden a las bases de datos de los proyectos financiados durante el PGM y 
             bases de datos donadas. Hasta ahora, el total de registros de maíces nativos es de 25,862 registros, 
             de los cuales 25,095 registros contienen coordenadas geográficas. Los datos puede descargarse en la ", tags$a(href = "https://www.biodiversidad.gob.mx/diversidad/proyectoMaices", "página")," del proyecto global de maíces de la CONABIO."),
          br(),
          br(),
          h2(strong("Visualización:"), align = "center"),
          h4("Esta visualización esta dividida en las siguientes secciones:"),
          
                   fluidRow(
                     boxPlus(
                       title = strong("Distribución de maíces"),
                       closable = FALSE,
                       width = 6,
                       height = 400,
                       status = "warning",
                       solidHeader = TRUE,
                       collapsible = FALSE,
                       h4("Visualiza los registros de las razas de maíces, así como
                       de sus parientes silvestres: teocintles y ", em("tripsacum")),
                       userPostMedia(src = "mapDistribution.png", height = 400, width = 400),
                       id = "mapa",
                       style = "cursor:pointer;"
                     ),
          
                     boxPlus(
                       title = strong("Diversidad de maíces"),
                       closable = FALSE,
                       width = 6,
                       height = 400,
                       status = "warning",
                       solidHeader = TRUE,
                       collapsible = FALSE,
                       h4("Información general sobre cada raza de maíz, así como su distribución en los diferentes
                          estados de la república"),
                       userPostMedia(src = "DatosMaices2.png", height = 400, width = 400),
                       id = "datosMaices",
                       style = "cursor:pointer;"
                     ),
          
                     boxPlus(
                       title = strong("Altitud"),
                       closable = FALSE,
                       width = 6,
                       height = 400,
                       status = "warning",
                       solidHeader = TRUE,
                       collapsible = FALSE,
                       h4("La altitud mínima y máxima donde se tienen datos de las razas de maíces"),
                       userPostMedia(src = "altitud1.png", height = 400, width = 400),
                       id = "Altitud1",
                       style = "cursor:pointer;"
                     ),
          
                     boxPlus(
                       title = strong("Tamaño de mazorca"),
                       closable = FALSE,
                       width = 6,
                       height = 400,
                       status = "warning",
                       solidHeader = TRUE,
                       collapsible = FALSE,
                       h4("Existe una gran variabilidad del tamaño de la mazorca entre las 
                          razas de maíz y dentro de las misma raza de maíz"),
                       userPostMedia(src = "tamanoMazorca.png", height = 400, width = 400),
                       id = "Mazorca",
                       style = "cursor:pointer;"
                     ),
                     
                     boxPlus(
                       title = strong("Gráfica de Aluvial"),
                       closable = FALSE,
                       width = 6,
                       height = 400,
                       status = "warning",
                       solidHeader = TRUE,
                       collapsible = FALSE,
                       h4("Otra forma de visualizar las razas de maíces de México"),
                       userPostMedia(src = "aluvial.png", height = 300, width = 300),
                       id = "Aluvial",
                       style = "cursor:pointer;"
                     ),
                     
                     boxPlus(
                       title = strong("Bibliografía"),
                       closable = FALSE,
                       width = 6,
                       height = 400,
                       status = "warning",
                       solidHeader = TRUE,
                       collapsible = FALSE,
                       h4("La lista de documentos generados por el Proyecto Global de Maíces"),
                       userPostMedia(src = "bibliografia.png", height = 400, width = 400),
                       id = "Bibliografia",
                       style = "cursor:pointer;"
                     )
        ) #close FluidRow
      ),
      
      #Ventana del Mapa
      tabItem(
        tabName = "widgets",
        value = "Distribucion de maíces",
        br(),
        br(),
       # div(
       #   img(src = "plecaPGM_1200x175.jpg", width = "900"),
       #   style = "text-align: center;"
       # ),
        fluidRow(
          tags$style(type = "text/css", "#mymap1 {height: calc(100vh - 80px) !important;}"),
          leafletOutput('mymap1', width = "100%", height = "100%")
        ),
      
        absolutePanel(
          top = 100,
          right = 40,
          draggable = T,
          width = "13%",
          #Raza Primaria
          selectInput(
            inputId = "Raza_primaria",
            label = "Raza Primaria:",
            c("All", levels(TableL$Raza_primaria))
            #choices = "",
            #selected = ""
          ),
          
          #Por Complejo Racial
          selectInput(inputId = "Complejo_racial",
                      label = "Grupo Racial:",
                      c("All", levels(as.factor(TableL$Complejo_racial)))),
          
          #Por Estado
          selectInput(inputId = "Estado",
                      label = "Estado:",
                      c("All", levels(as.factor(TableL$Estado)))),
          
          #Por Altitud
          sliderInput(inputId = "AltitudProfundidad",
                      label = "Altitud:",
                      value = range(TableL$AltitudProfundidad),
                      min = min(TableL$AltitudProfundidad),
                      max = max(TableL$AltitudProfundidad),
                      step = 10),
          
          #Por Proyecto
          selectInput(inputId = "Proyecto",
                      label = "Proyecto apoyado (ver bibliografía):",
                      c("All", levels(as.factor(TableL$Proyecto)))),
          
          checkboxGroupInput(
            inputId = "Tipo",
            label = h6("Parientes Silvestres:"),
            choices = levels(Parientes$Tipo),
            selected = NULL
          )
          
        )
        
      ),
      #parentesis del tabItem
      #Ventana 2 Fotos Maices
      tabItem(
        br(),
        br(),
        br(),
        tabName = "widgets1",
        div(
          img(src = "plecaPGM_1200x175.jpg", width = "900"),
          style = "text-align: center;"
        ),
        br(),
        br(),
        fluidRow(
         # h4("Razas de maíces"),
          
           fluidPage(
             boxPlus(
               width = 12,
               title = "Razas de maíces", 
               closable = FALSE, 
               status = "warning",
               solidHeader = TRUE, 
               collapsible = FALSE,
               enable_sidebar = TRUE,
               sidebar_width = 30,
               sidebar_start_open = TRUE,
               sidebar_content = tagList(
                 selectInput(
                 inputId = "Raza_Primaria",
                 label = h4(strong("Raza de maíz:")),
                 levels(as.factor(TableL1c$Raza_Primaria))
                            ),
                 h4("Características generales:"),
                 h5(textOutput("summary1")),
                 h5(
                   "Fuente:",
                   tags$a(href = "https://www.biodiversidad.gob.mx/diversidad/alimentos/maices/razas-de-maiz", "Maíces")
                 )
                                        ),
               br(),
               imageOutput("preImage", height = 500, width = 500
                           ), 
              br(),
              br(),
              br(),
              br(),
              h3(strong("Número de registros por estado")),
               plotOutput(
                 "plot11", height = 500, width = 700)
               )
            )
        #  ) #close sidebarLayout
        )
      ),
      
      ## Para la gráfica de la Altitud
      tabItem(
        br(),
        br(),
        br(),
        tabName = "widgets2",
        div(
          img(src = "plecaPGM_1200x175.jpg", width = "900"),
          style = "text-align: center;"
        ),
        br(),
        br(),
        h4("La gran adaptabilidad del ", strong("maíz"), " a diferentes ",
           strong("altitudes") , " nos permite encontrarlo al nivel del mar y 
           hasta casi los 3,500 metros de altura."),
        br(),
        h4(strong("Presencia de razas de maíces a diferentes alturas")),
        br(),
        fluidRow(
          tags$style(type = "text/css", "#graph2 {height: calc(100vh - 80px) !important;}"),
          plotOutput('graph2', height = "100%", width = "100%")
          #renderPlot('graph2', height = "auto")
        ),
        
        absolutePanel(
          top = 275,
          right = 40,
          draggable = T,
          #Seleccionar la variable para
          selectInput(
            inputId = 'var11',
            label = h4(strong('Ordenar por:')),
            choices = c("promedio", "máximo", "mínimo"),
            width = 200,
            #size = 14,
            selectize = T
          )
          
        ) # close column
      ), # close widget page
      
      ## Para la gráfica de Tamaño de mazorca
      tabItem(
        br(),
        br(),
        br(),
        tabName = "widgets4",
        div(
          img(src = "plecaPGM_1200x175.jpg", width = "900"),
          style = "text-align: center;"
        ),
        br(),
        br(),
        h4("La gran variedad de maíces también se ve reflejado en el tamaño
           de su mazorca."),
        #br(),
        br(),
        h4(strong("Tamaño de mazorca para las diferentes razas de maíces")),
        br(),
        fluidRow(
          tags$style(type = "text/css", "#graph3 {height: calc(100vh - 80px) !important;}"),
          plotOutput('graph3', height = "100%", width = "100%")
        ),
        
        absolutePanel(
          top = 275,
          right = 40,
          draggable = T,
          #Seleccionar la variable para
          selectInput(
            inputId = 'var12',
            label = h4(strong('Ordenar por:')),
            choices = c("promedio", "máximo", "mínimo"),
            width = 200
          )
          
        ) # close column
      ), # close widget page
      
      #Ventana 2.1 Sankeyplot
      
      tabItem(
        br(),
        br(),
        br(),
        tabName = "widgets3",
        div(
          img(src = "plecaPGM_1200x175.jpg", width = "900"),
          style = "text-align: center;"
        ),
        br(),
        br(),
        # Define UI for slider demo application
        
        #h3("La gráfica de aluvial o de Flujo de las razas de maíces en México"),
        h4("La distribución de las razas de maíces se encuentran en todo México.
           De izquierda a derecha se muestran los distintos ",
          tags$a(href = "https://www.biodiversidad.gob.mx/diversidad/alimentos/maices/razas-de-maiz",
                 "complejos raciales"),
          "que agrupan las razas (en el centro) distribuidas
            en los distintos estados del país (derecha)"
        ),
        
        # br(),
        
        br(),
        br(),
        br(),
        br(),
        
       # shinyUI(
          fluidPage(
            sidebarLayout(
          sidebarPanel(
            #Por Estado
            selectInput(
              inputId = "Estados",
              label = h5("Estado:"),
              c("All", levels(as.factor(TableL2$Estado)))
            ),
            br(),
            h5("Visualización de la presencia de maíces en distintos estados"),
            br(),
            width = 2
          ),
          column(9,
                 htmlOutput(
                   "Sankeyplot1", width = "1000", height = "600"
                 ))
          
        ))
        #)
      ),
      
      
      
      
      tabItem(
        tabName = 'conabio',
        value = 'Bibliografía',
        br(),
        br(),
        br(),
        div(
          img(src = "plecaPGM_1200x175.jpg", width = "900"),
          style = "text-align: center;"
        ),
        br(),
        #div(img(src = "plecaPGM_1200x175.jpg", width = "750"), style = "text-align: center;"),
        
        
        h3(
          strong("Bases de datos generadas durante la ejecución del",tags$a(href = "https://www.biodiversidad.gob.mx/diversidad/proyectoMaices",
                                                                            "Proyecto Global de Maíces:"), " “Recopilación, generación, actualización y análisis de información acerca de la diversidad genética de maíces y sus parientes silvestres en México:"),
          
        ),
        
        h5(strong("1.- "),
          "Hernández Casillas, J.M.; Díaz de la C., J. B. 2010. Base de datos de colecciones de maíces nativos, teocintles y Tripsacum de México. Bases de datos SNIB-CONABIO proyecto No.",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FY&Numero=1", "FY001") ,
          "México, D.F."
        ),
        h5(strong("2.- "),
          "Carrera Valtierra, J. A. 2013. Estudio de la diversidad genética y su distribución de los maíces criollos y sus parientes silvestres en Michoacán. Universidad Autónoma de Chapingo. Centro Regional Universitario Centro Oriente. Bases de datos SNIB2013-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=1", "FZ001."),
          " México, D.F."
        ),
        h5(strong("3.- "),
          "Rincón Sánchez, F., Hernández Pardo, C. J., Zamora Cansino F., Hernández Casillas, J. M., Ruiz Torres, N. A., Illescas Palma, C. N. y L. Ramón Gayosso. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Coahuila. INIFAP-UAAAN. Base de datos SNIB-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          "México, D. F."
        ),
        h5(strong("4.- "),
          "Vidal Martínez, V. A., Ortega Corona, A., Guerrero Herrera, M. de J., Cota Agramont, O., Herrera Cedano, F., Hernández Casillas, J. M., Valdivia Bernal, R., Caro Velarde F. de J. y G. González Rodríguez. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Nayarit. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No.",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          " México, D. F."
        ),
        h5(strong("5.- "),
          "Valadez Gutiérrez, Juan, Julio César García Rodríguez y Juan Manuel Hernández Casillas. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Nuevo León. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          " México, D. F."
        ),
        h5(strong("6.- "),
          "Palacios Velarde, O., Ortega Corona, A., Guerrero Herrera, M. de J., Hernández Casillas, J. M. y L. M. Peinado Fuentes. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Sinaloa. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          " México, D. F."
        ),
        h5(strong("7.- "),
          "Ortega Corona, A., Guerrero Herrera, M. de J., Cota Agramont, O., Hernández Casillas, J. M. y L. M. Peinado Fuentes. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Sonora. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          " México, D. F."
        ),
        h5(strong("8.- "),
          "Valadez Gutiérrez, J., García Rodríguez, J. C.,  Cervantes Martínez, J. E. y J. M. Hernández Casillas. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Tamaulipas. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          " México, D. F."
        ),
        h5(strong("9.- "),
          "Rendón Aguilar, B. 2011. Diversidad y distribución altitudinal de maíces nativos en la región de los Loxicha, Sierra Madre del Sur Oaxaca. Universidad Autónoma Metropolitana. Unidad Iztapalapa. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=FZ&Numero=3", "FZ003."),
          " México, D.F."
        ),
        h5(strong("10.- "),
          "Taba, S., Chávez Tovar, V. H., Rivas, M. y M. Rodríguez Alvarado. 2010. Monitoreo y recolección de la Diversidad de razas de maíz criollo en la región de la Huasteca en México para complementar las colecciones de los bancos de germoplasma de INIFAP y CIMMYT. Centro Internacional de Mejoramiento de Maíz y Trigo. Banco de Germoplasma de Maíz. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=7", "FZ007."),
          " México D. F."
        ),
        h5(strong("11.- "),
          "Mijangos Cortés, J. O. 2013. Colecta de maíces nativos en regiones estratégicas de la Península de Yucatán. Centro de Investigación Científica de Yucatán A.C. Unidad de Recursos Naturales. Bases de datos SNIB-CONABIO Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=14", "FZ014."),
          " México, D.F."
        ),
        h5(strong("12.- "),
          "Mijangos Cortés, J. O. 2013. Colecta de maíces nativos en regiones estratégicas de la Península de Yucatán. Centro de Investigación Científica de Yucatán A.C. Unidad de Recursos Naturales. Bases de datos SNIB-CONABIO Datos 2007. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=14", "FZ014."),
          " México, D.F."
        ),
        h5(strong("13.- "),
          "Zavala García, F. 2012. Conocimiento de la diversidad y distribución actual del maíz nativo en Nuevo León. Universidad Autónoma de Nuevo León. Facultad de Agronomía. Bases de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=15", "FZ015."),
          " México D. F."
        ),
        h5(strong("14.- "),
          "García Holguín, M. R. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México, segunda etapa 2008-2009. Instituto Nacional de Investigaciones Forestales, Agrícolas y Pecuarias. Base de datos SNIB-CONABIO Chihuahua. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México D.F."
        ),
        h5(strong("15.- "),
          "Guerrero Herrera, M. de J. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México, segunda etapa 2008-2009. Instituto Nacional de Investigaciones Forestales, Agrícolas y Pecuarias. Base de datos SNIB-CONABIO CIRNO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México D.F."
        ),
        h5(strong("16.- "),
          "Castillo Rosales, A., E. Quezada Guzmán, A. de Alba Ávila, L.R. Reveles Torres y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Norte Centro, estados: Aguascalientes, Durango y Zacatecas. INIFAP-CIRNOC. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(strong("17.- "),
          "Vidal Martínez, V.A., A. Morfín Valencia, A. García Berber, F. Herrera Cedano, M. de J. Guerrero Herrera, N.O. Gómez Montiel, J.M. Hernández Casillas, M. de la O Olan, J. Ron Parra, J. de J. Sánchez González, A. Jiménez Cordero, L. de la Cruz Larios, H. Ramírez Vega y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Pacífico Centro, estados: Colima, Jalisco y Nayarit. INIFAP-CIRPAC. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(strong("18.- "),
          "Preciado Ortiz, R.E., J.M. Hernández Casillas, M. de la O Olan, G. Esquivel Esquivel, A.D. Terrón Ibarra, A. Aguirre Gómez, L.A. Noriega González, A.S. Cruz Morales, J.P. Pérez Camarillo, L. Martínez Hernández, S. Franco Ramírez, E.R. Martínez Ruíz, M.A. Ávila Perches, J.R.A. Dorantes González, H.G. Gámez Vázquez, A.J. Gámez Vázquez, A. María Ramírez, E. Muñoz de la Vega, A. Ríos Sosa, F. Huerta López y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Centro, estados: Distrito Federal, Estado de México, Guanajuato, Hidalgo, Michoacán, Querétaro, San Luis Potosí y Tlaxcala. INIFAP-CIRCE. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(strong("19.- "),
          "Sierra Macías, M., I. Meneses Márquez, A. Palafox Caballero, N. Francisco Nicolás, A. Zambada Martínez, F. Rodríguez Montalvo, R. López Morgado, S. Barrón Freyre, J.M. Uribe Bernal, J.M. Hernández Casillas y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Golfo Centro, estados: Puebla, Veracruz y Tabasco. INIFAP-CIRGOC. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(strong("20.- "),
          "Gómez Montiel, N.O., B. Coutiño Estrada, A. Trujillo Campos, F. Palemón Alberto, G. Sánchez Grajales, F.J. Cruz Chávez, C.E. Aguilar Jiménez, J.M. Hernández Casillas, F. Castillo González, R. Ortega Paczka y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Pacífico Sur, estados: Chiapas, Guerrero y Morelos. INIFAP-CIRPAS. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(strong("21.- "),
          "Aguilar Castillo, G., H. Torres Pimentel, J. Medina Méndez, R.J. Nava Padilla y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Sureste, estados: Campeche, Quintana Roo y Yucatán. INIFAP-CIRSE. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(strong("22.- "),
          "Garza Castillo, M. R. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y Tripsacum en el estado de Tamaulipas. Universidad Autónoma de Tamaulipas. Instituto de Ecología y Alimentos. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=18", "FZ018."),
          " México, D.F."
        ),
        h5(strong("23.- "),
          "Carrera Valtierra, J. A. 2013. Estudio de la diversidad de maíz en la región costa de Michoacán y áreas adyacentes de Jalisco y Colima. Universidad Autónoma de Chapingo. Centro Regional Universitario Centro Oriente. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=23", "FZ023."),
          " México, D.F."
        ),
        h5(strong("24.- "),
          "Díaz Gallardo, R. I. 2013. Diagnóstico de la diversidad de maíces nativos, su agroecosistema y sus parientes silvestres en la región prioritaria “La Chinantla” y su zona de influencia. SEMARNAT. CONTRATO DGRMIS-DAC-DGSPYRNR-No.004/2009. Base de datos donada al SNIB-CONABIO Maíz. ",
          tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=3", "Z003."),
          " México D. F."
        ),
        h5(strong("25.- "),
          "Vázquez Vázquez, J. L. 2013. Diagnóstico de la diversidad de maíces nativos, su agroecosistema y sus parientes silvestres presentes en el ANP “Papigochic” y su zona de influencia. SEMARNAT. Contrato DGRMIS-DAC-DGSPYRNR-002/2009. Base de datos donada al SNIB-CONABIO Maíz. ",
          tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=4", "Z004."),
          " México D. F."
        ),
        h5(strong("26.- "),
             "Díaz Gallardo, R.I. 2014. Catálogo de maíces nativos, generada a partir de la tesis “El sistema milpa y sus recursos fitogenéticos en Santa María Tlahuitoltepec, Oaxaca”. Región Sierra Mixe. Universidad Autónoma Chapingo. Base de datos SNIB-CONABIO. Proyecto No. ",
             tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=5", "Z005."),
             ". México, D.F."
        ),
        h5(strong("27.- "),
          "Ortega Paczka, R. 2015. Computarización de datos de colecta de muestras de maíz y otros cultivos asociados de diferentes regiones de México. Donación del Dr. Rafael Ortega Paczka. Universidad Autónoma Chapingo. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=6", "Z006."),
          " México, D.F."
        )
        
        
      ), #close tab of Bibliografía
      
      # About Page
      tabItem(
        tabName = 'autor',
        value = "Visualización",
        br(),
        br(),
        br(),
        div(
          img(src = "plecaPGM_1200x175.jpg", width = "900"),
          style = "text-align: center;"
        ),
        br(),
        fluidRow(
          widgetUserBox(
            title = h4("Alejandro Ponce-Mendoza"),
            subtitle = "Experto para el Análisis de Información de Agrobiodiversidad",
            width = 4,
            type = 2,
            src = "APM.jpeg",
            color = "yellow",
            h5(
              "Trabajo en la",
              tags$a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CPAM.html", "Conabio"),
              "para conservación de la agrobiodiversidad. Me interesa la visualización y análisis,
                                 de datos ecológicos. Mis publicaciones las puedes encontrar",
              tags$a(href = "https://scholar.google.com/citations?user=M1i6_loAAAAJ&hl=en", "aquí")
            ),
            footer = socialButton(url = "https://github.com/APonce73",
                                  type = "github"),
            tags$a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CPAM.html", "Conabio")
            
          )
          
        ) #close fluidRow
        
      ) # close about page
      
    )
    
    
  )
  
)
#)
