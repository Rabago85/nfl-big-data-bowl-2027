{# grain: one row per player, keyed by nfl_id, 510 rows. #}

select * from {{ ref('silver_player_career_successes')}}