-- =====================================================
--  Camera Rental — DML (data dari Excel, dinormalize)
--  Jalankan SELEPAS schema.sql
-- =====================================================

TRUNCATE booking_addons, bookings, locations, addons, cameras, customers
    RESTART IDENTITY CASCADE;

-- ---------- CAMERAS ----------
INSERT INTO cameras (brand, model, deposit_semasa) VALUES
('Canon', 'R50', 50),
('DJI', 'Osmo Pocket', 50),
('Sony', 'A6400', 50),
('Kodak', 'Kodak', 50);

-- ---------- ADDONS ----------
-- Memory Card & Battery: harga belum diisi dalam Excel (sel kuning)
INSERT INTO addons (nama, harga_semasa) VALUES
('Tripod', 15.0),
('Memory Card', 0.0),
('Battery', 0.0);

-- ---------- CUSTOMERS ----------
-- 52 pelanggan unik (dari 66 booking)
INSERT INTO customers (nama, telefon) VALUES
('Farhan', '60193642527'),
('Nuradilah Binti Ishak', '601126662378'),
('Farah Nur Ain Binti Inuddin', '60103730614'),
('Siti Nurellyana Binti Tajul Arifin', '60132573221'),
('Nur Yuhanis Sabrina Binti Sabri', '60149332863'),
('Suryani Binti Basyah Abdullah', '601112625901'),
('Nur Allysha Sofea Binti Shaiful', '601163087887'),
('Nurmiza Humaira Binti Nashruddin', '60182230146'),
('Nooruldiyanah Binti Yusof', '60174408477'),
('Aina Nabila Binti Mat Razi', '60102003411'),
('Nur Aleesya Khairina Binti Azli', '60146436560'),
('Nurul Aziqin Binti Halim', '601128226965'),
('Nur Khairun Nysha Binti Kamarul Zaman', '60192361604'),
('Nur Aliefa Eliyana Binti Samsuri', '601120848711'),
('Muhammad Zafir Hadif Bin Mohamad Zurzain', '60177690628'),
('Noor Shaakirah Mubarok Ali', '60102980819'),
('Nur Aneesa Salbiah Binti Noorhisham', '60139869539'),
('Farizatul Izzrin Binti Faizz', '60182239286'),
('Nurul Ain Alia Binti Muhammad Sabri', '60174239066'),
('Chempaka Damia Binti Mohd Najib', '601133060626'),
('Norlaili Husna Binti Hisammuddin', '601129038285'),
('Muhamad Shazwan Bin Mohamad Noor', '60193447906'),
('Sarah Syahira Binti Saibatul Ajhar', '601140152913'),
('Nur Fadhilah', '60183197617'),
('Marissa Airen Binti Badri', '60145532152'),
('Abg Wan', '60199407740'),
('Nur Dania Nafeesa Binti Ahmad Shakhiri', '60142349886'),
('Nurul Najjah Najihah Binti Mohd Roslan', '601112266453'),
('Aisyah Safiyah Binti Asri', '60175420644'),
('Nuralya Sofea Binti Hairulanuar', '60122579992'),
('Nurul Ain Binti Rozainy', '601110289109'),
('Muhammad Hamzah Bin Badrul', '601119770895'),
('Nur Tasnim Binti Amran', '60172046836'),
('Normisha Safiah Binti Omar (RAYA)', '60132025697'),
('Nazirul Haziq Bin Suhadi', '60127376102'),
('Nor Najiha Binti Khalid', '60196796184'),
('Aina Syakirah Binti Amiuddin', '60179511774'),
('Lee Jing Jie', '60122041468'),
('Khalisha Alia Binti Zulkefli', '60173247476'),
('Mohd Adzrulll Syafeeq', '60137708090'),
('Siti Sarah Binti Ahmad Nazri', '601127025067'),
('Nur Qashrina Binti Jefri', '60149702930'),
('Jazeema Azam Binti Saiful Azam', '60164442684'),
('Faizatul Maisarah Binti Mohd Johan', 'PERLU-SEMAK-01'),
('Nur Adilah Insyirah Binti Mohammad Muzi', 'PERLU-SEMAK-02'),
('Nur Nabilah Binti Aziz', '60179244427'),
('Hasri Priadi Bin', '60142257625'),
('Fatin Nurizzati Binti Razali', '601123375736'),
('Nur Haifa Umairah Binti Ahmad Sofian', '601159800981'),
('Nurmala Maisuri Binti Kamarul Azhar', '60129256143'),
('Tengku Arish Iskandar Bin Tengku Ahmad', '60177187170'),
('Norfazlin Binti Md Isa', '601111337813');

