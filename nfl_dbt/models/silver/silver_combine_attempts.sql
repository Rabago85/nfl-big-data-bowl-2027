{# grain: one drill attempt EVENT = one event_id.
   Duplicate rule for (nfl_id, drill_name, attempt_raw) combinations that carry several event_ids:
     - order the events by start time; an event that starts more than one frame interval after the
       running max end of earlier events is a NEW chain (distinct, non-overlapping attempt);
     - events that overlap or are contiguous belong to the same chain -> merged: they share attempt_id
       (the smallest event_id of the chain);
     - chains after the first are renumbered: attempt = max attempt_raw of that player+drill + running count.
   Every decision is visible in duplicate_resolution / chain_no / combo_* columns. #}
with frames as (
    select event_id, entity_type, nfl_id, draft_year, drill_type, drill_name, attempt_raw, time
    from {{ ref('silver_combine_tracking') }}
),
event_base as (
    select
        event_id,
        max(case when entity_type = 'PLAYER' then nfl_id end)                 as nfl_id,
        count(distinct case when entity_type = 'PLAYER' then nfl_id end)      as n_player_ids,
        count(distinct nfl_id)                                                as n_distinct_nfl_ids,
        max(draft_year)                                                       as draft_year,
        max(drill_type)                                                       as drill_type,
        max(drill_name)                                                       as drill_name,
        max(attempt_raw)                                                      as attempt_raw,
        count(distinct concat_ws('|', drill_type, drill_name, cast(attempt_raw as string))) as n_distinct_attempt_keys,
        count_if(entity_type = 'PLAYER')                                      as frames_player,
        count_if(entity_type = 'BALL')                                        as frames_ball,
        min(case when entity_type = 'PLAYER' then time end)                   as start_time,
        max(case when entity_type = 'PLAYER' then time end)                   as end_time
    from frames
    group by event_id
),
ordered as (
    select *,
        max(end_time) over (
            partition by nfl_id, drill_name, attempt_raw
            order by start_time, event_id
            rows between unbounded preceding and 1 preceding) as prev_max_end
    from event_base
),
flagged as (
    select *,
        case when prev_max_end is null
               or (unix_micros(start_time) - unix_micros(prev_max_end)) > {{ var('frame_interval_us') }}
             then 1 else 0 end as is_new_chain
    from ordered
),
chained as (
    select *,
        sum(is_new_chain) over (
            partition by nfl_id, drill_name, attempt_raw
            order by start_time, event_id
            rows between unbounded preceding and current row) as chain_no
    from flagged
),
chain_stats as (
    select nfl_id, drill_name, attempt_raw, chain_no,
           min(event_id) as attempt_id,
           min(start_time) as chain_start,
           count(*) as chain_event_count
    from chained
    group by nfl_id, drill_name, attempt_raw, chain_no
),
combo_stats as (
    select nfl_id, drill_name, attempt_raw,
           max(chain_no) as combo_chain_count,
           sum(chain_event_count) as combo_event_count
    from chain_stats
    group by nfl_id, drill_name, attempt_raw
),
pair_stats as (
    select nfl_id, drill_name, max(attempt_raw) as pair_max_attempt
    from event_base
    group by nfl_id, drill_name
),
extra_chains as (
    select nfl_id, drill_name, attempt_raw, chain_no,
           row_number() over (partition by nfl_id, drill_name order by chain_start, attempt_id) as extra_rn
    from chain_stats
    where chain_no > 1
)
select
    c.event_id,
    s.attempt_id,
    c.nfl_id,
    c.draft_year,
    c.drill_type,
    c.drill_name,
    case when c.chain_no = 1 then c.attempt_raw else p.pair_max_attempt + e.extra_rn end as attempt,
    c.attempt_raw,
    c.frames_player,
    c.frames_ball,
    c.start_time,
    c.end_time,
    c.n_player_ids,
    c.n_distinct_nfl_ids,
    c.n_distinct_attempt_keys,
    c.chain_no,
    s.chain_event_count,
    cb.combo_chain_count,
    cb.combo_event_count,
    case
        when cb.combo_event_count = 1                          then 'none'
        when c.chain_no > 1 and s.chain_event_count > 1        then 'renumbered_and_merged'
        when c.chain_no > 1                                    then 'renumbered'
        when s.chain_event_count > 1                           then 'merged'
        else 'retained_distinct'
    end as duplicate_resolution
from chained c
join chain_stats s
  on s.nfl_id <=> c.nfl_id and s.drill_name <=> c.drill_name
 and s.attempt_raw <=> c.attempt_raw and s.chain_no = c.chain_no
join combo_stats cb
  on cb.nfl_id <=> c.nfl_id and cb.drill_name <=> c.drill_name and cb.attempt_raw <=> c.attempt_raw
join pair_stats p
  on p.nfl_id <=> c.nfl_id and p.drill_name <=> c.drill_name
left join extra_chains e
  on e.nfl_id <=> c.nfl_id and e.drill_name <=> c.drill_name
 and e.attempt_raw <=> c.attempt_raw and e.chain_no = c.chain_no
