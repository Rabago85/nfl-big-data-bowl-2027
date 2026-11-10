{{ config(severity='error', tags=['silver_player_play']) }}
select distinct pp.game_id, pp.season as derived_season, g.season as games_season
from {{ ref('silver_player_play') }} pp
join {{ ref('silver_games') }} g on pp.game_id = g.game_id
where pp.season <> g.season
