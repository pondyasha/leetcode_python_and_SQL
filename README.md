Here I practice python - easy and SQL (easy, medium and hard) questions from leetcode :) 

Few importants learnings from solutions solved by others:

1. When a table contains two primary keys just like the following:

          +--------------+------+
          | Column Name  | Type |
          +--------------+------+
          | customer_id  | int  |
          | year         | int  |
          | revenue      | int  |
          +--------------+------+
(customer_id, year) is the primary key for this table.

This table is already aggretated and would not contain multiple values for a customer_id in year 2021. So when writing a query we need not use group by to find total revenue per customer in 2021.

-------------------------------------------------------------------------------------------------------------------------
