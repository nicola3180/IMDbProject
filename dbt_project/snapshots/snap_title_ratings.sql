{% snapshot snap_title_ratings %}

{{
    config(
      target_schema='main',
      unique_key='title_id',
      strategy='check',
      check_cols=['average_rating', 'num_votes']
    )
}}

select
    title_id,
    average_rating,
    num_votes
from {{ ref('fct_title_ratings') }}

{% endsnapshot %}