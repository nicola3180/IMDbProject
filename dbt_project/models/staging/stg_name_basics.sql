select
    nconst as person_id,
    primaryname as primary_name,
    try_cast(birthyear as integer) as birth_year,
    try_cast(deathyear as integer) as death_year,
    nullif(primaryprofession, '\N') as primary_profession,
    nullif(knownfortitles, '\N') as known_for_titles
from {{ source('imdb_raw', 'name_basics') }}