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
# library(googleVis)  # ya no se usa: el Sankey pasó a D3 (www/js/sankey-maiz.js)
library(igraph)
library(scales)
# library(ggalt)  # archivado en CRAN; sus geom_dumbbell() se sustituyen (ver Parte B)
library(ggiraph)       # SVG interactivo (hover, tooltip, barra de herramientas)
library(ggrepel)       # separa los nombres que se encimarían
library(shinyWidgets)  # pickerInput de los selectores de altitud
library(datamods)      # filtros cruzados del mapa (select_group_*)
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
  
  
  # ---- Filtros del mapa ------------------------------------------------------
  # Aquí vivía un observeEvent de 450 líneas que cruzaba a mano los cuatro filtros
  # (complejo, raza, estado, proyecto): una rama por cada una de las 15 combinaciones
  # posibles, cada una repitiendo los mismos updateSelectInput. Todo eso lo hace
  # datamods en dos llamadas, y crece solo si mañana se agrega un quinto filtro.
  #
  # Cambio de comportamiento: antes cada filtro tenía una opción literal "All".
  # Ahora se deja VACÍO para no filtrar, y se pueden elegir varios valores a la vez
  # en el mismo filtro.
  puntos_filtrados <- select_group_server(
    id     = "filtros_mapa",
    data_r = reactive(TableL),
    vars_r = reactive(c("Complejo_racial", "Raza_primaria", "Estado", "Proyecto"))
  )

  #Ventana 1
  #### For the map in leaflet
  # El deslizador de altitud va ENCIMA de los filtros de datamods, que sólo maneja
  # columnas categóricas. No hace falta la guarda de los NA que lleva la app de
  # frijol: en maíz los 21,408 registros traen altitud, así que no hay ninguno que
  # una comparación pueda descartar en silencio.
  points <- reactive({
    d <- puntos_filtrados()
    r <- input$AltitudProfundidad
    if (is.null(r)) return(d)
    d[d$AltitudProfundidad >= r[1] & d$AltitudProfundidad <= r[2], ]
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
        # El fondo gris de Esri viene en DOS capas y las dos van en el grupo "Mapa"
        # para que se prendan y apaguen juntas: la base pone colores, relieve y agua,
        # pero NO rotula; los nombres de ciudades viven en World_Light_Gray_Reference
        # y hay que montarla encima a mano. Sin ella el mapa queda mudo.
        #
        # maxNativeZoom = 16 no es opcional: las teselas de Esri se acaban en z16 y
        # sin él el fondo se queda EN BLANCO al pasar de ahí. Con él, leaflet estira
        # la tesela de z16 —se ve borrosa, pero se ve—, y para el detalle real está
        # la capa de "Foto aérea", que baja bastante más.
        #
        # Antes esto era CartoDB.Positron, hasta que CARTO empezó a estampar la marca
        # "API KEY REQUIRED" dentro del PNG de sus teselas gratuitas. Es un fallo
        # traicionero: la tesela responde HTTP 200 y es una imagen válida, así que no
        # hay error que capturar ni en la consola ni en el log; la única señal es la
        # leyenda atravesada en el fondo. En local puede verse limpio por caché, así
        # que para comprobarlo hay que abrir el mapa en ventana de incógnito.
        addProviderTiles(
          providers$Esri.WorldGrayCanvas, group = "Mapa",
          options = providerTileOptions(maxNativeZoom = 16, maxZoom = 19)) %>%
        addTiles(
          urlTemplate = paste0("https://server.arcgisonline.com/ArcGIS/rest/",
                               "services/Canvas/World_Light_Gray_Reference/",
                               "MapServer/tile/{z}/{y}/{x}"),
          group = "Mapa",
          options = tileOptions(maxNativeZoom = 16, maxZoom = 19),
          attribution = "Tiles &copy; Esri &mdash; Esri, DeLorme, NAVTEQ") %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "Foto aérea") %>%
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
        # "Mapa" y "Foto aérea" son excluyentes (baseGroups); "Parientes" se puede
        # apagar sin tocar el fondo (overlayGroups).
        addLayersControl(
          baseGroups = c("Mapa", "Foto aérea"),
          overlayGroups = "Parientes",
          options = layersControlOptions(collapsed = TRUE))
      
    }) 
  
  
  # Aquí vivía un observe() con leafletProxy que volvía a añadir los parientes
  # silvestres al mapa. Era redundante y dañino: renderLeaflet ya depende de
  # input$Tipo, así que al marcar una casilla el mapa se reconstruye entero CON
  # los parientes, y el proxy los dibujaba encima una segunda vez (828 círculos
  # para los 414 registros de Tripsacum, con sus popups duplicados). Además se
  # disparaba al arrancar, antes de que el mapa existiera, de ahí el mensaje
  # "Couldn't find map with id mymap1" en la consola del navegador.
  
  
  
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
      
      
      # Se buscan las dos extensiones: el catálogo es casi todo .jpg, pero
      # alguna foto llegó como .png. Antes se construía siempre con '.jpg' y un
      # archivo .png quedaba invisible aunque estuviera en su sitio.
      candidatos <- file.path('./www', paste0(inorg, c('.jpg', '.png', '.jpeg')))
      filename <- candidatos[file.exists(candidatos)][1]

      # Dos de las 63 razas no tienen foto en www/ (Cacahuacintle y Choapaneco).
      # Sin esta comprobación el navegador muestra el icono de imagen rota, que
      # parece un error de la app en vez de un dato que falta.
      validate(need(!is.na(filename),
                    paste0("Todavía no hay fotografía de la raza ", input$Raza_Primaria, ".")))

      list(src = filename, alt = inorg)
    }, deleteFile = FALSE)
  
  #Para el summary
  # Generate a summary of the dataset ----
  # renderText y NO renderPrint. renderPrint muestra la representación de
  # consola de R: por eso salía el "[1]" —el índice del elemento dentro del
  # vector— y las comillas alrededor del texto. Ninguno de los dos está en los
  # datos: el valor guardado empieza directamente en "Su distribución original".
  # renderText entrega la cadena tal cual.
  output$summary1 <- renderText({
    req(input$Raza_Primaria)
    txt <- Anexo6$Informacion1[Anexo6$Raza_Primaria == input$Raza_Primaria]
    txt <- txt[!is.na(txt)]
    if (length(txt) == 0) return("Sin información disponible para esta raza.")
    trimws(paste(txt, collapse = " "))
  })
  #Para la gráfica
  
  # Registros por estado de la raza elegida. Barras horizontales ordenadas de
  # mayor a menor, interactivas con ggiraph.
  #
  # Antes era un geom_dumbbell() de ggalt (paquete archivado). Y era un dumbbell
  # sólo de nombre: la columna Min vale 0 en las 492 filas de TableL1c, así que
  # el "hueso" iba siempre de cero al conteo. Una barra dice exactamente lo
  # mismo, se lee mejor y no arrastra un paquete muerto.
  #
  # El color de la barra es el MISMO que tiene esa raza en el mapa de
  # distribución, para que las dos vistas se lean juntas.
  alto_plot11 <- reactive({
    n <- nrow(points1())
    max(320, n * 22 + 90)
  })

  output$plot11 <- renderGirafe({
    d <- points1()
    validate(need(nrow(d) > 0, "Esta raza no tiene registros por estado."))

    d$Estado <- as.character(d$Estado)
    d <- d[order(d$Val1), ]
    d$Estado <- factor(d$Estado, levels = d$Estado)   # mayor arriba al voltear
    total <- sum(d$Val1)
    d$tip <- paste0(d$Estado, "\n", d$Val1, " registros\n",
                    round(100 * d$Val1 / total, 1), "% de la raza")

    # umbral: por debajo del 18% de la barra mayor, el número no cabe dentro
    d$dentro <- d$Val1 >= 0.18 * max(d$Val1)

    color_raza <- unname(colores_raza[input$Raza_Primaria])
    if (is.na(color_raza)) color_raza <- "#FF8C00"

    g <- ggplot(d, aes(x = Val1, y = Estado)) +
      geom_col_interactive(
        aes(data_id = Estado, tooltip = tip),
        fill = color_raza, width = 0.72) +
      # El conteo va DENTRO de la barra cuando ésta es lo bastante larga, y fuera
      # cuando es corta. Poniéndolo siempre fuera, la etiqueta de la barra mayor
      # queda pegada al borde del panel y se pierde según el ancho que le toque
      # al contenedor. Así ninguna etiqueta depende del margen derecho.
      geom_text(data = d[d$dentro, ],
                aes(label = Val1), hjust = 1.25, size = 3.6, colour = "white") +
      geom_text(data = d[!d$dentro, ],
                aes(label = Val1), hjust = -0.25, size = 3.6, colour = "grey30") +
      # Límite explícito con 10% de aire, en vez de dejar que ggplot lo deduzca:
      # con expand la barra mayor terminaba pegada al borde del panel y su
      # etiqueta quedaba fuera del área visible.
      scale_x_continuous(limits = c(0, max(d$Val1) * 1.1),
                         expand = expansion(mult = c(0, 0))) +
      labs(x = "Registros", y = NULL,
           caption = paste0(nrow(d), " estados, ", total, " registros en total")) +
      theme_minimal() +
      theme(panel.grid.major.y = element_blank(),
            panel.grid.minor = element_blank(),
            panel.grid.major.x = element_line(colour = "grey90", linetype = "dashed"),
            axis.text.y = element_text(size = 12),
            axis.text.x = element_text(size = 11),
            plot.caption = element_text(colour = "grey45", hjust = 0, size = 11,
                                        face = "italic"),
            plot.caption.position = "plot")

    girafe(
      ggobj = g,
      width_svg = 8,
      height_svg = alto_plot11() / 72,
      options = list(
        opts_hover(css = "fill:#B40F20;"),
        opts_hover_inv(css = "opacity:0.35;"),
        opts_tooltip(css = "background-color:#333; color:#fff; padding:5px;
                            border-radius:4px; font-size:12px;"),
        opts_toolbar(saveaspng = TRUE, pngname = "registros_por_estado",
                     hidden = "selection"),
        opts_sizing(rescale = TRUE)
      )
    )
  })

  #### Para la Altitud

  # Rangos altitudinales por raza, filtrados por los estados elegidos.
  # Los registros de todos los estados seleccionados se agrupan juntos: el mínimo
  # es el más bajo de la selección, el máximo el más alto, y el promedio la media
  # de todos los registros individuales (queda ponderado por número de colectas,
  # no por estado). Es lo correcto biológicamente, pero conviene tenerlo claro.
  alt_razas <- reactive({
    req(input$Estado_alt)
    d <- Mex3[Mex3$Estado %in% input$Estado_alt, ]
    L <- suppressWarnings(
      d %>%
        dplyr::select(Raza, Altitud) %>%
        dplyr::group_by(Raza) %>%
        dplyr::summarise(minimo = min(Altitud,  na.rm = TRUE),
                         prom   = mean(Altitud, na.rm = TRUE),
                         maximo = max(Altitud,  na.rm = TRUE),
                         .groups = "drop")
    ) %>%
      dplyr::filter(is.finite(minimo), is.finite(maximo), is.finite(prom))

    # la variable elegida en el selector define el orden de izquierda a derecha
    L$ordenar <- switch(input$var11,
                        "promedio" = L$prom,
                        "máximo"   = L$maximo,
                        "mínimo"   = L$minimo)
    L <- L[order(L$ordenar), ]
    L$pos <- seq_len(nrow(L))
    L
  })

  DESPEGUE <- 200  # metros que el nombre se levanta sobre su propio valor

  # Alto de la gráfica: ~15 px por raza es lo que necesita un renglón de texto
  alto_graph2 <- reactive({
    LL <- alt_razas()
    if (nrow(LL) == 0) return(600)
    max(650, nrow(LL) * 15 + 130)
  })

  ####
  # Perfil altitudinal al estilo del "Perfil de vegetación y fauna" del Atlas
  # Nacional de España: silueta de montaña de fondo, un punto por raza a la
  # altitud elegida (promedio, máximo o mínimo) y su nombre al lado, alternando
  # izquierda/derecha. Se dibuja con ggiraph para que al pasar el mouse por una
  # raza se resalten su punto, su línea y su nombre a la vez.
  output$graph2 <- renderGirafe({
    LL <- alt_razas()
    validate(need(nrow(LL) > 0,
                  "No hay datos de altitud para los estados seleccionados."))

    # Cuántas razas se dibujan. No es un contador para el lector: sólo sirve para
    # cerrar la silueta de la montaña un poco después del último punto.
    n <- nrow(LL)

    # La montaña se dibuja en TRES capas anidadas (mínimo, promedio y máximo), para
    # que se vea de un vistazo toda la franja altitudinal que ocupa el maíz.
    #
    # La ladera de la variable ELEGIDA en el selector va exacta, sin suavizar, para
    # que cada punto quede posado sobre su superficie. Las otras dos se suavizan:
    # al no ser el criterio de orden, saltan bruscamente entre razas vecinas y sin
    # suavizar salen como una sierra de picos que arruina la figura.
    suavizar <- function(v) {
      if (length(v) < 5) return(pmax(v, 0))
      pmax(stats::predict(stats::loess(v ~ LL$pos, span = 0.5)), 0)
    }
    cresta_min  <- if (input$var11 == "mínimo")   LL$minimo else suavizar(LL$minimo)
    cresta_prom <- if (input$var11 == "promedio") LL$prom   else suavizar(LL$prom)
    cresta_max  <- if (input$var11 == "máximo")   LL$maximo else suavizar(LL$maximo)

    # Al suavizar por separado, las curvas podrían cruzarse. Se fuerza que se respete
    # mínimo <= promedio <= máximo, pero ajustando SIEMPRE las suavizadas y nunca la
    # exacta: si se moviera la exacta, los puntos dejarían de posarse sobre ella.
    if (input$var11 == "máximo") {
      cresta_prom <- pmin(cresta_prom, cresta_max)
      cresta_min  <- pmin(cresta_min,  cresta_prom)
    } else if (input$var11 == "mínimo") {
      cresta_prom <- pmax(cresta_prom, cresta_min)
      cresta_max  <- pmax(cresta_max,  cresta_prom)
    } else {                                   # promedio
      cresta_min <- pmin(cresta_min, cresta_prom)
      cresta_max <- pmax(cresta_max, cresta_prom)
    }

    poligono <- function(cresta) {
      data.frame(x = c(0.3, LL$pos, n + 0.7), y = c(0, cresta, 0))
    }

    # Espacio libre arriba para que ggrepel tenga a dónde mover los nombres.
    #
    # OJO: no basta con el punto más alto. scale_y_continuous(limits=) DESCARTA los
    # datos que quedan fuera (no los recorta visualmente), así que si la banda del
    # máximo suavizado rebasa el techo, el polígono pierde vértices y la cima sale
    # deformada. Ordenando por "promedio" pasa: los promedios llegan a ~2500 m pero
    # la banda del máximo alcanza los 3119 m. El techo cubre ambos.
    techo <- max(max(LL$ordenar) + DESPEGUE * 3, max(cresta_max) * 1.02)

    # Color de cada nombre. Se guarda como columna con el color literal y se pinta con
    # scale_colour_identity(): pasar un vector al parámetro `colour` funciona, pero
    # depende de que las filas queden en el mismo orden, y ggrepel las reacomoda.
    # Atándolo a los datos con aes() no hay forma de que se despareje.
    razas_resaltadas <- unique(unlist(razas_por_complejo[input$complejo_alt]))
    resaltar <- LL$Raza %in% razas_resaltadas
    LL$color_nombre <- ifelse(resaltar, "#B40F20", "grey15")
    # A diferencia del frijol, aquí NO se usa cursiva: los nombres de las razas de
    # maíz ("Cónico", "Tuxpeño") son nombres comunes, no nombres científicos.
    LL$face_nombre  <- ifelse(resaltar, "bold", "plain")

    # Los nombres se alternan: uno tiende hacia la izquierda de su punto y el
    # siguiente hacia la derecha. No es una posición fija sino un sesgo que se le
    # pasa a ggrepel (nudge_x), porque él decide la posición final para evitar choques.
    LL$lado <- ifelse(LL$pos %% 2 == 1, -1, 1)

    # Líneas de referencia de las capitales elegidas. Se dibujan primero para que
    # queden por debajo de los datos y no los tapen.
    caps <- capitales_altitud[capitales_altitud$ciudad %in% input$capitales, ]
    caps <- caps[caps$altitud <= techo, ]   # por si alguna sale del rango visible
    capa_capitales <- if (nrow(caps) > 0) {
      list(
        geom_hline(data = caps, aes(yintercept = altitud),
                   colour = "#1F6F8B", linewidth = 0.5, linetype = "longdash"),
        # x = -Inf ancla la etiqueta al borde izquierdo del panel, sea cual sea
        # el rango del eje X: no hay que calcular la posición
        geom_label(data = caps,
                   aes(x = -Inf, y = altitud,
                       label = paste0(ciudad, " · ", altitud, " m")),
                   hjust = 0, vjust = -0.25, size = 4, colour = "#1F6F8B",
                   fill = "white", linewidth = 0, label.padding = unit(1.2, "pt"))
      )
    } else NULL

    # Se usan los geoms *_interactive de ggiraph con un data_id común por raza:
    # al pasar el mouse por el punto, su línea punteada o su nombre, los tres se
    # resaltan a la vez (el estilo del resaltado se define en girafe(), más abajo).
    uno <- ggplot() +
      # de la más clara (máximo) a la más oscura (mínimo), para que queden anidadas
      geom_polygon(data = poligono(cresta_max),  aes(x, y), fill = "#F7EFE0", colour = NA) +
      geom_polygon(data = poligono(cresta_prom), aes(x, y), fill = "#E8D5B0", colour = NA) +
      geom_polygon(data = poligono(cresta_min),  aes(x, y), fill = "#CBB185", colour = NA) +
      capa_capitales +
      geom_point_interactive(
        data = LL,
        aes(x = pos, y = ordenar, data_id = Raza,
            tooltip = paste0(Raza, "\n",
                             "mínimo ",   round(minimo), " m\n",
                             "promedio ", round(prom),   " m\n",
                             "máximo ",   round(maximo), " m")),
        colour = "grey20", size = 1.8) +
      # ggrepel reacomoda los nombres que se encimarían y dibuja él mismo la línea
      # guía hasta su punto, así la línea sigue al nombre cuando lo tiene que mover.
      # nudge_x los sesga al lado que les toca (se conserva el alternado izq/der) y
      # nudge_y los levanta DESPEGUE metros sobre su punto.
      geom_text_repel_interactive(
        data = LL,
        aes(x = pos, y = ordenar, label = Raza,
            data_id = Raza, colour = color_nombre, fontface = face_nombre,
            tooltip = paste0(Raza, "\n", round(ordenar), " m")),
        nudge_x = LL$lado * 0.6,
        nudge_y = DESPEGUE,
        size = 4,
        segment.colour = "grey45", segment.linetype = "dashed",
        segment.size = 0.4,
        min.segment.length = 0,   # que siempre dibuje la línea guía
        box.padding = 0.3, point.padding = 0.2,
        max.overlaps = Inf,       # IMPRESCINDIBLE: si no, descarta nombres en silencio
        seed = 42) +              # para que el acomodo sea reproducible
      # Usan el color y el estilo literales que traen las columnas, sin inventar
      # una paleta ni una leyenda
      scale_colour_identity() +
      scale_discrete_identity(aesthetics = "fontface") +
      scale_y_continuous(breaks = seq(0, 4000, 500),
                         labels = paste0(seq(0, 4000, 500), " m"),
                         limits = c(0, techo), expand = c(0, 0)) +
      # aire a ambos lados, porque los nombres salen alternados
      scale_x_continuous(expand = expansion(mult = c(0.13, 0.13))) +
      labs(title = "Rangos altitudinales de las razas de maíz",
           subtitle = paste0("Cada punto marca la altitud ",
                             switch(input$var11,
                                    "promedio" = "promedio",
                                    "máximo"   = "máxima",
                                    "mínimo"   = "mínima"),
                             " de la raza\n",
                             "Las bandas de la montaña muestran el rango altitudinal: ",
                             "mínimo (tono oscuro), promedio y máximo (tono claro)",
                             # sólo aparece cuando hay resaltado, para que la figura
                             # se explique sola si alguien la exporta
                             if (length(input$complejo_alt) > 0)
                               paste0("\nEn rojo y negritas, las razas del complejo ",
                                      paste(input$complejo_alt, collapse = ", "))
                             else ""),
           x = NULL, y = NULL) +
      theme_minimal() +
      theme(plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
            plot.subtitle = element_text(size = 16, colour = "grey40", hjust = 0.5),
            panel.grid.major.x = element_blank(),
            panel.grid.minor = element_blank(),
            panel.grid.major.y = element_line(colour = "grey88", linetype = "dashed"),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.y = element_text(size = 12),
            legend.position = "none")

    # Se entrega como SVG interactivo. hover_css aplica al elemento bajo el mouse y
    # a todos los que comparten su data_id, así que resalta punto + línea + nombre.
    girafe(
      ggobj = uno,
      width_svg = 12,
      height_svg = alto_graph2() / 72,
      options = list(
        opts_hover(css = "fill:#B40F20; stroke:#B40F20; stroke-width:1.2pt;"),
        opts_hover_inv(css = "opacity:0.30;"),
        opts_tooltip(css = "background-color:#333; color:#fff; padding:5px;
                            border-radius:4px; font-size:12px;"),
        # hidden = "selection" quita los dos botones de lazo, que no se usan.
        # Se conservan el zoom, la descarga en PNG y la pantalla completa.
        opts_toolbar(saveaspng = TRUE, pngname = "altitud_maices",
                     hidden = "selection"),
        opts_sizing(rescale = TRUE)
      )
    )
  })

  
  
  # ---- Altitud por raza ------------------------------------------------------
  # Igual que la pestaña de Altitud pero SIN resumir: en vez de un punto por raza
  # (su promedio, máximo o mínimo), se dibuja el gradiente completo — cada altitud
  # donde se ha registrado esa raza.
  #
  # Responde una pregunta distinta: la montaña compara las razas entre sí; ésta
  # muestra el rango completo de unas pocas.
  #
  # El eje X es el PORCENTAJE de los registros de cada raza, no un conteo. Eso es
  # lo que permite comparar razas con volúmenes muy distintos: Tuxpeño tiene 806
  # altitudes distintas y Cacahuacintle 76, pero ambas curvas van de 0 a 100% y se
  # pueden leer una contra otra. Con un conteo crudo, la corta se quedaría
  # apretada contra el eje izquierdo.
  gradiente_razas <- reactive({
    req(input$razas_alt)
    d <- Mex3[!is.na(Mex3$Altitud) & Mex3$Raza %in% input$razas_alt, ]
    # distinct(): una misma altitud repetida en decenas de colectas aporta un solo
    # punto. Sin esto, Tuxpeño dibujaría 3,922 puntos encimados en vez de 806.
    d <- dplyr::distinct(d, Raza, Altitud, .keep_all = TRUE)
    d$Raza <- droplevels(factor(as.character(d$Raza)))
    d %>%
      dplyr::group_by(Raza) %>%
      dplyr::arrange(Altitud, .by_group = TRUE) %>%
      # con una sola altitud no hay gradiente que recorrer: se coloca al centro
      dplyr::mutate(pct = if (dplyr::n() > 1)
        (dplyr::row_number() - 1) / (dplyr::n() - 1) * 100 else 50) %>%
      dplyr::ungroup()
  })

  alto_graph5 <- reactive({
    # alto fijo: a diferencia de la montaña, aquí el número de renglones no crece
    # con los datos, sólo se acumulan curvas sobre el mismo espacio
    700
  })

  output$graph5 <- renderGirafe({
    D <- gradiente_razas()
    validate(need(nrow(D) > 0,
                  "No hay datos de altitud para las razas seleccionadas."))

    cols <- setNames(rep_len(paleta_razas, nlevels(D$Raza)), levels(D$Raza))

    techo <- max(D$Altitud) * 1.12

    caps <- capitales_altitud[capitales_altitud$ciudad %in% input$capitales2, ]
    caps <- caps[caps$altitud <= techo, ]
    capa_capitales <- if (nrow(caps) > 0) {
      list(
        geom_hline(data = caps, aes(yintercept = altitud),
                   colour = "#1F6F8B", linewidth = 0.5, linetype = "longdash"),
        geom_label(data = caps,
                   aes(x = -Inf, y = altitud,
                       label = paste0(ciudad, " · ", altitud, " m")),
                   hjust = 0, vjust = -0.25, size = 4, colour = "#1F6F8B",
                   fill = "white", linewidth = 0, label.padding = unit(1.2, "pt"))
      )
    } else NULL

    cinco <- ggplot(D, aes(x = pct, y = Altitud)) +
      # el área rellena convierte cada curva en una "montaña", igual que en Altitud
      geom_area(aes(group = Raza, fill = Raza),
                position = "identity", alpha = 0.22, colour = NA) +
      capa_capitales +
      # data_id = Raza: al pasar el mouse por cualquier punto se resalta el
      # gradiente completo de esa raza y se atenúan las demás
      geom_point_interactive(
        aes(colour = Raza, data_id = Raza,
            tooltip = paste0(Raza, "\n", round(Altitud), " m")),
        size = 1.2, alpha = 0.9) +
      scale_colour_manual(values = cols, name = NULL) +
      scale_fill_manual(values = cols, guide = "none") +
      scale_y_continuous(labels = function(x) paste0(x, " m"),
                         limits = c(0, techo), expand = c(0, 0)) +
      scale_x_continuous(labels = function(x) paste0(x, "%"),
                         limits = c(0, 100), expand = expansion(mult = c(0.02, 0.02))) +
      labs(title = "Gradiente altitudinal por raza",
           subtitle = paste0("Cada punto es una altitud donde se ha registrado la ",
                             "raza, de la más baja a la más alta\n",
                             "El eje horizontal es el porcentaje de los registros de ",
                             "cada raza, para poder compararlas entre sí"),
           caption = paste0("Sólo se incluyen las razas con más de ",
                            MIN_ALTITUDES_GRADIENTE - 1,
                            " altitudes distintas registradas (",
                            length(razas_con_gradiente), " de ",
                            razas_totales_con_altitud,
                            "): con menos no hay gradiente que mostrar."),
           x = NULL, y = NULL) +
      theme_minimal() +
      theme(plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
            plot.subtitle = element_text(size = 14, colour = "grey40", hjust = 0.5),
            panel.grid.minor = element_blank(),
            panel.grid.major.y = element_line(colour = "grey88", linetype = "dashed"),
            axis.text = element_text(size = 12),
            plot.caption = element_text(colour = "grey45", hjust = 0, size = 11,
                                        face = "italic"),
            plot.caption.position = "plot",
            legend.position = "top",
            # sin cursiva: los nombres de las razas son nombres comunes
            legend.text = element_text(size = 13))

    girafe(
      ggobj = cinco,
      width_svg = 12,
      height_svg = alto_graph5() / 72,
      options = list(
        opts_hover(css = "fill:#B40F20; stroke:#B40F20; stroke-width:1.2pt;"),
        opts_hover_inv(css = "opacity:0.25;"),
        opts_tooltip(css = "background-color:#333; color:#fff; padding:5px;
                            border-radius:4px; font-size:12px;"),
        opts_toolbar(saveaspng = TRUE, pngname = "altitud_por_raza",
                     hidden = "selection"),
        opts_sizing(rescale = TRUE)
      )
    )
  })

  # ---- Tamaño de mazorca (D3) ------------------------------------------------
  # Cada raza se dibuja como un elote acostado que va de su longitud mínima a su
  # máxima, ordenadas de menor a mayor de abajo hacia arriba y coloreadas por
  # complejo racial. El dibujo vive en www/js/mazorca-maiz.js.
  #
  # Antes era un geom_dumbbell() de ggalt (paquete archivado), luego un ggiraph.
  # Se pasó a D3 para poder ANIMAR: al cambiar el orden o los estados, cada elote
  # se desliza a su nuevo renglón y se estira, en vez de redibujarse de golpe.
  # El costo de la decisión es que se perdió la barra de herramientas que ggiraph
  # daba gratis (zoom, descarga en PNG, pantalla completa).
  mazorcas <- reactive({
    req(input$Estado_maz)
    d <- Size1[Size1$Estado %in% input$Estado_maz, ]
    S <- d %>%
      dplyr::group_by(Raza) %>%
      dplyr::summarise(minimo = min(Longitud),
                       prom   = mean(Longitud),
                       maximo = max(Longitud),
                       n      = dplyr::n(),
                       .groups = "drop")
    # Con un solo registro el mínimo y el máximo coinciden: no hay elote que
    # dibujar, sería una raya de grosor cero. Se excluye y se dice al pie.
    S <- S[S$maximo > S$minimo, ]
    if (nrow(S) == 0) return(S)

    S$Raza <- as.character(S$Raza)
    S$complejo <- unname(mazorca_complejo[S$Raza])
    S$complejo[is.na(S$complejo)] <- "Sin complejo"
    S$color <- unname(paleta_complejos[S$complejo])
    S$color[is.na(S$color)] <- "#9e9e9e"

    S$ordenar <- switch(input$var12,
                        "promedio" = S$prom,
                        "máximo"   = S$maximo,
                        "mínimo"   = S$minimo)
    S <- S[order(S$ordenar), ]
    S$pos <- seq_len(nrow(S))
    S
  })

  output$mazorca_pie <- renderUI({
    S <- mazorcas()
    con_dato <- Size1[Size1$Estado %in% input$Estado_maz, ]
    fuera <- setdiff(unique(as.character(con_dato$Raza)), S$Raza)
    tagList(
      tags$p(style = "color:#555; font-size:13px; margin-top:6px;",
             paste0(nrow(S), " razas dibujadas. Cada elote va de la longitud ",
                    "mínima a la máxima registrada; el punto blanco marca el ",
                    "promedio.")),
      if (length(fuera) > 0)
        tags$p(style = "color:#777; font-size:12px; font-style:italic;",
               paste0("Quedan fuera ", length(fuera),
                      " razas con un solo registro, sin rango que dibujar: ",
                      paste(sort(fuera), collapse = ", "), "."))
    )
  })

  # Mismo apretón de manos que el Sankey: los mensajes enviados antes de que el
  # JS registre su manejador se pierden en silencio.
  observeEvent(list(input$mazorca_listo, mazorcas()), {
    req(input$mazorca_listo)
    S <- mazorcas()
    req(nrow(S) > 0)
    filas <- function(df) {
      df[] <- lapply(df, function(x) if (is.factor(x)) as.character(x) else x)
      unname(lapply(seq_len(nrow(df)), function(i) as.list(df[i, ])))
    }
    session$sendCustomMessage("mazorcaMaiz", list(
      razas = filas(S[, c("Raza", "complejo", "minimo", "prom", "maximo",
                          "n", "color", "pos")] %>%
                      dplyr::rename(raza = Raza)),
      alto  = max(560, nrow(S) * 17 + 60),
      maxCm = ceiling(max(S$maximo) / 5) * 5
    ))
  })

  # El filtro del Sankey acepta uno o varios estados. Antes era un selectInput
  # con una opción literal "All"; ahora dejar la selección completa equivale a
  # no filtrar, igual que en las demás pestañas.
  points2 <- reactive({
    req(input$Estados)
    TableL2[TableL2$Estado %in% input$Estados, ]
  })

  # ---- Sankey con D3 ---------------------------------------------------------
  # Antes era gvisSankey (googleVis), que carga Google Charts desde gstatic.com
  # en tiempo de ejecucion: si esa peticion no pasa —redes que bloquean Google,
  # o simplemente sin internet— la grafica no aparece y no hay error que ver.
  # Ahora D3 va servido desde www/js/, sin dependencias externas.
  #
  # Se manda al navegador la estructura ya agregada; el dibujo y las
  # transiciones viven en www/js/sankey-maiz.js.
  sankey_datos <- reactive({
    d <- points2()

    # Dos niveles de flujo: complejo -> raza -> estado
    l1 <- aggregate(Val1 ~ Complejo_racial + Raza_primaria, data = d, FUN = sum)
    l2 <- aggregate(Val1 ~ Raza_primaria + Estado, data = d, FUN = sum)

    comps <- sort(unique(as.character(l1$Complejo_racial)))
    razas <- sort(unique(c(as.character(l1$Raza_primaria),
                           as.character(l2$Raza_primaria))))
    ests  <- sort(unique(as.character(l2$Estado)))

    # El complejo de cada raza da el color; asi un liston se puede seguir de
    # punta a punta por su tono.
    comp_de_raza <- setNames(as.character(l1$Complejo_racial),
                             as.character(l1$Raza_primaria))
    color_de <- function(complejo) {
      col <- unname(paleta_complejos[complejo])
      ifelse(is.na(col), "#9e9e9e", col)
    }

    # El id lleva prefijo de nivel para que un nombre repetido entre niveles no
    # colapse dos nodos en uno.
    nodes <- data.frame(
      id     = c(paste0("C|", comps), paste0("R|", razas), paste0("E|", ests)),
      nombre = c(comps, razas, ests),
      color  = c(color_de(comps),
                 color_de(unname(comp_de_raza[razas])),
                 rep("#b0b0b0", length(ests))),
      stringsAsFactors = FALSE
    )

    links <- rbind(
      data.frame(source = paste0("C|", as.character(l1$Complejo_racial)),
                 target = paste0("R|", as.character(l1$Raza_primaria)),
                 value  = l1$Val1,
                 color  = color_de(as.character(l1$Complejo_racial)),
                 stringsAsFactors = FALSE),
      data.frame(source = paste0("R|", as.character(l2$Raza_primaria)),
                 target = paste0("E|", as.character(l2$Estado)),
                 value  = l2$Val1,
                 color  = color_de(unname(comp_de_raza[as.character(l2$Raza_primaria)])),
                 stringsAsFactors = FALSE)
    )

    # El alto lo marca el nivel mas poblado: si no, los nodos delgados se
    # aplastan hasta desaparecer.
    alto <- max(600, max(length(comps), length(razas), length(ests)) * 16 + 40)

    # OJO: Shiny serializa los data.frame POR COLUMNAS ({id:[...], nombre:[...]}),
    # y D3 espera un arreglo de filas ([{id:..., nombre:...}, ...]). Sin esta
    # conversión el navegador falla con "datos.nodes.map is not a function".
    filas <- function(df) {
      df[] <- lapply(df, function(x) if (is.factor(x)) as.character(x) else x)
      unname(lapply(seq_len(nrow(df)), function(i) as.list(df[i, ])))
    }
    list(nodes = filas(nodes), links = filas(links), alto = alto)
  })

  # input$sankey_listo lo pone el propio JS cuando ya registro su manejador.
  # Sin ese apreton de manos, el primer envio se manda antes de que exista quien
  # lo reciba y se pierde en silencio: la pestana se queda en blanco hasta que
  # alguien mueve el filtro.
  observeEvent(list(input$sankey_listo, sankey_datos()), {
    req(input$sankey_listo)
    session$sendCustomMessage("sankeyMaiz", sankey_datos())
  })
  
  
})