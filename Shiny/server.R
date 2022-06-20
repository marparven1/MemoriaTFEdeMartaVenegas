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
TransBasket <- read.transactions("Datos/muestraTickets.csv", 
                                 format = 'basket', sep=',', header = TRUE )






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
  


plotData <- reactive({
  tamanos <- size(TransBasket) 
  tamanos <- table(tamanos)
  tamanos<-as.data.frame(tamanos)
  tamanos[1:input$TamanoTransaccionesInput,]
})


output$TamanoTrans <- renderPlotly({
  TamanoTransacciones <- plotData() 
  fig <- plot_ly(TamanoTransacciones, x = ~TamanoTransacciones$tamanos, y = ~TamanoTransacciones$Freq, type = 'bar', marker = list(color = 'rgba(219, 64, 82, 0.7)',
                                                                               line = list(color = 'rgba(219, 64, 82, 1.0)',
                                                                                           width = 2)))
  fig <- fig %>% layout(xaxis = list(title = "",
                                     tickangle = -45),
                        margin = list(b = 100),
                        title = 'Productos más vendidos',
                        xaxis = list(title = "ID del producto"),
                        yaxis = list(title = "Número de ventas"),
                        barmode = 'stack',
                        paper_bgcolor = 'rgba(245, 246, 249, 1)',
                        plot_bgcolor = 'rgba(245, 246, 249, 1)',
                        showlegend = FALSE)
  
  fig 
})




plotDataVentas <- reactive({
  CotaVentas <- muestra %>% group_by(item) %>% summarise(Cota = n())
  CotaVentas <- CotaVentas[order(CotaVentas$Cota,decreasing = TRUE),]
  CotaVentas[1:input$ConteoArticulos,]
})




output$VentaArt <- renderPlotly({
  VentaArt <- plotDataVentas() 
  fig <- plot_ly(VentaArt, x = ~reorder(item,-Cota), y = ~Cota, type = 'bar', 
                 marker = list(color = 'rgba(219, 64, 82, 0.7)',
                               line = list(color = 'rgba(219, 64, 82, 1.0)',
                                           width = 2)))
  fig <- fig %>% layout(xaxis = list(title = "",
                                     tickangle = -45),
                        margin = list(b = 100),
                        title = 'Distribución del tamaño de las transacciones',
                        xaxis =  list(title = "Mes del año",rangeslider = list(visible = T)),
                        yaxis = list(title = "Número de ventas"),
                        barmode = 'stack',
                        paper_bgcolor = 'rgba(245, 246, 249, 1)',
                        plot_bgcolor = 'rgba(245, 246, 249, 1)',
                        showlegend = FALSE)
  fig
})





  
  
}