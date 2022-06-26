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
library(RColorBrewer)


load("datos/muestraTickets.RData")
load("datos/DatosFormatoBasket.RData")
TransBasket <- read.transactions("Datos/muestraTickets.csv", 
                                 format = 'basket', sep=',', header = TRUE )


load("Datos/datosTFGMarta.RData")

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
  fig <- fig %>% layout(margin = list(b = 100),
                        yaxis = list(title = "Número de transacciones"),
                        xaxis = list(title = "Numero de artículos"),
                        barmode = 'stack',
                        paper_bgcolor = 'rgba(245, 246, 249, 1)',
                        plot_bgcolor = 'rgba(245, 246, 249, 1)',
                        showlegend = FALSE)
  
  fig 
})











plotDataVentas <- reactive({
  CotaVentas <- muestra %>% group_by(item) %>% dplyr::summarise(Cota = n())
  CotaVentas <- CotaVentas[order(CotaVentas$Cota,decreasing = TRUE),]
  CotaVentas$Soporte<-round(100*(CotaVentas$Cota/ 7801 ),2)
  CotaVentas<-CotaVentas[1:input$ConteoArticulos,c("item",input$selectorVis)]
  res <- input$ConteoArticulos
  colnames(CotaVentas)<-c("item","Seleccion")
  CotaVentas
})




output$soporte <- renderPlotly({
  VentaArt <- plotDataVentas() 
  fig <- plot_ly(VentaArt, x = ~reorder(item,-Seleccion), y = ~Seleccion, type = 'bar',
                 marker = list(color = 'rgba(219, 64, 82, 0.7)',
                               line = list(color = 'rgba(219, 64, 82, 1.0)',
                                           width = 2)))
  fig <- fig %>% layout(xaxis = list(title = "ID item",
                                     tickangle = -45),
                        margin = list(b = 100),
                        yaxis = list(title = "Volumen de ventas / Soporte (%)"),
                        barmode = 'stack',
                        paper_bgcolor = 'rgba(245, 246, 249, 1)',
                        plot_bgcolor = 'rgba(245, 246, 249, 1)',
                        showlegend = FALSE)
  fig
})





#### EDA #### 
#### 
# output$Datos1  <- DT::renderDataTable(
# DT::datatable({
#   datos
# },
# options = list(lengthMenu=list(c(5,15,20),c('10','15','20')),pageLength=5,
#                initComplete = JS(
#                  "function(settings, json) {",
#                  "$(this.api().table().header()).css({'background-color': 'rgb(236, 85, 107)', 'color': 'white'});",
#                  "}"),
#                columnDefs=list(list(className='dt-center',targets="_all"))
# ),
# filter = "top",
# selection = 'multiple',
# style = 'bootstrap',
# class = 'cell-border stripe',
# rownames = FALSE,
# colnames = colnames(datos)
# ))
  

load("datos/Dataset_Final.RData")

EvolVentasDatos <- reactive({
  VolumenVentasDiarias = dataset %>% group_by(FECHA,ID_TICKET) %>%  dplyr::summarize(n =  n()) %>% as.data.frame() %>% group_by(FECHA) %>%  dplyr::summarize(n =  n())
  VolumenVentasDiarias = VolumenVentasDiarias %>% mutate(TIPO = rep("TOTAL",nrow(VolumenVentasDiarias)))
  
  
  VolumenVentasDiarias_P1=dataset %>% filter(CODIGO==20445) %>% group_by(FECHA,ID_TICKET) %>%  dplyr::summarize(n =  n()) %>% as.data.frame() %>% group_by(FECHA) %>%  dplyr::summarize(n =  n())
  VolumenVentasDiarias_P1 = VolumenVentasDiarias_P1 %>% mutate(TIPO = rep("Sin calcio",nrow(VolumenVentasDiarias_P1)))
  
  VolumenVentasDiarias_P2=dataset %>% filter(CODIGO==22336) %>% group_by(FECHA,ID_TICKET) %>%  dplyr::summarize(n =  n()) %>% as.data.frame() %>% group_by(FECHA) %>%  dplyr::summarize(n =  n())
  VolumenVentasDiarias_P2 = VolumenVentasDiarias_P2 %>% mutate(TIPO = rep("Con calcio",nrow(VolumenVentasDiarias_P2)))
  
  VolumenVentasDiarioTodo=
    rbind.data.frame(VolumenVentasDiarias,VolumenVentasDiarias_P1,VolumenVentasDiarias_P2)
  VolumenVentasDiarioTodo
})



