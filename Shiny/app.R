library( shiny      )
library( shinythemes)
library(shinydashboard)
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



source("R/ui.R")
source("R/server.R")

shinyApp(ui = ui,server=server)



