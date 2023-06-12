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

--------------------------------------------------------------------

select a.region_id, b.region_name, count(a.node_id) nodes_count 
from customer_nodes a
left join regions b
on a.region_id = b.region_id
group by a.region_id, b.region_name

select 
	n.region_id,
	r.region_name,
	count(distinct n.node_id) unique_nodes,
	count(n.node_id) number_of_nodes
from customer_nodes n 
left join regions r on n.region_id = r.region_id
group by n.region_id, r.region_name
order by n.region_id;

SELECT c.region_id,
	region_name,
	COUNT(node_id) AS num_of_nodes
FROM customer_nodes c
INNER JOIN regions r
ON c.region_id = r.region_id
GROUP BY c.region_id, region_name
ORDER BY num_of_nodes DESC;

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