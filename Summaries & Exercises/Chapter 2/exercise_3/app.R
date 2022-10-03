library(shiny)

ui <- fluidPage(
  sliderInput("value", 
              "", 
              value = 0,
              min = 0,
              max = 100,
              step = 5,
              animate = TRUE)
)


server <- function(input, output) {
  # Nothing
}

# Run the application 
shinyApp(ui = ui, server = server)
