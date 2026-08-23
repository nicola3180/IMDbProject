{% snapshot snap_dim_title %}

{{
    config(
      target_schema='main',
      unique_key='title_id',
      strategy='check',
      check_cols=['primary_title', 'is_adult', 'start_year', 'runtime_minutes', 'genres']
    )
}}

select
    title_id,
    primary_title,
    is_adult,
    start_year,
    runtime_minutes,
    genres
from {{ ref('stg_title_basics') }}

{% endsnapshot %}