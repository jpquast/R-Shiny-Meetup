library(shiny)
library(ggplot2)

datasets <- c("economics", "faithfuld", "seals")
ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  plotOutput("plot") # plotOutput instead of tableOutput
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  output$summary <- renderPrint({ # summmry was a typo
    summary(dataset())
  })
  output$plot <- renderPlot({
    plot(dataset()) # dataset() instead of dataset
  }, res = 96)
}

shinyApp(ui, server)