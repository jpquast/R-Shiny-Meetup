library(bslib)

theme <- bs_theme(
  bg = "#36E923", fg = "#FFFDFD", primary = "#F900F9",
  danger = "#C735DC", base_font = font_google("Monoton"), code_font = font_google("Pacifico")
)

if (interactive()) bs_theme_preview(theme)
