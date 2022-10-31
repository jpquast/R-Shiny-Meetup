library(shiny)

unit_table <- data.frame(
  unit_conc = c("M", "mM", "uM", "nM", "pM", "fM"),
  unit_vol = c("L", "mL", "uL", "nL", "pL", "fL"),
  multiplier = c(1, 1e3, 1e6, 1e9, 1e12, 1e15)
)

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
               column(width = 4, numericInput(inputId = "stock_conc", label = "Value", value = NULL)),
               column(width = 4, selectizeInput(inputId = "stock_conc_unit", label = "Unit", choices = unit_table$unit_conc))
             )
             ),
           )
  ),
  fluidRow(
    column(4,
           tags$form(
             class="form-horizontal",
             
             tags$div(
               class="form-group",
               tags$label(class = "col-sm-4 control-label", `for` = "stock_vol", br(), "Stock volume"),
               column(width = 4, numericInput(inputId = "stock_vol", label = "", value = NULL)),
               column(width = 4, selectizeInput(inputId = "stock_vol_unit", label = "", choices = unit_table$unit_vol))
             )
           ),
    )
  ),
  fluidRow(
    column(4,
           tags$form(
             class="form-horizontal",
             
             tags$div(
               class="form-group",
               tags$label(class = "col-sm-4 control-label", `for` = "desired_conc", br(), "Desired concentration"),
               column(width = 4, numericInput(inputId = "desired_conc", label = "", value = NULL)),
               column(width = 4, selectizeInput(inputId = "desired_conc_unit", label = "", choices = unit_table$unit_conc))
             )
           ),
    )
  ),
  fluidRow(
    column(4,
           tags$form(
             class="form-horizontal",
             
             tags$div(
               class="form-group",
               tags$label(class = "col-sm-4 control-label", `for` = "desired_vol", br(), "Desired volume"),
               column(width = 4, numericInput(inputId = "desired_vol", label = "", value = NULL)),
               column(width = 4, selectizeInput(inputId = "desired_vol_unit", label = "", choices = unit_table$unit_vol))
             )
           ),
    )
  ),
  fluidRow(
    column(1),
    column(1,
           actionButton("calculate", "Calculate!")
           )
  )
)

server <- function(input, output, session){
  
  observeEvent(input$calculate, {
    unit_stock_conc <- unit_table[unit_table$unit_conc == input$stock_conc_unit,]$multiplier
    unit_stock_vol <- unit_table[unit_table$unit_vol == input$stock_vol_unit,]$multiplier
    unit_desired_conc <- unit_table[unit_table$unit_conc == input$desired_conc_unit,]$multiplier
    unit_desired_vol <- unit_table[unit_table$unit_vol == input$desired_vol_unit,]$multiplier
    
    # Calculate stock concentration
    if(is.na(input$stock_conc) & !is.na(input$stock_vol) & !is.na(input$desired_conc) & !is.na(input$desired_vol)){
      stock_concentration <- (((input$desired_conc / unit_desired_conc) * (input$desired_vol / unit_desired_vol)) / (input$stock_vol / unit_stock_vol)) * unit_stock_conc
      updateNumericInput(session = session, "stock_conc", value = stock_concentration)
    }
    
    # Calculate stock volume
    if(is.na(input$stock_vol) & !is.na(input$stock_conc) & !is.na(input$desired_conc) & !is.na(input$desired_vol)){
      stock_volume <- (((input$desired_conc / unit_desired_conc) * (input$desired_vol / unit_desired_vol)) / (input$stock_conc / unit_stock_conc)) * unit_stock_vol
      updateNumericInput(session = session, "stock_vol", value = stock_volume)
    }
    
    # Calculate desired concentration
    if(is.na(input$desired_conc) & !is.na(input$stock_vol) & !is.na(input$stock_conc) & !is.na(input$desired_vol)){
      desired_concentration <- (((input$stock_conc / unit_stock_conc) * (input$stock_vol / unit_stock_vol)) / (input$desired_vol / unit_desired_vol)) * unit_desired_conc
      updateNumericInput(session = session, "desired_conc", value = desired_concentration)
    }
    
    # Calculate desired volume
    if(is.na(input$desired_vol) & !is.na(input$stock_vol) & !is.na(input$desired_conc) & !is.na(input$stock_conc)){
      desired_volume <- (((input$stock_conc / unit_stock_conc) * (input$stock_vol / unit_stock_vol)) / (input$desired_conc / unit_desired_conc)) * unit_desired_vol
      updateNumericInput(session = session, "desired_vol", value = desired_volume)
    }
  })
}

shinyApp(ui = ui, server = server)