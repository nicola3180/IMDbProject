{{ config(materialized='view') }}

with active_crew as (
    select distinct person_id
    from {{ ref('bridge_title_crew') }}
),

persons as (
    select *
    from {{ ref('stg_name_basics') }}
)

select
    p.person_id,
    p.primary_name,
    p.birth_year,
    p.death_year,
    p.primary_profession
from persons p
inner join active_crew c
    on p.person_id = c.person_id