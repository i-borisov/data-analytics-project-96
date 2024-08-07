with last_visits as (
    select
        visitor_id,
        MAX(visit_date) as visit_date
    from sessions
    group by visitor_id
)

select
    lv.visitor_id,
    lv.visit_date,
    s.source as utm_source,
    s.medium as utm_medium,
    s.campaign as utm_campaign,
    l.lead_id,
    l.created_at,
    l.amount,
    l.closing_reason,
    l.status_id
from last_visits as lv inner join sessions as s on lv.visit_date = s.visit_date
left join
    leads as l
    on lv.visitor_id = l.visitor_id and lv.visit_date <= l.created_at
where s.medium in ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
order by
    l.amount desc nulls last, lv.visit_date asc, utm_source asc, utm_medium asc, utm_campaign asc;

