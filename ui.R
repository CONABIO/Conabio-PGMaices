library(shiny)
library(leaflet)
library(knitr)
library(plotly)
library(ggplot2)
library(shinythemes)
library(shinydashboard)



#runApp(system.file("shiny/", package = "googleVis"))
#library(ggplot2movies)

shinyUI(navbarPage(
  title = "Humane Borders", id = "nav",

  #Introducción
 
 #Ventana 1
    tabPanel("Map", 
        #     div(img(src = "CONABIO_LOGO_13.JPG", width = "200"), 
        #         img(src = "CodiceFlorentino.png", width = "500"), style = "text-align: center;"),
            # h4("Proyecto Global de Maíces"),
          #   div(class = "outer",
           # Define UI for slider demo application
           #bootstrapPage(tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
           
          dashboardBody(
            tags$style(type = "text/css", "#mymap1 {height: calc(100vh - 80px) !important;}"),
            leafletOutput('mymap1', width = "100%", height = "100%")
          ),
                        
                      #   h4("$$$"),
            
           
            absolutePanel(top = 70, right = 40,
                          
                          #Por Cause of Death
                          selectInput(inputId = "Cause_of_death",
                                      label = h6("Cause of Death:"),
                                      c("All", levels(Tabla2$Cause_of_death))),
                          
                          #Por Corridor
                          selectInput(inputId = "Corridor",
                                      label = h6("Corridor:"),
                                      c("All", levels(Tabla2$Corridor))),
                          
                        
                          # Sex
                          selectInput(inputId = "Sex",
                                      label = h6("Sex:"),
                                      c("All", levels(Tabla2$Sex))),
                          
                          #Age
                          #meters
                          sliderInput(inputId = "Age", label = h6("Age:"), min = 0, max = 100, value = c(0,100)),
                          h6("*Comment: All data without Age value were transformed to 100"),
                          
                          # County
                          selectInput(inputId = "County",
                                      label = h6("County:"),
                                      c("All", levels(Tabla2$County))),
                          
                          
                          # Surface Management
                          selectInput(inputId = "Surface_management",
                                      label = h6("Surface Management:"),
                                      c("All", levels(Tabla2$Surface_management)))
                          
                           ),
            
            absolutePanel(top = 70, left = 20,
                            #h4("Human Border:"),
                          tags$a(href = "https://humaneborders.org/", div(img(src = "logo-dipper-line.png", width = "200"), 
                                                                          style = "text-align: center;")),
                          br(),
                          h5("Download the original and complete data", tags$a(href = "http://www.humaneborders.info/app/map.asp", " Here")),
                          h6("Information until september 2018")
                          
                          
                          ),
        absolutePanel(bottom = 10, left = 20,
                      
                      h6("Download data selected in the map"),
                      downloadButton('downloadData', 'Download (csv)'),
                      
                      h6("Github:"),
                      tags$a(href = "https://github.com/APonce73/Conabio-PGMaices", "Human Border"),
                      h6("comments:"),
                      h6("aponce73pm@gmail.com")
        )
           ),
 
 tabPanel( 'Graphic',
           tags$a(href = "https://humaneborders.org/", div(img(src = "logo-dipper-line.png", width = "200"), 
                                                           style = "text-align: left;")),
   
           #titlePanel("Barplot by variables"),
           
           column(2,
             
             
             #Range
             selectInput(inputId = "Variable11",
                         label = h6("Variable:"),
                         selected = c("Age"), 
                         choices = c("Sex", "Age", "Surface_management",
                                     "Corridor", "Cause_of_death", "County",
                                     "Year", "Month", "Day")
                         )
                        ),
             
           mainPanel(
            
             #dataTableOutput("plot11")
             
              plotlyOutput("plot11", width = 1000, height = 800)
           )
           
 ),
 
 tabPanel('About Human Borders',
          
          tags$a(href = "https://humaneborders.org/", div(img(src = "logo-dipper-line.png", width = "200"), 
                                                          style = "text-align: left;")),
          #div(img(src = "CodiceFlorentino.png", width = "750"), style = "text-align: center;"),
          
          
          h4( tags$a(href = "https://humaneborders.org/", 
                     "Humane Borders"  ) ," motivated by faith and the universal need for kindness, 
              maintains a system of water stations in the Sonoran Desert on routes used by 
              migrants making the perilous journey here on foot. 
              Our primary mission is to save desperate people from a horrible death by 
              dehydration and exposure and to create a just and humane environment in the 
              borderlands. We locate our water stations on government and privately owned 
              land with permission from the landowners.
              
              Founded in the summer of the year 2000, Humane Borders, Inc. is a non-profit 
              corporation run almost exclusively by volunteers. Our focus is strictly 
              humanitarian assistance. Donations to Humane Borders are tax-deductible to the 
              extent allowed by law, and we depend upon gifts from individuals and religious 
              groups of all faiths to continue our work."),  
          
          column(5, wellPanel(
            h3("Ways You Can Help:"),
            
            h5("1.", tags$a(href = "https://humaneborders.org/donate/", 
                            "Donate Online"), "Humane Borders operates on tax-deductible philanthropic contributions from organizations and people like you."),
            h5("2.", tags$a(href = "https://humaneborders.org/volunteer-opportunities/", 
                            "Volunteer Your Time"), "Our water runs are regularly scheduled trips, leaving from Tucson, Phoenix, and Ajo to our water stations in the Sonoran Desert."),
            h5("3.", tags$a(href = "https://www.facebook.com/HumaneBordersAZ/", 
                            "Like Us and Share on Facebook"), "Learn about events, see the latest news, and easily share information about helping those in need.")
          )
          ),
          
          
          #        column(3, wellPanel(h3("Visualización Shiny"),
          #                             h5("Esta visualización esta basada en los datos de maíz, teocintle y tripsacum
          #                                del",
          #                                tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html", "Proyecto Global de Maíces"  )),
          #                             h5("La visualización tiene las siguientes páginas:"),
          #                             h5("Introducción"),
          #                             h5("Datos georeferencias del Proyecto Global de maíces"),
          #                             h5("Datos Generales de las razas de maíces"),
          #                             h5("Gráfica de Sankey"),
          #                             h5("Datos adicionales sobre el maíz"),
          #                             h5("Bibliografía del proyecto")       
          #                              #div(img(src = "Mapa.png", style = "display:block; margin-left: auto; margin-right: auto;",width = "400", height = "300")),
          #                             #div(img(src = "Mapa1.png", style = "display:block; margin-left: auto; margin-right: auto;",width = "300", height = "300"))
          #                             )),
          div(img(src = "HBorder1.jpg", width = "500"), 
              br(),
              br(),
              img(src = "HBorder2.jpg", width = "750"), style = "text-align: center;")
          ) #del tabPanel
)
)

#parentesis del tabpanel
#Ventana 2 Fotos Maices
#  tabPanel('Maíces',
#           div(img(src = "CONABIO_LOGO_13.JPG", width = "100"), 
#               img(src = "CodiceFlorentino.png", width = "300"), style = "text-align: center;"),
#           # Define UI for slider demo application
#           shinyUI(fluidPage(
#             #Application title
#             #titlePanel("Proyecto Global de Maíces CONABIO"),
#             h4("Razas de maíces"),
#             
#             sidebarLayout(
#               sidebarPanel(
#                 
#                 
#                 #Raza Primaria
#                 selectInput(inputId = "Raza_Primaria",
#                             label = h6("Raza de maíz:"),
#                             levels(TableL1c$Raza_Primaria)),
#                 h4("Conabio"),
#                 tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html", "Proyecto Maices"),
#                 # br(),
#                 
#                # h6("Descarga de la base de datos"),
#                # tags$a(href = "http://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo13_Base%20de%20datos/BaseMaicesNativos.xlsx", "DataBase"),
#                 h4("Github:"),
#                 tags$a(href = "https://github.com/APonce73/Conabio-PGMaices", "Conabio-Maíces"),
#                h5("comentarios:"),
#                h5("amastretta@conabio.gob.mx"),
#                h5("aponce73pm@gmail.com"),
#                 
#                 
#                width = 3),
#               
#               
#               fluidRow(
#                 column(6, imageOutput('preImage', height = 500, width = 500)),
#                
#                 column(9, wellPanel(
#                   h4("Características generales"),
#                   h4(textOutput("summary1")),
#                   h5("Fuente:", tags$a(href = "https://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo6_ReunionesTalleres/Tabla%20razas_marzo%202010.pdf", "Maíces"))
#                        )),
#                   #column(9, imageOutput('preImage', height = 500, width = 500)),
#                 column(9, 
#                   plotlyOutput("plot11", height = 500, width = 800)
#                 )
#                 
#                 
#                        
#               )
#             )
#               ))
#           ),

#Ventana 2.1 Sankeyplot

#tabPanel('Sankey', 
#         div(img(src = "CONABIO_LOGO_13.JPG", width = "100"), 
#             img(src = "CodiceFlorentino.png", width = "300"), style = "text-align: center;"),
#         # Define UI for slider demo application
#         
#         h3("Diagrama de Sankey o de Flujo de las razas de maíces en México"),
#         h4("Estos diagramas visualizan la dispersión o distribución de las 
#             razas de maíces. De izquierda a derecha se muestran los distintos ",
#             tags$a(href = "https://www.biodiversidad.gob.mx/usos/maices/razas2012.html", 
#            "complejos raciales"), "que conjuntan distintas razas que se distribuyen
#            en todo el país"),
#        
#         br(),
#         h4("..................................... Complejo racial 
#            ........................................................... Raza de maíz 
#            ........................................................................ Estado"),
#         br(),
#         #column(5, wellPanel(h4("FDFDFDFDF"))),
#         br(),
#         br(),
#         br(),
#         shinyUI(fluidPage(
#           #Application title
#           #titlePanel("Gráfica de Sankey"),
#           
#           
#           sidebarLayout(
#             sidebarPanel(
#               
#               #Raza Primaria
#            #   selectInput(inputId = "Raza_primarias",
#            #               label = h6("Raza Primaria:"),
#            #               c("All", levels(TableL2$Raza_primaria))),
#            #   #c("All", unique(as.character(TableL$Raza_primaria)))),
#               
#            #   #Por Complejo Racial
#            #   selectInput(inputId = "Complejo_racials",
#            #               label = h6("Grupo Racial:"),
#            #               c("All", levels(TableL2$Complejo_racial))),
#               
#               #Por Estado
#               selectInput(inputId = "Estados",
#                           label = h5("Estado:"),
#                            c("All", levels(TableL2$Estado))),
#               br(),
#               h5("Visualización de la presencia de maíces en distintos estados"),
#               br()
#               
#              # selectInput(inputId = "Complejo_racials",
#              #             label = h6("Grupo racial:"),
#              #             levels(TableLL$Complejo_racial)),
#               
#               
#               
#             , width = 2),    
#                column(9,
#               htmlOutput("Sankeyplot1", width = "1000", height = "600")
#             )
#             
#         )
#         ))
#),


#Datos Adiciconales  
#tabPanel('Datos adicionales sobre el maíz',
#         div(img(src = "CONABIO_LOGO_13.JPG", width = "100"), 
#             img(src = "CodiceFlorentino.png", width = "300"), style = "text-align: center;"),
#         #div(img(src = "CodiceFlorentino.png", width = "750"), style = "text-align: center;"),
#         br(),
#         br(),
#         h3("El Maíz me representa y me identifica con mi gente", style = "text-align: center;"),
#         br(),
#         br(),
#         
#         column(4, wellPanel(h3("Cronología del maíz en México"),
#                             h5("6200 años del presente (AdP) Guilá Naquitz (Oaxaca)"),
#                             h5("4500-7000 AdP, Tehuacan (Puebla)"),
#                             h5("5000      AdP, Zohapilco (Tlapacoya, México)"),
#                             h5("4562      AdP, San Andrés (Tabasco)"),
#                             h5("4500      AdP, Norte de Sinaloa"),
#                             h5("4500      AdP, Cueva de la Perra (Tamaulipas)"),
#                             h5("4400      AdP, Cueva de Ocampo (Tamaulipas)"),
#                             h5("4250      AdP, Laguna Pompal (Veracruz)"),
#                             h5("3750-4250 AdP, La Venta (Tabasco)"),
#                             h5("3890      AdP, Cueva de Valenzuela (Tamapulipas)"),
#                             h5("3400-3550 AdP, Costa del Pacífico"),
#                             h5("3000      AdP, La Playa (Sonora)"),
#                             h5("2980      AdP, Cerro Juanaqueña (Chihuahua)"),
#                             h5("2400-2700 AdP, Cueva del Valle (Chihuahua)"),
#                             h5("2400-2700 AdP, San Blas (Nayarit)"),
#                             h6("Fuente:Información biológica-agronómica básica sobre, los maíces nativos y sus parientes silvestres, CONABIO"), 
#                             br()
#                             
#                             
#                             #div(img(src = "Mapa.png", style = "display:block; margin-left: auto; margin-right: auto;",width = "400", height = "300")),
#                             #div(img(src = "Mapa1.png", style = "display:block; margin-left: auto; margin-right: auto;",width = "300", height = "300"))
#         )),
#         
#         
#         column(4, wellPanel(h3("Topónimos relacionados con el Maíz "),
#                             h5("Actopan: En la Tierra Fértil"),
#                             h5("Amilcingo: Las milpas de agua"),
#                             h5("Amilpas: En los sembradíos de riego"),
#                             h5("Centla: Donde abundan las mazorcas de maíz"),
#                             h5("Cincózcac: En el collar de mazorcas de maíz"),
#                             h5("Elota: Donde abundan los elotes"),
#                             h5("Jilotepec o Xilotepe: Lugar de jilotes"),
#                             h5("Jilotlan: Donde abundan los jilotes"),
#                             h5("Jilotzingo o Xilotzingo: Lugar del jilotito"),
#                             h5("Miahuatlan: Rio de las espigas de maíz"),
#                             h5("Milpa Alta: En las milpas de la parte alta"),
#                             h5("Miltepec: En el cerro de las milpas"),
#                             h5("Oapan: Sobre las cañas del maíz tierno"),
#                             h5("Teocinyocan: Lugar donde se hace divino el maíz"),
#                             h5("Textitlan: Junto a donde hay masa"),
#                             h5("Tlaxcala: Lugar de las tortillas"),
#                             h5("Xiloxotla: Lugar de maíz muy tierno")
#                             #div(img(src = "Mapa.png", style = "display:block; margin-left: auto; margin-right: auto;",width = "400", height = "300")),
#                             #div(img(src = "Mapa1.png", style = "display:block; margin-left: auto; margin-right: auto;",width = "300", height = "300"))
#         )),
#         
#         div(img(src = "Zea_mays.jpg", width = "400"),
#             div( img(src = "San_Andres_Calpan_Puebla.jpg", width = "500"), style = "text-align: center;")),
#             column(4, wellPanel(h2("Los dichos del maíz"),
#                                 br(),
#                                 h3("Otra vez la burra al maíz, y el burrito a los elotes"),
#                                 h5("Frase que se usa para mostrar disgusto cuando alguien ejecuta repetidamente una acción molesta o dañina"),
#                                 br(),
#                                 h3("Le está lloviendo en su milpita"),
#                                 h5("Recibir alguien muchos bienes o beneficios seguidos. 
#                                    No confundirlo con -le llovió sobre mojado-, que significa precisamente lo contrario" )
#                                 
#             )),
#         column(4, wellPanel(
#                             h3("Dar atole con el dedo"),
#                             h5("Engañar a alguien con algo muy simple, como si fuera
#                                un bebé al que hay que alimentar con cuidado"),
#                             br(),
#                             h3("Éste no siembra maíz por miedo a las urracas"),
#                             h5("Se aplica a las personas que justifican su pereza
#                                con pesimismo"),
#                             br(),
#                             h6("Fuente: -los dichos del maíz- por Susana González Aktories
#                                de la revista Artes de México (79) -Mitos del maíz-"),
#                             br()
#                             ))
#            
#            
#         
#),

#Bibliografía
#tabPanel('Bibliografía',
#         
#         div(img(src = "CONABIO_LOGO_13.JPG", width = "100"), 
#             img(src = "CodiceFlorentino.png", width = "300"), style = "text-align: center;"),
#         #div(img(src = "CodiceFlorentino.png", width = "750"), style = "text-align: center;"),
#         
#         
#         h4("Bases de datos generadas durante la ejecución del Proyecto Global de Maíces  “Recopilación, generación, actualización y análisis de información acerca de la diversidad genética de maíces y sus parientes silvestres en México.", tags$a(href = "http://www.biodiversidad.gob.mx/genes/proyectoMaices.html", 
#                                      "CONABIO."  )),
#         
#         h5("Hernández Casillas, J.M.; Díaz de la C., J. B. 2010. Base de datos de colecciones de maíces nativos, teocintles y Tripsacum de México. Bases de datos SNIB-CONABIO proyecto No.", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FY&Numero=1", "FY001" ) , "México, D.F."),
#         h5("Carrera Valtierra, J. A. 2013. Estudio de la diversidad genética y su distribución de los maíces criollos y sus parientes silvestres en Michoacán. Universidad Autónoma de Chapingo. Centro Regional Universitario Centro Oriente. Bases de datos SNIB2013-CONABIO Maíz. Proyecto No. ", tags$a(href = "http://www.biodiversidad.gob.mx/genes/pdf/proyecto/Anexo8_ResultadosProyectos/FZ001/Informe%20Final%20FZ001.pdf", "FZ001." ), " México, D.F."),
#         h5("Rincón Sánchez, F., Hernández Pardo, C. J., Zamora Cansino F., Hernández Casillas, J. M., Ruiz Torres, N. A., Illescas Palma, C. N. y L. Ramón Gayosso. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Coahuila. INIFAP-UAAAN. Base de datos SNIB-CONABIO Maíz. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."), "México, D. F."),
#         h5("Vidal Martínez, V. A., Ortega Corona, A., Guerrero Herrera, M. de J., Cota Agramont, O., Herrera Cedano, F., Hernández Casillas, J. M., Valdivia Bernal, R., Caro Velarde F. de J. y G. González Rodríguez. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Nayarit. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No.", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."), " México, D. F."),
#         h5("Valadez Gutiérrez, Juan, Julio César García Rodríguez y Juan Manuel Hernández Casillas. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Nuevo León. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."), " México, D. F."),
#         h5("Palacios Velarde, O., Ortega Corona, A., Guerrero Herrera, M. de J., Hernández Casillas, J. M. y L. M. Peinado Fuentes. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Sinaloa. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."), " México, D. F."),
#         h5("Ortega Corona, A., Guerrero Herrera, M. de J., Cota Agramont, O., Hernández Casillas, J. M. y L. M. Peinado Fuentes. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Sonora. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."), " México, D. F."),
#         h5("Valadez Gutiérrez, J., García Rodríguez, J. C.,  Cervantes Martínez, J. E. y J. M. Hernández Casillas. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Estado de Tamaulipas. INIFAP. Base de datos SNIB-CONABIO Maíz. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=FZ&Numero=2", "FZ002."), " México, D. F."),
#         h5("Rendón Aguilar, B. 2011. Diversidad y distribución altitudinal de maíces nativos en la región de los Loxicha, Sierra Madre del Sur Oaxaca. Universidad Autónoma Metropolitana. Unidad Iztapalapa. Base de datos SNIB-CONABIO proyecto No. ", tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=FZ&Numero=3", "FZ003."), " México, D.F."),
#         h5("Taba, S., Chávez Tovar, V. H., Rivas, M. y M. Rodríguez Alvarado. 2010. Monitoreo y recolección de la Diversidad de razas de maíz criollo en la región de la Huasteca en México para complementar las colecciones de los bancos de germoplasma de INIFAP y CIMMYT. Centro Internacional de Mejoramiento de Maíz y Trigo. Banco de Germoplasma de Maíz. Base de datos SNIB-CONABIO proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=7", "FZ007."), " México D. F."),
#         h5("Mijangos Cortés, J. O. 2013. Colecta de maíces nativos en regiones estratégicas de la Península de Yucatán. Centro de Investigación Científica de Yucatán A.C. Unidad de Recursos Naturales. Bases de datos SNIB-CONABIO Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=14", "FZ014."), " México, D.F."),
#         h5("Mijangos Cortés, J. O. 2013. Colecta de maíces nativos en regiones estratégicas de la Península de Yucatán. Centro de Investigación Científica de Yucatán A.C. Unidad de Recursos Naturales. Bases de datos SNIB-CONABIO Datos 2007. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=14", "FZ014."), " México, D.F."),
#         h5("Zavala García, F. 2012. Conocimiento de la diversidad y distribución actual del maíz nativo en Nuevo León. Universidad Autónoma de Nuevo León. Facultad de Agronomía. Bases de datos SNIB-CONABIO. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=15", "FZ015."), " México D. F."),
#         h5("García Holguín, M. R. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México, segunda etapa 2008-2009. Instituto Nacional de Investigaciones Forestales, Agrícolas y Pecuarias. Base de datos SNIB-CONABIO Chihuahua. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."), " México D.F."),
#         h5("Guerrero Herrera, M. de J. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México, segunda etapa 2008-2009. Instituto Nacional de Investigaciones Forestales, Agrícolas y Pecuarias. Base de datos SNIB-CONABIO CIRNO. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."), " México D.F."),
#         h5("Castillo Rosales, A., E. Quezada Guzmán, A. de Alba Ávila, L.R. Reveles Torres y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Norte Centro, estados: Aguascalientes, Durango y Zacatecas. INIFAP-CIRNOC. Base de datos SNIB-CONABIO. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."), " México, D.F."),
#         h5("Vidal Martínez, V.A., A. Morfín Valencia, A. García Berber, F. Herrera Cedano, M. de J. Guerrero Herrera, N.O. Gómez Montiel, J.M. Hernández Casillas, M. de la O Olan, J. Ron Parra, J. de J. Sánchez González, A. Jiménez Cordero, L. de la Cruz Larios, H. Ramírez Vega y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Pacífico Centro, estados: Colima, Jalisco y Nayarit. INIFAP-CIRPAC. Base de datos SNIB-CONABIO proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."), " México, D.F."),
#         h5("Preciado Ortiz, R.E., J.M. Hernández Casillas, M. de la O Olan, G. Esquivel Esquivel, A.D. Terrón Ibarra, A. Aguirre Gómez, L.A. Noriega González, A.S. Cruz Morales, J.P. Pérez Camarillo, L. Martínez Hernández, S. Franco Ramírez, E.R. Martínez Ruíz, M.A. Ávila Perches, J.R.A. Dorantes González, H.G. Gámez Vázquez, A.J. Gámez Vázquez, A. María Ramírez, E. Muñoz de la Vega, A. Ríos Sosa, F. Huerta López y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Centro, estados: Distrito Federal, Estado de México, Guanajuato, Hidalgo, Michoacán, Querétaro, San Luis Potosí y Tlaxcala. INIFAP-CIRCE. Base de datos SNIB-CONABIO proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."), " México, D.F."),
#         h5("Sierra Macías, M., I. Meneses Márquez, A. Palafox Caballero, N. Francisco Nicolás, A. Zambada Martínez, F. Rodríguez Montalvo, R. López Morgado, S. Barrón Freyre, J.M. Uribe Bernal, J.M. Hernández Casillas y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Golfo Centro, estados: Puebla, Veracruz y Tabasco. INIFAP-CIRGOC. Base de datos SNIB-CONABIO proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."), " México, D.F."),
#         h5("Gómez Montiel, N.O., B. Coutiño Estrada, A. Trujillo Campos, F. Palemón Alberto, G. Sánchez Grajales, F.J. Cruz Chávez, C.E. Aguilar Jiménez, J.M. Hernández Casillas, F. Castillo González, R. Ortega Paczka y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Pacífico Sur, estados: Chiapas, Guerrero y Morelos. INIFAP-CIRPAS. Base de datos SNIB-CONABIO proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."), " México, D.F."),
#         h5("Aguilar Castillo, G., H. Torres Pimentel, J. Medina Méndez, R.J. Nava Padilla y A. Ortega Corona. 2014. Conocimiento de la diversidad y distribución actual del maíz nativo y sus parientes silvestres en México. Segunda etapa 2008-2009. Región Sureste, estados: Campeche, Quintana Roo y Yucatán. INIFAP-CIRSE. Base de datos SNIB-CONABIO. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=16", "FZ016."), " México, D.F."),
#         h5("Garza Castillo, M. R. 2013. Conocimiento de la diversidad y distribución actual del maíz nativo y Tripsacum en el estado de Tamaulipas. Universidad Autónoma de Tamaulipas. Instituto de Ecología y Alimentos. Base de datos SNIB-CONABIO. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=18", "FZ018."), " México, D.F."),
#         h5("Carrera Valtierra, J. A. 2013. Estudio de la diversidad de maíz en la región costa de Michoacán y áreas adyacentes de Jalisco y Colima. Universidad Autónoma de Chapingo. Centro Regional Universitario Centro Oriente. Base de datos SNIB-CONABIO. Proyecto No. ", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos.cgi?Letras=FZ&Numero=23", "FZ023."), " México, D.F."),
#         h5("Díaz Gallardo, R. I. 2013. Diagnóstico de la diversidad de maíces nativos, su agroecosistema y sus parientes silvestres en la región prioritaria “La Chinantla” y su zona de influencia. SEMARNAT. CONTRATO DGRMIS-DAC-DGSPYRNR-No.004/2009. Base de datos donada al SNIB-CONABIO Maíz. ", tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=3", "Z003."), " México D. F."),
#         h5("Vázquez Vázquez, J. L. 2013. Diagnóstico de la diversidad de maíces nativos, su agroecosistema y sus parientes silvestres presentes en el ANP “Papigochic” y su zona de influencia. SEMARNAT. Contrato DGRMIS-DAC-DGSPYRNR-002/2009. Base de datos donada al SNIB-CONABIO Maíz. ", tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=4", "Z004."), " México D. F."),
#         h5("Díaz Gallardo, R.I. 2014. Catálogo de maíces nativos, generada a partir de la tesis “El sistema milpa y sus recursos fitogenéticos en Santa María Tlahuitoltepec, Oaxaca”. Región Sierra Mixe. Universidad Autónoma Chapingo. Base de datos SNIB-CONABIO. Proyecto No. ", tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=5", "Z005."), ". México, D.F."),
#         h5("Ortega Paczka, R. 2015. Computarización de datos de colecta de muestras de maíz y otros cultivos asociados de diferentes regiones de México. Donación del Dr. Rafael Ortega Paczka. Universidad Autónoma Chapingo. Base de datos SNIB-CONABIO. Proyecto No. ", tags$a(href = "http://www.snib.mx/proyectos/cgi-bin/datos2.cgi?Letras=Z&Numero=6", "Z006."), " México, D.F.")
#         
#         
#         )
#
#)


