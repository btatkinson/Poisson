library(tidyverse)
library(tidyr)
library(dplyr)
library(na.tools)

seasons <- seq(2014, 2019);

# iteration count
i = 0
df <- NULL;

for(season in seasons){
  # add iteration count
  i = i+1;
  
  # load play by play data
  reg_pbp <- read_csv(sprintf("../data/nflscrapR/play_by_play_data/regular_season/reg_pbp_%s.csv",season));
  
  # only grab needed columns
  reg_pbp <- reg_pbp[,c("passer_player_name","game_id","pass_touchdown")];
  
  # same person, Josh Allen, has two names-- Jos.Allen and J.Allen
  reg_pbp$passer_player_name <- sub("Jos.Allen", "J.Allen", reg_pbp$passer_player_name);
  
  # total pass touchdowns in season 
  sea_td <- reg_pbp %>% 
      group_by(passer_player_name) %>% 
      summarise(season_pass_touchdown = sum(pass_touchdown));
  # total games played in season
  sea_games <- reg_pbp %>% 
    group_by(passer_player_name) %>% 
    summarise(season_game_count = n_distinct(game_id));
  
  # merge games and pass touchdowns
  sea_df <- merge(sea_td,sea_games,by="passer_player_name");
  
  # drop small sample QBs
  sea_df <- sea_df %>% 
      filter(season_game_count > 7);
  
  # divide to get touchdowns per game
  sea_df <- transform(sea_df, td_pg = season_pass_touchdown / season_game_count);
  sea_df <- sea_df %>% drop_na();
  
  # add column denoting season
  sea_df$season = season;
  
  # concatenate with other seasons
  if(i==1){
    df <- sea_df;
  }else{
    df <- rbind(df, sea_df);
  };
  
  # sort values
  df <- df[order(-df$td_pg),];
}
print(df);

library(ggplot2)
library(sandwich)
library(msm)


# pasted from python notebook
#There were two defensive projections that stood out to me as bogus, and so I decided to change them.

#Arizona hired Kliff Kingsbury during the offseason, and he installed the fastest offense in the league. He also was not hired because of his defensive prowess. As a result, Arizona would allow significantly more possessions than in the past, and likely either 1) succeed on offense enough to force the other team to pass or 2) fail hard, and let the opponent rack up scores. For this reason I decided to add to their expectation.

#On the other hand, the 49ers have had two straight seasons of devastating injuries, had a historically low, 5 standard deviation off interception rate (2 all year in 2018), and drafted Nick Bosa, a defensive stud, second overall. Having them last in projected pass defense did not seem like a good idea. I subtracted from their expectation.

# qb priors

# load fantasypros data
qb_proj <- read_csv("../data/2019_projections.csv")

# defense priors



