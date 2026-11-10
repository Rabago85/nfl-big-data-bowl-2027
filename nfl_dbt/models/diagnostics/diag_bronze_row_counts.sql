{# Load reconciliation. Grain: one row per table / slice. Bronze vs silver vs documented/confirmed counts. #}
select 'players' as entity, (select count(*) from {{ source('bronze','players_bronze') }}) as bronze_rows,
       (select count(*) from {{ ref('silver_players') }}) as silver_rows, {{ var('expected')['players'] }} as expected_rows
union all
select 'combine_results', (select count(*) from {{ source('bronze','combine_results_bronze') }}),
       (select count(*) from {{ ref('silver_combine_results') }}), {{ var('expected')['combine_results'] }}
union all
select 'player_career_successes', (select count(*) from {{ source('bronze','player_career_successes_bronze') }}),
       (select count(*) from {{ ref('silver_player_career_successes') }}), {{ var('expected')['player_career_successes'] }}
union all
select 'games', (select count(*) from {{ source('bronze','games_bronze') }}),
       (select count(*) from {{ ref('silver_games') }}), {{ var('expected')['games'] }}
union all
select 'player_play', (select count(*) from {{ source('bronze','player_play_bronze') }}),
       (select count(*) from {{ ref('silver_player_play') }}), {{ var('expected')['player_play'] }}
union all
select 'combine_tracking (all rows)', (select count(*) from {{ source('bronze','combine_tracking_bronze') }}),
       (select count(*) from {{ ref('silver_combine_tracking') }}), 456328
union all
select 'combine_tracking (PLAYER rows)', (select count(*) from {{ source('bronze','combine_tracking_bronze') }} where upper(trim(entity_type)) = 'PLAYER'),
       (select count(*) from {{ ref('silver_combine_tracking') }} where entity_type = 'PLAYER'), 456328
union all
select 'combine_attempts (events)', (select count(distinct event_id) from {{ source('bronze','combine_tracking_bronze') }}),
       (select count(*) from {{ ref('silver_combine_attempts') }}), {{ var('expected')['combine_attempts'] }}
union all
select 'game_tracking', (select count(*) from {{ source('bronze','game_tracking_bronze') }}),
       (select count(*) from {{ ref('silver_game_tracking') }}), 22654290
