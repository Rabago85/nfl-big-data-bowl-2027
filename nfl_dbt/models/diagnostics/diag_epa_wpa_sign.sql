{# B3. Grain: (analysis, group_value). If EPA is from the offense's perspective, it should correlate positively
   with home win-probability-added when the home team has the ball and negatively when the visitor does. #}
with plays as (
    select game_id, play_id,
           max(possession_team) as possession_team,
           max(expected_points_added) as epa,
           max(home_team_win_probability_added) as home_wpa,
           max(yards_gained) as yards_gained
    from {{ ref('silver_player_play') }}
    group by game_id, play_id
)
select 'by_possession_home_or_visitor' as analysis,
       case when p.possession_team = g.home_team_abbr then 'possession_is_home' else 'possession_is_visitor' end as group_value,
       count(*) as n, corr(p.epa, p.home_wpa) as corr_epa_home_wpa, corr(p.epa, p.yards_gained) as corr_epa_yards,
       avg(p.epa) as avg_epa
from plays p join {{ ref('silver_games') }} g on p.game_id = g.game_id
group by 2
union all
select 'by_side_rows', side, count(*), null, corr(expected_points_added, yards_gained), avg(expected_points_added)
from {{ ref('silver_player_play') }}
group by side
