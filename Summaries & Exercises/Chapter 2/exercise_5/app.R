library(shiny)

ui <- fluidPage(
  verbatimTextOutput("mtcars"),
  textOutput("morning"),
  verbatimTextOutput("ttest"),
  verbatimTextOutput("model")
)

server <- function(input, output) {
  output$mtcars <- renderPrint(summary(mtcars))
  output$morning <- renderText("Good morning!")
  output$ttest <- renderPrint(t.test(1:5, 2:6))
  output$model <- renderPrint(str(lm(mpg ~ wt, data = mtcars)))
}

# Run the application 
shinyApp(ui = ui, server = server)