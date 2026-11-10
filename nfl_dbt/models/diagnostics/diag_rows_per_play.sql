{# O2. Grain: (metric, bucket). Rows per play, and opposing cohort pairs per play by role matchup
   (roles from players.nfl_position; co-presence is not a matchup). #}
with rows_pp as (
    select game_id, play_id, count(*) as n_rows
    from {{ ref('silver_player_play') }}
    group by game_id, play_id
),
roles as (
    select pp.game_id, pp.play_id,
        sum(case when pp.side = 'OFFENSE' and p.nfl_position in ('T','G','C') then 1 else 0 end) as off_ol,
        sum(case when pp.side = 'DEFENSE' and p.nfl_position in ('DT','DE','NT') then 1 else 0 end) as def_dl,
        sum(case when pp.side = 'OFFENSE' and p.nfl_position in ('WR','TE') then 1 else 0 end) as off_wr_te,
        sum(case when pp.side = 'DEFENSE' and p.nfl_position in ('CB','SS','FS','DB') then 1 else 0 end) as def_db
    from {{ ref('silver_player_play') }} pp
    join {{ ref('silver_players') }} p on pp.nfl_id = p.nfl_id
    group by pp.game_id, pp.play_id
)
select 'rows_per_play' as metric, cast(n_rows as int) as bucket, count(*) as n_plays from rows_pp group by n_rows
union all
select 'ol_vs_dl_pairs', cast(off_ol * def_dl as int), count(*) from roles group by off_ol * def_dl
union all
select 'wr_te_vs_db_pairs', cast(off_wr_te * def_db as int), count(*) from roles group by off_wr_te * def_db
