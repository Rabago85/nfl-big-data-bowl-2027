{{ config(severity='error', tags=['B7']) }}
{# B7: a player is tracked only in seasons at or after his draft_year. #}
with s as (select distinct season, nfl_id from {{ ref('silver_game_tracking') }})
select s.season, s.nfl_id, p.draft_year
from s
join {{ ref('silver_players') }} p on s.nfl_id = p.nfl_id
where s.season < p.draft_year
