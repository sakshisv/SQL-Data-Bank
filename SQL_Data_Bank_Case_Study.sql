---------- Data Bank Case Study ----------

-- Database
use Data_Bank

--Tables
select * from customer_nodes
select * from customer_transactions
select * from regions


---------- Case Study Questions ----------

---------- A. Customer Nodes Exploration ----------

--Q1. How many unique nodes are there on the Data Bank system?

select count(distinct node_id) nodes_count from customer_nodes

--Q2. What is the number of nodes per region?

select region_id, count(node_id) nodes_count from customer_nodes
group by region_id
order by region_id

--Q3. How many customers are allocated to each region?

select region_id, count(distinct customer_id) customer_count from customer_nodes
group by region_id

--Q4. How many days on average are customers reallocated to a different node?

select AVG(DATEDIFF(day, start_date, end_date)) avg_days
from customer_nodes
where end_date != '9999-12-31'

--Q5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

With reallocation_cte as (
select region_id, DATEDIFF(day, start_date, end_date) reallocation_days
from customer_nodes
where end_date != '9999-12-31')

select distinct a.region_id, b.region_name, 
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY a.reallocation_days) OVER (partition by b.region_name) median,
PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY a.reallocation_days) OVER (partition by b.region_name) percentile_80,
PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY a.reallocation_days) OVER (partition by b.region_name) percentile_90
from reallocation_cte a 
left join regions b
on a.region_id = b.region_id



---------- B. Customer Transactions ----------


--Q1. What is the unique count and total amount for each transaction type?

select txn_type, count(txn_type) unique_count, sum(txn_amount) total_amount
from customer_transactions
group by txn_type

--Q2. What is the average total historical deposit counts and amounts for all customers?

with total_cte as (
select customer_id, count(*) deposit_count, sum(txn_amount) total_amount
from customer_transactions
where txn_type = 'deposit'
group by customer_id)

select avg(deposit_count) avg_deposit, avg(total_amount) avg_amount from total_cte

--Q3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

with txn_type_cte as (
select customer_id, DATENAME(MONTH, txn_date) month_name, month(txn_date) months,
sum(case when txn_type = 'deposit' then 1 else 0 end) as deposit_count,
sum(case when txn_type = 'purchase' then 1 else 0 end) as purchase_count,
sum(case when txn_type = 'withdrawl' then 1 else 0 end) as withdrawl_count
from customer_transactions
group by customer_id, DATENAME(MONTH, txn_date), month(txn_date))

select month_name, months, count(customer_id) cust_count 
from txn_type_cte
where deposit_count > 1 and (purchase_count >= 1 or withdrawl_count >= 1)
group by month_name, months


WITH monthly_transactions AS (
  SELECT 
    customer_id, 
    month(txn_date) AS mth,
    SUM(CASE WHEN txn_type = 'deposit' THEN 0 ELSE 1 END) AS deposit_count,
    SUM(CASE WHEN txn_type = 'purchase' THEN 0 ELSE 1 END) AS purchase_count,
    SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS withdrawal_count
  FROM customer_transactions
  GROUP BY customer_id, month(txn_date)
)

SELECT
  mth,
  COUNT(DISTINCT customer_id) AS customer_count
FROM monthly_transactions
WHERE deposit_count > 1 
  AND (purchase_count >= 1 OR withdrawal_count >= 1)
GROUP BY mth
ORDER BY mth;




select DATENAME(MONTH, txn_date) month_name, month(txn_date) months, count(customer_id) cust_count from customer_transactions
where txn_type = 'deposit'
group by DATENAME(MONTH, txn_date), month(txn_date)
having count(txn_type) > 1


select * from customer_nodes
select * from customer_transactions
select * from regions