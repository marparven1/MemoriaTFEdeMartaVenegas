
library(shiny)
library(leaflet)
library(plotly)
library(shinyjs)
library(shinyBS)
library(shinydashboard)





# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # Tema
  theme = shinytheme("simplex"),
  # Estilo CSS
 tags$head( tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css")),

  
  #### NavBarPane ####
  navbarPage( "TFG", 
              selected = icon("home"), collapsible = TRUE, fluid = TRUE, 
              tabPanel( icon("home"),
                        includeHTML("Home.Rhtml"),
                        includeHTML("footer.Rhtml")
              ),

  #### Market basket analysis #### 
              tabPanel("Análisis de cesta de la compra",
                       br(),br(),hr(),br(),
                       fluidRow(
                         h1("Análisis de cesta de la compra con datos de tickets de un supermercado"),
                                 br(),
                         column(12,
                                p("Se ha aplicado un análisis de cesta de la compra a unos datos que proceden de una muestra de tickets 
                                  correspondiente a transacciones de una cadena de supermercados. La muestra contiene un total de 
                                  7801 tickets que incluyen 4631 artículos distintos.")
                                ),br(),
                         h2("Muestra de transacciones")),
                       fluidRow(
                         box(
                           title = "Tickets", width = 6, solidHeader = TRUE, 
                            img(class="imgIcon",src='img/Ticket.png',width="20%"), 
                           p("7801",align= "center")
                         ),
                         box(
                           title = "Artículos", width = 6, solidHeader = TRUE,
                           img(class="imgIcon",src='img/Articulos.png',width="20%"),p("4631",align= "center")
                         )
                       ),
                       br(),hr(),br(),
                       fluidRow(h2(em("Conjuntos de datos"),icon("database",lib = "font-awesome")),
                         tabBox(
                           title = "Datos",
                           # The id lets us use input$tabset1 on the server to find the current tab
                           id = "datos", height = "600px",width = "100%",
                           tabPanel("Conjunto de datos inicial", DT::dataTableOutput("CjtoInicial")),
                           tabPanel("Conjunto de datos en formato cesta", DT::dataTableOutput("FtoBasket"),
                                    br(),p("Nota: Únicamente se observa una cota inferior de la venta de cada producto."),br())
                         )),
                       br(),hr(),br(),
                       fluidRow(h1("1. Análisis de transacciones"),
                         tabBox(title = "Gráficas",width = "9",
                           tabPanel("Tamaño",
                                    plotlyOutput("TamanoTrans",height = "500px")
                           ),
                           tabPanel("ID producto", 
                                    plotlyOutput("soporte",height = "500px")
                                    )
                         ),
                         tabBox(title = "Selectores",width = "3",br(),
                                tabPanel("Tamaño",
                                         sliderInput("TamanoTransaccionesInput", 
                                                     p("Seleccione el número de transacciones"),
                                                     min = 1, max = 82, value = 10)
                                ),
                                tabPanel("ID producto", 
                                         numericInput("ConteoArticulos", 
                                                      "Seleccione el número de artículos que quiere mostrar:",
                                                      20, min =1, max = 4631),
                                         br(),
                                         selectInput("selectorVis", "Seleccione una opción para visualizar:",
                                                     list(`Cota inferior de ventas` = list("Cota"),
                                                          `Soporte individual` = list("Soporte"))),
                                         helpText("Nota: El soporte es la proporción de transacciones que contiene a un item
                                             o conjunto de items, y se mostrará en porcentaje."))
                                )
                         ),
                       br(),hr(),br(),
                       fluidRow(
                         div(h1("2. Aplicación del algoritmo a priori"), 
                             br(),
                             p("Este algoritmo permite generar una serie de reglas de 
                              asociación y descubrir conjuntos de items frecuentes.")),
                       ),
                       
                       br(),
                       
                       fluidRow(h2("Configuración del algoritmo a priori"),
                         box(title="Configuración inicial",
                           width = 6, 
                           "Confianza mínima: 50%",br(),"Soporte mínimo: al menos 20 compras", br(),
                           "Problema: recomendación de los productos más vendidos: 1096 y 1033."
                         ),
                         box(
                           title = "Configuración final", width = 6, 
                           "Confianza mínima: 18%", br(),"Soporte mínimo: al menos 15 compras", br(),
                           "Solución: Introducir en el antecedente los productos más vendidos para descubrir la asociación con productos menos vendidos."
                         )
                       ),
                       fluidRow(h2("Resultado de las reglas de asociación"), br(),
                                tabBox(title="Gráficas",
                                       height = "350px",
                                  tabPanel("Grafo", br(),
                                           img(class="imgIcon",src='img/grafoReglas.png',width="100%"),
                                                p("Venta frecuente de los productos 1096 y 1033.")
                                           ),
                                  
                                  tabPanel("Confianza", br()," ", br(),
                                           img(class="imgIcon",src='img/CestaConfianza.png',width="100%")
                                           ),
                                  
                                  tabPanel("Soporte", br(),
                                           "Soporte: frecuencia con que los objetos son comprados juntos.",br(),
                                           br(),img(class="imgIcon",src='img/CestaSoporte.png',width="100%")
                                           )
                                  ),
                                tabBox(title="Evaluación de las reglas",
                                       height = "350px",
                                       tabPanel("Generalidades",br(),
                                                "La transacción más repetida:", br(), img(class="imgIcon",src='img/BasketMasRepetida.png',width="100%"),
                                                br(),
                                                "Lift",br(),
                                                "Valores de este parámetro bastante altos. Reglas robustas, es decir, no se 
                                                  deben a la aleatoriedad, sino a un patrón de comportamiento existente.",
                                                br(),
                                                "Regla más robusta:" , br(),img(class="imgIcon",src='img/BasketMasRobusta.png',width="100%")
                                       ),
                                       tabPanel("Test exacto fisher", 
                                                br(),"Test exacto de Fisher: muestra un comportamiento real de ventas.",br(),
                                                img(class="imgIcon",src='img/MarketTestFisher.png',width="90%"), 
                                                img(class="imgIcon",src='img/MarketResTestFisher.png',width="65%")
                                       )
                                )
                                ),br(),br(),br(),hr(),br(),br(),br(),
                       fluidRow(div(h1("3. Conclusiones")),
                         box( title = "Patrón de ventas",
                           width = 4, background = "black",
                           "Uno o dos productos diferentes por transacción"
                         ),
                         box(
                           title = "Productos más vendidos", width = 4, background = "light-blue",
                           "La venta conjunta de los productos 1033 y 1096 se ha producido en un 1.23% de las transacciones, unas 170 veces."
                         ),
                         box(
                           title = "Reglas robustas",width = 4, background = "maroon",
                           "No se deben al azar, existe un patrón de comportamiento de ventas real."
                         )
                       ),
                      div(p(""),br(),p(""),br(),p(""),br()),
                       br(),hr(),br(),
                       includeHTML("footer.Rhtml")
                       ),
  #### Data science process #### 
    navbarMenu("Proceso de ciencia de datos",
               tabPanel("Preprocesado", br(),
                        fluidRow( 
                                 h1("Adquisición de los datos y preparación"),br(),
                                 h2("Muestra de transacciones")
                                 ) ,
                        
                        fluidRow(
                         box(
                            title = tagList(shiny::icon("money"), "Ventas de dos productos lácteos"), width = 6,  br(),
                            column(width = 6,img(class="imgIcon",src='img/prod1.png',width="40%"), br(),p("Con calcio",class="Tipo",align= "center")  ),
                            column(width = 6,img(class="imgIcon",src='img/prod2.png',width="40%"),br(),p("Sin calcio",class="Tipo",align= "center")  )
                            
                         ),
                         box( 
                           title = tagList(shiny::icon("calendar"), "Período de ventas considerado"), width = 6,  br(),
                           p("1/Septiembre/2020") , br(),p("30/Enero/2021")
                         )
                          ),
                       fluidRow(
                         h2(em("Conjuntos de datos inicial"),icon("database",lib = "font-awesome")),
                         box(title="Variables",width = 2,
                           HTML("<ul>
                         <li>ID de ticket</li>
                         <li>Línea de ticket</li>
                         <li>Fecha</li>
                         <li>Código</li>
                         <li>Cantidad</li>
                         <li>Precio</li>
                         <li>Precio con impuestos</li>
                         <li>Descuento</li>
                         <li>Importe</li>
                         <li>Importe con impuestos</li>
                        </ul>")),
                         box(collapsible = TRUE,width = 10,
                          # DT::dataTableOutput("Datos1",height = 250)
                          "Un listado mono"
                         )
                         
                       ),br(),
                     
                       fluidRow( 
                         h2("Transformación de los datos"),
                         box(width = 4,
                             title = h3("Transformación de variables"),
                             column(6,"Factorización"),
                             column(6,"Reformateo de variables numéricas")
                             ), 
                         box(width = 4,
                             title = h3("Creación de variables"),
                             column(4,"Temporales",br(), "Año, mes, día de la semama, día del mes y semana del año"),
                             column(4,"Ventas" , br(), "Volumen diario de ventas"),
                             column(4,"Dummies", br(), "Día de la semana y mes del año")
                             ), 
                         box(width = 4,
                             title= h3("Datos faltantes"),
                             column(5,  div(h1("2"))),
                             column(7,div(p("25/12/2020"),br(),p("01/01/2021")))
                             ),
                         
                        
                       ) ,
                        
                       
                        
                        
                        
                       
                        br(),hr(),br(),
                        includeHTML("footer.Rhtml")
                        ),
               tabPanel("Análisis exploratorio", br(),
                        fluidRow( 
                          column(12,
                                 h1("Análisis exploratorio de datos para dos productos lácteos"),br()) ),
                        
                        
                        
                        br(),hr(),br(),
                        includeHTML("footer.Rhtml")
                        ),
               tabPanel("Modelado", br(),
                        
                        fluidRow( 
                          column(12,
                                 h1("Construcción y evaluación de modelos predictivos"),br()) ),
                        br(),hr(),br(),
                        includeHTML("footer.Rhtml")
                        )
    ),
  #### Conclusiones ####
      tabPanel("Conclusiones", br(),
               fluidRow( 
                 column(12,
                        h1("Conclusiones"),br()) ),
               
               br(),hr(),br(),
               includeHTML("footer.Rhtml")
               )
)

)