select * 
from olympic_history

--find which sports are played in all summer  olympics

WITH cte AS (
    SELECT COUNT(DISTINCT Games) AS tot_games
    FROM olympic_history
    WHERE Season = 'Summer'
),
cte2 AS (
    SELECT Sport, COUNT(DISTINCT Games) AS tot_game_sport
    FROM olympic_history
    WHERE Season = 'Summer'
    GROUP BY Sport
)

SELECT * 
FROM cte2 
JOIN cte 
ON cte.tot_games = cte2.tot_game_sport;


--fetch the top 5 athletes who have won the most gold medals

with cte as(select Name, count(1) as tot_gold_medal
from olympic_history
where Medal = 'Gold'
group by Name
),
cte2 as (select *, dense_rank() over(order by tot_gold_medal desc) as rnk
from cte)
select * from cte2 where rnk <=5;


--list down total gold, silver and bronze medals won by each country

--group by country
--use case statement to separate the number of gold, silver and bronze medals

select noc,
sum(case when Medal= 'Gold' then 1 else 0 end) as golds,
sum(case when Medal = 'Silver' then 1 else 0 end) as silvers,
sum(case when Medal = 'Bronze' then 1 else 0 end) as bronzes
from olympic_history
where medal <> 'NA'
group by noc

--identify which country won the most gold, most silver and most bronze
with cte as (select noc,
sum(case when Medal= 'Gold' then 1 else 0 end) as golds,
sum(case when Medal = 'Silver' then 1 else 0 end) as silvers,
sum(case when Medal = 'Bronze' then 1 else 0 end) as bronzes
from olympic_history
where medal <> 'NA'
group by noc
),
cte2 as (select * , 
 DENSE_RANK() over(order by golds desc) as rnk_g,
 DENSE_RANK() over(order by silvers desc) as rnk_s,
 DENSE_RANK() over(order by bronzes desc) as rnk_b
from cte)

select * 
from cte2
where rnk_g =1 and rnk_s= 1 and rnk_b = 1





