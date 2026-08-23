with source as (
    select * from {{ source('imdb_raw', 'title_basics') }}
),

transformed as (
    select
        tconst as title_id,
        titleType as title_type,
        primaryTitle as primary_title,
        originalTitle as original_title,
        isAdult = 1 as is_adult,
        try_cast(startYear as integer) as start_year,
        try_cast(endYear as integer) as end_year,
        try_cast(runtimeMinutes as integer) as runtime_minutes,
        genres
    from source
    where try_cast(startYear as integer) >= 2020
)

select * from transformed