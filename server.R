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
  

  observeEvent(
    input$Complejo_racial,  if (input$Complejo_racial != "All") {
      updateSelectInput(session, inputId = "Raza_primaria", label = "Raza Primaria:", 
                        choice = c("All" ,levels(droplevels(TableL$Raza_primaria[TableL$Complejo_racial %in% input$Complejo_racial]))))
      # toggle("hideme") 
    } else updateSelectInput(session, inputId = "Raza_primaria", label = "Raza Primaria:", 
                             choice = c("All", levels(TableL$Raza_primaria[TableL$Complejo_racial %in% input$Complejo_racial]))))
  

  #Ventana 1
  #### For the map in leaflet
  points <- reactive({
    #input$update
    #TableL <- TableL()
 
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
      dplyr::filter(Raza_Primaria == inorg) %>%
      dplyr::select(Informacion1)
    
    
    print(Anexo7[1,], max.levels = 0, justify = c("right"), zero.print = ".")
   
  })
  #Para la gráfica
  
  output$plot11 <- renderPlotly({
    newData <- points1()
    ### para la figura
    LL <- ggplot(newData, aes(x = Val1, y = reorder(Estado, Val1)), size = 0.2) +
      # use a larger dot
      geom_segment(aes(yend = Estado, xend = 0)) +
      # plot the n points and color them
      geom_point(size = 3, color = "red", shape = 15) +
      labs(title = "", x = "No. Registros", y = "Estados")
      LL <- LL + theme(axis.text.x = element_blank(),axis.ticks = element_blank(),
                     panel.grid.minor.x = element_blank(),
                     panel.grid.major.x = element_blank(),
                     axis.title = element_text(size = 14,face = "bold")) +
      theme(legend.title = element_blank())
    
    gg <- plotly::ggplotly(LL)
    gg
    
  })
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
                                      node:{nodePadding: 4, 
                                      label:{fontSize: 10}, 
                                      interactivity: true, width: 70},
                                                }"
                                      ), chartid = "Sankey"
                      )
    
    return(LL34)
    
  })
  
  
})
