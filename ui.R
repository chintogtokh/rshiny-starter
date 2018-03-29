htmlTemplate("template.html",
    greeting = textOutput("greetingItem"),
    myplot = plotOutput("myplotIn"),
    xcol = selectInput("xcolInp", "X Variable", names(iris)),
    ycol = selectInput("ycolInp", "Y Variable", names(iris), selected=names(iris)[[2]]),
    clusters = numericInput("clustersInp", "Cluster count", 3, min = 1, max = 9)
)