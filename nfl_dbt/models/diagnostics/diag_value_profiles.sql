{# Grain: (source_column, value). Distinct values and counts, to build accepted lists and the coverage seed. #}
{% set targets = [
  ('silver_player_play','lined_up_position'), ('silver_player_play','coverage_assignment'),
  ('silver_player_play','coverage_assignment_at_snap'), ('silver_player_play','pass_result'),
  ('silver_player_play','play_direction'), ('silver_player_play','offense_formation'),
  ('silver_player_play','route_ran'), ('silver_player_play','team_coverage_man_zone'),
  ('silver_player_play','team_coverage_type'), ('silver_player_play','play_nullified_by_penalty'),
  ('silver_combine_tracking','drill_type'), ('silver_combine_tracking','drill_name'),
  ('silver_combine_tracking','entity_type'), ('silver_game_tracking','event'),
  ('silver_games','season_type'), ('silver_players','nfl_position'), ('silver_players','college_conference')
] %}
{% for m, c in targets %}
select '{{ m }}.{{ c }}' as source_column, cast({{ c }} as string) as value, count(*) as n_rows
from {{ ref(m) }}
group by {{ c }}
{{ 'union all' if not loop.last }}
{% endfor %}
