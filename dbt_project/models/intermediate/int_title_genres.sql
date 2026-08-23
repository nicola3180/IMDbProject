{{ config(materialized='view') }}

with raw_genres as (
    select
        title_id,
        trim(unnest(string_split(genres, ','))) as genre
    from {{ ref('stg_title_basics') }}
    where genres is not null
)

select
    title_id,
    genre
from raw_genres