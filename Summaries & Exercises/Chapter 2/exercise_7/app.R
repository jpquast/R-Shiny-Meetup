library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  dataTableOutput("table")
)
server <- function(input, output, session) {
  output$table <- renderDataTable(mtcars, options = list(pageLength = 5, searching = FALSE, ordering = FALSE))
}

# Run the application 
shinyApp(ui = ui, server = server)
