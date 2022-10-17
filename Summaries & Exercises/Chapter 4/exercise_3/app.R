library(shiny)
library(here)
library(vroom)
library(tidyverse)

injuries <- vroom::vroom(here("neiss/injuries.tsv.gz") %>% str_remove("exercise_3/"))
products <- vroom::vroom(here("neiss/products.tsv") %>% str_remove("exercise_3/"))
population <- vroom::vroom(here("neiss/population.tsv") %>% str_remove("exercise_3/"))

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
           selectInput("code", "Product", choices = prod_codes),
           numericInput("n_rows", "Number of rows", value = 6)
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
    column(2, actionButton("story", "Tell me a story")),
    column(10, textOutput("narrative"))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
  output$diag <- renderTable(count_top(selected(), diag, n = input$n_rows -1), width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part, n = input$n_rows -1), width = "100%")
  output$location <- renderTable(count_top(selected(), location, n = input$n_rows -1), width = "100%")
  
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
  
  # render narrative
  narrative_sample <- eventReactive(
    list(input$story, selected()),
    selected() %>% pull(narrative) %>% sample(1)
  )
  output$narrative <- renderText(narrative_sample())
}

shinyApp(ui, server)