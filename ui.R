library(shiny)
library(leaflet)
library(knitr)
library(plotly)
library(ggplot2)
library(ggplot2movies)

shinyUI(navbarPage(
  title = "Proyecto G Maíces",
#Ventana 1
    tabPanel('Mapa', 
           # Define UI for slider demo application
           shinyUI(fluidPage(
             #Application title
             titlePanel("Proyecto Global de Maíces CONABIO"),
             h4("Razas de maíces"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 #Raza Primaria
                 selectInput(inputId = "Raza_primaria",
                             label = h6("Raza Primaria:"),
                             c("All", levels(TableL$Raza_primaria))),
                 #c("All", unique(as.character(TableL$Raza_primaria)))),
                 
                 #Por Complejo Racial
                 selectInput(inputId = "Complejo_racial",
                             label = h6("Complejo Racial:"),
                             c("All", levels(TableL$Complejo_racial))),
                 
                 #Por Estado
                 selectInput(inputId = "Estado",
                             label = h6("Estado:"),
                             c("All", levels(TableL$Estado))),
                 
                 checkboxGroupInput("Periodo_Colecta", label = h6("Período de Colecta:"),
                                    choice = levels(TableL$Periodo_Colecta), selected = levels(TableL$Periodo_Colecta)),
                 
                 
                 h6("Descargar los datos seleccionados para la visualizados en el mapa"),
                 downloadButton('downloadData', 'Descargar (csv)'),
                 br(),
                 br(),
                 br(),
                 h6("Proyecto Global de Maíces"),
                 tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html", "Proyecto Maices"),
                 br(),
                 h6("Descarga de la base de datos"),
                 tags$a(href = "http://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo13_Base%20de%20datos/BaseMaicesNativos.xlsx", "DataBase"),
                 br(),
                 h6("comentarios: aponce@conabio.gob.mx"),
                 br(),
                 h5("Github:"),
                 tags$a(href = "https://github.com/APonce73/Conabio-PGMaices", "Conabio-Maíces"),
                 width = 2),
               fluidRow(
                 column(9,leafletOutput("mymap", height = 800))
               )
             )
           )) 
           ),
#Ventana 2
  tabPanel('Maíces',
           # Define UI for slider demo application
           shinyUI(fluidPage(
             #Application title
             titlePanel("Proyecto Global de Maíces CONABIO"),
             h4("Razas de maíces"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 
                 #Raza Primaria
                 selectInput(inputId = "Raza_Primaria",
                             label = h6("Raza de maíz:"),
                             levels(TableL1$Raza_Primaria)),
                 h6("Proyecto Global de Maíces"),
                 tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html", "Proyecto Maices"),
                 br(),
                 h6("Descarga de la base de datos"),
                 tags$a(href = "http://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo13_Base%20de%20datos/BaseMaicesNativos.xlsx", "DataBase"),
                 br(),
                 h6("comentarios: aponce@conabio.gob.mx"),
                 br(),
                 h5("Github:"),
                 tags$a(href = "https://github.com/APonce73/Conabio-PGMaices", "Conabio-Maíces"),
                 width = 2),
               fluidRow(
                 column(9, imageOutput('preImage')),
                 column(8,plotlyOutput("plot11", height = 700, width = 900))
                 
                        
               )
             )
               ))
           ),
#Ventana 3           
  tabPanel('Análisis',
           # Define UI for slider demo application
           shinyUI(fluidPage(
             #Application title
             titlePanel("Proyecto Global de Maíces CONABIO"),
             h4("Razas de maíces"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 #Por Complejo Racial
                # selectInput(inputId = "Complejo_racial",
                #             label = h6("Complejo Racial:"),
                #             levels(TableL$Complejo_racial)),
                 
                 #Por Estado
                 selectInput(inputId = "Complejo_racials",
                             label = h6("Complejo racial:"),
                             levels(TableLL$Complejo_racial)),
                 
                 checkboxGroupInput("Periodo_Colectas", label = h6("Período de Colecta:"),
                                    choice = levels(TableLL$Periodo_Colecta), selected = levels(TableLL$Periodo_Colecta)),
                 h6("Proyecto Global de Maíces"),
                 tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html", "Proyecto Maices"),
                 br(),
                 h6("Descarga de la base de datos"),
                 tags$a(href = "http://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo13_Base%20de%20datos/BaseMaicesNativos.xlsx", "DataBase"),
                 br(),
                 h6("comentarios: aponce@conabio.gob.mx"),
                 br(),
                 h5("Github:"),
                 tags$a(href = "https://github.com/APonce73/Conabio-PGMaices", "Conabio-Maíces"),
                 width = 2),
               fluidRow(
                   column(7,
                          plotOutput('Plot12', height = 700, width = 900)
                          #tableOutput('TablaF')
                          )
               )
             ))
           )
           )
  ))

