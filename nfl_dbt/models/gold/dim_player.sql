with players_combine_stats_joined as (
    select
        p.*,
        case
            when p.draft_round is null then true
            else false
        end as is_undrafted,
        c.combine_position,
        c.combine_height,
        c.combine_weight,
        c.hand_size,
        c.arm_length,
        c.wing_span,
        c.ten_yd_split,
        c.forty,
        c.vertical,
        c.broad_jump,
        c.three_cone,
        c.short_shuttle,
        c.bench_reps,
        c.ngs_athleticism_score,
        c.ngs_college_production_score,
        c.ngs_final_score
    from {{ ref('silver_players') }} p
    left join {{ ref('silver_combine_results') }} c
    on p.nfl_id = c.nfl_id
)
select * from players_combine_stats_joined