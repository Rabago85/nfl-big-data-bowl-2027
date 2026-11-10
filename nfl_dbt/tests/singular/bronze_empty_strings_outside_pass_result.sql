{{ config(severity='warn', tags=['bronze_integrity', 'parse_integrity']) }}
{# Only pass_result is expected to contain empty strings in player_play_bronze (everything else used 'NA').
   Returns one row of per-column counts if any OTHER string column has empty strings. #}
{% set cols = ['team_abbr','lined_up_position','play_description','possession_team','yardline_side','game_clock',
               'play_direction','offense_formation','receiver_alignment','play_nullified_by_penalty',
               'team_coverage_man_zone','team_coverage_type','route_ran','coverage_assignment','coverage_assignment_at_snap'] %}
with c as (
    select
    {%- for col in cols %}
        sum(case when trim({{ col }}) = '' then 1 else 0 end) as {{ col }}{{ ',' if not loop.last }}
    {%- endfor %}
    from {{ source('bronze', 'player_play_bronze') }}
)
select * from c
where {% for col in cols %}{{ col }} > 0{{ ' or ' if not loop.last }}{% endfor %}
