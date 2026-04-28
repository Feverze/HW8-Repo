-- Query Set 2: Checking In (Mrs. Smith reservation in Hotel B)

-- 2A) List unoccupied double rooms for reservation 1020 on check-in day.
SELECT rm.room_number
FROM reservation r
JOIN reserved_type rt
  ON rt.reservation_id = r.reservation_id
 AND rt.hotel_id = r.hotel_id
JOIN rooms rm
  ON rm.hotel_id = r.hotel_id
 AND rm.type_name = rt.type_name
WHERE r.reservation_id = 1020
  AND rt.type_name = 'double'
  AND NOT EXISTS (
    SELECT 1
    FROM room_assignment ra
    WHERE ra.hotel_id = rm.hotel_id
      AND ra.room_number = rm.room_number
      AND ra.start_date <= r.check_in
      AND ra.end_date >= r.check_in
  )
ORDER BY rm.room_number;

-- 2B) Assign room and add Mr. Smith as new occupant.
BEGIN;

INSERT INTO room_assignment (assignment_id, reservation_id, hotel_id, room_number, start_date, end_date)
SELECT 5300, r.reservation_id, r.hotel_id, '102', r.check_in, r.check_out
FROM reservation r
WHERE r.reservation_id = 1020
ON CONFLICT (assignment_id) DO NOTHING;

INSERT INTO occupant (occupant_id, assignment_id, name)
VALUES
  (9300, 5300, 'Mary Smith'),
  (9301, 5300, 'Mr. Smith')
ON CONFLICT (occupant_id) DO NOTHING;

COMMIT;
