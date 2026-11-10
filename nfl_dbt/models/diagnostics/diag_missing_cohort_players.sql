{# B10. Grain: one row per cohort player with NO game-tracking frames (13 expected). #}
with tracked as (select distinct nfl_id from {{ ref('silver_game_tracking') }}),
pp as (select nfl_id, count(*) as player_play_rows from {{ ref('silver_player_play') }} group by nfl_id)
select p.nfl_id, p.display_name, p.nfl_position, p.draft_year, p.draft_round, p.draft_overall_pick,
       cs.career_offensive_snaps, cs.career_defensive_snaps, cs.career_special_teams_snaps, cs.career_games_active,
       coalesce(pp.player_play_rows, 0) as player_play_rows
from {{ ref('silver_players') }} p
left join tracked t on t.nfl_id = p.nfl_id
left join {{ ref('silver_player_career_successes') }} cs on cs.nfl_id = p.nfl_id
left join pp on pp.nfl_id = p.nfl_id
where t.nfl_id is null