-- ---------- LOCATIONS ----------
-- 31 lokasi unik
INSERT INTO locations (nama) VALUES
('Aeon 23'),
('Aeon Bukit Raja'),
('Aeon Seksyen 13'),
('Bukit Kemuning'),
('Bukit Raja, Klang'),
('Citta Mall'),
('Golden Villa Apartment'),
('Hotel Mardhiyyah, Shah Alam'),
('I-City, Selangor'),
('Jalan Kebun, Shah Alam'),
('KSL Mall'),
('KUIS, Kajang'),
('Kapitan Seksyen 13'),
('Mamak Bukit Kemuning'),
('Meru, Klang'),
('NSK, Klang'),
('PLC'),
('Pelabuhan Klang'),
('Puchong'),
('Rawang, Selangor'),
('Seksyen 13'),
('Seksyen 19'),
('Seksyen 20'),
('Seksyen 24'),
('Seksyen 7'),
('Seksyen 8'),
('Setia City Mall'),
('Shah Alam'),
('Sunway Pyramid, Selangor'),
('UITM Shah Alam (Fakulti Undang-Undang)'),
('Zus Seksyen 20');

-- ---------- BOOKINGS ----------
INSERT INTO bookings (kod_booking, customer_id, camera_id, location_id,
    booking_date, start_date, return_date, rate_sehari, jumlah_sewa,
    deposit_dibayar, payment_status, status_sewa) VALUES
