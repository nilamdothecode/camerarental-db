------------------------------------------------------------------------
--  05_business_insights.sql
------------------------------------------------------------------------

--  Part 1: Money
-- ---------------------------------------------------------------------
 5.1  Papan pemuka hasil
-- ---------------------------------------------------------------------
SELECT COUNT(*)                                                   AS jumlah_tempahan,
       SUM(jumlah_sewa)                                           AS hasil_kasar,
       SUM(jumlah_sewa) FILTER (WHERE payment_status = 'paid')    AS telah_dikutip,
       SUM(jumlah_sewa) FILTER (WHERE payment_status = 'unpaid')  AS tertunggak,
       ROUND(AVG(jumlah_sewa), 2)                                 AS purata_tempahan
FROM bookings;


-- ---------------------------------------------------------------------
-- 5.2  Wang tertunggak, disusun ikut yang paling lama
--      RM450 daripada 4 tempahan pada masa penulisan.
--      Ini senarai panggilan telefon anda.
-- ---------------------------------------------------------------------
SELECT c.nama,
       c.telefon,
       b.kod_booking,
       b.start_date,
       b.jumlah_sewa,
       CASE
           WHEN b.start_date < CURRENT_DATE THEN 'Tempahan sudah berlalu'
           ELSE 'Tempahan akan datang'
       END AS keadaan
FROM bookings AS b
JOIN customers AS c ON b.customer_id = c.id
WHERE b.payment_status = 'unpaid'
ORDER BY b.start_date;


-- ---------------------------------------------------------------------
-- 5.3  Trend hasil bulanan
--      Kenal pasti bulan puncak dan bulan lembap.
-- ---------------------------------------------------------------------
SELECT TO_CHAR(start_date, 'YYYY-MM')  AS bulan,
       COUNT(*)                        AS bil_tempahan,
       SUM(jumlah_sewa)                AS hasil,
       ROUND(AVG(jumlah_sewa), 2)      AS purata_setiap_tempahan
FROM bookings
GROUP BY bulan
ORDER BY bulan;


-- =====================================================================
--  BAHAGIAN 2: PELANGGAN
-- =====================================================================

-- ---------------------------------------------------------------------
-- 5.4  Pelanggan paling bernilai (mengikut perbelanjaan, bukan kekerapan)
--
--      Pelanggan yang menyewa sekali selama 12 hari boleh berbelanja
--      lebih daripada pelanggan yang menyewa tiga kali selama sehari.
--      Kekerapan bukan nilai.
-- ---------------------------------------------------------------------
SELECT c.nama,
       c.telefon,
       COUNT(*)                    AS bil_tempahan,
       SUM(b.jumlah_sewa)          AS jumlah_belanja,
       ROUND(AVG(b.jumlah_sewa), 2) AS purata_setiap_tempahan
FROM bookings AS b
JOIN customers AS c ON b.customer_id = c.id
GROUP BY c.nama, c.telefon
ORDER BY jumlah_belanja DESC
LIMIT 10;


-- ---------------------------------------------------------------------
-- 5.5  Pelanggan sekali sahaja lawan pelanggan berulang
--
--      PENEMUAN: 12 pelanggan berulang (23% daripada asas pelanggan)
--      menjana RM1,830 -- iaitu RM152.50 setiap seorang.
--      40 pelanggan sekali sahaja menjana RM3,660 -- RM91.50 seorang.
--
--      Pelanggan berulang bernilai ~67% lebih tinggi setiap kepala.
--      Ini membenarkan kos untuk mengekalkan mereka.
-- ---------------------------------------------------------------------
WITH belanja_pelanggan AS (
    SELECT customer_id,
           COUNT(*)           AS bil_tempahan,
           SUM(jumlah_sewa)   AS jumlah_belanja
    FROM bookings
    GROUP BY customer_id
)
SELECT CASE WHEN bil_tempahan = 1 THEN 'Sekali sahaja'
            ELSE 'Berulang'
       END                                     AS segmen,
       COUNT(*)                                AS bil_pelanggan,
       SUM(jumlah_belanja)                     AS hasil,
       ROUND(AVG(jumlah_belanja), 2)           AS nilai_setiap_pelanggan
FROM belanja_pelanggan
GROUP BY segmen
ORDER BY hasil DESC;


-- ---------------------------------------------------------------------
-- 5.6  Pelanggan berulang -- mereka yang patut dijaga
-- ---------------------------------------------------------------------
SELECT c.nama,
       c.telefon,
       COUNT(*)             AS bil_tempahan,
       SUM(b.jumlah_sewa)   AS jumlah_belanja,
       MIN(b.start_date)    AS sewaan_pertama,
       MAX(b.start_date)    AS sewaan_terkini
FROM bookings AS b
JOIN customers AS c ON b.customer_id = c.id
GROUP BY c.nama, c.telefon
HAVING COUNT(*) > 1
ORDER BY bil_tempahan DESC, jumlah_belanja DESC;


-- ---------------------------------------------------------------------
-- 5.7  Pelanggan yang sudah lama tidak kembali
--      Sasaran untuk kempen "kami rindu anda".
-- ---------------------------------------------------------------------
SELECT c.nama,
       c.telefon,
       MAX(b.start_date)                       AS sewaan_terakhir,
       (CURRENT_DATE - MAX(b.start_date))      AS hari_sejak_terakhir,
       SUM(b.jumlah_sewa)                      AS jumlah_belanja
