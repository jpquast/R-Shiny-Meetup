library(shiny)

df <- data.frame(a = c(1, 2),
                 b = c(2, 10))

# Define UI 
ui <- fluidPage(

    # Application title
    titlePanel("Excercise 3"),

    # Sidebar 
    sidebarLayout(
        sidebarPanel(
          textInput("var", "Provide a or b", value = "a")
        ),

        mainPanel(
          verbatimTextOutput("text_output")
        )
    )
)

# Define server logic 
server <- function(input, output) {

  var <- reactive(df[[input$var]]) 
  # var is an already defined function it will get overwritten in the server environment, but we don't use the original var() function
  # df was not defined
  range1 <- reactive(range(var(), na.rm = TRUE)) # range needs to be renamed to e.g. range1 to work, to distinguish the base range() from the reactive range.
  # range is an already defined function therefore it won't run because it gets overwritten by the newly defined range function
  output$text_output <- renderPrint(range1())
}

# Run the application 
shinyApp(ui = ui, server = server)
