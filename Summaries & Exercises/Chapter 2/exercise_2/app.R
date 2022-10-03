library(shiny)

ui <- fluidPage(
  sliderInput("date", 
              "When should we deliver?", 
              min = as.Date("2020-09-16"),
              max = as.Date("2020-09-23"),
              value = as.Date("2020-09-17"),  
              timeFormat = "%Y-%m-%d")
)

server <- function(input, output) {
  # Nothing
}

# Run the application 
shinyApp(ui = ui, server = server)