FROM bookings AS b
JOIN customers AS c ON b.customer_id = c.id
GROUP BY c.nama, c.telefon
HAVING MAX(b.start_date) < CURRENT_DATE - INTERVAL '90 days'
ORDER BY jumlah_belanja DESC
LIMIT 15;


-- =====================================================================
--  BAHAGIAN 3: INVENTORI
-- =====================================================================

-- ---------------------------------------------------------------------
-- 5.8  Prestasi kamera -- termasuk yang tidak menjana apa-apa
--
--      PENEMUAN: Canon R50 menjana RM4,950 daripada 61 tempahan,
--      iaitu 90% daripada keseluruhan hasil.
--      Sony A6400 dan Kodak: sifar tempahan.
--
--      Risiko kepekatan. Kalau R50 rosak, perniagaan terhenti.
-- ---------------------------------------------------------------------
SELECT cam.brand || ' ' || cam.model            AS kamera,
       COUNT(b.kod_booking)                     AS bil_tempahan,
       COALESCE(SUM(b.jumlah_sewa), 0)          AS hasil,
       ROUND(
           100.0 * COALESCE(SUM(b.jumlah_sewa), 0)
           / (SELECT SUM(jumlah_sewa) FROM bookings), 1
       )                                        AS peratus_hasil
FROM cameras AS cam
LEFT JOIN bookings AS b ON cam.id = b.camera_id
GROUP BY kamera
ORDER BY hasil DESC;


-- ---------------------------------------------------------------------
-- 5.9  Penembusan add-on
--
--      PENEMUAN: hanya 6 daripada 66 tempahan (9%) mengambil add-on.
--      Peluang jualan tambahan yang terlepas.
--
--      Nota: harga Memory Card dan Battery belum ditetapkan (RM0),
--      jadi kedua-duanya disewa secara percuma tanpa disedari.
-- ---------------------------------------------------------------------
SELECT COUNT(DISTINCT b.kod_booking)                AS jumlah_tempahan,
       COUNT(DISTINCT ba.booking_kod)               AS tempahan_dengan_addon,
       ROUND(
           100.0 * COUNT(DISTINCT ba.booking_kod)
           / COUNT(DISTINCT b.kod_booking), 1
       )                                            AS peratus_penembusan,
       COALESCE(SUM(ba.harga_snapshot), 0)          AS hasil_addon
FROM bookings AS b
LEFT JOIN booking_addons AS ba ON b.kod_booking = ba.booking_kod;


-- ---------------------------------------------------------------------
-- 5.10  Add-on mana yang paling laku
-- ---------------------------------------------------------------------
SELECT a.nama                          AS addon,
       COUNT(*)                        AS kali_disewa,
       SUM(ba.harga_snapshot)          AS hasil
FROM booking_addons AS ba
JOIN addons AS a ON ba.addon_id = a.id
GROUP BY a.nama
ORDER BY kali_disewa DESC;


-- =====================================================================
--  BAHAGIAN 4: KUALITI DATA
--
--  Query yang mencari rekod yang tidak masuk akal.
--  Jalankan secara berkala; spreadsheet tidak akan menangkapnya.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 5.11  Tempahan bertanda 'return' tetapi tarikh pulang di masa hadapan
--       Mustahil secara logik.
-- ---------------------------------------------------------------------
SELECT kod_booking, start_date, return_date, status_sewa, payment_status
FROM bookings
WHERE status_sewa = 'return'
  AND return_date > CURRENT_DATE;


-- ---------------------------------------------------------------------
-- 5.12  Nombor telefon dikongsi oleh lebih daripada satu pelanggan
--       Sepatutnya tidak berlaku (telefon adalah UNIQUE),
--       tetapi ini menangkap ruang letak seperti 'PERLU-SEMAK-01'.
-- ---------------------------------------------------------------------
SELECT telefon, COUNT(*) AS bil_pelanggan
FROM customers
GROUP BY telefon
HAVING COUNT(*) > 1;

-- Pelanggan dengan telefon yang belum disahkan
SELECT id, nama, telefon
FROM customers
WHERE telefon LIKE 'PERLU-SEMAK%';


-- ---------------------------------------------------------------------
-- 5.13  Tempahan lepas yang masih bertanda 'booking'
--       Sama ada status terlupa dikemas kini, atau pelanggan tidak muncul.
-- ---------------------------------------------------------------------
SELECT c.nama,
       b.kod_booking,
       b.start_date,
       b.status_sewa,
       b.payment_status
FROM bookings AS b
JOIN customers AS c ON b.customer_id = c.id
WHERE b.status_sewa = 'booking'
  AND b.start_date < CURRENT_DATE
ORDER BY b.start_date;


-- ---------------------------------------------------------------------
-- 5.14  Pemulangan lewat -- adakah denda dikenakan?
--       Pada masa penulisan: tiada. 'late return' hanyalah label
--       tanpa kesan kewangan. Pertimbangkan column denda.
-- ---------------------------------------------------------------------
SELECT b.kod_booking,
       c.nama,
       b.start_date,
       b.return_date,
       (b.return_date - b.start_date) AS hari,
       b.rate_sehari,
       b.jumlah_sewa
FROM bookings AS b
JOIN customers AS c ON b.customer_id = c.id
WHERE b.status_sewa = 'late return';