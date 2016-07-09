library(shiny)
library(leaflet)
library(RColorBrewer)
library(dplyr)
library(knitr)

# Define server logic for slider examples
shinyServer(function(input, output) {
  
  #### For the map in leaflet
  points <- reactive({
    #input$update
    #TableL <- TableL()
    if (input$Raza_primaria!="All"){
      TableL<-TableL[TableL$Raza_primaria %in% input$Raza_primaria,]
    }else TableL <- TableL
    
    if (input$Complejo_racial!="All"){
      TableL<-TableL[TableL$Complejo_racial %in% input$Complejo_racial,]
    }else TableL <- TableL
    
    if (input$Estado!="All"){
      TableL<-TableL[TableL$Estado %in% input$Estado,]
    }else TableL <- TableL
    
    if(input$Periodo_Colecta!="All"){
      TableL <- TableL[TableL$Periodo_Colecta %in% input$Periodo_Colecta,]
    }else TableL <- TableL
    
  })
  
  
  #Para la tabla en csv 
  output$downloadData <- downloadHandler(
    filename = function() { paste("Tabla", '.csv', sep='') },
    content = function(file) {
      write.csv(points(), file)
    }
  )

  
  #P el mapa en leaflet
      output$mymap <- renderLeaflet({
       TTT <- sample(brewer.pal(8,"Dark2"),1)
        Goldberg <- points()
        TT <- paste(Goldberg$Raza_primaria)
        leaflet(data = Goldberg) %>%
        clearShapes() %>%
        addTiles() %>%
        clearBounds()%>%  
        #addLayersControl(overlayGroups = c(TT),options = layersControlOptions(collapsed = T))%>%
        addCircleMarkers(Goldberg$longitude, Goldberg$latitude, weight = 4, radius = 7, stroke = F, fillOpacity = 0.8, color=TTT[1],clusterOptions = markerClusterOptions(showCoverageOnHover = TRUE, spiderfyOnMaxZoom = T,zoomToBoundsOnClick = T), popup =paste(sep = " ","Raza Maiz=",Goldberg$Raza_primaria, ", Municipio=",Goldberg$Municipio, ". Localidad=",Goldberg$Localidad))%>%
        addMeasure(primaryLengthUnit = "kilometers", primaryAreaUnit = "hectares",activeColor = '#FF00FF')%>%
        #addProviderTiles("Esri.WorldTopoMap")
        addProviderTiles("OpenStreetMap.DE")
    })
})
