DROP TABLE IF EXISTS service_charge;
DROP TABLE IF EXISTS service;
DROP TABLE IF EXISTS bill;
DROP TABLE IF EXISTS occupant;
DROP TABLE IF EXISTS room_assignment;
DROP TABLE IF EXISTS reserved_type;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS price;
DROP TABLE IF EXISTS room_type_feature;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS season;
DROP TABLE IF EXISTS room_type;
DROP TABLE IF EXISTS hotel_feature;
DROP TABLE IF EXISTS hotel_phone;
DROP TABLE IF EXISTS guest_cat_assign;
DROP TABLE IF EXISTS guest_category;
DROP TABLE IF EXISTS guest;
DROP TABLE IF EXISTS hotel;

CREATE TABLE hotel (
  hotel_id INT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  street VARCHAR(200) NOT NULL
);

CREATE TABLE guest (
  guest_id INT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  id_type VARCHAR(40) NOT NULL,
  id_number VARCHAR(60) NOT NULL,
  address VARCHAR(200),
  home_phone VARCHAR(30),
  mobile_phone VARCHAR(30)
);

CREATE TABLE guest_category (
  category_name VARCHAR(40) PRIMARY KEY,
  discount_pct NUMERIC(5,4) NOT NULL CHECK (discount_pct >= 0 AND discount_pct <= 1)
);

CREATE TABLE guest_cat_assign (
  guest_id INT NOT NULL,
  category_name VARCHAR(40) NOT NULL,
  PRIMARY KEY (guest_id, category_name)
);

CREATE TABLE hotel_phone (
  hotel_id INT NOT NULL,
  phone VARCHAR(30) NOT NULL,
  PRIMARY KEY (hotel_id, phone)
);

CREATE TABLE hotel_feature (
  hotel_id INT NOT NULL,
  feature VARCHAR(80) NOT NULL,
  PRIMARY KEY (hotel_id, feature)
);

CREATE TABLE room_type (
  hotel_id INT NOT NULL,
  type_name VARCHAR(40) NOT NULL,
  capacity INT NOT NULL CHECK (capacity > 0),
  size_sqm NUMERIC(6,2) CHECK (size_sqm > 0),
  PRIMARY KEY (hotel_id, type_name)
);

CREATE TABLE season (
  hotel_id INT NOT NULL,
  season_name VARCHAR(60) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  PRIMARY KEY (hotel_id, season_name),
  CHECK (start_date < end_date)
);

CREATE TABLE rooms (
  hotel_id INT NOT NULL,
  room_number VARCHAR(20) NOT NULL,
  is_clean BOOLEAN NOT NULL DEFAULT TRUE,
  type_name VARCHAR(40) NOT NULL,
  floor INT NOT NULL,
  PRIMARY KEY (hotel_id, room_number)
);

CREATE TABLE room_type_feature (
  hotel_id INT NOT NULL,
  type_name VARCHAR(40) NOT NULL,
  feature VARCHAR(80) NOT NULL,
  PRIMARY KEY (hotel_id, type_name, feature)
);

CREATE TABLE price (
  hotel_id INT NOT NULL,
  type_name VARCHAR(40) NOT NULL,
  season_name VARCHAR(60) NOT NULL,
  day_of_week VARCHAR(3) NOT NULL CHECK (day_of_week IN ('Mon','Tue','Wed','Thu','Fri','Sat','Sun')),
  amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
  PRIMARY KEY (hotel_id, type_name, season_name, day_of_week)
);

CREATE TABLE reservation (
  reservation_id INT PRIMARY KEY,
  guest_id INT NOT NULL,
  hotel_id INT NOT NULL,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  CHECK (check_in < check_out)
);

CREATE TABLE reserved_type (
  reservation_id INT NOT NULL,
  hotel_id INT NOT NULL,
  type_name VARCHAR(40) NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  PRIMARY KEY (reservation_id, hotel_id, type_name)
);

CREATE TABLE room_assignment (
  assignment_id INT PRIMARY KEY,
  reservation_id INT NOT NULL,
  hotel_id INT NOT NULL,
  room_number VARCHAR(20) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  CHECK (start_date <= end_date)
);

CREATE TABLE occupant (
  occupant_id INT PRIMARY KEY,
  assignment_id INT NOT NULL,
  name VARCHAR(120) NOT NULL
);

CREATE TABLE bill (
  bill_id INT PRIMARY KEY,
  reservation_id INT NOT NULL UNIQUE,
  bill_date DATE NOT NULL,
  total NUMERIC(10,2) NOT NULL CHECK (total >= 0)
);

CREATE TABLE service (
  service_type VARCHAR(80) PRIMARY KEY,
  amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0)
);

CREATE TABLE service_charge (
  charge_id INT PRIMARY KEY,
  bill_id INT NOT NULL,
  service_type VARCHAR(80) NOT NULL,
  charge_date DATE NOT NULL
);

CREATE INDEX idx_reservation_hotel_dates
  ON reservation (hotel_id, check_in, check_out);

CREATE INDEX idx_room_assignment_room_dates
  ON room_assignment (hotel_id, room_number, start_date, end_date);
