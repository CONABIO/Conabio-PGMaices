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
  dashboardHeaderPlus(
    title = "Proyecto Global de  Maíces",
    titleWidth = 265,
    fixed = TRUE
  ), # close dashboard header
  
  ## Sidebar Menu
  dashboardSidebar(
    width = 265,
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
        div(
          img(src = "CONABIO_LOGO_13.png", width = "200"),
          img(src = "CodiceFlorentino.png", width = "300"),
        #  img(src = "CodiceFlorentino.png", width = "300"),
          style = "text-align: center;"
        ),
        fluidRow(
          h2(
            tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html",
                   strong("Proyecto Global de Maíces")),
            align = "center"
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
            tags$a(href = "http://www.inifap.gob.mx/", "INIFAP"), 
            ") y el Instituto Nacional de Ecología y Cambio Climático (", tags$a(href = "https://www.gob.mx/inecc", "INECC.") ,
            ")"
          ),
          #br(),
          h4("El proyecto incluyó tres líneas de acción:"),
          h4("1. Generación de un documento sobre centros de origen y de diversidad genética del maíz"),
          h4("2. Computarización de colecciones científicas de maíz nativo, teocintle y tripsacum "),
          h4("3. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres a través de proyectos de colecta"),
          br(),
          h4("Los registros de maíces corresponden a las bases de datos de los proyectos financiados durante el PGM y 
             bases de datos donadas. Hasta ahora, el total de registros de maíces nativos es de 25,862 registros, 
             de los cuales 25,095 registros contienen coordenadas geográficas. Los datos puede descargarse", tags$a(href = "https://www.biodiversidad.gob.mx/media/1/genes/files/BaseMaicesNativos.xlsx", "aqui.")),
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
                       userPostMedia(src = "datosMaices.png", height = 400, width = 400),
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
                       h4("La lista de documentos que generó el Proyecto Global de Maíces"),
                       userPostMedia(src = "bibliografia.png", height = 400, width = 400),
                       id = "Bibliografia",
                       style = "cursor:pointer;"
                     )
                   )
          
          
          
        )#close FluidRow
      ),
      #Introducción
      #  tabPanel('Introducción',
      #
      #  ), #del tabPanel
      
      #Ventana 1
      tabItem(
        tabName = "widgets",
        value = "Distribucion de maíces",
        br(),
        br(),
        fluidRow(
          tags$style(type = "text/css", "#mymap1 {height: calc(100vh - 80px) !important;}"),
          leafletOutput('mymap1', width = "100%", height = "100%")
        ),
        
        #   h4("$$$"),
        
        
        absolutePanel(
          top = 100,
          right = 40,
          draggable = T,
          width = "13%",
          
          #Por Complejo Racial
          selectInput(inputId = "Complejo_racial",
                      label = "Grupo Racial:",
                      c("All", levels(as.factor(TableL$Complejo_racial)))),
          #Raza Primaria
          selectInput(
            inputId = "Raza_primaria",
            label = h6("Raza Primaria:"),
            c("All", levels(TableL$Raza_primaria))
            #choices = "",
            #selected = ""
          ),
          
          #Por Estado
          selectInput(inputId = "Estado",
                      label = "Estado:",
                      c("All", levels(as.factor(TableL$Estado)))),
          
          #Por Estado
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
        
    #    absolutePanel(
    #      bottom = 10,
    #      left = 20,
    #      h4("Conabio:"),
    #      tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html", "Proyecto Maices"),
    #      br(),
    #      #h4("Descarga de la base de datos"),
    #      #tags$a(href = "http://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo13_Base%20de%20datos/BaseMaicesNativos.xlsx", "DataBase"),
    #      #br()
    #      h4("Github:"),
    #      tags$a(href = "https://github.com/APonce73/Conabio-PGMaices", "Conabio-Maíces"),
    #      h5("comentarios:"),
    #      #h5("amastretta@conabio.gob.mx"),
    #      h5("aponce@conabio.gob.mx")
    #      #uiOutput("fens")
    #    )
        # )
      ),
      #parentesis del tabItem
      #Ventana 2 Fotos Maices
      tabItem(
        br(),
        br(),
        tabName = "widgets1",
        div(
          img(src = "CONABIO_LOGO_13.png", width = "200"),
          img(src = "CodiceFlorentino.png", width = "300"),
          style = "text-align: center;"
        ),
        fluidRow(
         # h4("Razas de maíces"),
          
  #        sidebarLayout(
  #          sidebarPanel(
  #            #Raza Primaria
  #            selectInput(
  #              inputId = "Raza_Primaria",
  #              label = h6("Raza de maíz:"),
  #              levels(as.factor(TableL1c$Raza_Primaria))
  #            )
  #        #    h4("Conabio"),
  #        #    tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html", "Proyecto Maices"),
  #        #    # br(),
  #        #    
  #        #    # h6("Descarga de la base de datos"),
  #        #    # tags$a(href = "http://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo13_Base%20de%20datos/BaseMaicesNativos.xlsx", "DataBase"),
  #        #    h4("Github:"),
  #        #    tags$a(href = "https://github.com/APonce73/Conabio-PGMaices", "Conabio-Maíces"),
  #        #    h5("comentarios:"),
  #        #    #h5("amastretta@conabio.gob.mx"),
  #        #    h5("aponce73pm@gmail.com"),
  #        #    width = 3
  #          ), #close sidebarPanel
            
           
          
          
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
                 label = h6("Raza de maíz:"),
                 levels(as.factor(TableL1c$Raza_Primaria))
                            ),
                 h4("Características generales:"),
                 h4(textOutput("summary1")),
                 h5(
                   "Fuente:",
                   tags$a(href = "https://www.biodiversidad.gob.mx/media/1/genes/files/Tabla_razas_marzo_2010.pdf", "Maíces")
                 )
                                        ),
               imageOutput("preImage", height = 500, width = 500
                           ), 
               #h4("Características generales"),
               #h4(textOutput("summary1")),
              # h5(
              #   "Fuente:",
              #   tags$a(href = "https://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo6_ReunionesTalleres/Tabla%20razas_marzo%202010.pdf", "Maíces")
              # ),
              #br(),
              h4("Número de registros por estado"),
               plotOutput(
                 "plot11", height = 500, width = 700)
               )
             
             
        #      column(6, imageOutput(
        #        'preImage', height = 500, width = 500
        #      )),
        #      
        #      column(9, wellPanel(
        #        h4("Características generales"),
        #        h4(textOutput("summary1")),
        #        h5(
        #          "Fuente:",
        #          tags$a(href = "https://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo6_ReunionesTalleres/Tabla%20razas_marzo%202010.pdf", "Maíces")
        #        )
        #      )),
        #      column(9,
        #             plotOutput(
        #               "plot11", height = 500, width = 800
        #             ))
            )
        #  ) #close sidebarLayout
        )
      ),
      
      ## Para la gráfica de la Altitud
      tabItem(
        br(),
        br(),
        tabName = "widgets2",
        div(
          img(src = "CONABIO_LOGO_13.png", width = "200"),
          img(src = "CodiceFlorentino.png", width = "300"),
          style = "text-align: center;"
        ),
        br(),
        br(),
        fluidRow(
          tags$style(type = "text/css", "#graph2 {height: calc(100vh - 80px) !important;}"),
          plotOutput('graph2', height = "200%", width = "90%")
        ),
        
        absolutePanel(
          top = 150,
          right = 40,
          draggable = T,
          #Seleccionar la variable para
          selectInput(
            inputId = 'var11',
            label = h6(strong('Ordenar por:')),
            choices = c("promedio", "máximo", "mínimo"),
            width = 200
          )
          
        ) # close column
      ), # close widget page
      
      
      ## Para la gráfica de Tamaño de mazorca
      tabItem(
        br(),
        br(),
        tabName = "widgets4",
        div(
          img(src = "CONABIO_LOGO_13.png", width = "200"),
          img(src = "CodiceFlorentino.png", width = "300"),
          style = "text-align: center;"
        ),
        br(),
        br(),
        fluidRow(
          tags$style(type = "text/css", "#graph3 {height: calc(100vh - 80px) !important;}"),
          plotOutput('graph3', height = "200%", width = "90%")
        ),
        
        absolutePanel(
          top = 150,
          right = 40,
          draggable = T,
          #Seleccionar la variable para
          selectInput(
            inputId = 'var12',
            label = h6(strong('Ordenar por:')),
            choices = c("promedio", "máximo", "mínimo"),
            width = 200
          )
          
        ) # close column
      ), # close widget page
      
      #Ventana 2.1 Sankeyplot
      
      tabItem(
        br(),
        br(),
        tabName = "widgets3",
        div(
          img(src = "CONABIO_LOGO_13.png", width = "200"),
          img(src = "CodiceFlorentino.png", width = "300"),
          style = "text-align: center;"
        ),
        # Define UI for slider demo application
        
        h3("La gráfica de aluvial o de Flujo de las razas de maíces en México"),
        h4("Esta gráfica visualizan la distribución de las
             razas de maíces. De izquierda a derecha se muestran los distintos ",
          tags$a(href = "https://www.biodiversidad.gob.mx/usos/maices/razas2012.html",
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
      
      
      
 #     tabItem(
 #       tabName = "widgets9",
 #       value = "Datos adicionales sobre el maíz",
 #       br(),
 #       div(
 #         img(src = "CONABIO_LOGO_13.png", width = "200"),
 #         img(src = "CodiceFlorentino.png", width = "300"),
 #         style = "text-align: center;"
 #       ),
 #       #div(img(src = "CodiceFlorentino.png", width = "750"), style = "text-align: center;"),
 #       br(),
 #       br(),
 #       h3("El Maíz me representa y me identifica con mi gente", style = "text-align: center;"),
 #       br(),
 #       br(),
 #       
 #       column(
 #         4,
 #         wellPanel(
 #           h3("Cronología del maíz en México"),
 #           h5("6200 años del presente (AdP) Guilá Naquitz (Oaxaca)"),
 #           h5("4500-7000 AdP, Tehuacan (Puebla)"),
 #           h5("5000      AdP, Zohapilco (Tlapacoya, México)"),
 #           h5("4562      AdP, San Andrés (Tabasco)"),
 #           h5("4500      AdP, Norte de Sinaloa"),
 #           h5("4500      AdP, Cueva de la Perra (Tamaulipas)"),
 #           h5("4400      AdP, Cueva de Ocampo (Tamaulipas)"),
 #           h5("4250      AdP, Laguna Pompal (Veracruz)"),
 #           h5("3750-4250 AdP, La Venta (Tabasco)"),
 #           h5("3890      AdP, Cueva de Valenzuela (Tamapulipas)"),
 #           h5("3400-3550 AdP, Costa del Pacífico"),
 #           h5("3000      AdP, La Playa (Sonora)"),
 #           h5("2980      AdP, Cerro Juanaqueña (Chihuahua)"),
 #           h5("2400-2700 AdP, Cueva del Valle (Chihuahua)"),
 #           h5("2400-2700 AdP, San Blas (Nayarit)"),
 #           h6(
 #             "Fuente:Información biológica-agronómica básica sobre, los maíces nativos y sus parientes silvestres, CONABIO"
 #           ),
 #           br()
 #           
 #           
 #           #div(img(src = "Mapa.png", style = "display:block; margin-left: auto; margin-right: auto;",width = "400", height = "300")),
 #           #div(img(src = "Mapa1.png", style = "display:block; margin-left: auto; margin-right: auto;",width = "300", height = "300"))
 #         )
 #       ),
 #       
 #       
 #       column(
 #         4,
 #         wellPanel(
 #           h3("Topónimos relacionados con el Maíz "),
 #           h5("Actopan: En la Tierra Fértil"),
 #           h5("Amilcingo: Las milpas de agua"),
 #           h5("Amilpas: En los sembradíos de riego"),
 #           h5("Centla: Donde abundan las mazorcas de maíz"),
 #           h5("Cincózcac: En el collar de mazorcas de maíz"),
 #           h5("Elota: Donde abundan los elotes"),
 #           h5("Jilotepec o Xilotepe: Lugar de jilotes"),
 #           h5("Jilotlan: Donde abundan los jilotes"),
 #           h5("Jilotzingo o Xilotzingo: Lugar del jilotito"),
 #           h5("Miahuatlan: Rio de las espigas de maíz"),
 #           h5("Milpa Alta: En las milpas de la parte alta"),
 #           h5("Miltepec: En el cerro de las milpas"),
 #           h5("Oapan: Sobre las cañas del maíz tierno"),
 #           h5("Teocinyocan: Lugar donde se hace divino el maíz"),
 #           h5("Textitlan: Junto a donde hay masa"),
 #           h5("Tlaxcala: Lugar de las tortillas"),
 #           h5("Xiloxotla: Lugar de maíz muy tierno")
 #           #div(img(src = "Mapa.png", style = "display:block; margin-left: auto; margin-right: auto;",width = "400", height = "300")),
 #           #div(img(src = "Mapa1.png", style = "display:block; margin-left: auto; margin-right: auto;",width = "300", height = "300"))
 #         )
 #       ),
 #       
 #       div(
 #         img(src = "Zea_mays.jpg", width = "400"),
 #         div(img(src = "San_Andres_Calpan_Puebla.jpg", width = "500"), style = "text-align: center;")
 #       ),
 #       column(4, wellPanel(
 #         h2("Los dichos del maíz"),
 #         br(),
 #         h3("Otra vez la burra al maíz, y el burrito a los elotes"),
 #         h5(
 #           "Frase que se usa para mostrar disgusto cuando alguien ejecuta repetidamente una acción molesta o dañina"
 #         ),
 #         br(),
 #         h3("Le está lloviendo en su milpita"),
 #         h5(
 #           "Recibir alguien muchos bienes o beneficios seguidos.
 #                                   No confundirlo con -le llovió sobre mojado-, que significa precisamente lo contrario"
 #         )
 #         
 #       )),
 #       column(4, wellPanel(
 #         h3("Dar atole con el dedo"),
 #         h5(
 #           "Engañar a alguien con algo muy simple, como si fuera
 #                               un bebé al que hay que alimentar con cuidado"
 #         ),
 #         br(),
 #         h3("Éste no siembra maíz por miedo a las urracas"),
 #         h5("Se aplica a las personas que justifican su pereza
 #                               con pesimismo"),
 #         br(),
 #         h6(
 #           "Fuente: -los dichos del maíz- por Susana González Aktories
 #                               de la revista Artes de México (79) -Mitos del maíz-"
 #         ),
 #         br()
 #       ))
 #       
 #       
 #       
 #     ), #cortar hasta aqui
      
      tabItem(
        tabName = 'conabio',
        value = 'Bibliografía',
        br(),
        
        div(
          img(src = "CONABIO_LOGO_13.png", width = "200"),
          img(src = "CodiceFlorentino.png", width = "300"),
          style = "text-align: center;"
        ),
        #div(img(src = "CodiceFlorentino.png", width = "750"), style = "text-align: center;"),
        
        
        h4(
          "Bases de datos generadas durante la ejecución del Proyecto Global de Maíces  “Recopilación, generación, actualización y análisis de información acerca de la diversidad genética de maíces y sus parientes silvestres en México.",
          tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html",
                 "CONABIO.")
        ),
        
        h5(
          "Hernández Casillas, J.M.; Díaz de la C., J. B. 2010. Base de datos de colecciones de maíces nativos, teocintles y Tripsacum de México. Bases de datos SNIB-CONABIO proyecto No.",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FY&Numero=1", "FY001") ,
          "México, D.F."
        ),
        h5(
          "Carrera Valtierra, J. A. 2013. Estudio de la diversidad genética y su distribución de los maíces criollos y sus parientes silvestres en Michoacán. Universidad Autónoma de Chapingo. Centro Regional Universitario Centro Oriente. Bases de datos SNIB2013-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=1", "FZ001."),
          " México, D.F."
        ),
        h5(
          "Rincón Sánchez, F., Hernández Pardo, C. J., Zamora Cansino F., Hernández Casillas, J. M., Ruiz Torres, N. A., Illescas Palma, C. N. y L. Ramón Gayosso. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Coahuila. INIFAP-UAAAN. Base de datos SNIB-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          "México, D. F."
        ),
        h5(
          "Vidal Martínez, V. A., Ortega Corona, A., Guerrero Herrera, M. de J., Cota Agramont, O., Herrera Cedano, F., Hernández Casillas, J. M., Valdivia Bernal, R., Caro Velarde F. de J. y G. González Rodríguez. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Nayarit. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No.",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          " México, D. F."
        ),
        h5(
          "Valadez Gutiérrez, Juan, Julio César García Rodríguez y Juan Manuel Hernández Casillas. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Nuevo León. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          " México, D. F."
        ),
        h5(
          "Palacios Velarde, O., Ortega Corona, A., Guerrero Herrera, M. de J., Hernández Casillas, J. M. y L. M. Peinado Fuentes. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Sinaloa. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          " México, D. F."
        ),
        h5(
          "Ortega Corona, A., Guerrero Herrera, M. de J., Cota Agramont, O., Hernández Casillas, J. M. y L. M. Peinado Fuentes. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Sonora. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          " México, D. F."
        ),
        h5(
          "Valadez Gutiérrez, J., García Rodríguez, J. C.,  Cervantes Martínez, J. E. y J. M. Hernández Casillas. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Tamaulipas. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."),
          " México, D. F."
        ),
        h5(
          "Rendón Aguilar, B. 2011. Diversidad y distribución altitudinal de maíces nativos en la región de los Loxicha, Sierra Madre del Sur Oaxaca. Universidad Autónoma Metropolitana. Unidad Iztapalapa. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=FZ&Numero=3", "FZ003."),
          " México, D.F."
        ),
        h5(
          "Taba, S., Chávez Tovar, V. H., Rivas, M. y M. Rodríguez Alvarado. 2010. Monitoreo y recolección de la Diversidad de razas de maíz criollo en la región de la Huasteca en México para complementar las colecciones de los bancos de germoplasma de INIFAP y CIMMYT. Centro Internacional de Mejoramiento de Maíz y Trigo. Banco de Germoplasma de Maíz. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=7", "FZ007."),
          " México D. F."
        ),
        h5(
          "Mijangos Cortés, J. O. 2013. Colecta de maíces nativos en regiones estratégicas de la Península de Yucatán. Centro de Investigación Científica de Yucatán A.C. Unidad de Recursos Naturales. Bases de datos SNIB-CONABIO Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=14", "FZ014."),
          " México, D.F."
        ),
        h5(
          "Mijangos Cortés, J. O. 2013. Colecta de maíces nativos en regiones estratégicas de la Península de Yucatán. Centro de Investigación Científica de Yucatán A.C. Unidad de Recursos Naturales. Bases de datos SNIB-CONABIO Datos 2007. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=14", "FZ014."),
          " México, D.F."
        ),
        h5(
          "Zavala García, F. 2012. Conocimiento de la diversidad y distribución actual del maíz nativo en Nuevo León. Universidad Autónoma de Nuevo León. Facultad de Agronomía. Bases de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=15", "FZ015."),
          " México D. F."
        ),
        h5(
          "García Holguín, M. R. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México, segunda etapa 2008-2009. Instituto Nacional de Investigaciones Forestales, Agrícolas y Pecuarias. Base de datos SNIB-CONABIO Chihuahua. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México D.F."
        ),
        h5(
          "Guerrero Herrera, M. de J. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México, segunda etapa 2008-2009. Instituto Nacional de Investigaciones Forestales, Agrícolas y Pecuarias. Base de datos SNIB-CONABIO CIRNO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México D.F."
        ),
        h5(
          "Castillo Rosales, A., E. Quezada Guzmán, A. de Alba Ávila, L.R. Reveles Torres y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Norte Centro, estados: Aguascalientes, Durango y Zacatecas. INIFAP-CIRNOC. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(
          "Vidal Martínez, V.A., A. Morfín Valencia, A. García Berber, F. Herrera Cedano, M. de J. Guerrero Herrera, N.O. Gómez Montiel, J.M. Hernández Casillas, M. de la O Olan, J. Ron Parra, J. de J. Sánchez González, A. Jiménez Cordero, L. de la Cruz Larios, H. Ramírez Vega y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Pacífico Centro, estados: Colima, Jalisco y Nayarit. INIFAP-CIRPAC. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(
          "Preciado Ortiz, R.E., J.M. Hernández Casillas, M. de la O Olan, G. Esquivel Esquivel, A.D. Terrón Ibarra, A. Aguirre Gómez, L.A. Noriega González, A.S. Cruz Morales, J.P. Pérez Camarillo, L. Martínez Hernández, S. Franco Ramírez, E.R. Martínez Ruíz, M.A. Ávila Perches, J.R.A. Dorantes González, H.G. Gámez Vázquez, A.J. Gámez Vázquez, A. María Ramírez, E. Muñoz de la Vega, A. Ríos Sosa, F. Huerta López y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Centro, estados: Distrito Federal, Estado de México, Guanajuato, Hidalgo, Michoacán, Querétaro, San Luis Potosí y Tlaxcala. INIFAP-CIRCE. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(
          "Sierra Macías, M., I. Meneses Márquez, A. Palafox Caballero, N. Francisco Nicolás, A. Zambada Martínez, F. Rodríguez Montalvo, R. López Morgado, S. Barrón Freyre, J.M. Uribe Bernal, J.M. Hernández Casillas y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Golfo Centro, estados: Puebla, Veracruz y Tabasco. INIFAP-CIRGOC. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(
          "Gómez Montiel, N.O., B. Coutiño Estrada, A. Trujillo Campos, F. Palemón Alberto, G. Sánchez Grajales, F.J. Cruz Chávez, C.E. Aguilar Jiménez, J.M. Hernández Casillas, F. Castillo González, R. Ortega Paczka y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Pacífico Sur, estados: Chiapas, Guerrero y Morelos. INIFAP-CIRPAS. Base de datos SNIB-CONABIO proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(
          "Aguilar Castillo, G., H. Torres Pimentel, J. Medina Méndez, R.J. Nava Padilla y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Sureste, estados: Campeche, Quintana Roo y Yucatán. INIFAP-CIRSE. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."),
          " México, D.F."
        ),
        h5(
          "Garza Castillo, M. R. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y Tripsacum en el estado de Tamaulipas. Universidad Autónoma de Tamaulipas. Instituto de Ecología y Alimentos. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=18", "FZ018."),
          " México, D.F."
        ),
        h5(
          "Carrera Valtierra, J. A. 2013. Estudio de la diversidad de maíz en la región costa de Michoacán y áreas adyacentes de Jalisco y Colima. Universidad Autónoma de Chapingo. Centro Regional Universitario Centro Oriente. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=23", "FZ023."),
          " México, D.F."
        ),
        h5(
          "Díaz Gallardo, R. I. 2013. Diagnóstico de la diversidad de maíces nativos, su agroecosistema y sus parientes silvestres en la región prioritaria “La Chinantla” y su zona de influencia. SEMARNAT. CONTRATO DGRMIS-DAC-DGSPYRNR-No.004/2009. Base de datos donada al SNIB-CONABIO Maíz. ",
          tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=3", "Z003."),
          " México D. F."
        ),
        h5(
          "Vázquez Vázquez, J. L. 2013. Diagnóstico de la diversidad de maíces nativos, su agroecosistema y sus parientes silvestres presentes en el ANP “Papigochic” y su zona de influencia. SEMARNAT. Contrato DGRMIS-DAC-DGSPYRNR-002/2009. Base de datos donada al SNIB-CONABIO Maíz. ",
          tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=4", "Z004."),
          " México D. F."
        ),
        h5(
          "Díaz Gallardo, R.I. 2014. Catálogo de maíces nativos, generada a partir de la tesis “El sistema milpa y sus recursos fitogenéticos en Santa María Tlahuitoltepec, Oaxaca”. Región Sierra Mixe. Universidad Autónoma Chapingo. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=5", "Z005."),
          ". México, D.F."
        ),
        h5(
          "Ortega Paczka, R. 2015. Computarización de datos de colecta de muestras de maíz y otros cultivos asociados de diferentes regiones de México. Donación del Dr. Rafael Ortega Paczka. Universidad Autónoma Chapingo. Base de datos SNIB-CONABIO. Proyecto No. ",
          tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=6", "Z006."),
          " México, D.F."
        )
        
        
      ), #close tab of Bibliografía
      
      # About Page
      tabItem(
        tabName = "autor",
        br(),
    #    fluidRow(
    #      br(),
    #      h3(strong("Autores:"), align = "center"),
    #      widgetUserBox(
    #        title = h4("Dr. Alfonso Octavio Delgado Salinas"),
    #        subtitle = "Responsable del Proyecto",
    #        width = 4,
    #        type = 2,
    #        src = "Catbus.png",
    #        color = "blue",
    #        "UNAM",
    #        footer = NULL
    #      ),
    #      widgetUserBox(
    #        title = h4("M. en C. Susana Gama López"),
    #        subtitle = "Técnico Externo",
    #        width = 4,
    #        type = 2,
    #        src = "Catbus.png",
    #        color = "blue",
    #        "UNAM",
    #        footer = NULL
    #      ),
    #      widgetUserBox(
    #        title = h4("Dr. Enrique Martínez-Meyer"),
    #        subtitle = "Co-responsables del Proyecto",
    #        width = 4,
    #        type = 2,
    #        src = "Catbus.png",
    #        color = "blue",
    #        "UNAM",
    #        footer = NULL
    #      ),
    #      widgetUserBox(
    #        title = h4("Dr. Jorge Alberto Acosta Gallegos"),
    #        subtitle = "Colaborador Externo",
    #        width = 4,
    #        type = 2,
    #        src = "Catbus.png",
    #        color = "blue",
    #        "FALTA",
    #        footer = NULL
    #      )
    #    ), #close fluid row
        fluidRow(
          h3(strong("Conabio:"), align = "center"),
          
      #    widgetUserBox(
      #      title = h4("Oswaldo Oliveros Galindo"),
      #      subtitle = "Especialista en Agrobiodiversidad",
      #      width = 4,
      #      type = 2,
      #      collapsible = TRUE,
      #      #closable = TRUE,
      #      src = "Catbus.png",
      #      color = "yellow",
      #      "Some text here!",
      #      footer = a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CA.html", "Conabio")
      #    ),
          
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
