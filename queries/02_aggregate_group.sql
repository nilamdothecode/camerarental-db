----------------------------------------------------------------------
-- 02_aggregate_group.sql
-- COUNT, SUM, AVG, MIN, MAX, GROUP BY
----------------------------------------------------------------------
-- 2.1 Total sum of booking amounts
----------------------------------------------------------------------
select sum(jumlah_sewa) as hasil_keseluruhan
from bookings;

----------------------------------------------------------------------
-- 2.2 Booking summary
----------------------------------------------------------------------
select 
count(*) as jumlah_tempahan,
round(avg(jumlah_sewa),2) as hasil,
max(jumlah_sewa) as tempahan_tertinggi,
min(jumlah_sewa) as tempahan_terendah
from bookings;

----------------------------------------------------------------------
-- 2.3 Sum followed by yearly grouping
----------------------------------------------------------------------
select extract(year from start_date) as tahun,
count(*) as bil_tempahan,
sum(jumlah_sewa) as hasil
from bbookings
group by tahun
order by tahun;

----------------------------------------------------------------------
-- 2.4 Sum followed by monthly (12 months) grouping
----------------------------------------------------------------------
select to_char(start_date,'YYYY-MM') as bulan,
count(*) as bil_tempahan,
sum(jumlah_sewa) as hasil
from bookings
group by bulan
order by bulan desc
limit 12;

----------------------------------------------------------------------
-- 2.5 Payment status summary
----------------------------------------------------------------------
select payment_status,
count(*) as bil,
sum(jumlah_sewa) as nilai
from bookings
group by payment_status
order by nilai desc;

----------------------------------------------------------------------
-- 2.6 Rental status summary
----------------------------------------------------------------------
select status_sewa, count(*) as bil
from bookings
group by status_sewa
order by bil desc;

----------------------------------------------------------------------
-- 2.7 Monthly summary with more RM500 bookings
----------------------------------------------------------------------
select to_char(start_date,'YYYY-MM') as bulan,
sum(jumlah_sewa) as hasil
from bookings 
group by bulan
having sum(jumlah_sewa) > 500
order by hasil desc;


----------------------------------------------------------------------
-- 2.8 Using WHERE and HAVING together
-- WHERE removes unpdaid bookings first, 
-- then HAVING filters the monthly summary
----------------------------------------------------------------------
select to_char(start_date,'YYYY-MM') as bulan,
count(*) as bil_tempahan,
sum(jumlah_sewa) as hasil_sebenar
from bookings
where payment_status = 'paid'
group by bulan
having count(* ) >= 3
order by hasil_sebenar desc;