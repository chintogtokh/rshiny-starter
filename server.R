library(leaflet)

mydata <- as.data.frame(read.csv(file="data/test.csv", header=TRUE))

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

    output$greetingItem <- renderText("This is a starter template using RShiny and Bootstrap.")

    selectedData <- reactive({
        iris[, c(input$xcolInp, input$ycolInp)]
    })

    clusters <- reactive({
        kmeans(selectedData(), input$clustersInp)
    })

    output$myplotIn <- renderPlot({
        palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3","#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
        par(mar = c(5.1, 4.1, 0, 1))
        plot(selectedData(),
             col = clusters()$cluster,
             pch = 20,
             cex = 3)
        points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    })

    observeEvent(input$addMarkerButton, {
        leafletProxy("map", data = mydata) %>%
        clearShapes() %>%
        addMarkers(~long, ~lat, popup = ~as.character(name), label = ~as.character(name))
    })

}