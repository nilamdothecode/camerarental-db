----------------------------------------------------------------------
-- 04_Subqueries.sql
-- Subquery operations
--    bookings.customer_id       -> customers.id
--    bookings.camera_id         -> cameras.id
--    bookings.location_id       -> locations.id
--    booking_addons.booking_kod -> bookings.kod_booking
--    booking_addons.addon_id    -> addons.id

----------------------------------------------------------------------
-- 4.1 Single-value subquery:
-- Find the customer with the highest total booking amount
----------------------------------------------------------------------
select kod_booking, jumlah_sewa
from bookings
where jumlah_sewa > (select avg(jumlah_sewa) from bookings)
order by jumlah_sewa desc;


----------------------------------------------------------------------
-- 4.2 Highest rental amount 
----------------------------------------------------------------------
SELECT kod_booking, jumlah_sewa
FROM bookings
WHERE jumlah_sewa = (SELECT MAX(jumlah_sewa) FROM bookings);

----------------------------------------------------------------------
-- 4.3 IN with subquery:
-- Find all bookings made by customers who have made more than 1 booking
----------------------------------------------------------------------
select nama, telefon
from customers
where id in(select customer_id from bookings)
order by nama;

----------------------------------------------------------------------
-- 4.4 NOT EXISTS subquery:
-- Find not matching
----------------------------------------------------------------------
select brand, model
from cameras cam
where not exists (
    select 1 from bookings b where b.camera_id = cam.id
);

----------------------------------------------------------------------
-- 4.5 Booking without addon
----------------------------------------------------------------------
select b.kod_booking, b.jumlah_sewa
from bookings b
where not exists (
    select 1 from booking_addons ba 
    where ba.booking_kod = b.kod_booking
)
order by b.kod_booking
limit 10;

----------------------------------------------------------------------
-- 4.6 CTE: Repeated bookings by customers
----------------------------------------------------------------------
with kira_tempahan as (
    select customer_id, count(*) as bil
    from bookings
    group by customer_id
)
select c.nama, c.telefon, k.bil as bil_tempahan
FROM kira_tempahan AS k
JOIN customers AS c ON k.customer_id = c.id
WHERE k.bil > 1
ORDER BY k.bil DESC;

----------------------------------------------------------------------
-- 4.7 Multiple CTEs: ompare each customer's revenue
--      against the overall average across all customers.
----------------------------------------------------------------------

WITH belanja_pelanggan AS (
    SELECT customer_id, SUM(jumlah_sewa) AS jumlah
    FROM bookings
    GROUP BY customer_id
),
purata AS (
    SELECT AVG(jumlah) AS purata_belanja FROM belanja_pelanggan
)
SELECT c.nama,
       bp.jumlah                           AS belanja,
       ROUND(p.purata_belanja, 2)          AS purata_semua,
       ROUND(bp.jumlah - p.purata_belanja, 2) AS beza
FROM belanja_pelanggan AS bp
CROSS JOIN purata AS p
JOIN customers AS c ON bp.customer_id = c.id
WHERE bp.jumlah > p.purata_belanja
ORDER BY belanja DESC
LIMIT 10;