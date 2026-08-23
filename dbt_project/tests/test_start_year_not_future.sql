{{ config(severity = 'warn') }}

-- Returns records where start_year is greater than the current calendar year.
-- Future release titles legitimately exist in raw IMDb data.
select
    title_id,
    start_year
from {{ ref('stg_title_basics') }}
where start_year > extract(year from current_date)