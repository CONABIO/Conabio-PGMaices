library(shiny)
library(leaflet)
library(RColorBrewer)
#library(dplyr)
library(knitr)
library(ggthemes)
library(vcd)
library(grid)
library(plotly)
library(ggplot2)
library(googleVis)
library(igraph)
library(scales)
library(ggalt)
#library(dicromat)

# Define server logic for slider examples
shinyServer(function(input, output, session) {
   
  #Hacer interactivo el mapa
  shinyjs::onclick("mapa", 
                   shiny::updateNavbarPage(session, 
                                           inputId = "navbar",
                                           selected = "widgets"))
  
  #Hacer datos d maices
  shinyjs::onclick("datosMaices", 
                   shiny::updateNavbarPage(session, 
                                           inputId = "navbar",
                                           selected = "widgets1"))
  
  #Hacer la altitud
  shinyjs::onclick("Altitud1", 
                   shiny::updateNavbarPage(session, 
                                           inputId = "navbar",
                                           selected = "widgets2"))
  
  #Hacer tamaño de la mazorca
  shinyjs::onclick("Mazorca", 
                   shiny::updateNavbarPage(session, 
                                           inputId = "navbar",
                                           selected = "widgets4"))
  
  #Aluvial plot
  shinyjs::onclick("Aluvial", 
                   shiny::updateNavbarPage(session, 
                                           inputId = "navbar",
                                           selected = "widgets3"))
  
  #Bibliografia
  shinyjs::onclick("Bibliografia", 
                   shiny::updateNavbarPage(session, 
                                           inputId = "navbar",
                                           selected = "conabio"))
  
  
  observeEvent(
    eventExpr = c(input$Raza_primaria, input$Complejo_racial, input$Estado, input$Proyecto),
    if (input$Raza_primaria != "All" & input$Complejo_racial != "All" & input$Estado != "All" & input$Proyecto != "All") {
      selectInput(session,
                        inputId = "Complejo_racial ",
                        choices = c("All" , levels(TableL$Complejo_racial)))
      selectInput(session,
                        inputId = "Raza_primaria",
                        choices = c("All" , levels(TableL$Raza_primaria)))
      selectInput(session,
                        inputId = "Estado",
                        choices = c("All" , levels(TableL$Estado)))
      selectInput(session,
                        inputId = "Proyecto",
                        choices = c("All" , levels(TableL$Proyecto)))
      
      numericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                                  TableL$Raza_primaria %in% input$Raza_primaria &
                                                  TableL$Estado %in% input$Estado & 
                                                  TableL$Proyecto %in% input$Proyecto]),
        min = min(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Raza_primaria %in% input$Raza_primaria &
                                              TableL$Estado %in% input$Estado & 
                                              TableL$Proyecto %in% input$Proyecto]),
        max = max(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Raza_primaria %in% input$Raza_primaria &
                                              TableL$Estado %in% input$Estado & 
                                              TableL$Proyecto %in% input$Proyecto])
      )
      
    #  updateSliderInput(
    #    session,
    #    inputId = "AltitudProfundidad",
    #    value = range(TableL$AltitudProfundidad),
    #    min = min(TableL$AltitudProfundidad),
    #    max = max(TableL$AltitudProfundidad)
    #  )
      
    } 
    else if (input$Raza_primaria != "All" &
             input$Complejo_racial != "All" &
             input$Estado != "All" & 
             input$Proyecto == "All") {
      
      updateSelectInput(
        session,
        inputId = "Proyecto",
        #label = "Especie:",
        choices = c("All" , levels(droplevels(
          as.factor(TableL$Proyecto[TableL$Complejo_racial %in% input$Complejo_racial &
                                      TableL$Raza_primaria %in% input$Raza_primaria &
                                      TableL$Estado %in% input$Estado])))))
        
        updateNumericInput(
          session,
          inputId = "AltitudProfundidad",
          value = range(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                                    TableL$Raza_primaria %in% input$Raza_primaria &
                                                    TableL$Estado %in% input$Estado]),
          min = min(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                                TableL$Raza_primaria %in% input$Raza_primaria &
                                                TableL$Estado %in% input$Estado]),
          max = max(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                                TableL$Raza_primaria %in% input$Raza_primaria &
                                                TableL$Estado %in% input$Estado])
        )
      
      
    }
    else if (input$Complejo_racial != "All" &
             input$Raza_primaria != "All" &
             input$Estado == "All" & 
             input$Proyecto == "All") {
      # updateSelectInput(session,
     #                   inputId = "Complejo_racial ",
     #                   choices = c("All" , levels(droplevels(as.factor(TableL$Complejo_racial[TableL$Raza_primaria %in% input$Raza_primaria])))))
     # updateSelectInput(session,
     #                   inputId = "Raza_primaria",
     #                   choices = c("All" , levels(droplevels(as.factor(TableL$Raza_primaria[TableL$Complejo_racial %in% input$Complejo_racial])))))
      updateSelectInput(session, inputId = "Proyecto", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Proyecto[TableL$Complejo_racial %in% input$Complejo_racial &
                                                                                         TableL$Raza_primaria %in% input$Raza_primaria])))))
      updateSelectInput(session, inputId = "Estado", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Estado[TableL$Complejo_racial %in% input$Complejo_racial &
                                                                                       TableL$Raza_primaria %in% input$Raza_primaria])))))
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                                  TableL$Raza_primaria %in% input$Raza_primaria]),
        min = min(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Raza_primaria %in% input$Raza_primaria]),
        max = max(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Raza_primaria %in% input$Raza_primaria])
      )
      
    }
    else if (input$Raza_primaria == "All" &
             input$Complejo_racial != "All" &
             input$Estado == "All" & 
             input$Proyecto == "All") {
      updateSelectInput(session, inputId = "Proyecto", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Proyecto[TableL$Complejo_racial %in% input$Complejo_racial])))))
      updateSelectInput(session, inputId = "Estado", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Estado[TableL$Complejo_racial %in% input$Complejo_racial])))))
      updateSelectInput(session, inputId = "Raza_primaria", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Raza_primaria[TableL$Complejo_racial %in% input$Complejo_racial])))))
      
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial]),
        min = min(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial]),
        max = max(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial])
      )
      
    }
    else if (input$Raza_primaria != "All" &
             input$Complejo_racial != "All" &
             input$Estado == "All" & 
             input$Proyecto != "All") {
      updateSelectInput(session, inputId = "Estado", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Estado[TableL$Complejo_racial %in% input$Complejo_racial &
                                                                                       TableL$Raza_primaria %in% input$Raza_primaria &
                                                                                       TableL$Proyecto %in% input$Proyecto])))))
      
      
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                                  TableL$Raza_primaria %in% input$Raza_primaria &
                                                  TableL$Proyecto %in% input$Proyecto]),
        min = min(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Raza_primaria %in% input$Raza_primaria &
                                              TableL$Proyecto %in% input$Proyecto]),
        max = max(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Raza_primaria %in% input$Raza_primaria &
                                              TableL$Proyecto %in% input$Proyecto])
      )
      
    }
    else  if (input$Raza_primaria == "All" &
              input$Complejo_racial != "All" &
              input$Estado == "All" & 
              input$Proyecto != "All") {
      updateSelectInput(session, inputId = "Raza_primaria", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Raza_primaria[TableL$Complejo_racial %in% input$Complejo_racial &
                                                                                              TableL$Proyecto %in% input$Proyecto])))))
      updateSelectInput(session, inputId = "Estado", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Estado[TableL$Complejo_racial %in% input$Complejo_racial &
                                                                                       TableL$Proyecto %in% input$Proyecto])))))
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                                  TableL$Proyecto %in% input$Proyecto]),
        min = min(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Proyecto %in% input$Proyecto]),
        max = max(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Proyecto %in% input$Proyecto])
      )
      
    }
    else if (input$Raza_primaria == "All" &
             input$Complejo_racial == "All" &
             input$Estado == "All" & input$Proyecto != "All") {
      updateSelectInput(session, inputId = "Complejo_racial", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Complejo_racial[TableL$Proyecto %in% input$Proyecto])))))
      updateSelectInput(session, inputId = "Raza_primaria", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Raza_primaria[TableL$Proyecto %in% input$Proyecto])))))
      updateSelectInput(session, inputId = "Estado", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Estado[TableL$Proyecto %in% input$Proyecto])))))
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Proyecto %in% input$Proyecto]),
        min = min(TableL$AltitudProfundidad[TableL$Proyecto %in% input$Proyecto]),
        max = max(TableL$AltitudProfundidad[TableL$Proyecto %in% input$Proyecto])
      )
      
    }
    else  if (input$Raza_primaria == "All" &
              input$Complejo_racial != "All" &
              input$Estado != "All" & 
              input$Proyecto != "All") {
      updateSelectInput(session, inputId = "Raza_primaria", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Raza_primaria[TableL$Complejo_racial %in% input$Complejo_racial &
                                                                                              TableL$Estado %in% input$Estado &
                                                                                              TableL$Proyecto %in% input$Proyecto])))))
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                                  TableL$Estado %in% input$Estado &
                                                  TableL$Proyecto %in% input$Proyecto]),
        min = min(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Estado %in% input$Estado &
                                              TableL$Proyecto %in% input$Proyecto]),
        max = max(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Estado %in% input$Estado &
                                              TableL$Proyecto %in% input$Proyecto])
      )
      
    }
    else if (input$Raza_primaria == "All" &
             input$Complejo_racial != "All" &
             input$Estado != "All" 
             & input$Proyecto == "All") {
      updateSelectInput(session, inputId = "Raza_primaria", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Raza_primaria[TableL$Complejo_racial %in% input$Complejo_racial &
                                                                                              TableL$Estado %in% input$Estado])))))
      updateSelectInput(session, inputId = "Proyecto", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Proyecto[TableL$Complejo_racial %in% input$Complejo_racial &
                                                                                         TableL$Estado %in% input$Estado])))))
      
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                                  TableL$Estado %in% input$Estado]),
        min = min(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Estado %in% input$Estado]),
        max = max(TableL$AltitudProfundidad[TableL$Complejo_racial %in% input$Complejo_racial &
                                              TableL$Estado %in% input$Estado])
      )
      
      
    }
    else if (input$Raza_primaria != "All" &
             input$Complejo_racial == "All" &
             input$Estado != "All" & 
             input$Proyecto == "All") {
      updateSelectInput(session, inputId = "Complejo_racial", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Complejo_racial[TableL$Raza_primaria %in% input$Raza_primaria &
                                                                                                TableL$Estado %in% input$Estado])))))
      
      updateSelectInput(session, inputId = "Proyecto", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Proyecto[TableL$Raza_primaria %in% input$Raza_primaria &
                                                                                         TableL$Estado %in% input$Estado])))))
      
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria &
                                                  TableL$Estado %in% input$Estado]),
        min = min(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria &
                                              TableL$Estado %in% input$Estado]),
        max = max(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria &
                                              TableL$Estado %in% input$Estado])
      )
    
    }
    else if (input$Raza_primaria != "All" &
             input$Complejo_racial == "All" &
             input$Estado == "All" & 
             input$Proyecto == "All") {
      updateSelectInput(session, inputId = "Complejo_racial", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Complejo_racial[TableL$Raza_primaria %in% input$Raza_primaria])))))
      updateSelectInput(session, inputId = "Estado", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Estado[TableL$Raza_primaria %in% input$Raza_primaria])))))
      updateSelectInput(session, inputId = "Proyecto", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Proyecto[TableL$Raza_primaria %in% input$Raza_primaria])))))
      
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria]),
        min = min(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria]),
        max = max(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria])
      )
 #     updateNumericInput(session,
 #                     inputId = "AltitudProfundidad",
 #                     min = min(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria]),
 #                     max = max(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria]))
 #     
           
    }
 else if (input$Raza_primaria != "All" &
          input$Complejo_racial == "All" &
          input$Estado == "All" & 
          input$Proyecto != "All") {
   updateSelectInput(session, inputId = "Complejo_racial", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Complejo_racial[TableL$Raza_primaria %in% input$Raza_primaria &
                                                                                                TableL$Proyecto %in% input$Proyecto])))))
      updateSelectInput(session, inputId = "Estado", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Estado[TableL$Raza_primaria %in% input$Raza_primaria &
                                                                                       TableL$Proyecto %in% input$Proyecto])))))
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria &
                                                  TableL$Proyecto %in% input$Proyecto]),
        min = min(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria &
                                              TableL$Proyecto %in% input$Proyecto]),
        max = max(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria &
                                              TableL$Proyecto %in% input$Proyecto])
      )
      
    }
 else if (input$Raza_primaria == "All" &
          input$Complejo_racial == "All" &
          input$Estado != "All" & 
          input$Proyecto != "All") {
   updateSelectInput(session, inputId = "Complejo_racial", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Complejo_racial[TableL$Estado %in% input$Estado &
                                                                                                TableL$Proyecto %in% input$Proyecto])))))
      updateSelectInput(session, inputId = "Raza_primaria", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Raza_primaria[TableL$Estado %in% input$Estado &
                                                                                              TableL$Proyecto %in% input$Proyecto])))))
      
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Estado %in% input$Estado &
                                                  TableL$Proyecto %in% input$Proyecto]),
        min = min(TableL$AltitudProfundidad[TableL$Estado %in% input$Estado &
                                              TableL$Proyecto %in% input$Proyecto]),
        max = max(TableL$AltitudProfundidad[TableL$Estado %in% input$Estado &
                                              TableL$Proyecto %in% input$Proyecto])
      )
      
    }
 else if (input$Raza_primaria != "All" &
          input$Complejo_racial == "All" &
          input$Estado != "All" & 
          input$Proyecto != "All") {
   updateSelectInput(session, inputId = "Complejo_racial", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Complejo_racial[TableL$Raza_primaria %in% input$Raza_primaria &
                                                                                                TableL$Estado %in% input$Estado &
                                                                                                TableL$Proyecto %in% input$Proyecto])))))
      
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria &
                                                  TableL$Estado %in% input$Estado &
                                                  TableL$Proyecto %in% input$Proyecto]),
        min = min(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria &
                                              TableL$Estado %in% input$Estado &
                                              TableL$Proyecto %in% input$Proyecto]),
        max = max(TableL$AltitudProfundidad[TableL$Raza_primaria %in% input$Raza_primaria &
                                              TableL$Estado %in% input$Estado &
                                              TableL$Proyecto %in% input$Proyecto])
      )
      
    }
 else if (input$Complejo_racial == "All" &
          input$Raza_primaria == "All" &
          input$Estado != "All" & 
          input$Proyecto == "All") {
   
      updateSelectInput(session, inputId = "Complejo_racial", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Complejo_racial[TableL$Estado %in% input$Estado])))))
      updateSelectInput(session, inputId = "Raza_primaria", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Raza_primaria[TableL$Estado %in% input$Estado])))))
      updateSelectInput(session, inputId = "Proyecto", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Proyecto[TableL$Estado %in% input$Estado])))))
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad[TableL$Estado %in% input$Estado]),
        min = min(TableL$AltitudProfundidad[TableL$Estado %in% input$Estado]),
        max = max(TableL$AltitudProfundidad[TableL$Estado %in% input$Estado])
      )
      
    }
 else if(input$Complejo_racial == "All" &
          input$Raza_primaria == "All" &
          input$Estado == "All" &
          input$Proyecto == "All") {
   
      updateSelectInput(session, inputId = "Complejo_racial", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Complejo_racial)))))
      updateSelectInput(session, inputId = "Raza_primaria", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Raza_primaria)))))
      updateSelectInput(session, inputId = "Estado", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Estado)))))
      updateSelectInput(session, inputId = "Proyecto", 
                        #label = "Especie:", 
                        choices = c("All" ,levels(droplevels(as.factor(TableL$Proyecto)))))
      updateNumericInput(
        session,
        inputId = "AltitudProfundidad",
        value = range(TableL$AltitudProfundidad),
        min = min(TableL$AltitudProfundidad),
        max = max(TableL$AltitudProfundidad)
      )
      }
 
   # else 
   # {
   #   selectInput(session, inputId = "Complejo_racial", 
   #               #label = "Estado:", 
   #               choices = c("All", levels(TableL$Complejo_racial)))
   #   selectInput(session, inputId = "Raza_primaria", 
   #               #label = "Estado:", 
   #               choices = c("All", levels(TableL$Raza_primaria)))
   #   selectInput(session, inputId = "Estado", 
   #               #label = "Estado:", 
   #               choices = c("All", levels(TableL$Estado)))
   #   selectInput(session, inputId = "Proyecto", 
   #               #label = "Estado:", 
   #               choices = c("All", levels(TableL$Proyecto)))
   #   
   #   numericInput(
   #     session,
   #     inputId = "AltitudProfundidad",
   #     value = range(TableL$AltitudProfundidad),
   #     min = min(TableL$AltitudProfundidad),
   #     max = max(TableL$AltitudProfundidad)
   #   )
   # }
 )
  
  #######
  
  
  #Ventana 1
  #### For the map in leaflet
  points <- reactive({
    #input$update
    #TableL <- TableL()
    TableL <- TableL[TableL$AltitudProfundidad >= input$AltitudProfundidad[1] & TableL$AltitudProfundidad <= input$AltitudProfundidad[2],] 
    
    if (input$Complejo_racial != "All") {
      TableL <- TableL[TableL$Complejo_racial %in% input$Complejo_racial,]
    } else TableL <- TableL
    
    if (input$Raza_primaria != "All") {
      #TableL <- TableL[TableL$Complejo_racial %in% input$Complejo_racial,]
      TableL <- TableL[TableL$Raza_primaria %in% input$Raza_primaria,]
    } else TableL <- TableL
    
    if (input$Proyecto != "All") {
      TableL <- TableL[TableL$Proyecto %in% input$Proyecto,]
    } else TableL <- TableL
    
    if (input$Estado != "All") {
      TableL <- TableL[TableL$Estado %in% input$Estado,]
    } else TableL <- TableL
    
 #   if (input$AltitudProfundidad != range(TableL$AltitudProfundidad)) {
 #     TableL <- TableL[TableL$AltitudProfundidad %in% input$AltitudProfundidad,]
 #   } else TableL <- TableL
    
    
  })
  
 
  #head(Parientes)
  #validateCoords(Parientes$longitude, Parientes$latitude, mode = c("point"))
  
  #P el mapa en leaflet
  output$mymap1 <- renderLeaflet(
    {
      
      Parientes2 <- Parientes[Parientes$Tipo %in% input$Tipo,]
      factpal <- colorFactor(c("red", "orange"), Parientes2$Tipo)
      
      Goldberg <- points()
      
      TT <- paste(Goldberg$Raza_primaria)
      leaflet() %>%
        addTiles() %>%
        addCircleMarkers(Goldberg$longitude, Goldberg$latitude, 
                         weight = 8, radius = 5, stroke = F, fillOpacity = 0.9, color = Goldberg$RatingCol,
                         popup = paste(sep = " ",
                                       "Complejo Racial:",Goldberg$Complejo_racial,"<br/>",
                                       "Raza Maiz:",Goldberg$Raza_primaria,"<br/>", 
                                       "Municipio:",Goldberg$Municipio, "<br/>",
                                       "Localidad:",Goldberg$Localidad, "<br/>",
                                       "Altitud:",Goldberg$AltitudProfundidad, "<br/>",
                                       "Periodo:",Goldberg$Periodo, "<br/>",
                                       "Proyecto:",Goldberg$Proyecto, "<br/>")) %>%
        
        
        addCircleMarkers(lng = Parientes2$longitude[!is.na(Parientes2$longitude)], 
                         lat = Parientes2$latitude[!is.na(Parientes2$latitude)], 
                         weight = 3, radius = 3, color = factpal(Parientes2$Tipo), opacity = 0.6,
                         popup = paste(sep = " ",
                                       "Taxa:",Parientes2$Taxa,"<br/>", 
                                       "Estado:",Parientes2$Estado, "<br/>",
                                       "Municipio:",Parientes2$Municipio, "<br/>",
                                       "Proyecto:",Parientes2$Fuente), group = "Parientes") %>%
        
        
        addProviderTiles("CartoDB.Positron")
      
    }) 
  
  
  observe({
    
    
    
    Parientes2 <- Parientes[Parientes$Tipo %in% input$Tipo,]
    factpal <- colorFactor(c("red", "orange"), Parientes2$Tipo)
    proxy1 <- leafletProxy("mymap1" ) %>%
      
      addCircleMarkers(lng = Parientes2$longitude[!is.na(Parientes2$longitude)], 
                       lat = Parientes2$latitude[!is.na(Parientes2$latitude)], 
                       weight = 3, radius = 3, color = factpal(Parientes2$Tipo), opacity = 0.6,
                       popup = paste(sep = " ",
                                     "Taxa:",Parientes2$Taxa,"<br/>", 
                                     "Estado:",Parientes2$Estado, "<br/>",
                                     "Municipio:",Parientes2$Municipio, "<br/>",
                                     "Proyecto:",Parientes2$Fuente), group = "Parientes"
      )
    
  })
  
  
  
  ############
  #Para ventana 2 Imagenes y Grafico cleveland Plot
  points1 <- reactive({
    TableLH <- TableL1c[TableL1c$Raza_Primaria %in% input$Raza_Primaria,]
  })
  
  #Para la imagen
  output$preImage <- renderImage(
    {
      inorg <- input$Raza_Primaria
      
      if (inorg == "Cónico") {
        inorg <- c("Conico")
      }else if (inorg == "Chalqueño") {
        inorg <- c("Chalqueno")
      }else if (inorg == "Cónico Norteño") {
        inorg <- c("Conico Norteno")
      }else if (inorg == "Elotes Cónicos") {
        inorg <- c("Elotes Conicos")
      }else if (inorg == "Mixeño") {
        inorg <- c("Mixeno")
      }else if (inorg == "Olotón") {
        inorg <- c("Oloton")
      }else if (inorg == "Onaveño") {
        inorg <- c("Onaveno")
      }else if (inorg == "Palomero Toluqueño") {
        inorg <- c("Palomero Toluqueno")
      }else if (inorg == "Quicheño") {
        inorg <- c("Quicheno")
      }else if (inorg == "Ratón") {
        inorg <- c("Raton")
      }else if (inorg == "Tuxpeño") {
        inorg <- c("Tuxpeno")
      }else if (inorg == "Tuxpeño Norteño") {
        inorg <- c("Tuxpeno Norteno")
      }else if (inorg == "Uruapeño") {
        inorg <- c("Uruapeno")
      }else if (inorg == "Vandeño") {
        inorg <- c("Vandeno")
      }else inorg <- inorg
      
      
      filename <- file.path('./www', paste(inorg, '.jpg', sep = ''))
      #Return a list containing the filename and alt text
      list(src = filename,
           # alt = paste("Raza de maíz", inorg))
           alt = inorg)
    }, deleteFile = FALSE)
  
  #Para el summary
  # Generate a summary of the dataset ----
  output$summary1 <- renderPrint({
    inorg <- input$Raza_Primaria
    Anexo7 <- Anexo6 %>%
      #drop_na() %>% 
      dplyr::filter(Raza_Primaria == inorg) %>%
      dplyr::select(Informacion1)
    
    Anexo7 <- toString(Anexo7$Informacion1)
    #Anexo7 <- sub('^.', Anexo7)
    Anexo7 <- substring(Anexo7,1)
    print(Anexo7, max.levels = 0, justify = c("right"), zero.print = "0")
    
  })
  #Para la gráfica
  
  output$plot11 <- renderPlot({
    newData <- points1()
    ### para la figura
    LL <- ggplot(newData) +
      geom_dumbbell(
        aes(
          x = Min,
          xend = Val1,
          y = reorder(Estado, Val1)
        ),
        colour = "#dddddd",
        size = 3,
        colour_x = "#dddddd",
        colour_xend = "#FF8C00",
        dot_guide = TRUE,
        dot_guide_size = 0.05
      ) +
      theme_light() +
      labs(
        title = "",
        x = "Registros",
        y = "",
        family = "Helvetica",
        size = 14
      ) +
      theme(
        legend.position = "",
        axis.text.x = element_text(angle = 0, size = 14),
        axis.text.y = element_text(size = 14, vjust = 1)
      )
    
    LL
    
  })
  #### Para la Altitud
  
  #Para la Altitud  
  Mex11 <- reactive({
    switch(input$var11,
           "promedio" = Mex7,
           "máximo" = Mex8,
           "mínimo" = Mex9)
  })
  
  ####
  output$graph2 <- renderPlot({
    LL <- Mex11()
    uno <- ggplot(LL) + 
      geom_dumbbell(aes(x = minimo, xend = maximo, y = reorder(Raza, ordenar1) ),
                    colour = "#dddddd",
                    size = 4,
                    colour_x = "#FFA07A",
                    colour_xend = "#FF4500",
                    dot_guide = F,
                    dot_guide_size = 0.01) +
                    #width = 4,
                    #position = position_dodge(3)) +
      geom_point(aes(x = prom, y = reorder(Raza, ordenar1)),
                 size = 5, 
                 colour = "#BDB76B") +
      theme_light() +
      theme(legend.position = "", 
            axis.text.x = element_text(angle = 0, size = 18, hjust = 0, vjust = 0),
            axis.text.y = element_text(size = 18), 
            #axis.title = element_text(size = 18), 
           # legend.text = element_text(size = 12),
         #  plot.margin = unit(c(.8,1,.8,1), "cm"),
            plot.title = element_text(size = 20, vjust = 6), 
            axis.title.x.bottom = element_text(size = 16),
           panel.spacing.y = unit(1, "lines")) +
      labs(title = "", x = "metros", 
           y = "", fill = "",
           family = "Helvetica") 
      #xlim(0, 4000) +
      #scale_y_discrete(guide = guide_axis(n.dodge = 1), expand = c(0, 6))
    # last_plot +
    #    transition_reveal(ordenar1)
    
    uno
  }, height = 1400, width = "auto"
  )
  
  
  #Para Tamaño de mazorca 
  Mex10 <- reactive({
    switch(input$var12,
           "promedio" = Size7,
           "máximo" = Size8,
           "mínimo" = Size9)
  })
  
  ####
  output$graph3 <- renderPlot({
    LL <- Mex10()
    uno <- ggplot(LL) + 
      geom_dumbbell(aes(x = minimo, xend = maximo, y = reorder(Raza, ordenar1) ),
                    colour = "#dddddd",
                    size = 4,
                    colour_x = "#808000",
                    colour_xend = "#FF6347",
                    dot_guide = TRUE,
                    dot_guide_size = 0.05) +
      geom_point(aes(x = prom, y = reorder(Raza, ordenar1)),
                 size = 5, 
                 colour = "#4682B4") +
      theme_light() +
      theme(legend.position = "", 
            axis.text.x = element_text(angle = 0, size = 18, hjust = 1, vjust = 0),
            axis.text.y = element_text(size = 18), 
            #axis.title = element_text(size = 18), 
           # legend.text = element_text(size = 12),
            #plot.title = element_text(size = 20),
            axis.title.x.bottom = element_text(size = 16)) +
      labs(title = "", x = "cm", 
           y = "", fill = "",
           family = "Helvetica") +
      xlim(0, 40) 
    # last_plot +
    #    transition_reveal(ordenar1)
    
    uno
  }, height = 1400, width = "auto"
  )
  
  
  ###########
  #Ventana 2.1 Sankey Plot
  
  points2 <- reactive({
    
    if (input$Estados != "All") {
      TableL2 <- TableL2[TableL2$Estado %in% input$Estados,]
    }else TableL2 <- TableL2
    
  })
  
  Richard1 <- reactive({
    TableL22 <- points2()
    
    
    TableLJJ <- aggregate(TableL22$Val1 ~ TableL22$Raza_primaria + TableL22$Estado , FUN = sum, na.rm = T)
    TableLJJF <- aggregate(TableL22$Val1 ~ TableL22$Raza_primaria + TableL22$Complejo_racial, FUN = sum, na.rm = T)
    
    #TableL1b <- aggregate(TableL1[,17], by = list(Raza_Primaria,Estado), FUN = sum, na.rm = T)
    head(TableLJJ)
    names(TableLJJ)[1] <- c("origin")
    names(TableLJJ)[2] <- c("visit")
    names(TableLJJ)[3] <- c("Val1")
    head(TableLJJF)
    names(TableLJJF)[2] <- c("origin")
    names(TableLJJF)[1] <- c("visit")
    names(TableLJJF)[3] <- c("Val1")
    #detach(TableL22)
    
    Katcha <- rbind(TableLJJ,TableLJJF)
  })
  
  
  
  #P hacer la figura
  output$Sankeyplot1 <- renderGvis({
    
    Feynmann1 <- Richard1()
    
    LL34 <- gvisSankey(Feynmann1, from = "origin", to = "visit", weight = "Val1",
                       options = list(height = 950, width = 950,
                                      sankey = "{
                                      link:{color:{fill: 'red', fillOpacity: 0.9}},
                                      node:{nodePadding: 7, 
                                      label:{fontSize: 11}, 
                                      interactivity: true, width: 90},
                                                }"
                       ), chartid = "Sankey"
    )
    
    return(LL34)
    
  })
  
  
})