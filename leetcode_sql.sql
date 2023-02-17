/* 512. Game Play Analysis II

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
*/

select player_id, device_id
from (
select player_id, device_id,event_date,
rank() over (partition by player_id order by event_date asc) as rnk
from Activity
) a
where a.rnk = 1

---------------------------------------------------------------------------------------------------------------------------------------------
/* 534. Game Play Analysis III


+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.

Write an SQL query to report for each player and date, how many games played so far by the player. That is, the total number of games played by the player until that date. Check the example for clarity.

Return the result table in any order.

The query result format is in the following example.

*/

#cumulative sum

select player_id,
event_date,
sum(games_played) over (partition by player_id order by event_date asc) as games_played_so_far
from Activity

# self join

select
a2.player_id as player_id,
a2.event_date as event_date,
sum(a1.games_played) as games_played_so_far
from Activity a1
inner join Activity a2 on a2.player_id = a1.player_id
and a1.event_date <= a2.event_date
group by 1,2

#output

| player_id | event_date | games_played_so_far |
| --------- | ---------- | ------------------- |
| 1         | 2016-03-01 | 5                   |
| 1         | 2016-05-02 | 11                  |
| 1         | 2017-06-25 | 12                  |
| 3         | 2016-03-02 | 0                   |
| 3         | 2018-07-03 | 5                   |



