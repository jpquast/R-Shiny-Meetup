library(shiny)
library(here)
library(vroom)
library(tidyverse)

injuries <- vroom::vroom(here("neiss/injuries.tsv.gz") %>% str_remove("exercise_4/"))
products <- vroom::vroom(here("neiss/products.tsv") %>% str_remove("exercise_4/"))
population <- vroom::vroom(here("neiss/population.tsv") %>% str_remove("exercise_4/"))

count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

prod_codes <- setNames(products$prod_code, products$title)

ui <- fluidPage(
  fluidRow(
    column(6,
           selectInput("code", "Product", choices = prod_codes)
    )
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  # select rate vs. count
  fluidRow(
    column(8,
           selectInput("code", "Product",
                       choices = setNames(products$prod_code, products$title),
                       width = "100%"
           )
    ),
    column(2, selectInput("y", "Y axis", c("rate", "count")))
  ),
  # display narrative
  fluidRow(
    column(1, actionButton("prev_s", "", icon = icon("arrow-left"))),
    column(1, actionButton("next_s", "", icon = icon("arrow-right"))),
    column(10, textOutput("narrative"))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
  output$diag <- renderTable(count_top(selected(), diag), width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
  output$location <- renderTable(count_top(selected(), location), width = "100%")
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  # plot dependent on rate vs. count input
  output$age_sex <- renderPlot({
    if (input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries")
    } else {
      summary() %>%
        ggplot(aes(age, rate, colour = sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Injuries per 10,000 people")
    }
  }, res = 96)

  select_narrative <- reactive({
    print("selected_narratives")
    selected() %>% pull(narrative)
  })
  
  # render narrative
  # Problems:
  # Should not include index 0
  prev_i <- -1
  narrative_sample <- eventReactive(
    list(input$next_s, input$prev_s, select_narrative()),{
    i <- input$next_s[1] - input$prev_s[1] 
    # exclude 0 with prev_i
    # code ?
    print(paste0("index: ", i))
    n_narratives <- length(select_narrative())
    print(paste0("length narrative: ", n_narratives))
    multiples <- abs(floor(i/n_narratives))
    print(paste0("multiples: ", multiples))
    if (i > 0){
      result <- select_narrative()[i - (multiples * n_narratives)]
    }
    if (i < 0){
      result <- select_narrative()[(multiples * n_narratives) + i]
    }
    if (i == 0){
      result <- ""
    }
    prev_i <<- input$next_s[1] - input$prev_s[1]
    print(paste0("prev_i: ", prev_i))
    result
    }
  )
  output$narrative <- renderText(narrative_sample())
}

shinyApp(ui, server)