library(shiny)
library(leaflet)
library(knitr)
library(plotly)
library(ggplot2)

#runApp(system.file("shiny/", package = "googleVis"))
#library(ggplot2movies)

shinyUI(navbarPage(
  title = "Proyecto G Maíces",
# Ventana 0

#  tabPanel('Introducción',
#           absolutePanel(
             
#             imageOutput('preImage1', width = "100%", height = "100%"))),
             #top = 10, right = 10, width = 300,
              #           draggable = TRUE,
                         
                         #wellPanel(
                        #   column(9, imageOutput('preImage1')),
                        
               #          )
                #           )),
  
  
  #Ventana 1 Mapa
#tabPanel('Mapa', 
#         shinyUI(fluidPage(
#bootstrapPage(
#  #tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
#  leafletOutput("mymap", width = "100%", height = "100%"),
#  absolutePanel(top = 10, right = 10,
#                selectInput(inputId = "Raza_primaria",
#                            label = h6("Raza Primaria:"),
#                            c("All", levels(TableL$Raza_primaria))),
#                #c("All", unique(as.character(TableL$Raza_primaria)))),
#                
#                #Por Complejo Racial
#                selectInput(inputId = "Complejo_racial",
#                            label = h6("Grupo Racial:"),
#                            c("All", levels(TableL$Complejo_racial))),
#                
#                #Por Estado
#                selectInput(inputId = "Estado",
#                            label = h6("Estado:"),
#                            c("All", levels(TableL$Estado))),
#                
#                checkboxGroupInput("Periodo_Colecta", label = h6("Período de Colecta:"),
#                                   choice = levels(TableL$Periodo_Colecta), selected = levels(TableL$Periodo_Colecta))
#  )
#)
#))),



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
                             label = h6("Grupo Racial:"),
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
                 column(9,leafletOutput("mymap", width = "1000", height = "800"))
               )
              #leafletOutput("mymap", width = "100%", height = "100%")
             )
           )) 
           ),
#Ventana 2 Fotos Maices
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
                             levels(TableL1c$Raza_Primaria)),
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
                 column(9, imageOutput('preImage', height = 500, width = 500)),
                 column(8,plotlyOutput("plot11", height = 700, width = 900))
                 
                        
               )
             )
               ))
           ),

#Ventana 2.1 Sankeyplot

tabPanel('Sankey', 
         # Define UI for slider demo application
         shinyUI(fluidPage(
           #Application title
           titlePanel("Gráfica de Sankey"),
           h4("Razas de maíces"),
           
           sidebarLayout(
             sidebarPanel(
               
               #Raza Primaria
            #   selectInput(inputId = "Raza_primarias",
            #               label = h6("Raza Primaria:"),
            #               c("All", levels(TableL2$Raza_primaria))),
            #   #c("All", unique(as.character(TableL$Raza_primaria)))),
               
            #   #Por Complejo Racial
            #   selectInput(inputId = "Complejo_racials",
            #               label = h6("Grupo Racial:"),
            #               c("All", levels(TableL2$Complejo_racial))),
               
               #Por Estado
               selectInput(inputId = "Estados",
                           label = h6("Estado:"),
                            c("All", levels(TableL2$Estado))),
               br(),
               h6("Visualización de la presencia de maíces en distintos estados"),
               br()
               
              # selectInput(inputId = "Complejo_racials",
              #             label = h6("Grupo racial:"),
              #             levels(TableLL$Complejo_racial)),
               
               
               
             , width = 2),    
                column(9,
               htmlOutput("Sankeyplot1", width = "1000", height = "600")
             )
             #leafletOutput("mymap", width = "100%", height = "100%")
           
         )
         ))
),


#Ventana 3  StrucPlot         
  tabPanel('Análisis',
           # Define UI for slider demo application
           shinyUI(fluidPage(
             #Application title
             titlePanel("Strucplot"),
             h4("Razas de maíces"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 #Por Complejo Racial
                # selectInput(inputId = "Complejo_racial",
                #             label = h6("Complejo Racial:"),
                #             levels(TableL$Complejo_racial)),
                 
                 #Por Estado
                 selectInput(inputId = "Complejo_racials",
                             label = h6("Grupo racial:"),
                             levels(TableLL$Complejo_racial)),
                 
                 checkboxGroupInput("Periodo_Colectas", label = h6("Período de Colecta:"),
                                    choice = levels(TableLL$Periodo_Colecta), selected = levels(TableLL$Periodo_Colecta)),
                 h6("Strucplot es una gráfica de asociación entre los Estados y las razas de 
                      maíces presentes en cada grupo racial durante todos los períodos de colecta"),
                 #tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html", "Proyecto Maices"),
                 #br(),
                 #h6("Descarga de la base de datos"),
                 #tags$a(href = "http://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo13_Base%20de%20datos/BaseMaicesNativos.xlsx", "DataBase"),
                 #br(),
                 #h6("comentarios: aponce@conabio.gob.mx"),
                 #br(),
                 #h5("Github:"),
                 #tags$a(href = "https://github.com/APonce73/Conabio-PGMaices", "Conabio-Maíces"),
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



#library(devtools)
#install_github("mages/googleVis")
