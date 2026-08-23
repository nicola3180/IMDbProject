-- Returns records where average_rating is outside the valid IMDb bounds [0, 10]
select
    title_id,
    average_rating
from {{ ref('stg_title_ratings') }}
where average_rating < 0 or average_rating > 10