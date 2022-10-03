library(shiny)

ui <- fluidPage(
  selectInput("long",
              NULL,
              choices = list("Upper case letters" = LETTERS, "Lower case letters" = letters))
)


server <- function(input, output) {
  # Nothing
}

# Run the application 
shinyApp(ui = ui, server = server)
