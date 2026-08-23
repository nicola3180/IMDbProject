{{ config(materialized='table') }}

with titles as (
    select
        title_id,
        title_type,
        primary_title,
        original_title,
        is_adult,
        start_year,
        end_year,
        runtime_minutes,
        genres
    from {{ ref('stg_title_basics') }}
)

select *
from titles