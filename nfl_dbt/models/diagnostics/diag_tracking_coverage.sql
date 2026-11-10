{# Coverage metric (not a gate). Grain: (season, side). Share of player_play rows that have tracking frames. #}
with tracked as (select distinct game_id, play_id, nfl_id from {{ ref('silver_game_tracking') }})
select pp.season, pp.side, count(*) as player_play_rows,
       sum(case when t.nfl_id is not null then 1 else 0 end) as rows_with_tracking,
       sum(case when t.nfl_id is not null then 1 else 0 end) * 1.0 / count(*) as share_with_tracking
from {{ ref('silver_player_play') }} pp
left join tracked t on t.game_id = pp.game_id and t.play_id = pp.play_id and t.nfl_id = pp.nfl_id
group by pp.season, pp.side
