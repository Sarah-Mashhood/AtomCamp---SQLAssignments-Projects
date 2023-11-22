-- Assignment No. 1

select * from commodity;
select * from food_prices;

SET SQL_SAFE_UPDATES = 0;

UPDATE food_prices
set date = str_to_date(date,'%m/%d/%Y');

ALTER table food_prices
MODIFY date DATETIME;

-- ●	Select dates and commodities for cities Quetta, Karachi, and Peshawar 
-- where price was less than or equal 50 PKR

select date , cmname , price , mktname
from food_prices
where mktname IN ('Quetta', 'Karachi', 'Peshawar') 
AND price <= 50; 

-- Query to check number of observations against each market/city in PK

select  mktname , count(*) as Observations_Count
from food_prices
where country = 'Pakistan'
group by mktname;

-- Show number of distinct cities
select count(distinct(mktname))
from food_prices;

-- List down/show the names of cities in the table
select distinct(mktname) as Cities_name
from food_prices;

-- List down/show the names of commodities in the table
select distinct(cmname) as Comomodities_name
from food_prices;

-- List Average Prices for Wheat flour - Retail in EACH city separately over the entire period

select mktname , round(avg(price),2) as Avg_Price_WheatFlour_Retail
from food_prices
where cmname = 'Wheat flour - Retail'
group by mktname;

-- Calculate summary stats (avg price, max price) for each city separately for all cities 
-- except Karachi and sort alphabetically the city names, commodity names
-- where commodity is Wheat (does not matter which one) with separate rows for each commodity

select mktname , cmname, round(avg(price),2) as Avg_Price , round(max(price),2) as MaxPrice
from food_prices
where mktname <> 'Karachi' and cmname LIKE '%Wheat%'
group by mktname , cmname
order by mktname , cmname;

-- Calculate Avg_prices for each city for Wheat Retail and show only those 
-- avg_prices which are less than 30

select mktname , round(avg(price),2) as Avg_Price_Wheat_Retail
from food_prices
where cmname = 'Wheat - Retail' 
group by mktname
having Avg_Price_Wheat_Retail < 30;

-- Prepare a table where you categorize prices based on a logic
-- (price < 30 is LOW, price > 250 is HIGH, in between are FAIR)

select date , cmname , price , mktname,
CASE
WHEN price < 30 THEN 'LOW'
WHEN price > 250 THEN 'HIGH'
ELSE 'FAIR'
END as price_category
from food_prices;

-- Create a query showing date, cmname, category, city, price, city_category
-- where Logic for city category is: Karachi and Lahore are 'Big City',
-- Multan and Peshawar are 'Medium-sized city', Quetta is 'Small City'

select date , cmname, category, mktname, price ,
CASE
WHEN mktname IN ('Karachi' , 'Lahore') THEN 'Big City'
WHEN mktname IN ('Multan' , 'Peshawar') THEN 'Medium-sized city'
WHEN mktname = 'Quetta' THEN 'Small City'
END as city_category
from food_prices;

-- Create a query to show date, cmname, city, price. Create new column price_fairness 
-- through CASE showing price is fair if less than 100, unfair if more than or equal to 100, 
-- if > 300 then 'Speculative'

select date , cmname,  mktname, price ,
CASE
WHEN price < 100 THEN 'Fair'
WHEN price > 300 THEN 'Speculative'
WHEN price >= 100 THEN 'UnFair'
END as price_fairness
from food_prices
order by price_fairness;

-- Join the food prices and commodities table with a left join. 

select * 
from food_prices as fp
left join commodity as c
on fp.cmname = c.cmname;


-- Join the food prices and commodities table with an inner join

select * 
from food_prices as fp
inner join commodity as c
on fp.cmname = c.cmname;
