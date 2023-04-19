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


-----------------------------------------------------------------------------------------------------------------------

/*
 +-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the name and the ID of a student.
id is a continuous increment.

Write an SQL query to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.

Return the result table ordered by id in ascending order.

The query result format is in the following example.
 */

with cte as (

select  id, mod(id,2) as mod_val,
student,
lead(student) over (order by id asc) as lead_student,
lag(student) over (order by id asc) as lag_student
from Seat
)

select id,
case when id = (select max(id) from Seat) and id%2 = 1 then student
     when mod_val = 1 then lead_student
     when mod_val = 0 then lag_student
     end as student
from cte



---------------------------------------------------------------------------------------------------------------------
/*Your team at JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.

Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.

Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. The launch month is the earliest record in the monthly_cards_issued table for a given card. Order the results starting from the biggest issued amount.

monthly_cards_issued Table:
Column Name	Type
issue_month	integer
issue_year	integer
card_name	string
issued_amount	integer
monthly_cards_issued Example Input:
issue_month	issue_year	card_name	issued_amount
1	2021	Chase Sapphire Reserve	170000
2	2021	Chase Sapphire Reserve	175000
3	2021	Chase Sapphire Reserve	180000
3	2021	Chase Freedom Flex	65000
4	2021	Chase Freedom Flex	70000
Example Output:
card_name	issued_amount
Chase Sapphire Reserve	170000
Chase Freedom Flex	65000
*/
SELECT a.card_name, a.issued_amount
FROM
(
SELECT *,
make_date(issue_year,issue_month, 1) as Date_,
ROW_NUMBER() OVER (PARTITION BY card_name ORDER BY make_date(issue_year,issue_month, 1) ASC) as rnk
FROM monthly_cards_issued
) a
WHERE a.rnk = 1
ORDER BY 2 DESC
;
----------------------------------------------------------------------------------------------------------------------

/*
 A phone call is considered an international call when the person calling is in a different country than the person receiving the call.

What percentage of phone calls are international? Round the result to 1 decimal.

Assumption:

The caller_id in phone_info table refers to both the caller and receiver.
phone_calls Table:
Column Name	Type
caller_id	integer
receiver_id	integer
call_time	timestamp
phone_calls Example Input:
caller_id	receiver_id	call_time
1	2	2022-07-04 10:13:49
1	5	2022-08-21 23:54:56
5	1	2022-05-13 17:24:06
5	6	2022-03-18 12:11:49
phone_info Table:
Column Name	Type
caller_id	integer
country_id	integer
network	integer
phone_number	string
phone_info Example Input:
caller_id	country_id	network	phone_number
1	US	Verizon	+1-212-897-1964
2	US	Verizon	+1-703-346-9529
3	US	Verizon	+1-650-828-4774
4	US	Verizon	+1-415-224-6663
5	IN	Vodafone	+91 7503-907302
6	IN	Vodafone	+91 2287-664895
Example Output:
international_calls_pct
50.0

 */

--Solution

WITH caller_info AS
(
SELECT pc.caller_id,
ph.country_id as caller_country_id,
pc.receiver_id as receiver_id,
ph2.country_id as receiver_country_id
FROM phone_calls pc
LEFT JOIN phone_info ph on ph.caller_id = pc.caller_id
LEFT JOIN phone_info ph2 on ph2.caller_id = pc.receiver_id
)
SELECT
ROUND((SUM(CASE WHEN caller_country_id != receiver_country_id THEN 1 ELSE 0 END)*100.0/COUNT(1)),1) AS international_calls_pct
FROM caller_info
------------------------------------------------------------------------------





