library(shiny)
library(protti)
library(tidyverse)

unit_table <- data.frame(
  unit_conc = c("M", "mM", "uM", "nM", "pM", "fM"),
  unit_vol = c("L", "mL", "uL", "nL", "pL", "fL"),
  multiplier = c(1, 1e3, 1e6, 1e9, 1e12, 1e15)
)

#chebi <- fetch_chebi(stars = c(3))

chebi <- read.csv("chebi.csv")

chebi_type_accessions <- unique(chebi$type_accession)[!is.na(unique(chebi$type_accession))]

# Define UI
ui <- fluidPage(
  navbarPage("Concentration Calculator",
             tabPanel("Dilution",
  fluidRow(
           tags$form(
             class="form-horizontal",
             tags$div(
               class="form-group",
               tags$label(class = "col-sm-3 control-label", `for` = "stock_conc", br(), "Stock concentration"),
               column(width = 2, numericInput(inputId = "stock_conc", label = "Value", value = NULL, width = '100%')),
               column(width = 2, selectizeInput(inputId = "stock_conc_unit", label = "Unit", choices = unit_table$unit_conc, width = '100%'))
             )
           )
  ),
  fluidRow(
           tags$form(
             class="form-horizontal",
             
             tags$div(
               class="form-group",
               tags$label(class = "col-sm-3 control-label", `for` = "stock_vol", br(), "Stock volume"),
               column(width = 2, numericInput(inputId = "stock_vol", label = "", value = NULL, width = '100%')),
               column(width = 2, selectizeInput(inputId = "stock_vol_unit", label = "", choices = unit_table$unit_vol, width = '100%'))
             )
           ),
  ),
  fluidRow(
           tags$form(
             class="form-horizontal",
             
             tags$div(
               class="form-group",
               tags$label(class = "col-sm-3 control-label", `for` = "desired_conc", br(), "Desired concentration"),
               column(width = 2, numericInput(inputId = "desired_conc", label = "", value = NULL, width = '100%')),
               column(width = 2, selectizeInput(inputId = "desired_conc_unit", label = "", choices = unit_table$unit_conc, width = '100%'))
             )
    )
  ),
  fluidRow(
           tags$form(
             class="form-horizontal",
             
             tags$div(
               class="form-group",
               tags$label(class = "col-sm-3 control-label", `for` = "desired_vol", br(), "Desired volume"),
               column(width = 2, numericInput(inputId = "desired_vol", label = "", value = NULL, width = '100%')),
               column(width = 2, selectizeInput(inputId = "desired_vol_unit", label = "", choices = unit_table$unit_vol, width = '100%'))
             )
    )
  ),
  fluidRow(
    column(5),
    column(2,
           actionButton("calculate", "Calculate!", width = '100%')
           )
  )
),
tabPanel("ChEBI database",
           sidebarPanel(h3("Parameters"),
                        selectizeInput("type_accession", "Type accession", choices = chebi_type_accessions),
                        textInput("accession_number", "Accession number")),
         mainPanel(verbatimTextOutput("chebi_names"))
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
  
  output$chebi_name <- renderPrint({
    if(input$accession_number == "" | input$type_accession == ""){
      return(NULL)
    }
    result <- chebi %>% 
      filter(type_accession == input$type_accession) %>% 
      filter(accession_number == input$accession_number) %>% 
      distinct(name)
    
    print(result)
  })
  
  
}

shinyApp(ui = ui, server = server)