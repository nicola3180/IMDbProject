select
    tconst as title_id,
    cast(ordering as integer) as ordering,
    nconst as person_id,
    category,
    nullif(job, '\N') as job,
    nullif(characters, '\N') as characters
from {{ source('imdb_raw', 'title_principals') }}