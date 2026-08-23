select
    tconst as title_id,
    nullif(directors, '\N') as director_ids,
    nullif(writers, '\N') as writer_ids
from {{ source('imdb_raw', 'title_crew') }}