{{
    config(
        location_root='abfss://nfl@stdevwestus2project.dfs.core.windows.net/silver/'
    ) 
}}

{# grain: one row per cohort player (nfl_id). #}
with typed as (
    select
        cast(nfl_id as bigint)                  as nfl_id,
        display_name      as display_name,
        cast(draft_year as int)                 as draft_year,
        nfl_position        as nfl_position,
        cast(birth_date as date)                as birth_date,
        college_name         as college_name,
        college_conference   as college_conference,
        cast(draft_round as int)                as draft_round,
        cast(draft_pick_within_round as int)    as draft_pick_within_round,
        cast(draft_overall_pick as int)         as draft_overall_pick
    from nfl.bronze.players_bronze
)
select distinct * from typed