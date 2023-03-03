library(babynames)
library(tidyverse)

set.seed(001)

simulated_dataset <-
  tibble(
    prime_minister = sample(
      x = babynames |> filter(prop > 0.01) |>
        select(name) |> unique() |> unlist(),
      size = 10,
      replace = FALSE
    ),
    birth_year = sample(
      x = c(1750:1990),
      size = 10,
      replace = TRUE
    ),
    years_lived = sample(
      x = c(50:100),
      size = 10,
      replace = TRUE
    ),
    death_year = birth_year + years_lived,
    party = sample(
      x = c(
        "Liberal",
        "Conservative",
        "Progressive Conservative",
        "Other"
      ),
      size = 10,
      replace = TRUE
    )
  ) |>
  select(prime_minister, birth_year, death_year, party) |>
  arrange(birth_year)

simulated_dataset