{# grain: one row per game (game_id). Preseason is flagged, never filtered. #}

with unioned_season_team as (
  select 
    season, 
    home_team_abbr as team_abbr
  from nfl.gold.dim_game
  union 
  select 
    season, 
    visitor_team_abbr 
  from nfl.gold.dim_game
)
select
  concat(team_abbr, '-', season) as team_season_id,
  season,
  team_abbr
from unioned_season_team