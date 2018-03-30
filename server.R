library(leaflet)

mydata <- as.data.frame(read.csv(file="data/test.csv", header=TRUE))
markersON <<- 0

server <- function(input, output, session) {

    output$map <-
    renderLeaflet({
        leaflet(data = mydata) %>%
        addTiles(
            urlTemplate = "//{s}.tiles.mapbox.com/v3/mapbox.blue-marble-topo-jan/{z}/{x}/{y}.png",
            attribution = 'Blue Marble January'
        ) %>%
        setView(lng=133.87, lat=-23.7, zoom=3)
    })

    output$greeting <- renderText("This is a starter template using RShiny and Bootstrap.")

    selectedData <- function(){iris[, c(input$xcol, input$ycol)]}
    clustered <- function(){kmeans(selectedData(), input$clusters)}

    observe({
    output$myplot <- renderPlot({
        palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3","#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
        par(mar = c(5.1, 4.1, 0, 1))
        plot(selectedData(),
             col = clustered()$cluster,
             pch = 20,
             cex = 3)
        points(clustered()$centers, pch = 4, cex = 4, lwd = 4)
    })})

    observeEvent(input$addMarkerButton, {
        if(markersON == 0){
            leafletProxy("map", data = mydata) %>%
            clearMarkers() %>%
            addMarkers(~long, ~lat, popup = ~as.character(name), label = ~as.character(pop))
            markersON <<- 1
        }
        else{
            leafletProxy("map", data = mydata) %>%
            clearMarkers()
            markersON <<- 0
        }

    })

}