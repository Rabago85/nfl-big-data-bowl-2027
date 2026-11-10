{# O4. Grain: (play_direction, side). Position and angle at ball_snap. If x is normalized to play direction,
   mean x for offense should be the same for both play directions. #}
with snap as (
    select game_id, play_id, nfl_id, x, y, o, dir
    from {{ ref('silver_game_tracking') }}
    where event = '{{ var("event_names")["ball_snap"] }}'
)
select pp.play_direction, pp.side, count(*) as n_players,
       avg(s.x) as avg_x, min(s.x) as min_x, max(s.x) as max_x, avg(s.y) as avg_y,
       avg(s.o) as avg_o, avg(s.dir) as avg_dir
from snap s
join {{ ref('silver_player_play') }} pp
  on pp.game_id = s.game_id and pp.play_id = s.play_id and pp.nfl_id = s.nfl_id
group by pp.play_direction, pp.side
