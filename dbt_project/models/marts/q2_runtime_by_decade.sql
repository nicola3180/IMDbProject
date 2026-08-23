select
    floor(t.start_year / 10) * 10 as decade,
    count(*) as total_titles,
    round(avg(t.runtime_minutes), 1) as avg_runtime_minutes,
    round(avg(r.average_rating), 2) as avg_rating,
    round(corr(t.runtime_minutes, r.average_rating), 3) as runtime_rating_correlation
from {{ ref('dim_title') }} t
inner join {{ ref('fct_title_ratings') }} r
    on t.title_id = r.title_id
where t.runtime_minutes is not null
  and t.start_year is not null
group by floor(t.start_year / 10) * 10
order by decade