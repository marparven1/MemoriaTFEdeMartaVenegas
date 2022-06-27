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
                         column(12,h1("Análisis de cesta de la compra con datos de tickets de un supermercado")),
                         column(12,
                                p("Se ha aplicado un análisis de cesta de la compra a unos datos que proceden de una muestra de tickets 
                                  correspondiente a transacciones de una cadena de supermercados. La muestra contiene un total de 
                                  7801 tickets que incluyen 4631 artículos distintos.")
                                ),
                         column(12, h2("Muestra de transacciones"))
                         ),
                       fluidRow(
                         box(
                           title = "Tickets", width = 6, solidHeader = TRUE, 
                            img(class="imgIcon",src='img/Ticket.png',width="20%"), 
                           h3("7801",align= "center")
                         ),
                         box(
                           title = "Artículos", width = 6, solidHeader = TRUE,
                           img(class="imgIcon",src='img/Articulos.png',width="20%"),h3("4631",align= "center")
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
                              asociación y descubrir conjuntos de items frecuentes. Para ello  hace una búsqueda
                              por niveles de complejidad de menor a mayor tamaño de itemsets, es decir, si un itemset es 
                              considerado infrecuente, ningún superset podrá ser considerado frecuente."))
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
                                  tabPanel("Grafo",
                                           
                                           h3("Resultado de las reglas de asociación"),
                                           img(class="imgIcon",src='img/grafoReglas.png',width="100%"),
                                                p("Venta frecuente de los productos 1096 y 1033.")
                                           ),
                                  
                                  tabPanel("Confianza", br()," ", br(),
                                           img(class="imgIcon",src='img/CestaConfianza.png',width="100%")
                                           ),
                                  
                                  tabPanel("Soporte", br(),
                                           "Soporte: frecuencia con que los objetos son comprados juntos.",
                                           img(class="imgIcon",src='img/CestaSoporte.png',width="100%")
                                           )
                                  ),
                                tabBox(title="Evaluación de las reglas",
                                       height = "350px",
                                       tabPanel("Generalidades",br(),
                                                "La transacción más repetida:", br(), img(class="imgIcon",src='img/BasketMasRepetida.png',width="100%"),
                                                br(),
                                                "Lift",br(),
                                                "Valores de este parámetro bastante altos, indicando que las reglas son robustas, es decir, no se 
                                                  deben a la aleatoriedad, sino a un patrón de comportamiento existente.",
                                                br(),
                                                "Regla más robusta:" , br(),img(class="imgIcon",src='img/BasketMasRobusta.png',width="100%")
                                       ),
                                       tabPanel("Test exacto fisher", 
                                                br(),"Test exacto de Fisher: las reglas muestran un comportamiento real de ventas.",br(),
                                                img(class="imgIcon",src='img/MarketTestFisher.png',width="90%"), 
                                                img(class="imgIcon",src='img/MarketResTestFisher.png',width="65%")
                                       )
                                )
                                ),
                      
                      fluidRow(h1("3. Conclusiones"),
                       fluidRow(
                         class="container",
                         box( title = "Patrón de ventas", class="BoxCesta",
                              width = 3, 
                              "Uno o dos productos diferentes por transacción."
                         ),
                         box(
                           title = "Productos más vendidos", width = 3,  class="BoxCesta",
                           "La venta conjunta de los productos 1033 y 1096 se ha producido en un 1.23% de las transacciones, unas 170 veces."
                         ),
                         box(
                           title = "Reglas robustas",width = 3, class="BoxCesta",
                           "No se deben al azar, existe un patrón de comportamiento de ventas real."
                         )
                       ),
                       br(),hr(),br(),
                       includeHTML("footer.Rhtml")
                       )),
  #### Data science process #### 
    navbarMenu("Proceso de ciencia de datos",
               tabPanel("Preprocesado", 
                        fluidRow( 
                                 h1("Adquisición de los datos y preparación"),
                                 h2("Muestra de transacciones")
                                 ) ,
                        
                        fluidRow(class="ColorFondo",
                         box(
                            title = tagList(shiny::icon("money"), "Ventas de dos productos lácteos"), width = 6,  
                            column(width = 6,img(class="imgIcon",src='img/prod1.png',width="20%"), br(),h4("Con calcio",class="Tipo")  ),
                            column(width = 6,img(class="imgIcon",src='img/prod2.png',width="20%"),br(),h4("Sin calcio",class="Tipo")  )
                            
                         ),
                         box( 
                           title = tagList(shiny::icon("calendar"), "Período de ventas considerado"), width = 6, 
                           column(1),
                           column(5,  
                                     div( width = "600px", 
                                         align = "center",
                                      
                                           h4("1-Septiembre-2020"))),
                           column(5,   
                                     div(  width = "600px", 
                                         align = "center",
                                           h4( "30-Enero-2021") )),
                           column(1)
                           
                          
                           
                           
                           
                         )
                          ),
                      hr(),
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
				
				hr(),
				fluidRow(h2("TRANSFORMACIÓN DE LOS DATOS")),
				fluidRow(class="ColorFondo",
				  HTML('
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
				hr(),
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
				
				
#### EDA ####				
                        ),
               tabPanel("Análisis exploratorio",
                        fluidRow( 
                          column(12,
                                 h1("Análisis exploratorio de datos para dos productos lácteos"),
                                 h2("Objetivos")) ),
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
                            h2("Resumen de los datos")
                            ),
                       
                        fluidRow(id = "resumen", 
                          box(style="text-align: justify",
                            width = 4, title ="Transacciones",
                           p("97143",style= "text-size: 48pt; text-align: center;") ,  "1978 unidades vendidas en una media de 537 transacciones diarias."
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
                                      mainPanel(width =7,h2("Comparación del volumen total de ventas"),
                                                plotOutput("VentasTotalComp")
                                      ),
                                      sidebarPanel(width = 5,
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
                                    )
                         )
                       ),
                       hr(),
                       includeHTML("footer.Rhtml")
                        ),
                        
               tabPanel("Modelado", 
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
								                   div(class="panel panel-default", style="height: 193px;",
								                       div(class="panel-body",  width = "600px",
								                           align = "center",
								                           div(
								                             h5(
								                               "Datos de testeo", icon("arrows-to-dot")
								                             )
								                           ),
								                           div(
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
								            column(12,h2("Modelado clásico")),
								            tabBox(
								              title = "Modelos",width = 100,
								              # The id lets us use input$tabset1 on the server to find the current tab
								              id = "ModelosClasicos", 
								              tabPanel("Regresión de Poisson", 
								                       tabBox(width = 100,
								                         tabPanel(
								                           "General",br(),
								                           HTML(' <div class="row" style="margin-top: 0px">
								                                  <div class="column3" >
                                              <h3>Variable respuesta</h3>
                                                <h4>Volumen de diario de ventas</h4>
                                              <p>Variable discreta de tipo conteo</p>
                                              <img src="img/Poisson.png" style="width: 95%;">
                                              <p>Problema: sobredispersión de los datos</p>
                                            </div>
                                             <div class="column3" >
                                              <h3>Variables explicativas</h3>
                                                 <ul>
                                                  <li><p>Precio medio con impuestos</p></li>
                                                  <li><p>Descuento medio con impuestos</p></li>
                                                  <li><p>Día de la semana</p></li>
                                                  <li><p>Mes del año</p></li>
                                                 </ul>
                                            </div>
                                            <div class="column3" >
                                              <h3>Datos</h3>
                                              <p>Datos con variables categóricas en forma de factor</p>
                                              <p>Datos con variables en formato dummy</p>
                                            </div>
                                          </div>')
								                         ),
								                         tabPanel(
								                           "Total",
								                           column(6,h3("Modelado"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Modelo seleccionado según el criterio de información de Akaike</h4> 
                                                     <p>Para predecir el volumen diario de ventas para el producto con calcio se ha seleccionado el modelo
                                                     con variables dummy, ya que el valor del AIC=26958.345 es menor que el obtenido
                                                     con el conjunto de datos factorizado, AIC = 30079.583.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->
								                                       <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Variables significativas en el modelo</h4> 
                                                     <p>Todas las variables salvo el precio, y si la venta es un Domingo o durante el mes 
                                                     de agosto pueden considerarse significativas en el volumen de ventas.En particular, si la venta se realiza un Sábado se puede afirmar que el volumen de ventas aumentará en 11 unidades.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->')
								                           ),
								                           column(6,h3("Resultados"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Contraste de bondad de ajuste</h4> 
                                                     <p>El p-valor = 0, por tanto, no existen evidencias significativas para afirmar que el modelo es adecuado.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Métricas obtenidas en el testeo</h4> 
                                                     <p>El modelo generaliza bien pero el valor de la raíz del error cuadrático medio es bastante alto en comparación con el orden del volumen de ventas.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->'),
								                                  img(src='img/Poisson1.png', style="width: 80%;margin-top: 25px;" )
								                                  )
								                           
								                         ),
								                         tabPanel(
								                           "Con calcio",
								                           column(6,h3("Modelado"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Modelo seleccionado según el criterio de información de Akaike</h4> 
                                                     <p>Para predecir el volumen diario de ventas del producto sin calcio se ha seleccionado el modelo
                                                     con variables dummy, ya que el valor del AIC=12690.96 es menor que el obtenido
                                                     con el conjunto de datos factorizado, AIC = 13961.937</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->
								                                       <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Variables significativas en el modelo</h4> 
                                                     <p>Todas las variables introducidas en el modelo influyen en el volumen de ventas del producto con calcio salvo el precio de venta.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->')
								                           ),
								                           column(6,h3("Resultados"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Contraste de bondad de ajuste</h4> 
                                                     <p>El p-valor = 0, por tanto, no existen evidencias significativas para afirmar que el modelo es adecuado.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Métricas obtenidas en el testeo</h4> 
                                                     <p>El modelo generaliza bien al apliarlo en los datos de testeo, ya que las métricas han mejorado. Sin embargo, el valor de la raíz del error cuadrático medio es 
                                                     bastante alta en comparación con el orden del volumen de ventas.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->'),
								                                  img(src='img/Poisson2.png', style="width: 80%;margin-top: 25px;" )
								                           )
								                           
								                           
								                         ),
								                         tabPanel(
								                           "Sin calcio",
								                           column(6,h3("Modelado"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Modelo seleccionado según el criterio de información de Akaike</h4> 
                                                     <p>Para predecir el volumen total de ventas diario se ha seleccionado el modelo
                                                     con variables dummy, ya que el valor del AIC=16925.032 es menor que el obtenido
                                                     con el conjunto de datos factorizado, AIC = 18854.07</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->
								                                       <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Variables significativas en el modelo</h4> 
                                                     <p>De nuevo, la variable precio no es significativa para predecir el volumen de ventas. </p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->')
								                           ),
								                           column(6,h3("Resultados"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Contraste de bondad de ajuste</h4> 
                                                     <p>El p-valor = 0, por tanto, no existen evidencias significativas para afirmar que el modelo es adecuado.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Métricas obtenidas en el testeo</h4> 
                                                     <p>El modelo generaliza bien pero el valor de la raíz del error cuadrático medio es bastante alto en comparación con el orden del volumen de ventas.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->'),
								                                  img(src='img/Poisson3.png', style="width: 80%;margin-top: 25px;" )
								                                  )
								                           
								                           
								                         ),
								                         tabPanel("Sobredispersión",
								                                  p("Estos modelos se han desarrollando asumiendo que la distribución de las ventas diarias sigue una Poisson, 
								                                    caracterizándose esta distribución porque su esperanza y su varianza coinciden; pero esto no ocurre con 
								                                    nuestros datos."),
								                                  p("Por este motivo, podemos afirmar que el modelo de regresión de poisson no es adecuaado para modelar 
								                                    el volumen de ventas diario."),
								                                  p("A continuación podemos ver el constraste de sobresipersión en los modelos:"),
								                                  div(
								                                    column(4,img(src="img/SobreDisp1.png",style="width:80% , margin-bottom:10px")),
								                                    column(4,img(src="img/SobreDisp2.png",style="width:80% , margin-bottom:10px")),
								                                    column(4,img(src="img/SobreDisp3.png",style="width:80% , margin-bottom:10px"))
								                                  )
								                                 
								                                  )
								                       )
								                       ),
								              tabPanel("Binomial Negativa",
								                       tabBox(width = 100,
								                              tabPanel(
								                                "General",br(),
								                                HTML('
								                                <div class="row" style="margin-top: 0px">
								                                  <div class="column3" >
                                              <h3>Variable respuesta</h3>
                                                <h4>Volumen de diario de ventas</h4>
                                              <p>Variable discreta de tipo conteo</p>
                                              <p>Solución a la sobredispersión de los datos</p>
                                            </div>
                                            <div class="column3" >
                                              <h3>Datos</h3>
                                              <p>Datos con variables categóricas en forma de factor</p>
                                              <p>Datos con variables en formato dummy</p>
                                            </div>
                                             <div class="column3" >
                                              <h3>Variables explicativas</h3>
                                                 <ul>
                                                  <li><p>Precio medio con impuestos</p></li>
                                                  <li><p>Descuento medio con impuestos</p></li>
                                                  <li><p>Día de la semana</p></li>
                                                 </ul>
                                            </div>
                                          </div>')
								                              ),
								                         tabPanel(
								                           "Total",
								                           column(6,h3("Modelado"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Modelo seleccionado según el criterio de información de Akaike</h4> 
                                                     <p>Para predecir el volumen total de ventas diario se ha seleccionado el modelo
                                                     con variables dummy, con un valor del AIC=2227.36</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->
								                                       <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Variables significativas en el modelo</h4> 
                                                     <p>La variable más significativa es si la compra se realiza o no un Domingo, pudiendo afirmar que el volumen de ventas será menor si la venta se realiza un Domingo.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->')
								                           ),
								                           column(6,h3("Resultados"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Métricas obtenidas en el testeo</h4> 
                                                     <p>El modelo generaliza bien pero el valor de la raíz del error cuadrático medio es bastante alto en 
                                                     comparación con el orden del volumen de ventas.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->'),
								                                  img(src='img/BN1.png', style="width: 80%;margin-top: 25px;" )
								                           )
								                           
								                         ),
								                         tabPanel(
								                           "Con calcio",
								                           column(6,h3("Modelado"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Modelo seleccionado según el criterio de información de Akaike</h4> 
                                                     <p>Para predecir el volumen total de ventas diario se ha seleccionado el modelo
                                                     con variables dummy, con un valor del AIC=2044.261 frente al valor 2187.59 para el conjutno de datos de variables factorizadas.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->
								                                       <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Variables significativas en el modelo</h4> 
                                                     <p>La única variable significativa es si la compra se realiza o no un Domingo. El mes del año no es significativo del volumen de ventas.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->')
								                           ),
								                           column(6,h3("Resultados"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Métricas obtenidas en el testeo</h4> 
                                                     <p>El modelo generaliza bien pero el valor de la raíz del error cuadrático medio es bastante alto en 
                                                     comparación con el orden del volumen de ventas.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->'),
								                                  img(src='img/BN2.png', style="width: 80%;margin-top: 25px;" )
								                           )
								                           
								                         ),
								                         tabPanel(
								                           "Sin calcio",
								                           column(6,h3("Modelado"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Modelo seleccionado según el criterio de información de Akaike</h4> 
                                                     <p>Para predecir el volumen total de ventas diario se ha seleccionado el modelo
                                                     con variables dummy, con un valor del AIC=2014.79 frente al valor 2017.9 para el conjutno de datos de variables factorizadas.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->
								                                       <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Variables significativas en el modelo</h4> 
                                                     <p>El precio medio de venta no es una variable significativa en este modelo. Las variables significativas son el mes de Agosto y el día de la semana.
                                                     </p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->')
								                           ),
								                           column(6,h3("Resultados"),
								                                  HTML('
								                                    <!-- feature --> 
								                                     <div class="feature"> 
								                                     <i class="feature-icon fa fa-circle"></i> 
                                                     <div class="feature-content"> 
                                                     <h4>Métricas obtenidas en el testeo</h4> 
                                                     <p>Ambos resultados son bastante similares.</p> 
								                                     </div> 
								                                     </div> 
								                                    <!-- /feature -->'),
								                                  img(src='img/BN3.png', style="width: 80%;margin-top: 25px;" )
								                           )
								                          
								                           
								                         ),
								                         tabPanel("Comparación",
								                                  
								                                  tabBox(width = 100,
								                                         tabPanel( "Resultados",
								                                                   column(2),
								                                                   column(8,
								                                                          h3("Comparación de resultados del modelado"),
								                                                          p("En la tabla mostrada a continuación se observan las métricas obtenidas para los tres modelos:"),
								                                                          img(src='img/ResBN.png', style="margin-left: 25%;")
								                                                   ),
								                                                   column(2)
								                                                   
								                                         ),
								                                         tabPanel("Gráfico",
								                                                  column(12,h3("Comparación de la suma de predicciones con la predicción de la suma"),
								                                                         p("Mostramos un gráfico para comparar la predicción de ventas de la suma de
								                                         productos con la suma de las predicciones de cada uno de los productos
								                                         por separado.")),
								                                         column(7,plotlyOutput("CompModeladobN",height = 700)),
								                                         column(5, 
								                                                HTML('<!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                              <h4>Resultados similares</h4> 
                                                                <p>Los resultados obtenidos por la suma de predicciones son prácticamente los mismos que para la predicción de la suma, por lo que no variaría mucho utilizar un modelo u otro.</p> 
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->
								                                               <!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                            <h4>Mala representación del aumento de ventas</h4>
                                                              <p>Los modelos no han sabido captar el comporamiento creciente de las ventas trás un fuerte descenso de éstas el Domingo.</p>
								                                              </div>
								                                              </div>
								                                              <!-- /feature --> 
								                                             <!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                            <h4>Día festivo</h4>
                                                              <p>Tampoco ha generalizado bien el día 6 de Enero, ya que hubo un 
                                                              volumen de ventas muy inferior al que los modelos predicen, se trata de un día festivo</p>
								                                              </div>
								                                              </div>
								                                              <!-- /feature --> ')
								                                            
								                                          
								                                         )
								                                         )
								                                  )
								                                  
								                                  )
								                       )
								                       ),
								              tabPanel("Series temporales",
								                       tabBox(width = 100 , 
								                         tabPanel("Datos",
								                                  HTML('<!-- feature --> 
								                                              <div class="feature"> 
								                                              <i class="feature-icon fa fa-circle"></i> 
                                                              <div class="feature-content"> 
                                                              <h4>Datos diarios</h4> 
                                                              <p>Los datos de la serie son las ventas totales para cada día, considerando
                                                              un período S=7, es decir, datos semanales.</p> 
								                                              </div> 
								                                              </div> 
								                                              <!-- /feature --> 
								                                       <!-- feature --> 
								                                              <div class="feature"> 
								                                              <i class="feature-icon fa fa-circle"></i> 
                                                              <div class="feature-content"> 
                                                              <h4>Transformación de los datos</h4> 
                                                              <p>Al existir valores nulos, el 25 de Diciembre y 1 de Enero, se ha sumado una constante de 10 unidades a todas 
                                                              las observaciones.</p> 
								                                              </div> 
								                                              </div> 
								                                              <!-- /feature -->')
								                           
								                         ),
								                         tabPanel("Transformaciones",
								                                  column(1),
								                                  column(4,   img(src='img/FAS.png', style="width: 100%;margin-top: 25px;" )),
								                                  column(6, HTML('<!-- feature --> 
								                                              <div class="feature"> 
								                                              <i class="feature-icon fa fa-circle"></i> 
                                                              <div class="feature-content"> 
                                                              <h4>Transformación de BoxCox para estabilizar la varianza</h4> 
                                                              <p>Valor de lambda =1/2, el extremo inferior del intervalo de confianza, no el valor 0.6 que nos sugería la función.</p> 
								                                              </div> 
								                                              </div> 
								                                              <!-- /feature --> 
								                                       <!-- feature --> 
								                                              <div class="feature"> 
								                                              <i class="feature-icon fa fa-circle"></i> 
                                                              <div class="feature-content"> 
                                                              <h4>Transformaciones para estabilizar la media</h4> 
                                                              <p>La no estacionalidad de los datos se debe a que es un proceso integrado, ya que la FAS decrece lentamente en los 
                                                              retardos estacionales de período 7. Por ello, se hace una diferencia estacional.</p> 
								                                              </div> 
								                                              </div> 
								                                              <!-- /feature -->
								                                              <!-- feature --> 
								                                              <div class="feature"> 
								                                              <i class="feature-icon fa fa-circle"></i> 
                                                              <div class="feature-content"> 
                                                              <h4>Contraste de estacionariedad</h4> 
                                                              <p>Según el p-valor del test de Dickey-Fuller no existen evidencias significativas para asumir que el polinomio autoregresivo
                                                              tiene alguna raíz unitaria, la serie es estacionaria.</p> 
								                                              </div> 
								                                              </div> 
								                                              <!-- /feature -->')),
								                                  column(1)
								                         ),
								                         tabPanel("Resultados",
								                                 
								                                 column(5,
								                                        tabBox(width = 100,
								                                          tabPanel("FAS",img(src='img/FAS_dif.png', style="width: 100%;margin-top: 25px;" )),
								                                          tabPanel("FAP",img(src='img/FAP_dif.png', style="width: 100%;margin-top: 25px;" )),
								                                          tabPanel("Resultados",img(src='img/ResModelos.png', style="width: 100%;margin-top: 25px;" ))
								                                        )
								                                        
								                                        ),
								                                 column(6,
								                                        HTML('<!-- feature --> 
								                                              <div class="feature"> 
								                                              <i class="feature-icon fa fa-circle"></i> 
                                                              <div class="feature-content"> 
                                                              <h4>Modelo sugerido: ARIMA(0,1,1)_12</h4> 
                                                              <p>Trás estimar los parámetros, concluímos que el modelo no es adecuado, ya que los resíduos no pasan la diagnosis y además
                                                              según el test de Ljun-Box, no existen evidencias significativas para aceptar la incorrelación de los resíduos: p-valor = 0.002524 < 0.05 = alpha. Los resíduos no se comportan como un proceso de ruido blanco.</p> 
								                                              </div> 
								                                              </div> 
								                                              <!-- /feature --> 
								                                       <!-- feature --> 
								                                              <div class="feature"> 
								                                              <i class="feature-icon fa fa-circle"></i> 
                                                              <div class="feature-content"> 
                                                              <h4>No podemos encontrar un modelo que se ajuste a los datos</h4> 
                                                              <p>Ningino de los cuatro modelos ajustados pasaba la diagnosis, los resíduos no estaban incorrelados entre sí, y esa autocorrelación podría conducir a una exactitud del modelo predictivo y por tanto, a interpretaciones erróneas del volumen de ventas.</p> 
								                                              </div> 
								                                              </div> 
								                                              <!-- /feature -->
								                                           ')
								                                         ),
								                                 column(1)
								                         )
								                         
								                       )
								                   
								                       ))),
								          fluidRow(
								            column(12,h2("Aprendizaje automático")),br(),
								            tabBox(
								              title = "Resultados en el entrenamiento",width = 100,
								              # The id lets us use input$tabset1 on the server to find the current tab
								              id = "AprendizajeAutomatico", 
								              
								              tabPanel(
								                "Generalidades",
								                
								                HTML('<div class="row">
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle "></i>
								                       <div class="feature-content">
								                       <h4>Algoritmos de regresión</h4>
								                       <p>Para predecir el volumen de ventas diario se han aplicado los siguientes algoritmos de 
								                       regresión: máquinas de vector soporte, K-Nearest Neighbor Regression (KNN) y árboles de regresión, en particular, XGBoost. </p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle "></i>
								                       <div class="feature-content">
								                       <h4>Variables predictoras</h4>
								                       <p>Precio medio de venta con impuestos, descuento, mes del año y día de la semana.</p>
								                       <h4>Nota: No se ha introducido la variable año, ya que su varianza es prácticamente nula.</h4>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Validación cruzada</h4>
								                       <p>Con cinco grupos y tres repeticiones.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->	
								                       
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Estandarización de las variables</h4>
								                       <p>Se han escalado las variables para que estén todas en la misma escala, con el objetivo de obtener mejores métricas y para que los modelos minimicen el error al predecir el volumen de ventas.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->	
								                       
								                        <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Sin conjunto de validación</h4>
								                       <p>Debido a que únicamente se dispone de 181 registros y utilizar conjunto de datos de 
								                       validación conduciría a la obtención de modelos con peores métricas.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->	
								                     </div>')
								              ),
								              
								              tabPanel("SVM",
								                       tabBox(width = 100,
								                         tabPanel(
								                           "Hiperparámetros",
								                           HTML('<div class="section-header"><h3>Hiperparámetros del modelo</h3></div>
								                           <div class="row">
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Parámetro de costo, C</h4>
								                       <p>Este parámetro penaliza al modelo por cometer errores. Cuanto mayor sea su valor,
								                       menos probable es que el algoritmo realice una penalización errónea.</p>
								                       <p>Malla de valores entre 1 y 3.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->	
								                     </div>')
								                         ),
								                     tabPanel(
								                       "Total",
								                       HTML('<div class="section-header"><h3>Resultados del entrenamiento</h3>
								                       <p>A continuación se muestran los resultados del entrenamiento del modelo en los datos de entrenamiento.</p>
								                       </div>
								                           <div class="row">
								                           <div class="column"> 
								                           <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Métricas del mejor modelo</h4>
								                        <img src="img/ModeloSVM_Total.png" style="width: 95%;">
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                        
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Coeficiente de correlación, R^2</h4>
								                       <p>El modelo consigue explicar un 60.06% de la variabilidad total del volumen de ventas para los datos de entrenamiento.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                           <div class="column"> 
								                            <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Remuestreo en la validación cruzada</h4>
								                        <p>Las métricas no presentan gran variabilidad, ya que en la mayoría de ocasiones el modelo consigue explicar más del
								                        70% de la variabilidad del volumen de ventas. Por este motivo, el modelo es robusto y las predicciones serán fiables.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                        <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Error cuadrático medio alto</h4>
								                       <p>La raíz del error cuadrático medio es de 661 unidades, que es un valor alto para el volumen de ventas que se predice.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                     </div>')
								                       
								                     ),
								                         tabPanel(
								                           "Con calcio",
								                           HTML('<div class="section-header"><h3>Resultados del entrenamiento</h3>
								                       <p>A continuación se muestran los resultados del entrenamiento del modelo en los datos de entrenamiento.</p>
								                       </div>
								                           <div class="row">
								                           <div class="column"> 
								                           <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Métricas del mejor modelo</h4>
								                        <img src="img/ModeloSVM_Calcio.png" style="width: 95%;">
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                        
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Coeficiente de correlación, R^2</h4>
								                       <p>El modelo consigue explicar un 50.84% de la variabilidad total del volumen de ventas del producto con calcio  para los datos de entrenamiento.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                           <div class="column"> 
								                            <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Remuestreo en la validación cruzada</h4>
								                        <p>Las métricas no presentan gran variabilidad, ya que en la mayoría de ocasiones el modelo explica alrededor del
								                        77% de la variabilidad del volumen de ventas. Por este motivo, el modelo es robusto y las predicciones serán fiables.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                        <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Error cuadrático medio alto</h4>
								                       <p>La raíz del error cuadrático medio es de 410 unidades, que es un valor alto para el volumen de ventas que se predice.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                     </div>')
								                           
								                         ),
								                         tabPanel(
								                           "Sin calcio",
								                           HTML('<div class="section-header"><h3>Resultados del entrenamiento</h3>
								                       <p>A continuación se muestran los resultados del entrenamiento del modelo en los datos de entrenamiento.</p>
								                       </div>
								                           <div class="row">
								                           <div class="column"> 
								                           <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Métricas del mejor modelo</h4>
								                        <img src="img/ModeloSVM_SinCalcio.png" style="width: 95%;">
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                        
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Coeficiente de correlación, R^2</h4>
								                       <p>El modelo consigue explicar un 57.16% de la variabilidad total del volumen de ventas del producto sin calcio  para los datos de entrenamiento.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                           <div class="column"> 
								                            <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Remuestreo en la validación cruzada</h4>
								                        <p>La variabilidad no es tan evidente como para otros modelos.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                        <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Error cuadrático medio alto</h4>
								                       <p>La raíz del error cuadrático medio es de 309 unidades.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                     </div>')
								                           
								                         )
								                       )
								                       ),
								              tabPanel("KNN",
								                       tabBox(width = 100,
								                              tabPanel(
								                                "Hiperparámetros",
								                                HTML('<div class="section-header"><h3>Hiperparámetros del modelo</h3></div>
								                                <div class="row">
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Número de vecinos, k</h4>
								                       <p>Malla de valores: 3,5,7 y 9</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->	
								                     </div>')
								                              ),
								                     tabPanel(
								                       "Total",
								                       HTML('<div class="section-header"><h3>Resultados del entrenamiento</h3>
								                       <p>A continuación se muestran los resultados del entrenamiento del modelo en los datos de entrenamiento.</p>
								                       </div>
								                           <div class="row">
								                           <div class="column"> 
								                           <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Métricas del mejor modelo</h4>
								                        <img src="img/ModeloKNN_Total.png" style="width: 95%;">
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                        
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Coeficiente de correlación, R^2</h4>
								                       <p>El modelo consigue explicar un 56.69% de la variabilidad total del volumen de ventas para los datos de entrenamiento.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                           <div class="column"> 
								                            <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Remuestreo en la validación cruzada</h4>
								                        <p>Las métricas presentan gran variabilidad, ya que el coeficiente de correlación oscila entre un valor de 0.86 y 0.35. Por este motivo, el modelo no es muy robusto y las predicciones no serán del todo fiables.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                        <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Error cuadrático medio alto</h4>
								                       <p>La raíz del error cuadrático medio es de 693 unidades, que es un valor alto para el volumen de ventas que se predice.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                     </div>')
								                       
								                     ),
								                         tabPanel(
								                           "Con calcio",
								                           HTML('<div class="section-header"><h3>Resultados del entrenamiento</h3>
								                       <p>A continuación se muestran los resultados del entrenamiento del modelo en los datos de entrenamiento.</p>
								                       </div>
								                           <div class="row">
								                           <div class="column"> 
								                           <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Métricas del mejor modelo</h4>
								                        <img src="img/ModeloKNN_Calcio.png" style="width: 95%;">
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                        
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Coeficiente de correlación, R^2</h4>
								                       <p>El modelo consigue explicar un 47.7% de la variabilidad total del volumen de ventas del producto con calcio para los datos de entrenamiento.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                           <div class="column"> 
								                            <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Remuestreo en la validación cruzada</h4>
								                        <p>Las métricas presentan variabilidad, explicando en varias ocasiones un 70% de la variabilidad del volumen de ventas y en otras la variabilidad no lelga al 20%.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                        <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Error cuadrático medio alto</h4>
								                       <p>La raíz del error cuadrático medio es de 428 unidades, que es un valor alto para el volumen de ventas que se predice.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                     </div>')
								                           ),
								                         tabPanel(
								                           "Sin calcio",
								                           HTML('<div class="section-header"><h3>Resultados del entrenamiento</h3>
								                       <p>A continuación se muestran los resultados del entrenamiento del modelo en los datos de entrenamiento.</p>
								                       </div>
								                           <div class="row">
								                           <div class="column"> 
								                           <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Métricas del mejor modelo</h4>
								                        <img src="img/ModeloKNN_SinCalcio.png" style="width: 95%;">
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                        
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Coeficiente de correlación, R^2</h4>
								                       <p>El modelo consigue explicar un 50.56% de la variabilidad total del volumen de ventas del producto sin calcio para los datos de entrenamiento.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                           <div class="column"> 
								                            <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Remuestreo en la validación cruzada</h4>
								                        <p>Las métricas no presentan mucha variabilidad. En la mayoría de ocasiones, el modelo explica más del 50% de la variabilidad del volumen de ventas.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                        <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Error cuadrático medio alto</h4>
								                       <p>La raíz del error cuadrático medio es de 340 unidades, que es un valor alto para el volumen de ventas que se predice.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                     </div>')
								                           
								                         )
								                       )
								              ),
								              tabPanel("XGBoost",
								                       tabBox(width = 100,
								                         tabPanel(
								                           "Hiperparámetros",
								                           HTML('<div class="section-header"><h3>Hiperparámetros del modelo</h3></div>
								                           <div class="row">
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Hiperparametrizaciones</h4>
								                       <p>Se han probado cinco hiperparametrizaciones diferentes.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->	
								                     </div>')
								                         ),
								                     tabPanel(
								                       "Total",
								                       HTML('<div class="section-header"><h3>Resultados del entrenamiento</h3>
								                       <p>A continuación se muestran los resultados del entrenamiento del modelo en los datos de entrenamiento.</p>
								                       </div>
								                           <div class="row">
								                           <div class="column"> 
								                           <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Métricas del mejor modelo</h4>
								                        <img src="img/ModeloXGBoost_Total.png" style="width: 95%;">
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                        
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Coeficiente de correlación, R^2</h4>
								                       <p>El modelo consigue explicar un 52.73% de la variabilidad total del volumen de ventas para los datos de entrenamiento.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                           <div class="column"> 
								                            <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Remuestreo en la validación cruzada</h4>
								                        <p>De nuevo, las métricas presentan gran variabilidad, en ocasiones el modelo explica más del 85% del volumen de ventas y en otras no llega a explicar ni un 12%. Por este motivo, las prediciones no serán del todo fiables.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                        <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Error cuadrático medio alto</h4>
								                       <p>La raíz del error cuadrático medio es de 742 unidades, que es un valor alto para el volumen de ventas que se predice.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                     </div>')
								                       
								                     ),
								                         
								                         tabPanel(
								                           "Con calcio",
								                           HTML('<div class="section-header"><h3>Resultados del entrenamiento</h3>
								                       <p>A continuación se muestran los resultados del entrenamiento del modelo en los datos de entrenamiento.</p>
								                       </div>
								                           <div class="row">
								                           <div class="column"> 
								                           <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Métricas del mejor modelo</h4>
								                        <img src="img/ModeloXGBoost_Calcio.png" style="width: 95%;">
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                        
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Coeficiente de correlación, R^2</h4>
								                       <p>El modelo consigue explicar un 49.94% de la variabilidad total del volumen de ventas para los datos de entrenamiento.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                           <div class="column"> 
								                            <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Remuestreo en la validación cruzada</h4>
								                        <p>En este modelo, el valor del coeficiente de correlación se mantiene por encima de un 0.65 en la mayoría de ocasiones, por lo que el modelo es robusto y las predicciones serán fiables.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                        <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Error cuadrático medio alto</h4>
								                       <p>La raíz del error cuadrático medio es de 417 unidades, que es un valor alto para el volumen de ventas que se predice.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                     </div>')
								                         ),
								                         tabPanel(
								                           "Sin calcio",
								                           HTML('<div class="section-header"><h3>Resultados del entrenamiento</h3>
								                       <p>A continuación se muestran los resultados del entrenamiento del modelo en los datos de entrenamiento.</p>
								                       </div>
								                           <div class="row">
								                           <div class="column"> 
								                           <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Métricas del mejor modelo</h4>
								                        <img src="img/ModeloXGBoost_SinCalcio.png" style="width: 95%;">
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                        
								                       <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Coeficiente de correlación, R^2</h4>
								                       <p>El modelo consigue explicar un 53.42% de la variabilidad total del volumen de ventas para los datos de entrenamiento.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                           <div class="column"> 
								                            <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Remuestreo en la validación cruzada</h4>
								                        <p>Respecto al remuestreo en la validación cruzada, se trata de un modelo robusto, ya que las métricas no oscilan 
								                        tanto como en otros de modelos. El coeficiente de determinación varía entre un valor de 0.2808295 y 0.8770442, 
								                        pero en la mayoría de ocasiones se mantiene por encima de 0.5.
								                        Por este motivo, las predicciones serán algo más fiables, a pesar de no tener un valor de R2 especialmente elevado.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                       
								                        <!-- feature -->
								                       <div class="feature">
								                       <i class="feature-icon fa fa-circle"></i>
								                       <div class="feature-content">
								                       <h4>Error cuadrático medio alto</h4>
								                       <p>La raíz del error cuadrático medio es de 333 unidades, que es un valor alto para el volumen de ventas que se predice.</p>
								                       </div>
								                       </div>
								                       <!-- /feature -->
								                           </div>
								                     </div>')
								                             )
								                       )
								              )
								            )
								            
								          ),
								          
								          fluidRow( 
								            column(12,h3("Configuración de los mejores hiperparámetros y predicción del volumen de ventas")),
								            column(12,  p("para cada una de las tres variables respuesta se han configurado los tres modelos 
								                                  con los correspondientes hiperparámetros que ofrecían mejores métricas para posteriormente
								                                  aplicarlos a los datos de entrenamiento. De esta forma, se ha elegido un modelo final 
								                                  de cada varaible y se ha aplicado en los datos de testeo para predecir el volumen
								                                  de ventas diario."))
								           
								            ),
								         
								          fluidRow(
								            tabBox(width = 100,title = "Testeo",
								              tabPanel("Total", 
								                       tabBox(width = 100,
								                tabPanel( "Selección del modelo",
								                          div(width = 100,
								                            
								                            column(6,
								                                   HTML("<table>  
								                                          <tr>    <th>MODELO</th>     <th>RMSE</th>    <th>R2  </th>  </tr>
								                                          <tr>    <td>SVM</td>        <td>661</td>    <td>0.6</td>  </tr>
								                                          <tr>    <td>KNN</td>        <td>692</td>    <td>0.567</td>  </tr>
								                                          <tr>    <td>XGBoost</td>    <td>439</td>    <td>0.522</td>  </tr> 
								                                       </table>") )  ,
								                            column(6,
								                                   HTML('
								                                              <!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                              <h4>Modelo final para predecir el volumen de ventas total</h4>
								                                              <p>Máquina de vector soporte. Mejor coeficiente de correlación y modelo más robusto.</p>
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->
								                                             '))
								                           
								                          )
								                          ),
								                tabPanel("Testeo",
								                         h3("Predicción del volumen total de ventas. Máquina de vector soporte, SVM"),
								                         div(width = 100,
								                            
								                             column(6,
								                                   plotlyOutput("Total") )  ,
								                             column(6,
								                                    HTML('<!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                             <h4>Coeficiente de correlación</h4> 
								                                             <p>El modelo máquina de vector soporte explica un 58.6% de la variabilidad total del volumen de ventas en los datos de testeo. Este valor ha mejorado con respecto al entrenamiento, ha sabido generalizar con nuevos datos.</p>
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->
								                                               <!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                              <h4>Raíz del error cuadrático medio</h4>
								                                              <p>624 ventas, un valor alto para el volumen de ventas diario.</p>
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->'))
								                            
								                         )
								                       
								                         )
								              )
								                       ),
								              
								              tabPanel("Con calcio",
								                       tabBox(width = 100,
								                         tabPanel( "Selección del modelo",
								                                   div(width = 100,
								                                       
								                                       column(6,
								                                              HTML("<table> 
								                                                   <tr> <th>MODELO</th> <th>RMSE</th> <th>R2 </th> 
								                                                   </tr> <tr> <td>SVM</td> <td>410</td> <td>0.51</td> </tr> 
								                                                   <tr> <td>KNN</td> <td>428</td> <td>0.477</td> </tr> <tr> 
								                                                   <td>XGBoost</td> <td>256</td> <td>0.487</td> </tr> 
								                                                   </table>") )  ,
								                                       column(6,
								                                              HTML('<!-- feature --> 
								                                              <div class="feature"> 
								                                              <i class="feature-icon fa fa-circle"></i> 
                                                              <div class="feature-content"> 
                                                              <h4>Modelo final para predecir el volumen de ventas del 
                                                              producto con calcio.</h4> 
                                                              <p>XGBoost: Mejor valor de RMSE y es un modelo que presentaba 
                                                              robustez.</p> 
								                                              </div> 
								                                              </div> 
								                                              <!-- /feature --> ')
								                                              )
								                                      
								                                   )
								                                   ),
								                         tabPanel("Testeo",
								                                  h3("Predicción del volumen de ventas del producto con calcio. Gradient extreme boosting, XGBoost"),
								                                  div(width = 100,
								                                     
								                                      column(6,
								                                             plotlyOutput("Calcio") )  ,
								                                      column(6,
								                                             HTML('<!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                            
								                                             <h4>Coeficiente de correlación</h4> 
                                                             <p>El modelo XGBoost explica un 46.07% de la variabilidad total del volumen de ventas en los
                                                             datos de testeo. Este valor es ligeramente inferior respecto al entrenamiento, pero es
                                                             prácticamente idéntico.</p> 
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->
								                                               <!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                              <h4>Raíz del error cuadrático medio</h4>
                                                              <p>397 ventas, un valor alto para el volumen de ventas diario.</p>
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->'))
								                                     
								                                  )    
								                         )
								                       )
								                       ),
								              
								              tabPanel("Sin calcio",
								                       tabBox(width = 100,
								                              tabPanel( "Selección del modelo",
								                                        div(width = 100,
								                                           
								                                            column(6,
								                                                   HTML("<table> <tr> <th>MODELO</th> <th>RMSE</th> <th>R2 </th> </tr> <tr> <td>SVM</td> 
                                                                          <td>309</td> <td>0.57</td> </tr> <tr> <td>KNN</td> <td>340</td> <td>0.51</td> </tr>
								                                                        <tr> <td>XGBoost</td> <td>212</td> <td>0.52</td> </tr> </table>"))  ,
								                                            column(6,
								                                                   HTML('<!-- feature --> 
								                                              <div class="feature"> 
								                                              <i class="feature-icon fa fa-circle"></i> 
                                                              <div class="feature-content"> 
                                                              <h4>Modelo final para predecir el volumen de ventas del 
                                                              producto con calcio</h4> 
                                                              <p>Máquina de vector soporte: Mejor valor de coeficiente de correlación.
								                                              </div> 
								                                              </div> 
								                                              <!-- /feature --> ')
								                                            )
								                                            
								                                        )
								                              ),
								                              tabPanel("Testeo",
								                                       h3("Predicción del volumen de ventas del producto sin calcio. Máquina de vector soporte, SVM"),
								                                       div(width = 100,
								                                           
								                                           column(6,
								                                                  plotlyOutput("SinCalcio") )  ,
								                                           column(6,
								                                                  HTML('<!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                              <h4>Coeficiente de correlación</h4> 
                                                                <p>El modelo máquina de vector soporte explica un 60.08% de la variabilidad total del volumen de ventas en 
                                                                los datos de testeo. Este resultado es el mejor de todo el modelado.
                                                                El modelo ha sabido generalizar bastante bien con datos nuevos.
                                                                </p> 
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->
								                                               <!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                            <h4>Raíz del error cuadrático medio</h4>
                                                              <p>286 ventas, un valor alto para el volumen de ventas diario.</p>
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->'))
								                                           
								                                       )
								                                       
								                              )
								                              
								                       )
								                       ),
								              tabPanel("Comparación",
								                       tabBox(width = 100,
								                              tabPanel( "Resultados",
								                                        column(2),
								                                        column(8,
								                                               h3("Comparación de resultados del modelado"),
								                                               p("En la tabla mostrada a continuación se observan las métricas obtenidas trás entrenar los modelos en los correspondientes datos de testeo:"),
								                                               img(src='img/ResTesteo.png', style="margin:0 auto;")
								                                               ),
								                                        column(2)
								                                        
								                                        ),
								                              tabPanel("Gráfico",
								                                       column(12,h3("Comparación de la suma de predicciones con la predicción de la suma"),
								                                              p("Mostramos un gráfico para comparar la predicción de ventas de la suma de
								                                         productos con la suma de las predicciones de cada uno de los productos
								                                         por separado.")),
								                                       column(6,plotlyOutput("CompModelado",height = 700)),
								                                       column(6, 
								                                              HTML('<!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                              <h4>Suma de predicciones</h4> 
                                                                <p>Este modelo tiene un comportamiento más acorde a la realidad.</p> 
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->
								                                               <!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                            <h4>Valores extremos de ventas</h4>
                                                              <p>Los modelos no han sabido captar cuando el volumen de ventas era muy elevado, ya que las predicciones han sido
                                                              generalmente inferiores al valor real de ventas. Tampoco ha generalizado bien el día 6 de Enero, ya que hubo un 
                                                              volumen de ventas muy inferior al que los modelos predicen, se trata de un día festivo.</p>
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->
								                                              <!-- feature -->
								                                              <div class="feature">
								                                              <i class="feature-icon fa fa-circle"></i>
								                                              <div class="feature-content">
								                                            <h4>Buenas predicciones los Domingos</h4>
                                                              <p>Los modelos si han sabido generalizar bien las ventas de los días que eran Domingo, ya que éstas 
                                                              han sido siempre considerablemente inferiores al resto de días de la semana.</p>
								                                              </div>
								                                              </div>
								                                              <!-- /feature -->')
								                                              )
								                                       )
								                              )
								              )
								            )
								          ),
                        hr(),
                        fluidRow( includeHTML("footer.Rhtml"))
                       )   
               ),
                   
  #### Conclusiones ####
      tabPanel("Conclusiones", 
               fluidRow( 
                 column(12,
                        h1("Conclusiones") )),
                fluidRow(
                  column(12, h2("Análisis de cesta de la compra")),
                  HTML('		<div class="row">
						<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-circle"></i>
							<div class="feature-content">
								<h4>Reglas que muestran un patrón de venta</h4>
								<p>La mayoría de transacciones constan de uno o dos productos.</p>
							</div>
						</div>
						<!-- /feature -->
						
								<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-circle"></i>
							<div class="feature-content">
								<h4>Resultados</h4>
								<p>Los altos valores del parámetro lift indican que las reglas no se deben a la aleatoriedad,
                            sino que es un patrón del comportamiento real de ventas.</p>
							</div>
						</div>
						<!-- /feature -->
								<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-circle"></i>
							<div class="feature-content">
								<h4>Patrón de venta frecuente</h4>
								<p>Venta conjunta de los productos 1033 y 1096.</p>
							</div>
						</div>
						<!-- /feature -->	</div>')
                ),
                fluidRow(
                  column(12, h2("Modelado")),
                  HTML('		<div class="row">
						<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-circle"></i>
							<div class="feature-content">
								<h4>Resultado general del modelado</h4>
								<p>En general, los modelos obtenidos no consiguen predecir el volumen de ventas con una precisión que podamos
								considerar aceptable, ya que en el remuestreo observamos que los modelos presentaban cierta variabilidad. 
								Al trabajar con datos reales, esto es algo que se podía esperar, ya que modelar 
								el comportamiento humano (ventas de productos) no siempre es fácil, debido a que se ve afectado por muchos factores, 
								no únicamente precio, día o época del año.</p>
							</div>
						</div>
						<!-- /feature -->
						
								<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-circle"></i>
							<div class="feature-content">
								<h4>Limitación en los datos</h4>
								<p>La principal limitación ha sido que únicamente contábamos con datos de 181 días. Por este motivo, 
								no se ha podido generar un conjunto de datos para la validación de los modelos.</p>
							</div>
						</div>
						<!-- /feature -->
								<!-- feature -->
						<div class="feature">
							<i class="feature-icon fa fa-circle"></i>
							<div class="feature-content">
								<h4>Posibilidad de mejora y continuación del estudio</h4>
								<p>Se plantea la realización del estudio dentro de unos meses, ya que así habría más datos para entrenar y
								validad los modelos.</p>
								<p>Otra opción es recoger otro tipo de variables de entradas, como la hora de la venta, condiciones meteorológicas o lugar donde se realiza la transacción,
								en caso de tener datos de diferentes establecimientos. De este modo podríamos comprender mejor el comportamiento de ventas.</p>
							</div>
						</div>
						<!-- /feature -->	</div>')
                ),hr(),
               includeHTML("footer.Rhtml")
               )
  )
)
