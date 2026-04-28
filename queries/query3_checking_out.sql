-- Query Set 3: Checking Out (billing + service charge + checkout updates)

BEGIN;

INSERT INTO service (service_type, amount)
VALUES ('minibar', 35.00)
ON CONFLICT (service_type) DO NOTHING;

INSERT INTO bill (bill_id, reservation_id, bill_date, total)
VALUES (7300, 1020, DATE '2026-07-17', 0.00)
ON CONFLICT (bill_id) DO NOTHING;

INSERT INTO service_charge (charge_id, bill_id, service_type, charge_date)
VALUES (8300, 7300, 'minibar', DATE '2026-07-16')
ON CONFLICT (charge_id) DO NOTHING;

UPDATE room_assignment ra
SET end_date = r.check_out
FROM reservation r
WHERE ra.reservation_id = r.reservation_id
  AND r.reservation_id = 1020;

WITH nightly_cost AS (
  SELECT
    r.reservation_id,
    SUM(p.amount * (1 - COALESCE(gc.discount_pct, 0)))::numeric(10,2) AS room_total
  FROM reservation r
  JOIN reserved_type rt
    ON rt.reservation_id = r.reservation_id
   AND rt.hotel_id = r.hotel_id
  JOIN season s
    ON s.hotel_id = r.hotel_id
   AND r.check_in BETWEEN s.start_date AND s.end_date
   AND (r.check_out - INTERVAL '1 day') BETWEEN s.start_date AND s.end_date
  JOIN generate_series(r.check_in, r.check_out - INTERVAL '1 day', INTERVAL '1 day') d(night)
    ON TRUE
  JOIN price p
    ON p.hotel_id = r.hotel_id
   AND p.type_name = rt.type_name
   AND p.season_name = s.season_name
   AND p.day_of_week = TRIM(TO_CHAR(d.night, 'Dy'))
  LEFT JOIN guest_cat_assign gca
    ON gca.guest_id = r.guest_id
  LEFT JOIN guest_category gc
    ON gc.category_name = gca.category_name
  WHERE r.reservation_id = 1020
  GROUP BY r.reservation_id
),
service_total AS (
  SELECT b.reservation_id, COALESCE(SUM(s.amount), 0)::numeric(10,2) AS extras_total
  FROM bill b
  LEFT JOIN service_charge sc ON sc.bill_id = b.bill_id
  LEFT JOIN service s ON s.service_type = sc.service_type
  WHERE b.reservation_id = 1020
  GROUP BY b.reservation_id
)
UPDATE bill b
SET total = (nc.room_total + st.extras_total)::numeric(10,2)
FROM nightly_cost nc
JOIN service_total st ON st.reservation_id = nc.reservation_id
WHERE b.reservation_id = nc.reservation_id;

COMMIT;

-- 3B) Billing statement: date range, room type, features, total stay cost.
SELECT
  g.name AS reserving_guest,
  r.check_in,
  r.check_out,
  rt.type_name,
  STRING_AGG(DISTINCT rtf.feature, ', ' ORDER BY rtf.feature) AS room_features,
  b.total AS total_cost
FROM reservation r
JOIN guest g ON g.guest_id = r.guest_id
JOIN reserved_type rt
  ON rt.reservation_id = r.reservation_id
 AND rt.hotel_id = r.hotel_id
LEFT JOIN room_type_feature rtf
  ON rtf.hotel_id = rt.hotel_id
 AND rtf.type_name = rt.type_name
JOIN bill b ON b.reservation_id = r.reservation_id
WHERE r.reservation_id = 1020
GROUP BY g.name, r.check_in, r.check_out, rt.type_name, b.total;
