select
    titleid as title_id,
    cast(ordering as integer) as ordering,
    title,
    nullif(region, '\N') as region,
    nullif(language, '\N') as language,
    nullif(types, '\N') as types,
    nullif(attributes, '\N') as attributes,
    try_cast(isoriginaltitle as boolean) as is_original_title
from {{ source('imdb_raw', 'title_akas') }}