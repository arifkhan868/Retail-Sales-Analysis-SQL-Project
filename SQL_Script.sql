---Table Create
create table gold.retail_sales (
  transactions_id int primary key,
  sale_date date,
  sale_time time,
  customer_id int,
  gender varchar,
  age int,
  category varchar,
  quantiy int,
  price_per_unit int,
  cogs float,
  total_sale float
);

-----Data Cleaning
select
  *
from
  gold.retail_sales;

select
  count(*)
from
  gold.retail_sales;

select
  *
from
  gold.retail_sales
where
  transactions_id is null;

select
  *
from
  gold.retail_sales
where
  transactions_id is null
  or sale_date is null
  or sale_time is null
  or customer_id is null
  or gender is null
  or age is null
  or category is null
  or quantiy is null
  or price_per_unit is null
  or cogs is null
  or total_sale is null;

delete from gold.retail_sales
where
  quantiy is null;

----- Data Exploration
-- How many sales we have?
select
  count(*) as total_sales
from
  gold.retail_sales;

-- How many unique customers we have ?
select
  count(distinct customer_id) as total_customer
from
  gold.retail_sales;

--How many unique category we have ?
select distinct
  category
from
  gold.retail_sales;

-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select
  *
from
  gold.retail_sales
where
  sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing and the quantity sold is more than 3 in the month of Nov-2022
select
  *
from
  gold.retail_sales
where
  category = 'Clothing'
  and to_char(sale_date, 'yyyy-mm') = '2022-11'
  and quantiy > 3;

-- Q.3 Write a SQL query to calculate the total sales (total sale) for each category.
select
  category,
  sum(total_sale) as total_sales
from
  gold.retail_sales
group by
  1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select
  category,
  round(avg(age), 2) as avg_age
from
  gold.retail_sales
where
  category = 'Beauty'
group by
  1;

-- Q.5 Write a SQL query to find all transactions where the total sale is greater than 1000.
select
  *
from
  gold.retail_sales
where
  total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select
  category,
  gender,
  count(*) as total_order
from
  gold.retail_sales
group by
  1,
  2
order by
  1 desc;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select
  year,
  month,
  avg_sales
from
  (
    select
      extract(
        year
        from
          sale_date
      ) as year,
      extract(
        month
        from
          sale_date
      ) as month,
      avg(total_sale) as avg_sales,
      rank() over (
        partition by
          extract(
            year
            from
              sale_date
          )
        order by
          avg(total_sale) desc
      ) as ranking
    from
      gold.retail_sales
    group by
      1,
      2
    order by
      1,
      3 desc
  ) as ct
where
  ranking = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select
  customer_id,
  sum(total_sale) as total_sales
from
  gold.retail_sales
group by
  1
order by
  2 desc
limit
  5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select
  category,
  count(distinct customer_id) as unique_customer
from
  gold.retail_sales
group by
  1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17,     Evening >17)
with
  hourly_sales as (
    select
      *,
      case
        when extract(
          hour
          from
            sale_time
        ) < 12 then 'Morning'
        when extract(
          hour
          from
            sale_time
        ) between 12 and 17  then 'Afternoon'
        else 'Evening'
      end as shift
    from
      gold.retail_sales
  )
select
  shift,
  count(*) as total_order
from
  hourly_sales
group by
  1;

-- end of project