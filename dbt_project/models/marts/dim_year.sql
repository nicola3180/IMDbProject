{{ config(materialized='table') }}

with distinct_years as (
    select distinct
        start_year as year
    from {{ ref('stg_title_basics') }}
    where start_year is not null
)

select
    year,
    cast(floor(year / 10) * 10 as integer) as decade,
    cast(floor(year / 100) * 100 as integer) as century
from distinct_years
order by year