output$EvolVentas<- renderPlotly({
  VolumenVentasDiarioTodo <- EvolVentasDatos() 
  fig <- plot_ly(VolumenVentasDiarioTodo, x = ~FECHA, y = ~n, color = ~TIPO,
                 colors = c(`Con calcio` = '#BB8FCE', `Sin calcio` = '#45B39D', `TOTAL` = '#A9CCE3')) 
  fig <- fig %>% add_lines()
  fig <- fig %>% layout(yaxis = list(title = "Ventas diarias"),
                        xaxis = list(title = "Día",rangeslider = list(visible = T)) )
  
  fig
})



Comp <- reactive({
  Ventas <- cbind.data.frame(
    VENTAS_TOTALES=c(188867,169196),
    TIPO = c("CON CALCIO","SIN CALCIO") ) 
  Ventas
})


output$VentasTotalComp<- renderPlot(
  {
    Ventas <- Comp() 
    ggplot(Ventas, aes(fill =TIPO , x = TIPO , y=VENTAS_TOTALES)) + 
      geom_histogram(stat="identity", position="dodge")   +
      labs(x="ID Producto" , y = "Volumen total de ventas", 
           caption = "Fuente: Elaboración propia con datos de ventas")+
      scale_fill_brewer(palette="Accent")+
      theme_bw()+ theme(legend.position = 'none')
     
    
  }
)


load("datos/VENTAS_MENSUALES.RData")

VMensuales <- reactive({
  VENTAS_MENSUALES
})


output$VentasMensuales<- renderPlotly(
  {
    VentasM <- VMensuales() 
    fig <- plot_ly(VentasM, x = ~MES, y = ~TOTAL_VENTAS,
                   color = ~TIPO,
                   colors = c(`CON CALCIO` = '#BB8FCE', `SIN CALCIO` = '#45B39D', `TOTAL` = '#A9CCE3'),
                   type = 'bar'
    ) 
    fig <- fig %>% layout(
                          yaxis = list(title = "Volumen de ventas"),
                          xaxis =  list(title = "Mes",
                                        categoryorder = "array",
                                        categoryarray = c("Agosto","Septiembre","Octubre","Noviembre","Diciembre","Enero"))
                          )
    fig
    
  }
)

load("datos/VENTAS_SEMANALES.RData")

Vsemanales <- reactive({
  VENTAS_SEMANALES
})


output$VentasSemanales <- renderPlotly(
  {
    VentasS <- Vsemanales() 

    fig <- plot_ly(VENTAS_SEMANALES, x = ~DIA_SEMANA, y = ~VENTAS_MEDIAS,
                   color = ~TIPO,
                   colors = c(`CON CALCIO` = '#BB8FCE', `SIN CALCIO` = '#45B39D', `TOTAL` = '#A9CCE3'),
                   type = 'bar'
    ) 
    fig <- fig %>% layout(
                          yaxis = list(title = "Volumen de ventas"),
                          xaxis = list(title = "Día de la semana",
                                       categoryorder = "array",
                                       categoryarray = c("Lunes","Martes","Miércoles","Jueves","Viernes","Sábado","Domingo"))  )
    fig
    
    
  }
)

#output$GranCom


#### Modelado ####

load("datos/PrediccionesTotalVentas.RData")

PredsTotalVentas <- reactive({
  PredTotal
})


