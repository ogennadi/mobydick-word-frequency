library(dplyr)
library(stringr)
library(tidytext)

STOP_WORDS_FILE <- 'stop-words.txt'
MOBYDICK_FILE <- 'mobydick.txt'
JOIN_COLUMN <- 'word'

sa_stop_words <- read.table(STOP_WORDS_FILE, as.is=FALSE, col.names = c(JOIN_COLUMN), colClasses = 'character') %>% 
  tibble(word = .$word)

sa_mobydick <- read.table(MOBYDICK_FILE, as.is=FALSE,  col.names = 'text', colClasses = 'character', sep = '\n', row.names = NULL) %>% 
  tibble(text = .$text) %>%
  unnest_tokens(word, text)

sa_moby_count <- sa_mobydick %>%
  anti_join(sa_stop_words, by = JOIN_COLUMN) %>%
  count(word, sort=TRUE)

sa_moby_count %>% top_n(100) %>% write.csv(file="word-frequency.csv", row.names = FALSE)
lapply(sa_mobydick %>% select(word), write, "mobydick-words.txt")