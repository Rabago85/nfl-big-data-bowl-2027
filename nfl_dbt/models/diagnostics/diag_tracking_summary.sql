{# B12 / B13 / B14. Grain: one row per season. Ranges and sign checks for game tracking columns. #}
select season,
       count(*) as n_frames,
       min(x) as min_x, max(x) as max_x, min(y) as min_y, max(y) as max_y,
       min(s) as min_s, max(s) as max_s, avg(s) as avg_s,
       min(a) as min_a, max(a) as max_a,
       sum(case when a < 0 then 1 else 0 end) as n_a_negative,
       min(dis) as min_dis, max(dis) as max_dis,
       min(o) as min_o, max(o) as max_o, min(dir) as min_dir, max(dir) as max_dir,
       sum(case when abs(s - dis / 0.1) > {{ var('thresholds')['speed_dis_tolerance'] }} then 1 else 0 end) * 1.0
         / sum(case when s is not null and dis is not null then 1 else 0 end) as share_speed_dis_off
from {{ ref('silver_game_tracking') }}
group by season
