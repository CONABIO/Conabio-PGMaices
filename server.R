library(shiny)
library(leaflet)
library(RColorBrewer)
library(dplyr)
library(knitr)
library(vcd)
library(grid)
library(plotly)
library(ggplot2)
library(googleVis)
library(igraph)
#library(rCharts)
#runGist(4642963)

#library(ggplot2movies)

#shiny::runApp(system.file("shiny/", package = "googleVis"))

# Define server logic for slider examples
shinyServer(function(input, output) {
  
  
  #Para ventana 00
  
#  points2 <- reactive({
#    TableLH <- TableL1c[TableL1c$Raza_Primaria %in% input$Raza_Primaria,]
#  })
  
 # output$preImage1 <- renderImage({
    
  #  inorg1 <- input$Raza_Primaria
    ##TableLH <- TableL[TableL$Raza_primaria %in% input$Raza_primaria,]
  #  filename <- normalizePath(file.path('./www',
  #                                      paste(inorg1, '.jpg', sep = '')))
  #  #Return a list containing the filename and alt text
  #  list(src = filename,
  #       alt = paste("Raza de maíz", inorg1))
  #}, deleteFile = FALSE)
  
  
  
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
    #TTT <- c(brewer.pal(8,"Dark2"),brewer.pal(10,"Paired"),brewer.pal(9,"Set1"),
    #         brewer.pal(10,"Set3"),brewer.pal(10,"Spectral"),brewer.pal(10,"PiYG"),brewer.pal(7,"BrBG"))
    TTT <- c(brewer.pal(8,"Dark2"))
    
    
    #DDD <- TTT[as.numeric(TableL$Raza_primaria)]
    #head(TableL$Raza_primaria)
    #head(DDD)
    #TTT <- colorNumeric(c(1:64), levels(TableL$Raza_primaria))
    Goldberg <- points()
    TT <- paste(Goldberg$Raza_primaria)
    leaflet(data = Goldberg) %>%
      clearShapes() %>%
      addTiles() %>%
      clearBounds() %>%  
      #addLayersControl(overlayGroups = c(TT),options = layersControlOptions(collapsed = T))%>%
      addCircleMarkers(Goldberg$longitude, Goldberg$latitude, 
                       weight = 8, radius = 4, stroke = F, fillOpacity = 0.9, color = sample(TTT,1),
                       clusterOptions = markerClusterOptions(showCoverageOnHover = T, 
                                                             spiderfyOnMaxZoom = T,
                                                             zoomToBoundsOnClick = T,
                                                             spiderfyDistanceMultiplier = 2), 
                       popup = paste(sep = " ","Complejo Racial:",Goldberg$Complejo_racial,"<br/>","Raza Maiz:",Goldberg$Raza_primaria,"<br/>", "Municipio:",Goldberg$Municipio, "<br/>","Localidad:",Goldberg$Localidad)) %>%
      addMeasure(primaryLengthUnit = "kilometers", primaryAreaUnit = "hectares",activeColor = '#FF00FF') %>%
      #addProviderTiles("Esri.WorldTopoMap")
      addProviderTiles("OpenStreetMap.DE")
  })
  
  ## display a palettes simultanoeusly
 
  
  #Para ventana 2 Imagenes y Grafico cleveland Plot
  
  points1 <- reactive({
      TableLH <- TableL1c[TableL1c$Raza_Primaria %in% input$Raza_Primaria,]
  })

  output$preImage <- renderImage({
    inorg <- input$Raza_Primaria
    TableLH <- TableL[TableL1c$Raza_Primaria %in% input$Raza_Primaria,]
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
  ###########
  #Ventana 2.1 Sankey Plot
  
  points2 <- reactive({
 
       #input$update
  #  if (input$Raza_primarias != "All") {
  #    TableL2 <- TableL2[TableL2$Raza_primaria %in% input$Raza_primarias,]
  #  }else TableL2 <- TableL2
    
  # if (input$Complejo_racials != "All") {
  #    TableL2 <- TableL2[TableL2$Complejo_racial %in% input$Complejo_racials,]
  #  }else TableL2 <- TableL2
    
    if (input$Estados != "All") {
      TableL2 <- TableL2[TableL2$Estado %in% input$Estados,]
    }else TableL2 <- TableL2
    
  })
  
  Richard1 <- reactive({
    TableL22 <- points2()
    
    attach(TableL22)
    TableLJJ <- aggregate(Val1 ~ Complejo_racial + Estado , FUN = sum, na.rm = T)
    TableLJJF <- aggregate(Val1 ~ Complejo_racial + Raza_primaria, FUN = sum, na.rm = T)
    
    #TableL1b <- aggregate(TableL1[,17], by = list(Raza_Primaria,Estado), FUN = sum, na.rm = T)
    head(TableLJJ)
    names(TableLJJ)[1] <- c("origin")
    names(TableLJJ)[2] <- c("visit")
    names(TableLJJ)[3] <- c("Val1")
    head(TableLJJF)
    names(TableLJJF)[2] <- c("origin")
    names(TableLJJF)[1] <- c("visit")
    names(TableLJJF)[3] <- c("Val1")
    detach(TableL22)
    
    Katcha <- rbind(TableLJJ,TableLJJF)
  })
  
  
  
  #P hacer la figura
  output$Sankeyplot1 <- renderGvis({
    
    Feynmann1 <- Richard1()
    
    LL34 <- gvisSankey(Feynmann1, from = "origin", to = "visit", weight = "Val1",
                       options = list(height = 950, width = 850,
                                      sankey = "{
                                      link:{color:{fill: 'red', fillOpacity: 0.9}},
                                      node:{nodePadding: 7, 
                                      label:{fontSize: 10}, 
                                      interactivity: true, width: 40},
                                                }"
                                      ), chartid = "Sankey"
                      )
    
    #output$sankeyplot <- renderGvis({ gvisSankey(sankeydata(), from = "source", to = "target",
    #                                            weight = "value", options = list( width = 1200, height = 600, 
    #                                        sankey = "{
    #                                        link: {color: { fill: 'grey100' } }, 
    #                                        node: { width: 40, color: { fill: '#a61d4c' },
    #                                        label: { fontName: 'Calibri', fontSize: 12, 
    #                                        color: '#871b47'} }}" ), chartid = "Sankey" )})
    
    #plot(LL34)
    return(LL34)
    
  })
  
  
  
  #############
  #Para Ventana 3 Para el mosaicplot
  points3 <- reactive({
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
    NewData <- points3()
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
