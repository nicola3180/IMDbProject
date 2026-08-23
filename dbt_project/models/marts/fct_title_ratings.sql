{{ config(materialized='table') }}

with titles as (
    select
        title_id,
        title_type,
        start_year as release_year,
        runtime_minutes
    from {{ ref('stg_title_basics') }}
),

ratings as (
    select
        title_id,
        average_rating,
        num_votes
    from {{ ref('stg_title_ratings') }}
)

select
    t.title_id,
    t.title_type,
    t.release_year,
    t.runtime_minutes,
    coalesce(r.average_rating, 0.0) as average_rating,
    coalesce(r.num_votes, 0) as num_votes
from titles t
left join ratings r
    on t.title_id = r.title_id