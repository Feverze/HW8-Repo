ALTER TABLE IF EXISTS guest_cat_assign DROP CONSTRAINT IF EXISTS fk_guest_cat_assign_guest;
ALTER TABLE IF EXISTS guest_cat_assign DROP CONSTRAINT IF EXISTS fk_guest_cat_assign_category;

ALTER TABLE IF EXISTS hotel_phone DROP CONSTRAINT IF EXISTS fk_hotel_phone_hotel;
ALTER TABLE IF EXISTS hotel_feature DROP CONSTRAINT IF EXISTS fk_hotel_feature_hotel;

ALTER TABLE IF EXISTS room_type DROP CONSTRAINT IF EXISTS fk_room_type_hotel;
ALTER TABLE IF EXISTS season DROP CONSTRAINT IF EXISTS fk_season_hotel;

ALTER TABLE IF EXISTS rooms DROP CONSTRAINT IF EXISTS fk_rooms_hotel;
ALTER TABLE IF EXISTS rooms DROP CONSTRAINT IF EXISTS fk_rooms_room_type;

ALTER TABLE IF EXISTS room_type_feature DROP CONSTRAINT IF EXISTS fk_room_type_feature_room_type;

ALTER TABLE IF EXISTS price DROP CONSTRAINT IF EXISTS fk_price_room_type;
ALTER TABLE IF EXISTS price DROP CONSTRAINT IF EXISTS fk_price_season;

ALTER TABLE IF EXISTS reservation DROP CONSTRAINT IF EXISTS fk_reservation_guest;
ALTER TABLE IF EXISTS reservation DROP CONSTRAINT IF EXISTS fk_reservation_hotel;

ALTER TABLE IF EXISTS reserved_type DROP CONSTRAINT IF EXISTS fk_reserved_type_reservation;
ALTER TABLE IF EXISTS reserved_type DROP CONSTRAINT IF EXISTS fk_reserved_type_room_type;

ALTER TABLE IF EXISTS room_assignment DROP CONSTRAINT IF EXISTS fk_room_assignment_reservation;
ALTER TABLE IF EXISTS room_assignment DROP CONSTRAINT IF EXISTS fk_room_assignment_room;

ALTER TABLE IF EXISTS occupant DROP CONSTRAINT IF EXISTS fk_occupant_assignment;

ALTER TABLE IF EXISTS bill DROP CONSTRAINT IF EXISTS fk_bill_reservation;

ALTER TABLE IF EXISTS service_charge DROP CONSTRAINT IF EXISTS fk_service_charge_bill;
