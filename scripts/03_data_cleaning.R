library(rvest)
library(tidyverse)
library(janitor)
library(kableExtra)
library(knitr)

raw_data <- read_html("inputs/pms.html")

parse_data <-
  raw_data |>
  html_element(xpath = '//*[@id="mw-content-text"]/div[1]/table[2]') |>
  html_table()

# Clean table
cleaned_data <- parse_data[-c(2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,57),-c(2,7,11)] %>%
  clean_names() %>%
  mutate(no = rep(1:28))

# Extract birth and death year
dob <- cleaned_data %>%
  separate(
    name_birth_death,
    into = c("name", "date"),
    sep = "\\(",
    extra = "merge") %>%
  mutate(born = str_extract(date, "[[:digit:]]{4}–[[:digit:]]{4}"),
         alive = str_extract(date, "b.[[:space:]][[:digit:]]{4}")) %>% 
  select(name, born, alive)
  
cleaned_dob <- dob %>%
  separate(born, into = c("birth", "died"),
           sep = "–") %>%  
  mutate(born = str_remove_all(alive, "b.[[:space:]]"),
         birth = if_else(!is.na(alive), born, birth)) %>%
  select(-c(born, alive))

# Clean office term
office_term_clean <- cleaned_data %>% 
  mutate(term_of_office = str_extract(term_of_office, "[[:digit:]]{4}"),
         term_of_office_2 = str_extract(term_of_office_2, "[[:digit:]]{4}")
  ) %>%
  rename("office_start" = term_of_office, "office_end" = term_of_office_2) %>% 
  select(office_start, office_end)

# Clean political party
party_clean <- cleaned_data %>% 
  mutate(political_party = str_remove(political_party, "Ldr.[[:space:]][[:digit:]]{4}")) %>%
  mutate(political_party = str_remove_all(political_party, "[()//]")) %>%
  mutate(political_party = str_remove_all(political_party, "[()//]")) %>%
  select(political_party)

# Merge table
final_table <- bind_cols(c(cleaned_dob,office_term_clean,party_clean))

# Generate table
final_table %>% knitr::kable(col.names = c("No.",
                             "Prime Minister",        
                             "Birth year",            
                             "Death year",                    
                             "Took office",
                             "Left office"))