{# grain: one row per team per season (team_abbr, season); 32 teams x 3 seasons. #}

with unioned_season_team as (
  select 
    season, 
    home_team_abbr as team_abbr
  from {{ ref('dim_game') }}
  union 
  select 
    season, 
    visitor_team_abbr 
  from {{ ref('dim_game') }}
)
select
  concat(team_abbr, '-', season) as team_season_id,
  season,
  team_abbr
from unioned_season_team