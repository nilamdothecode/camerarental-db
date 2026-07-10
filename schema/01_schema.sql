-- =====================================================================
--  Sistem Sewa Kamera  —  Skema (struktur table)
--  PostgreSQL / Neon
--
--  Urutan binaan: table induk dahulu (tiada FK), kemudian table
--  transaksi yang merujuknya. Jalankan fail ini DAHULU, kemudian seed.
-- =====================================================================

-- Untuk bina semula dari kosong, buang komen pada blok DROP di bawah.
-- AMARAN: ini memadam table berserta semua datanya.
-- Perhati urutan: anak dahulu, induk kemudian.
-- DROP TABLE IF EXISTS booking_addons;
-- DROP TABLE IF EXISTS bookings;
-- DROP TABLE IF EXISTS locations;
-- DROP TABLE IF EXISTS addons;
-- DROP TABLE IF EXISTS cameras;
-- DROP TABLE IF EXISTS customers;

-- ---------------------------------------------------------------------
-- 1. PELANGGAN  (induk)  —  telefon = kunci sebenar pengenalan
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama        VARCHAR(150) NOT NULL,
    telefon     VARCHAR(20) NOT NULL UNIQUE,   -- unique: halang pendua
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON COLUMN customers.telefon IS 'Kunci pengenalan sebenar; nama boleh sama antara orang';

-- ---------------------------------------------------------------------
-- 2. KAMERA  (induk)
-- ---------------------------------------------------------------------
CREATE TABLE cameras (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    brand           VARCHAR(50) NOT NULL,
    model           VARCHAR(100) NOT NULL,
    deposit_semasa  NUMERIC(8,2) NOT NULL DEFAULT 50,  -- untuk booking BARU
    aktif           BOOLEAN NOT NULL DEFAULT TRUE,      -- soft delete
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON COLUMN cameras.deposit_semasa IS 'Deposit untuk booking baru; booking lama simpan snapshot sendiri';

-- ---------------------------------------------------------------------
-- 3. ADD-ON  (induk)
-- ---------------------------------------------------------------------
CREATE TABLE addons (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama          VARCHAR(100) NOT NULL UNIQUE,
    harga_semasa  NUMERIC(8,2) NOT NULL DEFAULT 0,
    aktif         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- 4. LOKASI  (induk)  —  elak "SCM" vs "Setia City Mall"
-- ---------------------------------------------------------------------
CREATE TABLE locations (
    id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama     VARCHAR(150) NOT NULL UNIQUE,
    kawasan  VARCHAR(100)
);

-- ---------------------------------------------------------------------
-- 5. TEMPAHAN  (transaksi)  —  PK = kod_booking (natural key)
--    rate_sehari & deposit_dibayar = SNAPSHOT harga ketika ditempah
-- ---------------------------------------------------------------------
CREATE TABLE bookings (
    kod_booking      VARCHAR(20) PRIMARY KEY,           -- cth '2025-001'
    customer_id      BIGINT NOT NULL REFERENCES customers(id),
    camera_id        BIGINT NOT NULL REFERENCES cameras(id),
    location_id      BIGINT REFERENCES locations(id),   -- nullable: belum pasti
    booking_date     DATE NOT NULL,
    start_date       DATE NOT NULL,
    return_date      DATE,
    rate_sehari      NUMERIC(8,2) NOT NULL CHECK (rate_sehari >= 0),
    jumlah_sewa      NUMERIC(10,2) NOT NULL CHECK (jumlah_sewa >= 0),  -- apa yang DICAJ
    deposit_dibayar  NUMERIC(8,2) NOT NULL CHECK (deposit_dibayar >= 0),
    payment_status   VARCHAR(20) NOT NULL DEFAULT 'unpaid'
                       CHECK (payment_status IN ('unpaid', 'paid', 'deposit')),
    status_sewa      VARCHAR(20) NOT NULL DEFAULT 'booking'
                       CHECK (status_sewa IN ('booking', 'in-used', 'return', 'late return')),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),

    CHECK (return_date IS NULL OR return_date >= start_date)
);

COMMENT ON COLUMN bookings.rate_sehari IS 'Snapshot rate ketika ditempah (rate berperingkat: 1-2/3-6/7+ hari)';
COMMENT ON TABLE bookings IS 'duration & total TIDAK disimpan - dikira: return_date - start_date';

-- ---------------------------------------------------------------------
-- 6. ADD-ON TEMPAHAN  (junction)  —  satu booking, banyak add-on
--    Menggantikan column Add-on 1/2/3 dalam Excel  (1NF)
-- ---------------------------------------------------------------------
CREATE TABLE booking_addons (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_kod     VARCHAR(20) NOT NULL REFERENCES bookings(kod_booking),
    addon_id        BIGINT NOT NULL REFERENCES addons(id),
    harga_snapshot  NUMERIC(8,2) NOT NULL,   -- harga ketika disewa
    kuantiti        INTEGER NOT NULL DEFAULT 1 CHECK (kuantiti > 0)
);

-- ---------------------------------------------------------------------
-- INDEX  —  column yang kerap dicari
-- ---------------------------------------------------------------------
CREATE INDEX idx_bookings_customer   ON bookings (customer_id);
CREATE INDEX idx_bookings_start_date ON bookings (start_date);
CREATE INDEX idx_bookings_status     ON bookings (status_sewa);
