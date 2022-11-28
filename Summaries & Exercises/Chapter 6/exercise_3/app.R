library(shiny)

ui <- fluidPage(
  titlePanel("Central limit theorem"),
  fluidRow(
    column(
      6,
      plotOutput("hist")
    ),
    column(
      6,
      plotOutput("hist1")
    )
  ),
  fluidRow(
    column(
      offset = 4,
      4,
      numericInput("m", "Number of samples:", 2, min = 1, max = 100)
    ),
  )
)

server <- function(input, output, session) {
  output$hist <- renderPlot(
    {
      means <- replicate(1e4, mean(runif(input$m)))
      hist(means, breaks = 20)
    },
    res = 96
  )
  output$hist1 <- renderPlot(
    {
      means <- replicate(1e4, mean(runif(input$m)))
      hist(means, breaks = 20)
    },
    res = 96
  )
}

shinyApp(ui, server)