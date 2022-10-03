library(shiny)
library(reactable)

# Define UI for application that draws a histogram
ui <- fluidPage(
  reactableOutput("table")
)
server <- function(input, output, session) {
  output$table <- renderReactable(reactable(mtcars,
                                            showPageSizeOptions = TRUE,
                                            pageSizeOptions = c(10, 25, 50, 100),
                                            defaultPageSize = 5))
}

# Run the application 
shinyApp(ui = ui, server = server)
