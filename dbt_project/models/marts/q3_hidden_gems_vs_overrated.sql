with title_classifications as (
    select
        t.title_id,
        g.genre,
        case
            when r.average_rating >= 8.0 and r.num_votes between 1000 and 50000 then 1
            else 0
        end as is_hidden_gem,
        case
            when r.average_rating < 6.0 and r.num_votes > 50000 then 1
            else 0
        end as is_overrated
    from {{ ref('dim_title') }} t
    inner join {{ ref('fct_title_ratings') }} r
        on t.title_id = r.title_id
    inner join {{ ref('int_title_genres') }} g
        on t.title_id = g.title_id
    where g.genre is not null
)

select
    genre,
    count(*) as total_rated_titles,
    sum(is_hidden_gem) as hidden_gems_count,
    sum(is_overrated) as overrated_count,
    round(
        sum(is_hidden_gem)::double / nullif(sum(is_overrated), 0),
        2
    ) as gems_to_overrated_ratio
from title_classifications
group by genre
having sum(is_hidden_gem) > 0 or sum(is_overrated) > 0
order by gems_to_overrated_ratio desc nulls last, hidden_gems_count desc