INSERT INTO guest_category (category_name, discount_pct) VALUES
('gold', 0.15),
('silver', 0.07)
ON CONFLICT DO NOTHING;

INSERT INTO hotel (hotel_id, name, street) VALUES
(1, 'Hotel A', '100 Ocean Ave'),
(2, 'Hotel B', '200 Market St'),
(3, 'Hotel C', '300 River Rd'),
(4, 'Hotel D', '400 Hill St'),
(5, 'Hotel E', '500 Lake Dr')
ON CONFLICT DO NOTHING;

INSERT INTO season (hotel_id, season_name, start_date, end_date) VALUES
(1, 'regular', '2026-01-01', '2026-05-31'),
(1, 'summer_special', '2026-06-01', '2026-08-31'),
(2, 'regular', '2026-01-01', '2026-05-31'),
(2, 'summer_special', '2026-06-01', '2026-08-31'),
(3, 'regular', '2026-01-01', '2026-05-31'),
(3, 'summer_special', '2026-06-01', '2026-08-31'),
(4, 'regular', '2026-01-01', '2026-05-31'),
(4, 'summer_special', '2026-06-01', '2026-08-31'),
(5, 'regular', '2026-01-01', '2026-05-31'),
(5, 'summer_special', '2026-06-01', '2026-08-31')
ON CONFLICT DO NOTHING;

INSERT INTO room_type (hotel_id, type_name, capacity, size_sqm) VALUES
(1, 'double', 2, 25.00), (1, 'suite', 4, 50.00),
(2, 'double', 2, 24.50), (2, 'suite', 4, 52.00),
(3, 'double', 2, 26.00), (3, 'suite', 4, 48.00),
(4, 'double', 2, 25.50), (4, 'suite', 4, 51.00),
(5, 'double', 2, 27.00), (5, 'suite', 4, 49.00)
ON CONFLICT DO NOTHING;

INSERT INTO rooms (hotel_id, room_number, is_clean, type_name, floor) VALUES
(1,'101',true,'double',1), (1,'102',true,'double',1), (1,'103',true,'double',1),
(1,'201',true,'suite',2),  (1,'202',true,'suite',2),  (1,'203',true,'suite',2),
(2,'101',true,'double',1), (2,'102',true,'double',1), (2,'103',true,'double',1),
(2,'201',true,'suite',2),  (2,'202',true,'suite',2),  (2,'203',true,'suite',2),
(3,'101',true,'double',1), (3,'102',true,'double',1), (3,'103',true,'double',1),
(3,'201',true,'suite',2),  (3,'202',true,'suite',2),  (3,'203',true,'suite',2),
(4,'101',true,'double',1), (4,'102',true,'double',1), (4,'103',true,'double',1),
(4,'201',true,'suite',2),  (4,'202',true,'suite',2),  (4,'203',true,'suite',2),
(5,'101',true,'double',1), (5,'102',true,'double',1), (5,'103',true,'double',1),
(5,'201',true,'suite',2),  (5,'202',true,'suite',2),  (5,'203',true,'suite',2)
ON CONFLICT DO NOTHING;

INSERT INTO price (hotel_id, type_name, season_name, day_of_week, amount)
SELECT rt.hotel_id, rt.type_name, s.season_name, d.day_of_week,
       CASE
         WHEN rt.type_name='double' AND s.season_name='regular' THEN
           CASE d.day_of_week WHEN 'Mon' THEN 120 WHEN 'Tue' THEN 120 WHEN 'Wed' THEN 125
                              WHEN 'Thu' THEN 130 WHEN 'Fri' THEN 150 WHEN 'Sat' THEN 160 ELSE 140 END
         WHEN rt.type_name='double' AND s.season_name='summer_special' THEN
           CASE d.day_of_week WHEN 'Mon' THEN 150 WHEN 'Tue' THEN 150 WHEN 'Wed' THEN 160
                              WHEN 'Thu' THEN 170 WHEN 'Fri' THEN 190 WHEN 'Sat' THEN 210 ELSE 180 END
         WHEN rt.type_name='suite' AND s.season_name='regular' THEN
           CASE d.day_of_week WHEN 'Mon' THEN 220 WHEN 'Tue' THEN 220 WHEN 'Wed' THEN 230
                              WHEN 'Thu' THEN 240 WHEN 'Fri' THEN 270 WHEN 'Sat' THEN 290 ELSE 250 END
         ELSE
           CASE d.day_of_week WHEN 'Mon' THEN 280 WHEN 'Tue' THEN 280 WHEN 'Wed' THEN 300
                              WHEN 'Thu' THEN 320 WHEN 'Fri' THEN 360 WHEN 'Sat' THEN 390 ELSE 340 END
       END::numeric(10,2)
