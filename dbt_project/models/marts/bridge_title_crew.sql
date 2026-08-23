{{ config(materialized='view') }}

select
    title_id,
    person_id,
    category as role
from {{ ref('stg_title_principals') }}
where person_id is not null