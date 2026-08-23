{{ config(materialized='table') }}

with distinct_genres as (
    select distinct
        genre
    from {{ ref('int_title_genres') }}
    where genre is not null
)

select
    row_number() over (order by genre) as genre_id,
    genre as genre_name
from distinct_genres