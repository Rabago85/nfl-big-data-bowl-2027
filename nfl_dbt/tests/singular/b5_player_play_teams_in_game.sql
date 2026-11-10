{{ config(severity='error', tags=['B5']) }}
{# B5: team_abbr and possession_team both belong to the game's home or visitor team. #}
select pp.game_id, pp.play_id, pp.nfl_id, pp.team_abbr, pp.possession_team, g.home_team_abbr, g.visitor_team_abbr
from {{ ref('silver_player_play') }} pp
join {{ ref('silver_games') }} g on pp.game_id = g.game_id
where pp.team_abbr not in (g.home_team_abbr, g.visitor_team_abbr)
   or pp.possession_team not in (g.home_team_abbr, g.visitor_team_abbr)
