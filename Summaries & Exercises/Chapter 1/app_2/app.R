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
  # generation of the summary output
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  # generation of the table output
  output$table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    dataset
  })
}

# Construct application
shinyApp(ui, server)