with source as (
    select * from {{ source('imdb_raw', 'title_ratings') }}
),

transformed as (
    select
        tconst as title_id,
        try_cast(averageRating as numeric(3, 1)) as average_rating,
        try_cast(numVotes as integer) as num_votes
    from source
    where tconst in (select title_id from {{ ref('stg_title_basics') }})
)

select * from transformed