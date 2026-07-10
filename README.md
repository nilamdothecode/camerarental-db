# Camera Rental Database

A PostgreSQL database for a real camera rental business, rebuilt from three years of
spreadsheet records. This project covers schema design, data normalisation, and SQL
analysis — not a textbook exercise, but real business data with real problems.

---

## Background

The business tracked rentals in Google Sheets: one tab per year, one for the price list.
It worked, but a spreadsheet cannot stop you from making mistakes. After 66 bookings,
the data contained:

- One phone number shared by **three different customers** (copy-paste during entry)
- A **duplicate booking code** (`2026-011` used twice)
- The same location spelled four ways (`SCM`, `Setia City Mall`, `Setia City Mall, Shah Alam`)
- A booking marked **"returned"** with a future return date
- Three columns `Add-on 1/2/3` — and `Add-on 3` was never used once

Every one of these is now **impossible** under this schema.

---

## Schema

Six tables. Four parents, one transaction, one junction.

```
customers ──┐
cameras   ──┼──> bookings ──> booking_addons <── addons
locations ──┘
```

| Table | Role | Key constraint |
|---|---|---|
| `customers` | Renters | `telefon UNIQUE` — blocks duplicates |
| `cameras` | Camera inventory | `aktif` for soft delete |
| `addons` | Tripod, battery, memory card | — |
| `locations` | Pickup points | `nama UNIQUE` — blocks spelling variants |
| `bookings` | Rental transactions | PK is `kod_booking` (natural key) |
| `booking_addons` | M:N junction | Replaces the `Add-on 1/2/3` columns |

Files: [`schema/01_schema.sql`](schema/01_schema.sql), [`schema/02_seed.sql`](schema/02_seed.sql)

### Design decisions

**Snapshot values vs current values.**
The deposit used to be RM100, now it's RM50. If `bookings` referenced the current price
in `cameras`, historical records would show the wrong amount. So:

- `cameras.deposit_semasa` — for **new** bookings
- `bookings.deposit_dibayar` — what was **actually** paid, frozen forever

Same principle for `rate_sehari` and `booking_addons.harga_snapshot`.

**Store what happened; compute what can be derived.**
`duration` is not stored — it is `return_date - start_date`. But `jumlah_sewa` **is**
stored, because it is the amount the customer actually paid. That is a transactional
fact, not a calculation that should shift if the pricing formula changes.

**Repeating group eliminated.**
`Add-on 1`, `Add-on 2`, `Add-on 3` became rows in `booking_addons`.
Customer wants five add-ons? Five rows. No `ALTER TABLE`.

---

## Findings

Numbers below are produced by [`queries/05_business_insights.sql`](queries/05_business_insights.sql).

**Repeat customers are worth 67% more per head.**
12 repeat customers (23% of the base) generate RM152.50 each.
40 one-time customers generate RM91.50 each. This justifies spending on retention.

**A single camera carries 90% of revenue.**
Canon R50: RM4,950 across 61 bookings. DJI Osmo Pocket: RM540 across 5.
Sony A6400 and Kodak: zero. Concentration risk — if the R50 breaks, the business stops.

**Add-on attach rate is only 9%.**
6 of 66 bookings. And the battery has no price set, so it has been rented for free
without anyone noticing.

**RM450 outstanding** across 4 unpaid bookings.

---

## Repository layout

```
schema/
  01_schema.sql            DDL — tables, constraints, indexes
  02_seed.sql              66 bookings, 52 customers (normalised from Excel)
queries/
  01_basic_select.sql      SELECT, WHERE, ORDER BY, LIKE, IN, BETWEEN
  02_aggregate_groupby.sql COUNT, SUM, AVG + GROUP BY + HAVING
  03_joins.sql             INNER JOIN, LEFT JOIN, JOIN + GROUP BY
  04_subqueries_cte.sql    Subqueries, EXISTS, CTEs
  05_business_insights.sql Real business questions + data quality checks
docs/
  erd.png                  Entity relationship diagram
```

---

## Running it

Requires PostgreSQL 12+. Tested on Neon.

```bash
createdb camerarental
psql -d camerarental -f schema/01_schema.sql
psql -d camerarental -f schema/02_seed.sql
```

Verify:

```sql
SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL SELECT 'bookings', COUNT(*) FROM bookings;
-- customers: 52, bookings: 66
```

Then run any file in `queries/`.

---

## A note on data quality

Two customers in the seed have placeholder phone numbers (`PERLU-SEMAK-01`,
`PERLU-SEMAK-02`). Their real numbers were overwritten by a copy-paste error in the
source spreadsheet and cannot be recovered from the data — they must be checked
against the original records.

This was left visible on purpose. Hiding a gap in the data is worse than flagging it.

[`queries/05_business_insights.sql`](queries/05_business_insights.sql) includes a
**Data Quality** section that hunts for inconsistent records: bookings marked
"returned" with future dates, past bookings still marked "booking", and late returns
carrying no penalty.

---

## Note on language

Table and column names are in Malay, matching how the business actually records its
data (`jumlah_sewa`, `kod_booking`, `status_sewa`). Renaming them to English would put
a translation layer between the schema and the people who use it.