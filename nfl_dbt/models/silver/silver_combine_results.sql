{# grain: one row per player (nfl_id). Opt-out nulls are preserved, never imputed. #}
with typed as (
    select
        cast(nfl_id as bigint)                       as nfl_id,
        cast(draft_year as int)                      as draft_year,
        {{ clean_code('combine_position') }}         as combine_position,
        cast(combine_height as double)               as combine_height,
        cast(combine_weight as double)               as combine_weight,
        cast(hand_size as double)                    as hand_size,
        cast(arm_length as double)                   as arm_length,
        cast(wing_span as double)                    as wing_span,
        cast(ten_yd_split as double)                 as ten_yd_split,
        cast(forty as double)                        as forty,
        cast(vertical as double)                     as vertical,
        cast(broad_jump as double)                   as broad_jump,
        cast(three_cone as double)                   as three_cone,
        cast(short_shuttle as double)                as short_shuttle,
        cast(bench_reps as double)                   as bench_reps,
        cast(ngs_athleticism_score as double)        as ngs_athleticism_score,
        cast(ngs_college_production_score as double) as ngs_college_production_score,
        cast(ngs_final_score as double)              as ngs_final_score
    from {{ source('bronze', 'combine_results_bronze') }}
)
select distinct * from typed
