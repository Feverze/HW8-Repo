-- Query 4: Find occupants for specific room/date

SELECT 'reserver' AS person_role, g.name AS person_name
FROM room_assignment ra
JOIN reservation r ON r.reservation_id = ra.reservation_id
JOIN guest g ON g.guest_id = r.guest_id
WHERE ra.hotel_id = 2
  AND ra.room_number = '102'
  AND DATE '2026-07-16' BETWEEN ra.start_date AND ra.end_date
UNION
SELECT 'occupant' AS person_role, o.name AS person_name
FROM room_assignment ra
JOIN occupant o ON o.assignment_id = ra.assignment_id
WHERE ra.hotel_id = 2
  AND ra.room_number = '102'
  AND DATE '2026-07-16' BETWEEN ra.start_date AND ra.end_date
ORDER BY person_role, person_name;
