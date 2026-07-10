----------------------------------------------------------------------
-- 03_Joins.sql
-- JOIN operations
--
--    bookings.customer_id       -> customers.id
--    bookings.camera_id         -> cameras.id
--    bookings.location_id       -> locations.id
--    booking_addons.booking_kod -> bookings.kod_booking
--    booking_addons.addon_id    -> addons.id

----------------------------------------------------------------------
-- 3.1 Booking with customers name
--      The bookings table only stores customer_id, not the name.
----------------------------------------------------------------------
select b.kod_booking,
c.nama as pelanggan,
b.start_date,
b.jumlah_sewa
from bookings b
join customers c on b.customer_id = c.id
order by b.start_date desc
limit 10;

----------------------------------------------------------------------
-- 3.2 Booking with unpaid customers
----------------------------------------------------------------------
select c.nama, c.telefon,
b.kod_booking, 
b.start_date, 
b.jumlah_sewa as tertunggak
from bookings b
join customers c on b.customer_id = c.id
where b.payment_status = 'unpaid'
order by b.start_date;

----------------------------------------------------------------------
-- 3.3 Past bookings that are still unpaid
----------------------------------------------------------------------
select c.nama, 
c.telefon,
b.kod_booking,
b.start_date,
(Current_date - b.start_date) as hari_berlalu,
b.jumlah_sewa
from bookings b
join customers c on b.customer_id = c.id
where b.payment_status = 'unpaid'
and b.start_date < current_date
order by hari_berlalu desc;

----------------------------------------------------------------------
-- 3.4 Join 3 tables: bookings, customers, cameras
----------------------------------------------------------------------
select b.kod_booking,
c.nama as pelanggan,
cam.brand || ' ' || cam.model as kamera,
b.jumlah_sewa
from bookings b
join customers as c on b.customer_id = c.id
join cameras cam on b.camera_id = cam.id
order by b.kod_booking 
limit 10;

----------------------------------------------------------------------
-- 3.5 Join + Group BY: Booking followed by camera brand
----------------------------------------------------------------------
select cam.brand || ' ' || cam.model as kamera,
count(*) as bil_tempahan,
sum(b.jumlah_sewa) as hasil
from bookings b 
join cameras  cam on b.camera_id = cam.id
group by kamera
order by hasil desc;

----------------------------------------------------------------------
-- 3.6 Pickup location 
----------------------------------------------------------------------
select l.nama as lokasi,
count(*) as bil_tempahan
from bookings b
join locations l on b.location_id = l.id
group by l.nama
order by bil_tempahan desc
limit 10;

----------------------------------------------------------------------
-- 3.7 Left Join: All camera includes those that have never been rented
----------------------------------------------------------------------
select cam.brand || ' ' || cam.model as kamera,
count(b.kod_booking) as bil_tempahan,
coalesce(sum(b.jumlah_sewa),0) as hasil
from cameras cam
left join bookings as b on cam.id = b.camera_id
group by kamera
order by hasil desc;


----------------------------------------------------------------------
-- 3.8 Left Join to find the matched 
----------------------------------------------------------------------
select cam.brand, cam.model
from cameras cam
left join bookings as b on cam.id = b.camera_id
where b.kod_booking is null;

----------------------------------------------------------------------
-- 3.9 Booking with Addons
----------------------------------------------------------------------
select b.kod_booking,
c.nama as pelanggan,
a.nama as addon,
ba.harga_snapshot 
from booking_addons ba
join bookings b on ba.booking_kod = b.kod_booking
join customers c on b.customer_id = c.id
join addons a on ba.addon_id = a.id
order by b.kod_booking;