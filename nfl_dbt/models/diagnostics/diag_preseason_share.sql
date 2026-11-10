{# O6. Grain: one row per nfl_position. Share of player_play rows that are preseason. #}
select p.nfl_position,
       count(*) as n_rows,
       sum(case when g.is_preseason then 1 else 0 end) as n_preseason_rows,
       sum(case when g.is_preseason then 1 else 0 end) * 1.0 / count(*) as preseason_share
from {{ ref('silver_player_play') }} pp
join {{ ref('silver_games') }} g on pp.game_id = g.game_id
join {{ ref('silver_players') }} p on pp.nfl_id = p.nfl_id
group by p.nfl_position
