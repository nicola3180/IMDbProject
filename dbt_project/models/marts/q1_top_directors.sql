with director_movies as (
    select
        p.person_id,
        p.primary_name as director_name,
        f.title_id,
        f.average_rating,
        f.num_votes
    from {{ ref('fct_title_ratings') }} f
    inner join {{ ref('bridge_title_crew') }} b
        on f.title_id = b.title_id
    inner join {{ ref('dim_person') }} p
        on b.person_id = p.person_id
    where lower(coalesce(b.role, '')) like '%director%'
      and f.num_votes >= 10000
)

select
    person_id,
    director_name,
    count(distinct title_id) as total_titles,
    round(avg(average_rating), 2) as avg_rating,
    sum(num_votes) as total_votes
from director_movies
group by person_id, director_name
having count(distinct title_id) >= 5
order by avg_rating desc, total_votes desc
limit 10