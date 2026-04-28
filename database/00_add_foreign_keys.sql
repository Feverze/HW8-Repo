

ALTER TABLE guest_cat_assign
  ADD CONSTRAINT fk_guest_cat_assign_guest
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id),
  ADD CONSTRAINT fk_guest_cat_assign_category
    FOREIGN KEY (category_name) REFERENCES guest_category(category_name);

ALTER TABLE hotel_phone
  ADD CONSTRAINT fk_hotel_phone_hotel
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id);

ALTER TABLE hotel_feature
  ADD CONSTRAINT fk_hotel_feature_hotel
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id);

ALTER TABLE room_type
  ADD CONSTRAINT fk_room_type_hotel
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id);

ALTER TABLE season
  ADD CONSTRAINT fk_season_hotel
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id);

ALTER TABLE rooms
  ADD CONSTRAINT fk_rooms_hotel
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id),
  ADD CONSTRAINT fk_rooms_room_type
    FOREIGN KEY (hotel_id, type_name) REFERENCES room_type(hotel_id, type_name);

ALTER TABLE room_type_feature
  ADD CONSTRAINT fk_room_type_feature_room_type
    FOREIGN KEY (hotel_id, type_name) REFERENCES room_type(hotel_id, type_name);

ALTER TABLE price
  ADD CONSTRAINT fk_price_room_type
    FOREIGN KEY (hotel_id, type_name) REFERENCES room_type(hotel_id, type_name),
  ADD CONSTRAINT fk_price_season
    FOREIGN KEY (hotel_id, season_name) REFERENCES season(hotel_id, season_name);

ALTER TABLE reservation
  ADD CONSTRAINT fk_reservation_guest
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id),
  ADD CONSTRAINT fk_reservation_hotel
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id);

ALTER TABLE reserved_type
  ADD CONSTRAINT fk_reserved_type_reservation
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id),
  ADD CONSTRAINT fk_reserved_type_room_type
    FOREIGN KEY (hotel_id, type_name) REFERENCES room_type(hotel_id, type_name);

ALTER TABLE room_assignment
  ADD CONSTRAINT fk_room_assignment_reservation
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id),
  ADD CONSTRAINT fk_room_assignment_room
    FOREIGN KEY (hotel_id, room_number) REFERENCES rooms(hotel_id, room_number);

ALTER TABLE occupant
  ADD CONSTRAINT fk_occupant_assignment
    FOREIGN KEY (assignment_id) REFERENCES room_assignment(assignment_id);

ALTER TABLE bill
  ADD CONSTRAINT fk_bill_reservation
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id);

ALTER TABLE service_charge
  ADD CONSTRAINT fk_service_charge_bill
    FOREIGN KEY (bill_id) REFERENCES bill(bill_id);
