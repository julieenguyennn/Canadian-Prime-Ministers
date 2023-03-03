library(tidyverse)
library(janitor)

raw_data <- read_html("inputs/pms.html")

parse_data <-
  raw_data |>
  html_element(xpath = '//*[@id="mw-content-text"]/div[1]/table[2]') |>
  html_table()

# Clean table
cleaned_data <- parse_data[-c(2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,57),-c(2,11)]



