

library(shiny)
library(leaflet)

# Define UI for slider demo application
shinyUI(fluidPage(
  #Application title
  titlePanel("Proyecto Global de Maíces CONABIO"),
  h4("Razas de maíces"),
  
  sidebarLayout(
    sidebarPanel(
      
      #Raza Primaria
      selectInput(inputId="Raza_primaria",
                  label=h6("Raza Primaria:"),
                  c("All", levels(TableL$Raza_primaria))),
                  #c("All", unique(as.character(TableL$Raza_primaria)))),
      
      #Por Complejo Racial
      selectInput(inputId="Complejo_racial",
                  label=h6("Complejo Racial:"),
                  c("All", levels(TableL$Complejo_racial))),
      
      #Por Estado
      selectInput(inputId="Estado",
                  label=h6("Estado:"),
                  c("All", levels(TableL$Estado))),
      #Por año
      #selectInput(inputId="Year",
      #            label=h6("Año:"),
      #            c("All", levels(TableL$Year))),
      
     # checkboxGroupInput("Anhio_Colecta", label=h6("Año:"),
     #           choice=levels(TableL$Anhio_Colecta),selected=levels(TableL$Anhio_Colecta)),
      
      checkboxGroupInput("Periodo_Colecta", label=h6("Período de Colecta:"),
                         choice = levels(TableL$Periodo_Colecta), selected = levels(TableL$Periodo_Colecta)),
      
      
      h6("Descargar los datos visualizados en el mapa"),
      downloadButton('downloadData', 'Descargar (csv)'),
      br(),
      br(),
      br(),
      h6("Proyecto Global de Maíces"),
      tags$a(href="http://www.biodiversidad.gob.mx/genes/proyectoMaices.html", "Proyecto Maices"),
      br(),
      h6("Download Full Database"),
      tags$a(href="http://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo13_Base%20de%20datos/BaseMaicesNativos.xlsx", "DataBase"),
      br(),
      h6("comentarios: aponce@conabio.gob.mx"),
      br(),
      h5("Github:"),
      tags$a(href="https://github.com/APonce73/Conabio-Maices", "Conabio-Maíces"),
      width=2),
      
  
  
    fluidRow(
      column(9,leafletOutput("mymap",height=700))
    )
    
  )
        
))

