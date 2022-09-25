#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# This app greets the user by name

# Load the Shiny package
library(shiny)

# The UI side of the app
ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)
# The server side of the app
server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hello ", input$name)
  })
}

# Construct application
shinyApp(ui, server)