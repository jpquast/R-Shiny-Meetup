library(shiny)

# Define UI 
ui <- fluidPage(

    # Application title
    titlePanel("Excercise 2"),

    # Sidebar 
    sidebarLayout(
        sidebarPanel(
            numericInput("a", "a", value = NULL),
            numericInput("b", "b", value = NULL),
            numericInput("c", "c", value = NULL),
            numericInput("d", "d", value = NULL),
            numericInput("x1", "x1", value = NULL),
            numericInput("x2", "x2", value = NULL),
            numericInput("x3", "x3", value = NULL),
            numericInput("y1", "y1", value = NULL),
            numericInput("y2", "y2", value = NULL)
        ),

        mainPanel(
           textOutput("f"),
           textOutput("z")
        )
    )
)

# Define server logic 
server1 <- function(input, output, session) {
  c <- reactive(input$a + input$b)
  e <- reactive(c() + input$d)
  output$f <- renderText(e())
  
  # Reactivity graph
  # a ---v 
  # b -> c --v
  # d -----> e -> f
}
server2 <- function(input, output, session) {
  x <- reactive(input$x1 + input$x2 + input$x3)
  y <- reactive(input$y1 + input$y2)
  output$z <- renderText(x() / y())
  
  # Reactivity graph
  # x1 ---v
  # x2 -> x ---v
  # x3 ---^    z
  # y1 -> y ---^
  # y2 ---^
}
server3 <- function(input, output, session) {
  d <- reactive(c() ^ input$d)
  a <- reactive(input$a * 10)
  c <- reactive(b() / input$c) 
  b <- reactive(a() + input$b)
  
  # Reactivity graph
  # a -> a -v
  # b ----> b -v
  # c -------> c -v
  # d ----------> d
}

# Run the application 
shinyApp(ui = ui, server = server1)
