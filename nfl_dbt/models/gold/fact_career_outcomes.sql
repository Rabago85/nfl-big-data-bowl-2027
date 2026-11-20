{# grain: one row per player, keyed by nfl_id, 510 rows. #}
{# values are derived from different source than player_play #}

select * from {{ ref('silver_player_career_successes')}}