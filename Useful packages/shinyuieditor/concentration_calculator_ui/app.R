# Does not nicely work because gridlayout cuts off everything that reaches out of the boundaries

library(plotly)
library(gridlayout)
library(shiny)
library(ggplot2)

unit_table <- data.frame(
  unit_conc = c("M", "mM", "uM", "nM", "pM", "fM"),
  unit_vol = c("L", "mL", "uL", "nL", "pL", "fL"),
  multiplier = c(1, 1e3, 1e6, 1e9, 1e12, 1e15)
)

# Chick weights investigated over three panels
ui <- navbarPage(
  title = "Concentration Calculator",
  collapsible = FALSE,
  #theme = bslib::bs_theme(),
  tabPanel(
    title = "Concentrations",
    grid_container(
      layout = c(
        ".                          value_text   unit_text        ",
        "stock_concentration_text   stock_conc   stock_conc_unit  ",
        "stock_volume_text          stock_vol    stock_vol_unit   ",
        "desired_concentration_text desired_conc desired_conc_unit",
        "desired_volume_text        desired_vol  desired_vol_unit ",
        ".                          .            calculate        "
      ),
      row_sizes = c(
        "40px",
        "190px",
        "200px",
        "120px",
        "110px",
        "70px"
      ),
      col_sizes = c(
        "500px",
        "1fr",
        "1fr"
      ),
      gap_size = "0px",
      grid_card_text(
        area = "stock_concentration_text",
        content = "Stock concentration",
        alignment = "end"
      ),
      grid_card_text(
        area = "stock_volume_text",
        content = "Stock volume",
        alignment = "end"
      ),
      grid_card_text(
        area = "desired_concentration_text",
        content = "Desired concentration",
        alignment = "end"
      ),
      grid_card_text(
        area = "desired_volume_text",
        content = "Desired volume",
        alignment = "end"
      ),
      grid_card_text(
        area = "value_text",
        content = "Value",
        alignment = "center"
      ),
      grid_card_text(
        area = "unit_text",
        content = "Unit",
        alignment = "center"
      ),
      grid_card(
        area = "stock_conc",
        numericInput(
          inputId = "stock_conc",
          label = "",
          value = NULL
        )
      ),
      grid_card(
        area = "stock_vol",
        numericInput(
          inputId = "stock_vol",
          label = "",
          value = NULL
        )
      ),
      grid_card(
        area = "desired_conc",
        numericInput(
          inputId = "desired_conc",
          label = "",
          value = NULL
        )
      ),
      grid_card(
        area = "desired_vol",
        numericInput(
          inputId = "desired_vol",
          label = "",
          value = NULL
        )
      ),
      grid_card(
        area = "stock_conc_unit",
        selectInput(
          inputId = "stock_conc_unit",
          label = "",
          choices = unit_table$unit_conc
        )
      ),
      grid_card(
        area = "stock_vol_unit",
        selectInput(
          inputId = "stock_vol_unit",
          label = "",
          choices = unit_table$unit_vol
        )
      ),
      grid_card(
        area = "desired_conc_unit",
        selectInput(
          inputId = "desired_conc_unit",
          label = "",
          choices = unit_table$unit_conc
        )
      ),
      grid_card(
        area = "desired_vol_unit",
        selectInput(
          inputId = "desired_vol_unit",
          label = "",
          choices = unit_table$unit_vol
        )
      ),
      grid_card(
        area = "calculate",
        actionButton(
          inputId = "calculate",
          label = "Calculate!",
          width = "100%"
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
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

shinyApp(ui, server)