FROM room_type rt
JOIN season s ON s.hotel_id = rt.hotel_id
CROSS JOIN (VALUES ('Mon'),('Tue'),('Wed'),('Thu'),('Fri'),('Sat'),('Sun')) d(day_of_week)
ON CONFLICT DO NOTHING;

INSERT INTO guest (guest_id, name, id_type, id_number, address, home_phone, mobile_phone) VALUES
(1,'John Smith','passport','P10001','1 Main St','555-0001','555-1001'),
(2,'Mary Smith','passport','P10002','2 Main St','555-0002','555-1002'),
(3,'Alex Kim','driver_license','D10003','3 Main St','555-0003','555-1003'),
(4,'Priya Patel','passport','P10004','4 Main St','555-0004','555-1004'),
(5,'Diego Lopez','driver_license','D10005','5 Main St','555-0005','555-1005'),
(6,'Nina Rossi','passport','P10006','6 Main St','555-0006','555-1006'),
(7,'Sam Green','driver_license','D10007','7 Main St','555-0007','555-1007'),
(8,'Olivia Chen','passport','P10008','8 Main St','555-0008','555-1008'),
(9,'Noah Brown','driver_license','D10009','9 Main St','555-0009','555-1009'),
(10,'Emma White','passport','P10010','10 Main St','555-0010','555-1010')
ON CONFLICT DO NOTHING;

INSERT INTO guest_cat_assign (guest_id, category_name) VALUES
(1,'gold'),(2,'gold'),(3,'silver'),(4,'silver'),(5,'gold'),
(6,'silver'),(7,'gold'),(8,'silver'),(9,'gold'),(10,'silver')
ON CONFLICT DO NOTHING;

INSERT INTO reservation (reservation_id, guest_id, hotel_id, check_in, check_out) VALUES
(1001,1,1,'2026-07-15','2026-07-17'),
(1002,2,2,'2026-07-20','2026-07-23'),
(1003,3,3,'2026-03-10','2026-03-12'),
(1004,4,4,'2026-02-01','2026-02-02'),
(1005,5,5,'2026-08-05','2026-08-08'),
(1006,6,1,'2026-04-15','2026-04-16'),
(1007,7,2,'2026-01-12','2026-01-14'),
(1008,8,3,'2026-06-11','2026-06-13'),
(1009,9,4,'2026-05-20','2026-05-21'),
(1010,10,5,'2026-03-15','2026-03-18'),
(1011,1,2,'2026-09-01','2026-09-03'),
(1012,2,1,'2026-04-20','2026-04-22')
ON CONFLICT DO NOTHING;

INSERT INTO reserved_type (reservation_id, hotel_id, type_name, quantity) VALUES
(1001,1,'double',1),
(1002,2,'double',2),
(1002,2,'suite',1),
(1003,3,'double',1),
(1004,4,'suite',1),
(1005,5,'double',2),
(1005,5,'suite',1),
(1006,1,'double',1),
(1007,2,'suite',1),
(1008,3,'double',1),
(1009,4,'double',1),
(1010,5,'suite',1),
(1011,2,'double',1),
(1012,1,'suite',1)
ON CONFLICT DO NOTHING;

INSERT INTO room_assignment (assignment_id, reservation_id, hotel_id, room_number, start_date, end_date) VALUES
(5001,1003,3,'101','2026-03-10','2026-03-12'),
(5002,1004,4,'201','2026-02-01','2026-02-02'),
(5003,1007,2,'202','2026-01-12','2026-01-14')
ON CONFLICT DO NOTHING;

