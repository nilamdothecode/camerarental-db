----------------------------------------------------------------------
-- 01_basic_select.sql
-- This query selects all columns from the "users" table.
----------------------------------------------------------------------
-- 1.1 List All Customers
select id, nama, telefon
from customers
order by nama;

----------------------------------------------------------------------
-- 1.2 Unpaid Bookings
----------------------------------------------------------------------
select kod_booking, start_date, jumlah_sewa
from bookings
where payment_status = 'unpaid'
order by start_date;

----------------------------------------------------------------------
-- 1.3 Highest Booking Amount (RM150 and above)
----------------------------------------------------------------------
select kod_booking, jumlah_sewa, rate_sehari
from bookings
where jumlah_sewa >= 150
order by jumlah_sewa desc;

----------------------------------------------------------------------
-- 1.4 Find customers by partial name match
-- LIKE for incomplete matching;
----------------------------------------------------------------------
select nama, telefon 
from customers
where nama like '%Nur%'
order by nama;

----------------------------------------------------------------------
-- 1.5 Booking in a specific date range
----------------------------------------------------------------------
select kod_booking, start_date, return_date, jumlah_sewa
from bookings
where start_date between '2025-08-01' and '2025-08-31'
order by start_date;

----------------------------------------------------------------------
-- 1.6 Bookings with unpaid, in-used status
----------------------------------------------------------------------
select kod_booking, start_date, status_sewa, payment_status
from bookings
where status_sewa in ('booking','in-used')
order by start_date;

----------------------------------------------------------------------
-- 1.7 Most expensive bookings (top 5)
----------------------------------------------------------------------
select kod_booking, jumlah_sewa
from bookings
order by jumlah_sewa desc
limit 5;

----------------------------------------------------------------------
-- 1.8 Rent from specific date range 
----------------------------------------------------------------------
select 
kod_booking, 
start_date,
return_date,
(return_date - start_date) as beza_sehari
from bookings
where return_date is not null
order by beza_sehari desc
limit 10;
