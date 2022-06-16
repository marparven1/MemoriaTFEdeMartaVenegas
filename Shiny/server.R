library( shiny      )
library( shinythemes)
library( DT       )
library( ggplot2  )
library( nortest  )
library( tseries  )
library( RcmdrMisc)
library( lmtest   )
library( plotly   )
library( quantmod )
library( dplyr    )
library( tibble   )
library( purrr    )
library( shinyjs  )
library( rintrojs )
library( markdown )
library( tidyr    )
library(arules)


load("datos/muestraTickets.RData")
load("datos/DatosFormatoBasket.RData")



# Define server logic required to draw a histogram ----
server <- function(input, output) {

#### Análisis cesta de la compra #### 

  
output$CjtoInicial<- DT::renderDataTable(
  DT::datatable({
    muestra
  },
  options = list(lengthMenu=list(c(5,15,20),c('5','15','20')),pageLength=10,
                 initComplete = JS(
                   "function(settings, json) {",
                   "$(this.api().table().header()).css({'background-color': 'rgb(236, 85, 107)', 'color': 'white'});",
                   "}"),
                 columnDefs=list(list(className='dt-center',targets="_all"))
  ),
  filter = "top",
  selection = 'multiple',
  style = 'bootstrap',
  class = 'cell-border stripe',
  rownames = FALSE,
  colnames = colnames(muestra)
  ))

output$FtoBasket<- DT::renderDataTable(
  DT::datatable({
    cestas
  },
  options = list(lengthMenu=list(c(5,15,20),c('5','15','20')),pageLength=10,
                 initComplete = JS(
                   "function(settings, json) {",
                   "$(this.api().table().header()).css({'background-color': 'rgb(236, 85, 107)', 'color': 'white'});",
                   "}"),
                 columnDefs=list(list(className="text-left" ,targets="_all"))
  ),
  filter = "top",
  selection = 'multiple',
  style = 'bootstrap',
  class = 'cell-border stripe',
  rownames = FALSE,
  colnames = colnames(cestas)
  ))
  


  
  
}