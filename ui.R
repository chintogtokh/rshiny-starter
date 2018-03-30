library(leaflet)

htmlTemplate("template.html",
	map = leafletOutput("map", width = "100%", height = "500px"),
    greeting = textOutput("greeting"),
    myplot = plotOutput("myplot"),
    xcol = selectInput("xcol", "X Variable", names(iris)),
    ycol = selectInput("ycol", "Y Variable", names(iris), selected=names(iris)[[2]]),
    addMarkerButton = actionButton("addMarkerButton", "Toggle cities")
)