INSERT INTO occupant (occupant_id, assignment_id, name) VALUES
(9001,5001,'Alex Kim'),
(9002,5002,'Priya Patel'),
(9003,5003,'Sam Green'),
(9004,5003,'Chris Green')
ON CONFLICT DO NOTHING;

INSERT INTO bill (bill_id, reservation_id, bill_date, total) VALUES
(7001,1003,'2026-03-12',300.00),
(7002,1004,'2026-02-02',260.00),
(7003,1007,'2026-01-14',620.00)
ON CONFLICT DO NOTHING;

INSERT INTO service (service_type, amount) VALUES
('laundry',25.00),
('spa',40.00),
('airport_shuttle',60.00)
ON CONFLICT DO NOTHING;

INSERT INTO service_charge (charge_id, bill_id, service_type, charge_date) VALUES
(8001,7001,'laundry','2026-03-11'),
(8002,7002,'spa','2026-02-01'),
(8003,7003,'airport_shuttle','2026-01-13')
ON CONFLICT DO NOTHING;

-- Additional seed data to support HW8 query scenarios
INSERT INTO guest_category (category_name, discount_pct) VALUES
('vip', 0.20)
ON CONFLICT DO NOTHING;

INSERT INTO guest (guest_id, name, id_type, id_number, address, home_phone, mobile_phone) VALUES
(11,'Taylor Guest','passport','P10011','11 Main St','555-0011','555-1011')
ON CONFLICT DO NOTHING;

INSERT INTO guest_cat_assign (guest_id, category_name) VALUES
(11,'vip')
ON CONFLICT DO NOTHING;

INSERT INTO room_type_feature (hotel_id, type_name, feature) VALUES
(1,'double','city_view'),
(1,'suite','balcony'),
(2,'double','free_wifi'),
(2,'double','breakfast_included'),
(2,'suite','jacuzzi')
ON CONFLICT DO NOTHING;

-- Make one room type unavailable in Hotel A for 2026-07-15 to 2026-07-17
INSERT INTO reservation (reservation_id, guest_id, hotel_id, check_in, check_out) VALUES
(1013,4,1,'2026-07-15','2026-07-17')
ON CONFLICT DO NOTHING;

INSERT INTO reserved_type (reservation_id, hotel_id, type_name, quantity) VALUES
(1013,1,'suite',3)
ON CONFLICT DO NOTHING;

-- Existing reservation for Mrs. Smith used in check-in/check-out flows
INSERT INTO reservation (reservation_id, guest_id, hotel_id, check_in, check_out) VALUES
(1020,2,2,'2026-07-15','2026-07-17')
ON CONFLICT DO NOTHING;

INSERT INTO reserved_type (reservation_id, hotel_id, type_name, quantity) VALUES
(1020,2,'double',1)
ON CONFLICT DO NOTHING;

-- Another active reservation keeps one double occupied and unavailable
INSERT INTO reservation (reservation_id, guest_id, hotel_id, check_in, check_out) VALUES
(1021,6,2,'2026-07-14','2026-07-18')
ON CONFLICT DO NOTHING;

INSERT INTO reserved_type (reservation_id, hotel_id, type_name, quantity) VALUES
(1021,2,'double',1)
ON CONFLICT DO NOTHING;

INSERT INTO room_assignment (assignment_id, reservation_id, hotel_id, room_number, start_date, end_date) VALUES
(5201,1021,2,'101','2026-07-14','2026-07-18')
ON CONFLICT DO NOTHING;

INSERT INTO occupant (occupant_id, assignment_id, name) VALUES
(9201,5201,'Nina Rossi')
ON CONFLICT DO NOTHING;

-- Billing records across multiple hotels for yearly chain-spend query
INSERT INTO bill (bill_id, reservation_id, bill_date, total) VALUES
(7010,1001,'2026-07-17',380.00),
(7011,1011,'2026-09-03',310.00)
ON CONFLICT DO NOTHING;

INSERT INTO service_charge (charge_id, bill_id, service_type, charge_date) VALUES
(8010,7010,'spa','2026-07-16'),
(8011,7011,'laundry','2026-09-02')
ON CONFLICT DO NOTHING;
