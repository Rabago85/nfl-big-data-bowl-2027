{{ config(severity='warn', tags=['O1']) }}
select count(*) as n_preseason_games, {{ var('expected')['preseason_games'] }} as expected_preseason_games
from {{ ref('silver_games') }}
where is_preseason
having count(*) <> {{ var('expected')['preseason_games'] }}
