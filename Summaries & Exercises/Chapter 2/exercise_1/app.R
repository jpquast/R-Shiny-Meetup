library(shiny)

ui <- fluidPage(
  textInput("name", label = NULL, placeholder = "Your name")
)


server <- function(input, output) {
  # Nothing
}

# Run the application 
shinyApp(ui = ui, server = server)