output$Total <- renderPlotly(
  {
    PredTotal <- PredsTotalVentas() 
    
    fig <- plot_ly(PredTotal, x = ~Fecha, y = ~Predicción, name = 'Predicción', type = 'scatter', mode = 'lines+markers') 
    fig <- fig %>% add_trace(y = ~ValorReal, name = 'Valor real', mode = 'lines+markers') 
    fig <- fig %>%
      layout(
        xaxis = list(zerolinecolor = '#ffff',
                     zerolinewidth = 2,
                     gridcolor = 'ffff',rangeslider = list(visible = T)),
        yaxis = list(zerolinecolor = '#ffff',
                     zerolinewidth = 2, title ="Volumen de ventas",
                     gridcolor = 'ffff'),
        plot_bgcolor='#e5ecf6')
    
    
    fig
    
  }
)


load("datos/PrediccionesCalcioVentas.RData")

PredsCalcioVentas <- reactive({
  PredCalcio
})


output$Calcio <- renderPlotly(
  {
    PredCalcio <- PredsCalcioVentas() 
    
    fig <- plot_ly(PredCalcio, x = ~Fecha, y = ~Predicción, name = 'Predicción', type = 'scatter', mode = 'lines+markers') 
    fig <- fig %>% add_trace(y = ~ValorReal, name = 'Valor real', mode = 'lines+markers') 
    fig <- fig %>%
      layout(
        xaxis = list(zerolinecolor = '#ffff',
                     zerolinewidth = 2,
                     gridcolor = 'ffff',rangeslider = list(visible = T)),
        yaxis = list(zerolinecolor = '#ffff',
                     zerolinewidth = 2, title ="Volumen de ventas",
                     gridcolor = 'ffff'),
        plot_bgcolor='#e5ecf6')
    
    
    fig
    
  }
)


load("datos/PrediccionesSinCalcioVentas.RData")

PredssinCalcioVentas <- reactive({
  PredSinCalcio
})


output$SinCalcio <- renderPlotly(
  {
    PredSinCalcio <- PredssinCalcioVentas() 
    
    fig <- plot_ly(PredSinCalcio, x = ~Fecha, y = ~Predicción, name = 'Predicción', type = 'scatter', mode = 'lines+markers') 
    fig <- fig %>% add_trace(y = ~ValorReal, name = 'Valor real', mode = 'lines+markers') 
    fig <- fig %>%
      layout(
        xaxis = list(zerolinecolor = '#ffff',
                     zerolinewidth = 2,
                     gridcolor = 'ffff',rangeslider = list(visible = T)),
        yaxis = list(zerolinecolor = '#ffff',
                     zerolinewidth = 2, title ="Volumen de ventas",
                     gridcolor = 'ffff'),
        plot_bgcolor='#e5ecf6')
    
    
    fig
    
  }
)



load("datos/CompPreds.RData")

CompPred <- reactive({
  comparacionPreds
})


output$CompModelado <- renderPlotly(
  {
    comparacionPreds <- CompPred() 
    

fig <- plot_ly(comparacionPreds, x = ~FECHA, y = ~Pred, color = ~Tipo,
               colors = c(`Suma de la predicción` = '#BB8FCE', `Predicción de la suma` = '#45B39D', `Ventas reales` = '#A9CCE3')) 
fig <- fig %>% add_lines()
fig <- fig %>% layout(yaxis = list(title = "Volumen de ventas"),
                      xaxis = list(title = "Día",rangeslider = list(visible = T)) )

fig

}
)





load("datos/CompPredsBN.RData")

CompPredII <- reactive({
  PredTotalBn
})


output$CompModeladobN <- renderPlotly(
  {
    comparacionPredsBN <- CompPredII() 
    
    
    fig <- plot_ly(comparacionPredsBN, x = ~fecha, y = ~`Predicción`, color = ~Tipo,
                   colors = c(`Suma de la predicción` = '#BB8FCE', `Predicción de la suma` = '#45B39D', `Ventas reales` = '#A9CCE3')) 
    fig <- fig %>% add_lines()
    fig <- fig %>% layout(yaxis = list(title = "Volumen de ventas"),
                          xaxis = list(title = "Día",rangeslider = list(visible = T)) )
    
    fig
    
  }
)







}