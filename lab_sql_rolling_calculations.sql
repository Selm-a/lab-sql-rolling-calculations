use sakila ; 


#Get number of monthly active customers.
select * from customer;
select * from rental;

create or replace view  customer_rental as
	select customer_id, convert(rental_date, date) as activity_date,
		date_format(convert(rental_date, date), "%y") as activity_year,
		date_format(convert(rental_date, date), "%m") as activity_month
    from rental;
    
    select * from customer_rental ;
    select count(customer_id) as customer_per_month, activity_year, activity_month
    from customer_rental
    group by activity_year, activity_month
    order by activity_year, activity_month;

#Active users in the previous month.
  select * from customer_rental ;
create or replace view customer_rental_2 as 
    (select count(customer_id) as customer_per_month, activity_year, activity_month
    from customer_rental
    group by activity_year, activity_month
    order by activity_year, activity_month);
	
    select  activity_year, activity_month, customer_per_month,
  	lag(customer_per_month, 1) over (order by activity_month) as total_previous_month
    from customer_rental_2;


#Percentage change in the number of active customers.
    select  activity_year, activity_month, customer_per_month,
  	lag(customer_per_month, 1) over (order by activity_month) as total_previous_month,
    round((customer_per_month / lag(customer_per_month, 1) over (order by activity_month) -1)*100, 2) as percentage_change
    from customer_rental_2;

#Retained customers every month.

    select * from customer_rental ;
    select count(customer_id) as customer_per_month, activity_year, activity_month
    from customer_rental
    group by activity_year, activity_month
    order by activity_year, activity_month;


select * from rental ;
    
select customer_id,  rental_date,
rank() over (partition by customer_id order by rental_date desc) as "rank"
from rental;

select customer_id,  date_format(convert(rental_date, date), "%m") as activity_month,
rank() over (partition by customer_id order by (date_format(convert(rental_date, date), "%m"))) as "rank"
from rental;
    
create or replace view customer_retained as 
(select customer_id,  date_format(convert(rental_date, date), "%m") as activity_month,
rank() over (partition by customer_id order by (date_format(convert(rental_date, date), "%m"))) as "rank"
from rental);

#how much customers in total 
select count(distinct customer_id) 
from customer_retained;

#how much customers retained every month 
select count(distinct customer_id) 
from customer_retained
where activity_month = 02 and 05 and 06 and 07 and 08; 


