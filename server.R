library(shiny)
library(leaflet)
library(tidyverse)
library(RColorBrewer)
#library(dplyr)
library(knitr)
library(vcd)
library(grid)
library(plotly)
library(ggplot2)
library(googleVis)
library(igraph)
library(scales)
library(DT)
#library(dicromat)

# Define server logic for slider examples
shinyServer(
  function(input, output, session) {
  

  #Ventana 1
  #### For the map in leaflet
  points <- reactive({
    #input$update
    #Tabla2 <- Tabla2()
   
    if (input$Sex != "All") {
      Tabla2 <- Tabla2[Tabla2$Sex %in% input$Sex,]
    } else Tabla2 <- Tabla2
    
    Tabla2 <- Tabla2[c(Tabla2$Age >= input$Age[1] & Tabla2$Age <= input$Age[2]),]
    
    if (input$County != "All") {
      Tabla2 <- Tabla2[Tabla2$County %in% input$County,]
    }else Tabla2 <- Tabla2
    
     if (input$Surface_management != "All") {
      Tabla2 <- Tabla2[Tabla2$Surface_management %in% input$Surface_management,]
    }else Tabla2 <- Tabla2
    
      if (input$Corridor != "All") {
        Tabla2 <- Tabla2[Tabla2$Corridor %in% input$Corridor,]
      }else Tabla2 <- Tabla2
    
    if (input$Cause_of_death != "All") {
      Tabla2 <- Tabla2[Tabla2$Cause_of_death %in% input$Cause_of_death,]
    }else Tabla2 <- Tabla2
    
  })
 
  #Para la tabla en csv 
  output$downloadData <- downloadHandler(
    filename = function() { paste("Tabla", '.csv', sep = '') },
    content = function(file) {
      write.csv(points(), file)
    }
  )
  
  
  #P el mapa en leaflet
  output$mymap1 <- renderLeaflet(
    {
      Goldberg <- points()
      
        
      Goldberg$ratingcol <- ifelse(Goldberg$Cause_of_death == "Asphyxia", "#F7FCF0",
                             ifelse(Goldberg$Cause_of_death == "Blunt Force Injury", "#E0F3DB",
                              ifelse(Goldberg$Cause_of_death == "Diabetes", "#CCEBC5",
                               ifelse(Goldberg$Cause_of_death == "Drowning", "#A8DDB5",
                                ifelse(Goldberg$Cause_of_death == "Drug Overdose", "#7BCCC4",
                                 ifelse(Goldberg$Cause_of_death == "Exposure", "#D53E4F",
                                  ifelse(Goldberg$Cause_of_death == "Exsanguination", "#2B8CBE",
                                   ifelse(Goldberg$Cause_of_death == "Gunshot Wound", "#0868AC",
                                    ifelse(Goldberg$Cause_of_death == "Heart Disease", "#084081",
                                     ifelse(Goldberg$Cause_of_death == "Lightning Strike", "#9E0142",
                            ifelse(Goldberg$Cause_of_death == "Motor Vehicle Accident", "#4EB3D3",
                             ifelse(Goldberg$Cause_of_death == "Nonviable Fetus", "#F46D43",
                              ifelse(Goldberg$Cause_of_death == "Not_Reported", "#FDAE61",
                               ifelse(Goldberg$Cause_of_death == "Other Injury", "#FEE08B",
                                 ifelse(Goldberg$Cause_of_death == "Other Disease", "#FFFFBF",
                                  ifelse(Goldberg$Cause_of_death == "Other Injury / Homicide", "#E6F598",
                                   ifelse(Goldberg$Cause_of_death == "Pending", "#ABDDA4",
                                    ifelse(Goldberg$Cause_of_death == "Pregnancy Complication", "#66C2A5",
                                     ifelse(Goldberg$Cause_of_death == "Skeletal Remains", "#1B9E77",
                                      ifelse(Goldberg$Cause_of_death == "Undetermined", "#5E4FA2", "black")))))))))))))))))))) 
                                                                                                                      
      
     
    
    leaflet() %>%
      addTiles() %>%
      #clearBounds() %>%  
      addCircleMarkers(Goldberg$lng, Goldberg$lat, 
                       radius = 5, stroke = F, fillOpacity = 0.9, color = Goldberg$ratingcol,
                       #clusterOptions = markerClusterOptions(showCoverageOnHover = T, 
                      #                                       spiderfyOnMaxZoom = T,
                      #                                       zoomToBoundsOnClick = T,
                      #                                       spiderfyDistanceMultiplier = 2), 
                      popup = paste(sep = " ",
                                     "Sex:",Goldberg$Sex,"<br/>",
                                     "Age:",Goldberg$Age,"<br/>", 
                                     "Surface Management:",Goldberg$Surface_management, "<br/>",
                                     "Corridor:",Goldberg$Corridor, "<br/>",
                                     "Cause of Death:",Goldberg$Cause_of_death, "<br/>",
                                     "Estado:",Goldberg$State, "<br/>")) %>%
  
      
      addProviderTiles("CartoDB.Positron")
    
  })

  
  points11 <- reactive({
#    #input$update
#    #Tabla2 <- Tabla2()
    if (input$Variable11 == "Age") {
    Tabla2 <- data.frame(Tabla2.1[Tabla2.1$Age < 98,c(4,7,14)])
    }else TablaLL <- data.frame(Tabla2.1[, c(input$Variable11)], Tabla2.1[,c(7,14)])
    
    #TablaLL <- data.frame(Tabla2.1[, c(input$Variable11)], Tabla2.1[,c(7,14)])
    #names(TablaLL)[1] <- c("variable")
  })
    
  ############

    output$plot11 <- renderPlotly({
    
    TablaLL1 <- points11()
   ggBar <- ggplot(TablaLL1 ) +
      geom_bar(aes(x = reorder(TablaLL1[,1], TablaLL1[,3]), y = TablaLL1[,3], fill = TablaLL1[,2]), stat = "identity") +
      coord_flip() +
     labs(title = "", x = "", y = "Total number") +
     guides(fill = guide_legend(title = "Cause of death"))
      theme_bw()
    
    ggBar
    
    #LL+geom_text(aes(label=newData$Mountain), 
    #                    color="gray20", size=1)
    gg <- ggplotly(ggBar)
    gg
    
  })

})