('2025-001', 1, 1, 12, '2025-08-29', '2025-08-29', '2025-08-30', 50.00, 50.00, 100.00, 'paid', 'return'),
('2025-002', 2, 1, 20, '2025-07-31', '2025-08-14', '2025-08-17', 40.00, 120.00, 100.00, 'paid', 'return'),
('2025-003', 3, 1, 10, '2025-08-09', '2025-08-10', '2025-08-10', 50.00, 50.00, 100.00, 'paid', 'return'),
('2025-004', 2, 1, 20, '2025-08-17', '2025-08-14', '2025-08-19', 50.00, 50.00, 100.00, 'paid', 'return'),
('2025-005', 4, 1, 9, '2025-08-21', '2025-09-09', '2025-09-10', 50.00, 50.00, 100.00, 'paid', 'return'),
('2025-006', 5, 1, 9, '2025-08-22', '2025-09-13', '2025-09-14', 50.00, 50.00, 100.00, 'paid', 'return'),
('2025-007', 6, 1, 9, '2025-08-26', '2025-08-30', '2025-08-31', 50.00, 50.00, 100.00, 'paid', 'return'),
('2025-008', 7, 1, 29, '2025-09-05', '2025-09-05', '2025-09-06', 50.00, 65.00, 50.00, 'paid', 'return'),
('2025-009', 8, 1, 13, '2025-09-12', '2025-10-03', '2025-10-05', 50.00, 100.00, 50.00, 'paid', 'return'),
('2025-010', 9, 1, 5, '2025-09-17', '2025-10-08', '2025-10-09', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-011', 10, 1, 16, '2025-09-17', '2025-11-16', '2025-11-16', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-012', 11, 1, 18, '2025-09-24', '2025-09-25', '2025-09-28', 40.00, 135.00, 50.00, 'paid', 'return'),
('2025-013', 12, 2, 31, '2025-09-26', '2025-09-26', '2025-09-27', 45.00, 45.00, 50.00, 'paid', 'return'),
('2025-014', 13, 1, 27, '2025-09-27', '2025-10-18', '2025-10-20', 50.00, 100.00, 50.00, 'paid', 'return'),
('2025-015', 14, 1, 27, '2025-09-28', '2025-10-24', '2025-10-25', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-016', 15, 2, 14, '2025-09-28', '2025-10-17', '2025-10-26', 35.00, 315.00, 50.00, 'paid', 'late return'),
('2025-017', 16, 2, 15, '2025-10-03', '2025-10-03', '2025-10-04', 45.00, 45.00, 50.00, 'paid', 'return'),
('2025-018', 16, 2, 15, '2025-10-05', '2025-10-03', '2025-10-04', 45.00, 90.00, 50.00, 'paid', 'return'),
('2025-019', 17, 1, 28, '2025-10-04', '2025-12-13', '2025-12-15', 50.00, 100.00, 50.00, 'paid', 'return'),
('2025-020', 8, 1, 13, '2025-10-19', '2025-11-25', '2025-11-25', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-021', 18, 1, 27, '2025-10-20', '2025-12-20', '2025-12-21', 50.00, 100.00, 50.00, 'paid', 'return'),
('2025-022', 19, 1, 22, '2025-10-20', '2025-11-08', '2025-11-08', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-023', 12, 1, 31, '2025-11-03', '2025-11-28', '2025-11-30', 40.00, 120.00, 50.00, 'paid', 'late return'),
('2025-024', 20, 1, 9, '2025-10-26', '2025-11-24', '2025-11-24', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-025', 21, 1, 4, '2025-10-29', '2025-11-03', '2025-11-04', 50.00, 100.00, 50.00, 'paid', 'return'),
('2025-026', 22, 1, 27, '2025-10-31', '2025-11-01', '2025-11-02', 50.00, 100.00, 50.00, 'paid', 'return'),
('2025-027', 23, 1, 3, '2025-11-06', '2025-12-05', '2025-12-06', 50.00, 100.00, 50.00, 'paid', 'return'),
('2025-028', 24, 1, 30, '2025-11-06', '2025-11-09', '2025-11-09', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-029', 25, 1, 25, '2025-11-09', '2025-11-10', '2025-11-10', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-030', 26, 1, 7, '2025-11-09', '2025-11-22', '2025-11-22', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-031', 26, 1, 7, '2025-11-09', '2025-12-26', '2025-12-26', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-032', 27, 1, 27, '2025-11-14', '2025-11-20', '2025-11-20', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-033', 28, 1, 9, '2025-11-13', '2025-11-23', '2025-11-23', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-034', 29, 1, 27, '2025-11-21', '2025-11-26', '2025-11-26', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-035', 30, 1, 2, '2025-11-22', '2025-12-07', '2025-12-08', 50.00, 100.00, 50.00, 'paid', 'return'),
('2025-036', 31, 1, 27, '2025-11-09', '2025-12-10', '2025-12-10', 50.00, 50.00, 50.00, 'paid', 'return'),
('2025-037', 32, 1, 17, '2025-12-21', '2025-12-22', '2025-12-23', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-001', 33, 1, 8, '2025-12-09', '2026-01-03', '2026-01-04', 50.00, 100.00, 50.00, 'paid', 'return'),
('2026-002', 34, 1, 25, '2026-01-05', '2026-03-19', '2026-03-23', 40.00, 200.00, 50.00, 'paid', 'return'),
('2026-003', 35, 1, 28, '2026-01-15', '2026-01-19', '2026-01-19', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-004', 36, 1, 5, '2026-01-07', '2026-01-31', '2026-02-01', 50.00, 100.00, 50.00, 'paid', 'return'),
('2026-005', 37, 1, 26, '2026-01-30', '2026-02-08', '2026-02-08', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-006', 38, 1, 19, '2026-01-31', '2026-02-14', '2026-02-25', 35.00, 435.00, 50.00, 'paid', 'return'),
('2026-007', 39, 1, 27, '2026-03-06', '2026-03-07', '2026-03-07', 50.00, 100.00, 50.00, 'paid', 'return'),
('2026-008', 40, 1, 6, '2026-03-25', '2026-03-28', '2026-03-28', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-009', 41, 1, 11, '2026-03-30', '2026-04-01', '2026-04-01', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-010', 18, 1, 27, '2026-03-31', '2026-04-06', '2026-04-06', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-011a', 42, 1, 23, '2026-03-31', '2026-04-03', '2026-04-03', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-011b', 42, 2, 23, '2026-03-31', '2026-04-03', '2026-04-03', 45.00, 45.00, 50.00, 'paid', 'return'),
('2026-012', 43, 1, 25, '2026-04-01', '2026-04-04', '2026-04-04', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-013', 6, 1, 24, '2026-04-11', '2026-04-12', '2026-04-12', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-014', 12, 1, 23, '2026-04-11', '2026-05-09', '2026-05-09', 50.00, 65.00, 50.00, 'paid', 'return'),
('2026-015', 44, 1, 25, '2026-04-16', '2026-04-18', '2026-04-19', 50.00, 100.00, 50.00, 'paid', 'return'),
('2026-016', 45, 1, 25, '2026-04-17', '2026-05-11', '2026-05-11', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-017', 46, 1, 5, '2026-04-19', '2026-04-20', '2026-04-25', 40.00, 240.00, 50.00, 'paid', 'return'),
('2026-018', 47, 1, 21, '2026-04-28', '2026-05-01', '2026-05-03', 40.00, 120.00, 50.00, 'paid', 'return'),
('2026-019', 48, 1, 21, '2026-04-28', '2026-05-18', '2026-05-18', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-020', 27, 1, 25, '2026-04-28', '2026-07-26', '2026-07-26', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-021', 49, 1, 2, '2026-05-05', '2026-06-15', '2026-06-15', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-022', 50, 1, 25, '2026-05-08', '2026-05-12', '2026-05-12', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-023', 50, 1, 25, '2026-06-02', '2026-06-06', '2026-06-06', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-024', 27, 1, 25, '2026-04-28', '2026-06-16', '2026-06-16', 50.00, 50.00, 50.00, 'unpaid', 'booking'),
('2026-025', 51, 1, 2, '2026-06-27', '2026-06-27', '2026-06-28', 50.00, 50.00, 50.00, 'paid', 'return'),
('2026-026', 10, 1, 16, '2026-06-28', '2026-10-27', '2026-11-01', 40.00, 200.00, 50.00, 'unpaid', 'booking'),
('2026-027', 36, 1, 5, '2026-06-23', '2026-07-07', '2026-07-07', 50.00, 100.00, 50.00, 'unpaid', 'booking'),
('2026-028', 52, 1, 1, '2026-06-30', '2026-07-03', '2026-07-05', 50.00, 100.00, 50.00, 'unpaid', 'booking');

-- ---------- BOOKING_ADDONS ----------
-- Add-on 1/2/3 dipecahkan jadi baris (bukan column) — ini 1NF
-- 7 add-on direkodkan
INSERT INTO booking_addons (booking_kod, addon_id, harga_snapshot) VALUES
('2025-008', 1, 15.00),
('2025-012', 1, 15.00),
('2025-020', 3, 0.00),
('2025-031', 3, 0.00),
('2026-006', 3, 0.00),
('2026-006', 1, 15.00),
('2026-014', 1, 15.00);

-- ---------- Semakan pantas ----------
-- SELECT 'customers' AS t, COUNT(*) FROM customers
-- UNION ALL SELECT 'cameras', COUNT(*) FROM cameras
-- UNION ALL SELECT 'addons', COUNT(*) FROM addons
-- UNION ALL SELECT 'locations', COUNT(*) FROM locations
-- UNION ALL SELECT 'bookings', COUNT(*) FROM bookings
-- UNION ALL SELECT 'booking_addons', COUNT(*) FROM booking_addons;