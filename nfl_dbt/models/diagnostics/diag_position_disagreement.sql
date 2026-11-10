{# B11. Grain: one row per player. combine_position vs nfl_position vs modal lined_up_position. #}
with modal as (
    select nfl_id, lined_up_position, count(*) as n_snaps,
           row_number() over (partition by nfl_id order by count(*) desc, lined_up_position) as rn
    from {{ ref('silver_player_play') }}
    where lined_up_position is not null
    group by nfl_id, lined_up_position
)
select p.nfl_id, p.display_name, p.draft_year,
       c.combine_position, p.nfl_position,
       m.lined_up_position as modal_lined_up_position, m.n_snaps as modal_snaps,
       (c.combine_position <=> p.nfl_position)       as combine_eq_nfl,
       (p.nfl_position <=> m.lined_up_position)      as nfl_eq_modal_lined_up
from {{ ref('silver_players') }} p
left join {{ ref('silver_combine_results') }} c on c.nfl_id = p.nfl_id
left join modal m on m.nfl_id = p.nfl_id and m.rn = 1
