-- Query 5: Total spending over one year at chain

SELECT
  g.guest_id,
  g.name,
  SUM(b.total)::numeric(10,2) AS total_spent_in_period
FROM guest g
JOIN reservation r ON r.guest_id = g.guest_id
JOIN bill b ON b.reservation_id = r.reservation_id
WHERE g.name = 'John Smith'
  AND r.check_in >= DATE '2026-01-01'
  AND r.check_in < DATE '2027-01-01'
GROUP BY g.guest_id, g.name
HAVING COUNT(DISTINCT r.reservation_id) >= 2
   AND COUNT(DISTINCT r.hotel_id) >= 2;
