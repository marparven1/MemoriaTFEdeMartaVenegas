
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
                      br(),hr(),br(),
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
                              asociación y descubrir conjuntos de items frecuentes."))
                       ),
                       br(),
                      fluidRow(
                        h2("Configuración del algoritmo a priori", class="center"),
                        column(2),
                        column(4,
                               div(class="panel panel-default", 
                                   div(class="panel-body",   align = "justify",
                                       div(
                                         h3(
                                           "Configuración inicial"
                                         ),
                                         div(
                                           shiny::HTML("<ul>
                                                       <li><b>Confianza mínima</b>: 50%</li>
                                                       <li><b>Soporte mínimo</b>: 20 compras</li>
                                                       <li><b>Problema</b>: Recomendación de los productos más vendidos: 1096 y 1033</li>
                                                       </ul>")
                                           )
                                       )
                                   )
                               )
                        ),
                        column(4,
                               div(class="panel panel-default",
                                   div(class="panel-body",    align = "justify",
                                       div(
                                         h3(
                                           "Configuración final"
                                         ),
                                         div(
                                           shiny::HTML("<ul>
                                                       <li><b>Confianza mínima</b>: 18%</li>
                                                       <li><b>Soporte mínimo</b>: 15 compras</li>
                                                       <li><b>Problema</b>: Introducción en el antecedente de los productos más vendidos</li>
                                                       </ul>")
                                         )
                                       )
                                     
                                   )
                               )
                        ),
                        column(2)
                      ),
                      
                      
                      br(),
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
                      fluidRow(h1("3. Conclusiones"), br()),
                       fluidRow(
                         class="container",
                     
                         box(
                           title = "Productos más vendidos", width = 3,  class="BoxCesta",
                           "La venta conjunta de los productos 1033 y 1096 se ha producido en un 1.23% de las transacciones, unas 170 veces."
                         ),
                         
                         box( title = "Patrón de ventas", class="BoxCesta",
                              width = 3, 
                              "Uno o dos productos diferentes por transacción."
                         ),
                         box(
                           title = "Reglas robustas",width = 3, class="BoxCesta",
                           "No se deben al azar, existe un patrón de comportamiento de ventas real."
                         )
                       ),
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
                            column(width = 6,img(class="imgIcon",src='img/prod1.png',width="20%"), br(),h4("Con calcio",class="Tipo")  ),
                            column(width = 6,img(class="imgIcon",src='img/prod2.png',width="20%"),br(),h4("Sin calcio",class="Tipo")  )
                            
                         ),
                         box( 
                           title = tagList(shiny::icon("calendar"), "Período de ventas considerado"), width = 6,  br(),
                           p("1/Septiembre/2020") , br(),p("30/Enero/2021")
                         )
                          ),
                        br(),hr(),br(),
                       fluidRow(
                         h2("Variables",icon("database",lib = "font-awesome")),
                         p("A continuación se muestran las variables del conjunto de datos inicial"),
                         br()
                       ),
                       
                       fluidRow(style="justify-content: center;width: 50%;",
                           column(2, icon("receipt",class="ICN")),
                           column(10,strong("ID ticket:"), "Variable numérica que identifica unívocamente a cada ticket de venta."
                       )
                       ),
                       br(),
                       fluidRow(style="justify-content: center;width: 50%;",
                         column(2, icon("barcode",class="ICN")),
                         column(10,strong("Línea ticket:"), "Variable numérica con la línea correspondiente del ticket."
                         )
                       ),
                       br(),
                       fluidRow(style="justify-content: center;width: 50%;",
                         column(2,icon("calendar",class="ICN")),
                         column(10,strong("Fecha:"), "Fecha en que se realizó la venta."
                         )
                       ),
                       br(),
                       fluidRow(style="justify-content: center;width: 50%;",
                         column(2,icon("code",class="ICN")),
                         column(10,strong("Código producto:"), "Identificador del producto."
                         )
                       ),
                       br(),
                       fluidRow(style="justify-content: center;width: 50%;",
                         column(2,icon("cards-blank",class="ICN")),
                         column(10,strong("Cantidad:"), "Número de items vendidos de un determinado producto."
                         )
                       ),
                       br(),
                       fluidRow(style="justify-content: center;width: 50%;",
                         column(2, icon("money-bill",class="ICN")),
                         column(10,strong("Precio:"), "Precio base del artículo libre de impuestos, euros."
                         )
                       ),
                       br(),
                       fluidRow(style="justify-content: center;width: 50%;",
                         column(2,icon("euro-sign",class="ICN")),
                         column(10,strong("Precio con impuestos:"), "Precio de venta del artículo, en euros."
                         )
                       ),
                     
                       br(),
                       fluidRow(style="justify-content: center;width: 50%;",
                         column(2, icon("percent",class="ICN")),
                         column(10,strong("Descuento:"), "Descuento aplicado."
                         )
                       ),
                       br(),
                       fluidRow(style="justify-content: center;width: 50%;",
                         column(2,  icon("tag",class="ICN")),
                         column(10,strong("Importe:"), " Importe de la compra libre de impuestos, en euros."
                         ),
                        
                       ),
                       br(),
                       fluidRow(style="justify-content: center;width: 50%;",
                         column(2, icon("tags", class="ICN")),
                         column(10,strong("Importe con impuestos:"), "Importe a pagar por el comprador, en euros."
                         )
                       ),
                       
                    
                      
                       br(),hr(),br(),
                       fluidRow( 
                         h2("Transformación de los datos"),
                         box(width = 4,
                             title = h3("Transformación de variables"),
                             column(6,"Factorización"),
                             column(6,"Reformateo de variables numéricas")
                             ), 
                         box(width = 4,
                             title = h3("Creación de variables"),
                             column(4,strong("TEMPORALES"),br(), "Año, mes, día de la semama, día del mes y semana del año"),
                             column(4,strong("VENTAS") , br(), "Volumen diario de ventas"),
                             column(4,strong("DUMMIES"), br(), "Día de la semana y mes del año")
                             ), 
                         box(width = 4,
                             title= h3("Datos faltantes"),
                             column(5,  div(h1("2", style="text-align: end;"))),
                             column(7,div(p("25/12/2020"),br(),p("01/01/2021")))
                             )
                       ) ,
                        
                        includeHTML("footer.Rhtml")
                        ),
               tabPanel("Análisis exploratorio", br(),
                        fluidRow( 
                          column(12,
                                 h1("Análisis exploratorio de datos para dos productos lácteos"),br()) ),
                        fluidRow(
                          shiny::HTML("<br><br><center> <h1>Objetivos</h1> </center>
                                            <br>")
                        ),
                        fluidRow(
                          column(3),
                          column(2,
                                 div(class="panel panel-default", 
                                     div(class="panel-body",  width = "600px",
                                         align = "center",
                                         div(
                                           tags$img(src = "img/uno.png", height = "50px")
                                         ),
                                         div(
                                           h5(
                                             "Encotrar un patrón de ventas de productos."
                                           )
                                         )
                                     )
                                 )
                          ),
                          column(2,
                                 div(class="panel panel-default",
                                     div(class="panel-body",  width = "600px", 
                                         align = "center",
                                         div(
                                           tags$img(src = "img/dos.png",     height = "50px")),
                                         div(
                                           h5(
                                             "Estudiar que variables influyen en el volumen de ventas de productos lácteos"
                                           )
                                         )
                                     )
                                 )
                          ),
                          column(2,
                                 div(class="panel panel-default",
                                     div(class="panel-body",  width = "600px", 
                                         align = "center",
                                         div(
                                           tags$img(src = "img/tres.png",   height = "50px")
                                         ),
                                         div(
                                           h5(
                                             "Describir la evolución de ventas con tiempo", icon("chart-line")
                                           )
                                         )
                                     )
                                 )
                          ),
                          column(3)
                        ),
                       hr(),
                          
                          fluidRow(
                            h2("Resumen de los datos"),br(),
                            ),
                       
                        fluidRow(id = "resumen", 
                          box(style="text-align: justify",
                            width = 4, title ="Ventas totales",
                           p("97143",style= "48pt") ,  "1978 unidades vendidas en una media de 537 transacciones diarias."
                          ),
                        
                          box(style="text-align: justify",
                            title = "Importe por transacción", width = 4,
                            "Medio: 4,25€" , br(), "Máximo: 196,68€",
                            br(),"Mínimo: 69 céntimos", br(),"25% de las transaciones han tenido 
                            un importe mayor a 8.34€"
                          ),
                          box(style="text-align: justify",
                            title = "Tamaño de las transacciones",width = 4,
                            "El 75% de las transacciones han sido de 6 items o menos." , br(),
                            "Tamaño máximo: 132 items."
                          )
                        ),
                       hr(),
                       
                       fluidRow(
                         h2("Gráficas"),br(),
                       ),
                       
                       fluidRow(
                         tabBox(
                           title = "Gráficas EDA",side = "right", 
                           # The id lets us use input$tabset1 on the server to find the current tab
                           id = "graficasEDA", height = "500px",width = 100,
                           tabPanel("Evolución ventas",br(),
                                    sidebarLayout(
                                      mainPanel(width = 8,h2("Evolución del volumen de ventas diario"),
                                                plotlyOutput("EvolVentas")
                                      ),
                                      sidebarPanel(width = 4,
                                        "Gran variación del volumen de ventas diario en función del día de la semana.",br(), 
                                          "Picos donde el volumen de ventas fué superior al habitual, 
                                          a mediados de Octubre y a mediados de Diciembre del año 2020."
                                      )
                                    )
                                    ),
                           
                           tabPanel("Comparación de ventas",br(),
                                    sidebarLayout(
                                      mainPanel(width = 8,h2("Volumen total de ventas"),
                                                plotOutput("VentasTotalComp")
                                      ),
                                      sidebarPanel(width = 4,
                                        "El volumen de ventas del producto con calcio ha sido ligeramente 
                                        superior, con un volumen total de ventas de 188867 unidades frente a 
                                        las 169196 unidades vendidas del producto que no lleva calcio.", br(),br(),
                                        HTML("<table>  <tr>    <th>TIPO</th>    <th>IMPORTE MEDIO TRANSACCIÓN</th>    <th>PRECIO MEDIO PRODUCTO</th>  </tr>  <tr>    <td>Con calcio</td>    <td>4.07</td>    <td>1.49</td>  </tr>  <tr>    <td>Sin calcio</td>    <td>3.31</td>    <td>1.39</td>  </tr></table>")
                                      )
                                    )
                                    ),
                           
                           tabPanel("Granularidad mensual",br(),
                                   
                                    sidebarLayout(
                                      mainPanel(width = 8,
                                                plotlyOutput("VentasMensuales")
                                      ),
                                      sidebarPanel(width = 4,
                                                   "osdnfsidfpijsdfpsjdfpsjdfposjdfposjdpo"
                                       )
                                    )
                                    ),
                           
                           tabPanel("Granularidad semanal", br(),
                                     
                                    sidebarLayout(
                                      mainPanel(width = 8,br(),
                                                plotlyOutput("VentasSemanales")
                                      ),
                                      sidebarPanel(width = 4,
                                                   "osdnfsidfpijsdfpsjdfpsjdfposjdfposjdpo"
                                      )
                                    )
                                    )
                           
                         )
                       ),
                       
                       
                       
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



