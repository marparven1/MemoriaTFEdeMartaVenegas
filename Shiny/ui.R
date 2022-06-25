
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
                         tabBox(title = "Selectores",width = "3",
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
        #### Listado vbles ####
				fluidRow(
				  HTML('<div class="section-header"><h2>Variables de la muestra de tickets</h2></div>
						<div class="row">
						<div class="column" ">
						<!-- feature -->
						<div class="feature">
                              <i class="feature-icon fa fa-receipt"></i>
                              <div class="feature-content">
                              <h4>Identificador de ticket</h4>
                              <p>Variable numérica que identifica unívocamente a cada ticket de venta.</p>
                              </div>
                              </div>
						<!-- /feature -->

						<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-barcode"></i>
							<div class="feature-content">
								<h4>Línea ticket</h4>
								<p>Variable numérica con la línea correspondiente del ticket..</p>
							</div>
						</div>
						<!-- /feature -->

						<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-calendar"></i>
							<div class="feature-content">
								<h4>Fecha</h4>
								<p>Fecha en que se realizó la venta.</p>
							</div>
						</div>
						<!-- /feature -->
						
								<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-th-large"></i>
							<div class="feature-content">
								<h4>Código producto</h4>
								<p>Variable que corresponde al identificador del producto.</p>
							</div>
						</div>
						<!-- /feature -->
								<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-clock-o"></i>
							<div class="feature-content">
								<h4>Cantidad</h4>
								<p>Número de items vendidos de un determinado producto para la línea correspondiente.</p>
							</div>
						</div>
						<!-- /feature -->
						</div>
						<div class="column" ">
    		<!-- feature -->
					<div class="feature">
                              <i class="feature-icon fa fa-money-bill"></i>
                              <div class="feature-content">
                              <h4>Precio</h4>
                              <p>Precio base del artículo libre de impuestos, euros.</p>
                              </div>
                              </div>
						<!-- /feature -->

						<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-euro-sign"></i>
							<div class="feature-content">
								<h4>Precio con impuestos:</h4>
								<p>Precio de venta del artículo, en euros.</p>
							</div>
						</div>
						<!-- /feature -->

						<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-percent"></i>
							<div class="feature-content">
								<h4>Descuento</h4>
								<p>Descuento aplicado</p>
							</div>
						</div>
						<!-- /feature -->
						
								<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-tag"></i>
							<div class="feature-content">
								<h4>Importe</h4>
								<p>Importe de la compra libre de impuestos, en euros.</p>
							</div>
						</div>
						<!-- /feature -->
								<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-tags"></i>
							<div class="feature-content">
								<h4>Importe con impuestos</h4>
								<p>Importe a pagar por el comprador, en euros.</p>
							</div>
						</div>
						<!-- /feature -->
					</div></div>'
				  )
				),
				
				#### / Listado vbles ####
				
				br(),hr(),br(),
				fluidRow(
				  HTML('<h2>TRANSFORMACIÓN DE LOS DATOS</h2>
				  <div class="row">
				  <div class="column" >
				  <h3>Transformación de variables</h3>
				  <p style="text-align: center;">Factorización de las variables línea de ticket y código de producto.</p>
				  </div>
				  <div class="column" >
				  <h3>Datos faltantes</h3>
				  <p style="text-align: center;">Datos faltantes para los días de Navidad y Año nuevo.</p>
				  </div>
				  </div>')),
				fluidRow( 
				HTML('<div class="section-header"><h3>Creación de variables</h3></div>
					<div class="row">
					
						<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-clock-o"></i>
							<div class="feature-content">
								<h4>Variables temporales</h4>
								<p>De la fecha se han extraído las siguientes variables: Año, mes, día de la semama, día del mes y semana del año.</p>
							</div>
						</div>
						<!-- /feature -->
						
								<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-shopping-bag"></i>
							<div class="feature-content">
								<h4>Variable ventas</h4>
								<p>Volumen diario de ventas.</p>
							</div>
						</div>
						<!-- /feature -->
								<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-tags"></i>
							<div class="feature-content">
								<h4>DUMMIES</h4>
								<p>Creación de variables dummy para el día de la semana y mes del año con la intención de representar la pertenencia de cada instancia a los distintos grupos.</p>
							</div>
						</div>
						<!-- /feature -->	</div>')
				
				),
                        
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
                            width = 4, title ="Transacciones",
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
                         h2("Gráficas")
                       ),
                       
                       fluidRow(
                         tabBox(
                           title = "VENTAS",side = "right", 
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
                                      mainPanel(width = 8,h2("Comparación del volumen total de ventas"),
                                                plotOutput("VentasTotalComp")
                                      ),
                                      sidebarPanel(width = 4,
                                        "El volumen de ventas del producto con calcio ha sido ligeramente 
                                        superior, con un volumen total de ventas de 188867 unidades frente a 
                                        las 169196 unidades vendidas del producto que no lleva calcio.", br(),br(),
                                        HTML("<table>  <tr>    <th>TIPO</th>    <th>IMPORTE MEDIO TRANSACCIÓN</th>    <th>PRECIO MEDIO PRODUCTO</th>  </tr>  <tr>    <td>Con calcio</td>    <td>4.07</td>    <td>1.49</td>  </tr>  <tr>    <td>Sin calcio</td>    <td>3.31</td>    <td>1.39</td>  </tr></table>"),
                                        br(), "Nota: no siempre se opta por la opción mas económica."
                                      )
                                    )
                                    ),
                           
                           tabPanel("Granularidad mensual",br(),
                                   
                                    sidebarLayout(
                                      mainPanel(width = 8,h2("Volumen de ventas mensual"),
                                                plotlyOutput("VentasMensuales")
                                      ),
                                      sidebarPanel(width = 4,
                                                   "Comportamiento inicial de ventas creciente, hasta obtener récord de ventas en el mes de Octubre,
                                                   con un volumen total de ventas de 68805 artículos.", br(),"Mayor volumen de ventas del producto con calcio."
                                       )
                                    )
                                    ),
                           
                           tabPanel("Granularidad semanal", br(),
                                     
                                    sidebarLayout(
                                      mainPanel(width = 8,h2("Volumen medio de ventas según día de la semana"),
                                                plotlyOutput("VentasSemanales")
                                      ),
                                      sidebarPanel(width = 4,
                                                   "Mayor volumen de ventas los Jueves y Sábados, con una media, respectivamente de 2445 y 2503 items vendidos.", br(),
                                                   "Los Domingos, el volumen de ventas disminuye considerablemente, 
                                                   superando el número medio de ventas del artículo sin calcio al del 
                                                   producto que sí tiene."
                                      )
                                    )
                                    ),
                           tabPanel("Precio y descuento",br(),
                                    sidebarLayout(
                                      mainPanel(width = 8,h2("Estudio del precio y descuentos")
                                      ),
                                      sidebarPanel(width = 4,
                                                   "ssdfsdf"
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
                                 h1("Construcción y evaluación de modelos predictivos") ),
                          column(12,
                                 p("Se han aplicado diferentes modelos predictivos a los datos de transacciones con el objetivo de predecir
                                   el volumen diario de ventas. 
                                   La etapa de modelado ha consistido en la aplicación de modelos estadísticos clásicos y modelos de
                                   aprendizaje automático. Para cada algoritmo utilizado, salvo para el análisis de series temporales, se han 
                                   construido tres diferentes:"))),
                        fluidRow( 
                          HTML('<div class="row">
                          <!-- feature -->
                          <div class="feature">
                          <i class="feature-icon fa fa-atom"></i>
                          <div class="feature-content">
                          <h4>Total de ventas</h4>
                          <p style="margin-right:100px;">Predicción del volumen total de ventas diario, es decir, volumen de ventas de la suma de los dos tipos de productos, con y sin calcio.</p>
                          </div>
                          </div>
                          <!-- /feature -->

								          <!-- feature -->
								          <div class="feature">
								          <i class="feature-icon fa fa-blender"></i>
								          <div class="feature-content">
								          <h4>Con calcio</h4>
								          <p>Predicción del volumen de ventas diario para el producto con calcio.</p>
								          </div>
								          </div>
								          <!-- /feature -->
								          
								          <!-- feature -->
								          <div class="feature">
								          <i class="feature-icon fa fa-blender-phone"></i>
								          <div class="feature-content">
								          <h4>Sin calcio</h4>
								          <p>Predicción del volumen de ventas diario para el producto sin calcio.</p>
								          </div>
								          </div>
								          <!-- /feature -->	</div>')
                        ),
								          fluidRow(
								            column(12,
								                   p("Posteriormente, realizaremos una comparación de las predicciones de la suma de productos con
								                     la suma de las predicciones proporcionadas por cada modelo individual.
								                     Para los diferentes modelos entrenados, se recogerá su rendimiento para 
								                     compararlos y elegir el mejor modelo para predecir la demanda."))
								          ),hr(),
								          fluidRow(
								            column(12,h2("Partición de los datos de entrenamiento y testeo")),
								            
								            column(4),
								            column(2,
								                   div(class="panel panel-default",
								                       div(class="panel-body",  width = "600px", 
								                           align = "center",
								                           div(
								                             h5(
								                               "Datos de entrenamiento", icon("arrows-spin")
								                             )
								                           ),
								                           div(
								                             p("80%", class="NumGran")
								                           )))
								            ),
								            column(2,
								                   div(class="panel panel-default", 
								                       div(class="panel-body",  width = "600px",
								                           align = "center",
								                           div(
								                             h5(
								                               "Datos de testeo", icon("arrows-to-dot")
								                             )
								                           ),
								                           div(br(),
								                             p("20%", class="NumGran")
								                           )))
								                   ),
								            column(4),
								            br(),
								            column(12,
								                   p("De esta manera, para mantener la temporalidad de los datos, tomamos los 145 
								                     primeros registros para entrenar el modelo y 36 para el testeo. Esto
								                     corresponde a entrenar los modelos con datos diarios desde el 1 de Agosto al
								                     23 de Diciembre, para posteriormente realizar predicciones del 24 de Diciembre
								                     al 30 de Enero."))
								          ),
								          fluidRow(
								            column(12,h2("Modelado")),br(),
								            tabBox(
								              title = "Modelos",
								              # The id lets us use input$tabset1 on the server to find the current tab
								              id = "Modelos", 
								              tabPanel("Regresión de Poisson", 
								                       tabBox(
								                         tabPanel(
								                           "Total"
								                         ),
								                         tabPanel(
								                           "Sin calcio"
								                           
								                         ),
								                         tabPanel(
								                           "Con calcio"
								                           
								                         )
								                       )
								                       ),
								              tabPanel("Binomial Negativa",
								                       tabBox(
								                         tabPanel(
								                           "Total"
								                         ),
								                         tabPanel(
								                           "Sin calcio"
								                           
								                         ),
								                         tabPanel(
								                           "Con calcio"
								                           
								                         )
								                       )
								                       ),
								              tabPanel("Series temporales",
								                    "FDFDF"
								                       ),
								              tabPanel("SVM",
								                       tabBox(
								                         tabPanel(
								                           "Total"
								                         ),
								                         tabPanel(
								                           "Sin calcio"
								                           
								                         ),
								                         tabPanel(
								                           "Con calcio"
								                           
								                         )
								                       )
								                       ),
								              tabPanel("KNN",
								                       tabBox(
								                         tabPanel(
								                           "Total"
								                         ),
								                         tabPanel(
								                           "Sin calcio"
								                           
								                         ),
								                         tabPanel(
								                           "Con calcio"
								                           
								                         )
								                       )
								              ),
								              tabPanel("XGBoost",
								                       tabBox(
								                         tabPanel(
								                           "Total"
								                         ),
								                         tabPanel(
								                           "Sin calcio"
								                           
								                         ),
								                         tabPanel(
								                           "Con calcio"
								                           
								                         )
								                       )
								              )
								            )
								            
								          ),
                        
                          
                        br(),hr(),br(),
                        fluidRow(column(12)),
                        fluidRow( includeHTML("footer.Rhtml"))
                       
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



