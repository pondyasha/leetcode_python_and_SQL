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

-----------------------------------------------------------------------------------------------------------------------------
/* 550. Game Play Analysis IV
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


Write an SQL query to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

The query result format is in the following example.
 */

--Write your MySQL query statement below
select ifnull(round(count(a.player_id)/a.count_players,2),0) as fraction
from
(
select player_id,
(select count(distinct player_id) from Activity) as count_players,
event_date as next_day,
min(event_date) over (partition by player_id) as first_day
from Activity
) a
where (a.next_day - a.first_day) = 1

-- output
| fraction |
| -------- |
| 0.12     |
----------------------------------------------------------------------------------------
/*
584. Find Customer Referee
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| referee_id  | int     |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.


Write an SQL query to report the names of the customer that are not referred by the customer with id = 2.

Return the result table in any order.


Write your MySQL query statement below

 */



select a.name
from (
select name, ifnull(referee_id, 0) as referee_id
from Customer) a
where a.referee_id != 2

--output
| name |
| ---- |
| Will |
| Jane |
| Bill |
| Zack |


--------------------------------------------------------------------------------------------------------
/*
 603. Consecutive Available Seats
 Table: Cinema

+-------------+------+
| Column Name | Type |
+-------------+------+
| seat_id     | int  |
| free        | bool |
+-------------+------+
seat_id is an auto-increment primary key column for this table.
Each row of this table indicates whether the ith seat is free or not. 1 means free while 0 means occupied.


Write an SQL query to report all the consecutive available seats in the cinema.

Return the result table ordered by seat_id in ascending order.

The test cases are generated so that more than two seats are consecutively available.

The query result format is in the following example.


 */
-- Method 1
select distinct c1.seat_id as seat_id
from Cinema c1
inner join Cinema c2
where abs(c1.seat_id - c2.seat_id) = 1
and c1.free = 1 and c2.free = 1
order by 1 asc

-- Method 2
select seat_id
from(

select seat_id,
free,
lag(free) over (order by seat_id) as previous,
lead(free) over (order by seat_id)  as next
from Cinema
) a
where free and previous or free and next

-- output

| seat_id |
| ------- |
| 3       |
| 4       |
| 5       |

---------------------------------------------------------------------------------------------------------------












