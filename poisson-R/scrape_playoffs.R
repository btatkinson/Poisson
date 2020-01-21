library(tidyverse)
library(tidyr)
library(dplyr)
library(na.tools)
library(ggimage)
library(nflscrapR)

postseason2020 <- scrape_game_ids(2019, type="post")
to_scrape <- postseason2020 %>% filter(state_of_game=="POST")
ts_game_ids <- to_scrape$game_id

ps2020 <- scrape_game_play_by_play(ts_game_ids[1],type="post",season="2020")

for (gi in ts_game_ids[c(-1)]){
  pbp <- scrape_game_play_by_play(gi,type="post",season="2020")
  ps2020<-rbind(ps2020,pbp)
}

write.csv(ps2020, "../data/nflscrapR/play_by_play_data/post_season/post_pbp_2019.csv")


