# Install using the remotes package

#install.packages("remotes")
#remotes::install_github("rstudio/shinyuieditor")

#### Make example app using the geysir dataset

library(shinyuieditor)

launch_editor(app_loc = "geysir-app/")

# selection: geyser multi-file

#### Make custom app UI by changeing the geysir app

library(shinyuieditor)

launch_editor(app_loc = "concentration_calculator_ui/")

# selection: chick weights navbarPage