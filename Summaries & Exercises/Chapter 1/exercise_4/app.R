library(shiny)

ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", "and y is", min = 1, max = 50, value = 5),
  "then, (x * y) is", textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)

# server <- function(input, output, session) {
#   output$product <- renderText({ 
#     product <- input$x * input$y
#     product
#   })
#   output$product_plus5 <- renderText({ 
#     product <- input$x * input$y
#     product + 5
#   })
#   output$product_plus10 <- renderText({ 
#     product <- input$x * input$y
#     product + 10
#   })
# }

server <- function(input, output, session) {
  # Reduce duplication by using reactive
  multiply <- reactive({input$x * input$y})
  
  output$product <- renderText({ 
    multiply()
  })
  output$product_plus5 <- renderText({ 
    multiply() + 5
  })
  output$product_plus10 <- renderText({ 
    multiply() + 10
  })
}

shinyApp(ui, server)