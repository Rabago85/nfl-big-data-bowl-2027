{# B9. Grain: one row per player. Non-preseason player_play rows vs career offensive + defensive snaps. #}
with pp as (
    select pp.nfl_id,
           sum(case when not g.is_preseason then 1 else 0 end) as player_play_rows_non_preseason,
           sum(case when g.is_preseason then 1 else 0 end)     as player_play_rows_preseason
    from {{ ref('silver_player_play') }} pp
    join {{ ref('silver_games') }} g on pp.game_id = g.game_id
    group by pp.nfl_id
)
select p.nfl_id, p.display_name, p.nfl_position, p.draft_year,
       coalesce(pp.player_play_rows_non_preseason, 0) as player_play_rows_non_preseason,
       coalesce(pp.player_play_rows_preseason, 0)     as player_play_rows_preseason,
       coalesce(cs.career_offensive_snaps, 0) + coalesce(cs.career_defensive_snaps, 0) as career_off_def_snaps,
       coalesce(pp.player_play_rows_non_preseason, 0) * 1.0
         / nullif(coalesce(cs.career_offensive_snaps, 0) + coalesce(cs.career_defensive_snaps, 0), 0) as rows_to_snaps_ratio
from {{ ref('silver_players') }} p
left join {{ ref('silver_player_career_successes') }} cs on cs.nfl_id = p.nfl_id
left join pp on pp.nfl_id = p.nfl_id
