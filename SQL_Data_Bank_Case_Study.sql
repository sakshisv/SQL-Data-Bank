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

select avg(DATEDIFF(day, start_date, end_date)) avg_days
from customer_nodes
where end_date != '9999-12-31'

SELECT AVG(DATEDIFF(day,start_date,end_date))
FROM customer_nodes
WHERE end_date != '9999-12-31';

SELECT AVG(DATEDIFF(day,start_date,end_date))
FROM customer_nodes
WHERE end_date != '9999-12-31';

SELECT c.region_id,
        region_name, 
        count(node_id) as total_nodes
FROM customer_nodes c 
JOIN regions r ON c.region_id = r.region_id
GROUP BY c.region_id,region_name
ORDER BY c.region_id

--Q5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

