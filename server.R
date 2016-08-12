library(shiny)
library(leaflet)
library(RColorBrewer)
library(dplyr)
library(knitr)
library(vcd)
library(grid)
library(plotly)
library(ggplot2)
library(ggplot2movies)


# Define server logic for slider examples
shinyServer(function(input, output) {
  
  #Ventana 1
  #### For the map in leaflet
  points <- reactive({
    #input$update
    #TableL <- TableL()
    if (input$Raza_primaria != "All") {
      TableL <- TableL[TableL$Raza_primaria %in% input$Raza_primaria,]
    }else TableL <- TableL
    
    if (input$Complejo_racial != "All") {
      TableL <- TableL[TableL$Complejo_racial %in% input$Complejo_racial,]
    }else TableL <- TableL
    
    if (input$Estado != "All") {
      TableL <- TableL[TableL$Estado %in% input$Estado,]
    }else TableL <- TableL
    
   # if (input$Periodo_Colecta != "All") {
      TableL <- TableL[TableL$Periodo_Colecta %in% input$Periodo_Colecta,]
    #}else TableL <- TableL
  })
  
  
  #Para la tabla en csv 
  output$downloadData <- downloadHandler(
    filename = function() { paste("Tabla", '.csv', sep = '') },
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
      clearBounds() %>%  
      #addLayersControl(overlayGroups = c(TT),options = layersControlOptions(collapsed = T))%>%
      addCircleMarkers(Goldberg$longitude, Goldberg$latitude, weight = 4, radius = 7, 
                       stroke = F, fillOpacity = 0.8, color = TTT[1],
                       clusterOptions = markerClusterOptions(showCoverageOnHover = TRUE, spiderfyOnMaxZoom = T,zoomToBoundsOnClick = T), 
                       popup = paste(sep = " ","Complejo Racial:",Goldberg$Complejo_racial,"<br/>","Raza Maiz:",Goldberg$Raza_primaria,"<br/>", "Municipio:",Goldberg$Municipio, "<br/>","Localidad:",Goldberg$Localidad)) %>%
      addMeasure(primaryLengthUnit = "kilometers", primaryAreaUnit = "hectares",activeColor = '#FF00FF') %>%
      #addProviderTiles("Esri.WorldTopoMap")
      addProviderTiles("OpenStreetMap.DE")
  })
  
  #Para ventana 2
  
  points1 <- reactive({
      TableLH <- TableL1c[TableL1c$Raza_Primaria %in% input$Raza_Primaria,]
  })

  output$preImage <- renderImage({
    inorg <- input$Raza_Primaria
    TableLH <- TableL[TableL$Raza_primaria %in% input$Raza_primaria,]
    filename <- normalizePath(file.path('./www',
                              paste(inorg, '.jpg', sep = '')))
    #Return a list containing the filename and alt text
    list(src = filename,
         alt = paste("Raza de maíz", input$Raza_Primaria))
  }, deleteFile = FALSE)
  
  
  output$plot11 <- renderPlotly({
    #newData<-TablaVal
    newData <- points1()
    ### para la figura
    #names(newData)
    LL <- ggplot(newData, aes(x = Val1, y = reorder(Estado, Val1)), size = 0.2) +
      # use a larger dot
      geom_segment(aes(yend = Estado, xend = 0)) +
      # plot the n points and color them
      geom_point(size = 1, color = "red") +
      labs(title = "", x = "Frecuencia", y = "Estados")
      #theme_bw() +
      #coord_flip()
    LL <- LL + theme(axis.text.x = element_blank(),axis.ticks = element_blank(),
                     #panel.grid.minor. = element_blank(),
                     #panel.grid.major = element_line(colour = "black", linetype = "dotted"),
                     panel.grid.minor.x = element_blank(),
                     panel.grid.major.x = element_blank(),
                     axis.title = element_text(size = 14,face = "bold")) +
      theme(legend.title = element_blank())
    
    #LL
    #LL+geom_text(aes(label=newData$Mountain), 
    #                    color="gray20", size=1)
    gg <- ggplotly(LL)
    gg
    
  })
  
  
  #Para Ventana 3
  points2 <- reactive({
    #maizemat<-maizemat[maizemat$Raza %in% input$Razas, ]
    TableLL1 <- TableLL[TableLL$Complejo_racial %in% input$Complejo_racials,]
    TableLL2 <- TableLL1[TableL$Periodo_Colecta %in% input$Periodo_Colectas,]
  })
  
  #Es un comprobador de resultados
  #output$TablaF <- renderTable(
  #  print(as.data.frame(Tabla4())))
  
  
  #Para el mosaicplot
  output$Plot12 <- renderPlot({
    #NewData <- Tabla4()
    NewData <- points2()
    attach(NewData)
    Tabla3 <- xtabs(Val1 ~ Estado + Raza_primaria)
    detach(NewData)
    Tabla4 <- Tabla3[apply(Tabla3,1,sum) > 0,apply(Tabla3,2,sum) > 0]
    #Tabla3 <- xtabs(NewData$Val1 ~ NewData$Raza_primaria + NewData$Complejo_racial)
    #Tabla4 <- Tabla3[apply(Tabla3,1,sum) > 0,apply(Tabla3,2,sum) > 0]    
        assoc(Tabla4, gp = shading_hsv, 
           labeling_args = list(rot_labels = c(left = 0, top = 45, bottom = 0,right = 0),
           abbreviate = c(variable = TRUE)), zero_size = 0, main = "")
    
    ####################
    
  })
  
  
})
