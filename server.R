library(shiny)
library(leaflet)
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
#library(dicromat)

# Define server logic for slider examples
shinyServer(function(input, output, session) {
  
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
   
    if (input$Complejo_racial != "All") {
      TableL <- TableL[TableL$Complejo_racial %in% input$Complejo_racial,]
    } else TableL <- TableL
    
 #    if (input$Raza_primaria != "All") {
#      TableL <- TableL[TableL$Raza_primaria %in% input$Raza_primaria,]
#    }else TableL <- TableL
    
    
      if (input$Proyecto != "All") {
        TableL <- TableL[TableL$Proyecto %in% input$Proyecto,]
      }else TableL <- TableL
    
    if (input$Estado != "All") {
      TableL <- TableL[TableL$Estado %in% input$Estado,]
    }else TableL <- TableL
    
    
  })
 

  
  
  #P el mapa en leaflet
  output$mymap1 <- renderLeaflet(
    {
    #TTT <- c(brewer.pal(8,"Dark2"),brewer.pal(10,"Paired"),brewer.pal(9,"Set1"),
    #         brewer.pal(10,"Set3"),brewer.pal(10,"Spectral"),brewer.pal(10,"PiYG"),brewer.pal(7,"BrBG"))
    TTT <- c(brewer.pal(8,"Dark2"))
    

 #   acm_defaults <- function(mymap1, x, y) addCircleMarkers(mymap1, x, y, radius = 6, 
#                    color = "black", fillColor = "orange", fillOpacity = 1, opacity = 1, 
#                    weight = 2, stroke = TRUE, layerId = "Selected")
    
    #DDD <- TTT[as.numeric(TableL$Raza_primaria)]
    #head(TableL$Raza_primaria)
    #head(DDD)
    #TTT <- colorNumeric(c(1:64), levels(TableL$Raza_primaria))
    Goldberg <- points()
    
    #Trip2 <- points2()
    TT <- paste(Goldberg$Raza_primaria)
    leaflet() %>%
      #clearShapes() %>%
      addTiles() %>%
      #clearBounds() %>%  
      addCircleMarkers(Goldberg$longitude, Goldberg$latitude, 
                       weight = 8, radius = 5, stroke = F, fillOpacity = 0.9, color = sample(TTT,1),
                       clusterOptions = markerClusterOptions(showCoverageOnHover = T, 
                                                             spiderfyOnMaxZoom = T,
                                                             zoomToBoundsOnClick = T,
                                                             spiderfyDistanceMultiplier = 2), 
                      popup = paste(sep = " ",
                                     "Complejo Racial:",Goldberg$Complejo_racial,"<br/>",
                                     "Raza Maiz:",Goldberg$Raza_primaria,"<br/>", 
                                     "Municipio:",Goldberg$Municipio, "<br/>",
                                     "Localidad:",Goldberg$Localidad, "<br/>",
                                     "Periodo:",Goldberg$Periodo, "<br/>",
                                     "Proyecto:",Goldberg$Proyecto, "<br/>")) %>%
  
 #   addCircleMarkers(Parientes2$longitude[!is.na(Parientes2$longitude)], 
  #    Parientes2$latitude[!is.na(Parientes2$latitude)], 
  #    weight = 3, radius = 2, color = '#9D7', opacity = 1,
  #    popup = paste(sep = " ",
  #                "Taxa:",Parientes2$Taxa,"<br/>", 
  #                "Municipio:",Parientes2$Municipio, "<br/>",
  #                "Proyecto:",Parientes2$Fuente)) %>%
      
      addProviderTiles("CartoDB.Positron")
    
  })
 
  observe({
    
    #Parientes2 <- points1()
    Parientes2 <- Parientes[Parientes$Tipo %in% input$Tipo,]
    factpal <- colorFactor(c("red", "orange"), Parientes2$Tipo)
    proxy1 <- leafletProxy("mymap1") %>%
      clearMarkers() %>%
      #proxy1 %>%
        #Parientes2 <- points1()
        #Teo1 == Teocintle
    addCircleMarkers(Parientes2$longitude[!is.na(Parientes2$longitude)], 
                     Parientes2$latitude[!is.na(Parientes2$latitude)], 
                     weight = 3, radius = 3, color = factpal(Parientes2$Tipo), opacity = 0.6,
                     popup = paste(sep = " ",
                                   "Taxa:",Parientes2$Taxa,"<br/>", 
                                   "Estado:",Parientes2$Estado, "<br/>",
                                   "Municipio:",Parientes2$Municipio, "<br/>",
                                   "Proyecto:",Parientes2$Fuente))
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
    
    
    #TableLH <- TableL[TableL1c$Raza_Primaria %in% input$Raza_Primaria,]
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
      dplyr::filter(Raza_Primaria == inorg) %>%
      dplyr::select(Informacion1)
    
    
    print(Anexo7[1,], max.levels = 0, justify = c("right"), zero.print = ".")
    #dataset <- datasetInput()
    #summary(dataset)
  })
  #Para la gráfica
  
  output$plot11 <- renderPlotly({
    #newData<-TablaVal
    newData <- points1()
    ### para la figura
    #names(newData)
    LL <- ggplot(newData, aes(x = Val1, y = reorder(Estado, Val1)), size = 0.2) +
      # use a larger dot
      geom_segment(aes(yend = Estado, xend = 0)) +
      # plot the n points and color them
      geom_point(size = 3, color = "red", shape = 15) +
      labs(title = "", x = "No. Registros", y = "Estados")
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
    gg <- plotly::ggplotly(LL)
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
    
    
    #attach(TableL22)
    #TableLJJ <- aggregate(Val1 ~ Complejo_racial + Estado , FUN = sum, na.rm = T)
    #TableLJJF <- aggregate(Val1 ~ Complejo_racial + Raza_primaria, FUN = sum, na.rm = T)
    
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
                                      node:{nodePadding: 4, 
                                      label:{fontSize: 10}, 
                                      interactivity: true, width: 70},
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
  
  
})
