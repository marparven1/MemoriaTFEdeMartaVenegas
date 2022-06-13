
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
  tags$head(
  #  tags$link(rel = "stylesheet", type = "text/css", href = "www/css/Home.css")
    
    
  
    
  ),

  
  #### NavBarPane ####
  navbarPage( "TFG", 
              selected = icon("home"), collapsible = TRUE, fluid = TRUE, 
              tabPanel( icon("home"),
                        includeHTML("Home.Rhtml")
                        #,
                        #includeHTML("html/footer.html")
              ),
              tabPanel(
  # App title ----
  titlePanel("Hello Shiny!"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
    )
    )
  )
)

)