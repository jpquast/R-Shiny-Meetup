# Load the Shiny package
library(shiny)

# The UI side of the app
ui <- fluidPage(
  # Input selector field
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  # Text output
  verbatimTextOutput("summary"),
  # Table output
  tableOutput("table")
)
# The server side of the app
server <- function(input, output, session) {
  # Create a reactive expression
  dataset <- reactive({
    get(input$dataset, "package:datasets")
  })
  
  output$summary <- renderPrint({
    # Use a reactive expression by calling it like a function
    summary(dataset())
  })
  
  output$table <- renderTable({
    dataset()
  })
}

# Construct application
shinyApp(ui, server)