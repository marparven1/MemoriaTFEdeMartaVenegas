
library(shiny)
library(leaflet)
library(plotly)
library(shinyjs)
library(shinyBS)







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
                       fluidRow( h1("Análisis de cesta de la compra con datos de tickets de un supermercado"),
                                 br(),
                         column(12,
                                p("Se ha aplicado un análisis de cesta de la compra a unos datos que proceden de una muestra de tickets 
                                  correspondiente a transacciones de una cadena de supermercados. La muestra contiene un total de 
                                  7801 tickets que incluyen 4631 artículos distintos."),
                                br()) ),
                       br(),br(), br(),
                               fluidRow( h2(em("Conjunto de datos inicial"),icon("database",lib = "font-awesome")),
                         column(12,
                                column(DT::dataTableOutput("CjtoInicial"), width = 12)
                         )),
                       fluidRow(
                        br(),
                         column(12,
                                h2(em("Conjunto de datos en formato cesta"),icon("database",lib = "font-awesome"))),
                         br(), br(),
                         column(12,
                                column(DT::dataTableOutput("FtoBasket"), width = 12),br(),
                                p("Nota: Únicamente se observa una cota inferior de la venta de cada producto."))),
                       br(),br(),
                       
                       fluidRow( h2("Tamaño de las transacciones"),
                                 column(9,plotlyOutput("TamanoTrans",height = "500px")),                  
                                 column(3,
                                          sliderInput("TamanoTransaccionesInput", 
                                                      p("Seleccione el número de transacciones"),
                                                                           min = 1, max = 82, value = 10)
                                        )
                                 ),
                       br(),br(),br(),
                       fluidRow(
                         h2("Análisis de transacciones"),
                         column(9, plotlyOutput("soporte",height = "500px") ),
                         column(3,
                                div(id="FormBasket",h3("Opciones de visualización"),
                                    numericInput("ConteoArticulos", 
                                                 "Seleccione el número de artículos que quiere mostrar:",
                                                 20, min =1, max = 4631),
                                    br(),
                                    selectInput("selectorVis", "Seleccione una opción para visualizar:",
                                                list(`Cota inferior de ventas` = list("Cota"),
                                                     `Soporte individual` = list("Soporte"))),
                                    helpText("Nota: El soporte es la proporción de transacciones que contiene a un item o conjunto de items, y se mostrará en porcentaje."))
                        ),
                       ),

                       br(),hr(),br(),
                       includeHTML("footer.Rhtml")
                       ),
  #### Data science process #### 
    navbarMenu("Proceso de ciencia de datos",
               tabPanel("Preprocesado", br(),
                        fluidRow( 
                          column(12,
                                 h1("Adquisición de los datos y preparación"),br()) ),
                        
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