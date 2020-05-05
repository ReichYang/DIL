

shinyServer(function (input, output) {

  dataf <- reactive({
    from<- input$time
    till<- input$time
    print(from)
    print(till)
    df %>% filter(date <= till)
    })
  

  pal = colorNumeric(
    palette = "Greens",
    domain = df$retweet_count
  )
  
  
  output$map <- renderLeaflet({
    
    
    leaflet(data=df) %>%
      setView(lng = -79.05578, lat = 35.913154, zoom = 7) %>%
      
      addTiles(group = "OpenStreetMap") %>%
      addProviderTiles(providers$CartoDB.Positron, group = "CartoDB") %>%
      addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
      addProviderTiles(providers$Wikimedia, group = "Wikimedia") %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "WorldImagery") %>%
      
      
      
      addLayersControl(
        baseGroups = c("OpenStreetMap", "Toner Lite","Wikimedia","WorldImagery"),
        
        options = layersControlOptions(collapsed = FALSE)
      )
      
      
  })
  
 
  observe({
    if(nrow(dataf())==0){
      leafletProxy("map", data = dataf()) %>%
        clearMarkers()%>% clearShapes()%>% clearMarkerClusters() 
      
    }else{
      
      if(input$cluster){
    
    leafletProxy("map", data = dataf()) %>%  clearControls()%>%
      clearMarkers() %>% clearShapes()%>% clearMarkerClusters() %>%
      addCircleMarkers(
        lng=~longitude,
        lat=~latitude,
        clusterOptions = markerClusterOptions(),
        color = ~pal(retweet_count),
        stroke=FALSE,
        fillOpacity=0.5,
        popup = ~text) %>%
        addLegend("bottomright", pal = pal, values = ~retweet_count,
                    title = "Retweet Counts",
                    
                    opacity = 1
          )
      }else{
        leafletProxy("map", data = dataf()) %>%
          clearMarkers() %>% clearShapes()%>% clearMarkerClusters() %>%  clearControls()%>%
          addCircleMarkers(
            lng=~longitude,
            lat=~latitude,
            color = ~pal(retweet_count),
            stroke=FALSE,
            fillOpacity=0.5,
            popup = ~text) %>%
          addLegend("bottomright", pal = pal, values = ~retweet_count,
                    title = "Retweet Counts",
                    
                    opacity = 1
          )
        
    }
  }})

  
  
  
})