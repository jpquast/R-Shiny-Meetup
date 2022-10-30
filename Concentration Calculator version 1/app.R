library(shiny)



# Define UI
ui <- fluidPage(
  titlePanel("Concentration Calculator"),
  fluidRow(
    column(4,
           tags$form(
             class="form-horizontal",
             
             tags$div(
               class="form-group",
               tags$label(class = "col-sm-4 control-label", `for` = "stock_conc", br(), "Stock concentration"),
               column(width = 4, textInput(inputId = "stock_conc", label = "Value")),
               column(width = 4, selectizeInput(inputId = "stock_conc_unit", label = "Unit", choices = c("a")))
             )
             ),
           )
  )
)

server <- function(input, output, session){
  
}

shinyApp(ui = ui, server = server)