
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
              tabPanel("Análisis de cesta de la compra", br(),
                       fluidRow( 
                         column(12,
                                h1("Análisis de cesta de la compra con datos de tickets de un supermercado"),
                                br()) ),
                       br(),hr(),br(),
                       fluidRow( 
                         column(12,
                                p("Se ha aplicado un análisis de cesta de la compra a unos datos que proceden de una muestra de tickets 
                                  correspondiente a transacciones de una cadena de supermercados. La muestra contiene un total de 
                                  7801 tickets que incluyen 4631 artículos distintos."),
                                br()) ),
                       fluidRow( 
                         column(12,
                                h2(em("Conjunto de datos inicial"),icon("database",lib = "font-awesome")))),
                       br(),
                               fluidRow( 
                         column(12,
                                column(DT::dataTableOutput("CjtoInicial"), width = 12)
                         ) , br(),
                         column(12,
                                h2(em("Conjunto de datos en formato cesta"),icon("database",lib = "font-awesome"))),
                         br(),
                         column(12,
                                column(DT::dataTableOutput("FtoBasket"), width = 12)
                         )
                         
                         
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