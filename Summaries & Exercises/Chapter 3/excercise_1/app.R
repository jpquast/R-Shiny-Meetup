library(shiny)

# Define UI 
ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

# Define server logic 
server1 <- function(input, output, server) {
  # input$greeting <- renderText(paste0("Hello ", name)) # original code
  output$greeting <- renderText(paste0("Hello ", input$name))
}

server2 <- function(input, output, server) {
  # greeting <- paste0("Hello ", input$name) # original code
  # output$greeting <- renderText(greeting) # original code
  greeting_reactive <- reactive(paste0("Hello ", input$name)) # can't access "input" outside of reactive functions
  output$greeting <- renderText(greeting_reactive()) 
}

server3 <- function(input, output, server) {
  #output$greting <- paste0("Hello", input$name) # original code
  output$greeting <- renderText(paste0("Hello ", input$name))
}

# Run the application 
shinyApp(ui = ui, server = server2)
