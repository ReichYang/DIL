shinyUI(
  # Use a fluid Bootstrap layout
  fluidPage(
    
    
    fluidRow(
      column(12, titlePanel("SilentSam Tweets")),
      column(12, leafletOutput('map', width = "1500", height = "700")),
    absolutePanel(bottom=10,  # Give the page a title
    sidebarPanel(sliderInput("time", "Date: ", min(df$date),
                              max(df$date),
                              value = min(df$date),
                              step=1,
                              animate=T,
                              width=1400
                              ), checkboxInput("cluster", "Show Cluster", TRUE)
   )
  )
)))

