# Load the Shiny package
library(shiny)

# The UI side of the app
ui <- fluidPage(
  "Hello, world!"
)
# The server side of the app
server <- function(input, output, session) {
  # Has no content so far.
}

# Construct application
shinyApp(ui, server)