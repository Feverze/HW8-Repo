-- Query Set 1: Reservations (Hotel A, 2026-07-15 to 2026-07-17, VIP)

-- 1A) Find available room types with average nightly cost for the stay.
WITH request AS (
  SELECT
    h.hotel_id,
    DATE '2026-07-15' AS check_in,
    DATE '2026-07-17' AS check_out,
    COALESCE(gc.discount_pct, 0) AS discount_pct
  FROM hotel h
  LEFT JOIN guest_category gc ON gc.category_name = 'vip'
  WHERE h.name = 'Hotel A'
),
nights AS (
  SELECT r.hotel_id, gs::date AS night, r.discount_pct
  FROM request r
  CROSS JOIN generate_series(r.check_in, r.check_out - INTERVAL '1 day', INTERVAL '1 day') gs
),
available AS (
  SELECT
    rt.hotel_id,
    rt.type_name,
    COUNT(rm.room_number) AS total_rooms,
    COALESCE(SUM(rv.quantity), 0) AS reserved_rooms
  FROM room_type rt
  JOIN request req ON req.hotel_id = rt.hotel_id
  JOIN rooms rm
    ON rm.hotel_id = rt.hotel_id
   AND rm.type_name = rt.type_name
  LEFT JOIN reservation r
    ON r.hotel_id = rt.hotel_id
   AND r.check_in < req.check_out
   AND r.check_out > req.check_in
  LEFT JOIN reserved_type rv
    ON rv.reservation_id = r.reservation_id
   AND rv.hotel_id = rt.hotel_id
   AND rv.type_name = rt.type_name
  GROUP BY rt.hotel_id, rt.type_name
),
nightly AS (
  SELECT
    n.hotel_id,
    p.type_name,
    (p.amount * (1 - n.discount_pct))::numeric(10,2) AS discounted_nightly_rate
  FROM nights n
  JOIN season s
    ON s.hotel_id = n.hotel_id
   AND n.night BETWEEN s.start_date AND s.end_date
  JOIN price p
    ON p.hotel_id = n.hotel_id
   AND p.season_name = s.season_name
   AND p.day_of_week = TRIM(TO_CHAR(n.night, 'Dy'))
)
SELECT
  a.type_name,
  (SUM(n.discounted_nightly_rate) / COUNT(*))::numeric(10,2) AS avg_cost_per_night
FROM available a
JOIN nightly n
  ON n.hotel_id = a.hotel_id
 AND n.type_name = a.type_name
WHERE (a.total_rooms - a.reserved_rooms) > 0
GROUP BY a.type_name
ORDER BY avg_cost_per_night;

-- 1B) Insert a new VIP guest and create reservation for one available room type.
BEGIN;

INSERT INTO guest (guest_id, name, id_type, id_number, address, home_phone, mobile_phone)
VALUES (1200, 'Jordan VIP', 'passport', 'P1200', '1200 Guest Ln', '555-1200', '555-2200')
ON CONFLICT (guest_id) DO NOTHING;

INSERT INTO guest_cat_assign (guest_id, category_name)
VALUES (1200, 'vip')
ON CONFLICT (guest_id, category_name) DO NOTHING;

INSERT INTO reservation (reservation_id, guest_id, hotel_id, check_in, check_out)
SELECT 2200, 1200, h.hotel_id, DATE '2026-07-15', DATE '2026-07-17'
FROM hotel h
WHERE h.name = 'Hotel A'
ON CONFLICT (reservation_id) DO NOTHING;

INSERT INTO reserved_type (reservation_id, hotel_id, type_name, quantity)
SELECT 2200, h.hotel_id, 'double', 1
FROM hotel h
WHERE h.name = 'Hotel A'
ON CONFLICT (reservation_id, hotel_id, type_name) DO NOTHING;

COMMIT;
