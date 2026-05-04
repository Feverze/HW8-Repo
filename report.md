# CS374 Hotel Database HW8 Report
Francesco Benedetto and Cameron Hakenson

## ER Model (Chen-style)

```mermaid
flowchart LR
    classDef entity fill:#cdebca,stroke:#1f4e1a,stroke-width:1.5px,color:#000,font-weight:bold
    classDef rel    fill:#fff5cc,stroke:#1f4e1a,stroke-width:1.2px,color:#000
    classDef attr   fill:#e8f5e7,stroke:#1f4e1a,color:#000
    classDef pk     fill:#e8f5e7,stroke:#1f4e1a,color:#000,text-decoration:underline,font-weight:bold

    %% =========================================================
    %% HOTEL and its multivalued attributes
    %% =========================================================
    HOTEL[HOTEL]:::entity
    h_id((hotel_id)):::pk --- HOTEL
    h_name((name)):::attr --- HOTEL
    h_street((street)):::attr --- HOTEL

    HOTEL_PHONE[HOTEL_PHONE]:::entity
    hp_hid((hotel_id)):::pk --- HOTEL_PHONE
    hp_phone((phone)):::pk --- HOTEL_PHONE
    R_H_HAS_PH{has}:::rel
    HOTEL ---|1| R_H_HAS_PH ---|M| HOTEL_PHONE

    HOTEL_FEATURE[HOTEL_FEATURE]:::entity
    hf_hid((hotel_id)):::pk --- HOTEL_FEATURE
    hf_feat((feature)):::pk --- HOTEL_FEATURE
    R_H_HAS_FT{has}:::rel
    HOTEL ---|1| R_H_HAS_FT ---|M| HOTEL_FEATURE

    %% =========================================================
    %% GUEST and category assignment (M:N via associative entity)
    %% =========================================================
    GUEST[GUEST]:::entity
    g_id((guest_id)):::pk --- GUEST
    g_name((name)):::attr --- GUEST
    g_idtype((id_type)):::attr --- GUEST
    g_idnum((id_number)):::attr --- GUEST
    g_addr((address)):::attr --- GUEST
    g_home((home_phone)):::attr --- GUEST
    g_mob((mobile_phone)):::attr --- GUEST

    GUEST_CATEGORY[GUEST_CATEGORY]:::entity
    gc_name((category_name)):::pk --- GUEST_CATEGORY
    gc_disc((discount_pct)):::attr --- GUEST_CATEGORY

    GUEST_CAT_ASSIGN[GUEST_CAT_ASSIGN]:::entity
    gca_gid((guest_id)):::pk --- GUEST_CAT_ASSIGN
    gca_cat((category_name)):::pk --- GUEST_CAT_ASSIGN
    R_G_FOR{for}:::rel
    GUEST ---|1| R_G_FOR ---|M| GUEST_CAT_ASSIGN
    R_GC_OF{categorizes}:::rel
    GUEST_CATEGORY ---|1| R_GC_OF ---|M| GUEST_CAT_ASSIGN

    %% =========================================================
    %% ROOM_TYPE, its features, and ROOMS
    %% =========================================================
    ROOM_TYPE[ROOM_TYPE]:::entity
    rt_hid((hotel_id)):::pk --- ROOM_TYPE
    rt_name((type_name)):::pk --- ROOM_TYPE
    rt_cap((capacity)):::attr --- ROOM_TYPE
    R_H_OFFERS{offers}:::rel
    HOTEL ---|1| R_H_OFFERS ---|M| ROOM_TYPE

    ROOM_TYPE_FEATURE[ROOM_TYPE_FEATURE]:::entity
    rtf_hid((hotel_id)):::pk --- ROOM_TYPE_FEATURE
    rtf_tn((type_name)):::pk --- ROOM_TYPE_FEATURE
    rtf_feat((feature)):::pk --- ROOM_TYPE_FEATURE
    R_RT_HAS{has}:::rel
    ROOM_TYPE ---|1| R_RT_HAS ---|M| ROOM_TYPE_FEATURE

    ROOMS[ROOMS]:::entity
    r_hid((hotel_id)):::pk --- ROOMS
    r_num((room_number)):::pk --- ROOMS
    r_clean((is_clean)):::attr --- ROOMS
    r_tn((type_name)):::attr --- ROOMS
    R_H_CONT{contains}:::rel
    HOTEL ---|1| R_H_CONT ---|M| ROOMS
    R_RT_CLF{classifies}:::rel
    ROOM_TYPE ---|1| R_RT_CLF ---|M| ROOMS

    %% =========================================================
    %% SEASON and PRICE
    %% =========================================================
    SEASON[SEASON]:::entity
    s_hid((hotel_id)):::pk --- SEASON
    s_name((season_name)):::pk --- SEASON
    s_start((start_date)):::attr --- SEASON
    s_end((end_date)):::attr --- SEASON
    R_H_DEF{defines}:::rel
    HOTEL ---|1| R_H_DEF ---|M| SEASON

    PRICE[PRICE]:::entity
    p_hid((hotel_id)):::pk --- PRICE
    p_tn((type_name)):::pk --- PRICE
    p_sn((season_name)):::pk --- PRICE
    p_dow((day_of_week)):::pk --- PRICE
    p_amt((amount)):::attr --- PRICE
    R_RT_PRC{priced_as}:::rel
    ROOM_TYPE ---|1| R_RT_PRC ---|M| PRICE
    R_S_APPL{applied_in}:::rel
    SEASON ---|1| R_S_APPL ---|M| PRICE

    %% =========================================================
    %% RESERVATION, RESERVED_TYPE, ROOM_ASSIGNMENT, OCCUPANT
    %% =========================================================
    RESERVATION[RESERVATION]:::entity
    res_id((reservation_id)):::pk --- RESERVATION
    res_gid((guest_id)):::attr --- RESERVATION
    res_hid((hotel_id)):::attr --- RESERVATION
    res_in((check_in)):::attr --- RESERVATION
    res_out((check_out)):::attr --- RESERVATION
    R_G_MAKES{makes}:::rel
    GUEST ---|1| R_G_MAKES ---|M| RESERVATION
    R_H_RECV{receives}:::rel
    HOTEL ---|1| R_H_RECV ---|M| RESERVATION

    RESERVED_TYPE[RESERVED_TYPE]:::entity
    rty_rid((reservation_id)):::pk --- RESERVED_TYPE
    rty_hid((hotel_id)):::pk --- RESERVED_TYPE
    rty_tn((type_name)):::pk --- RESERVED_TYPE
    rty_qty((quantity)):::attr --- RESERVED_TYPE
    R_RES_REQ{requests}:::rel
    RESERVATION ---|1| R_RES_REQ ---|M| RESERVED_TYPE
    R_RT_ISOF{is_of}:::rel
    ROOM_TYPE ---|1| R_RT_ISOF ---|M| RESERVED_TYPE

    ROOM_ASSIGNMENT[ROOM_ASSIGNMENT]:::entity
    ra_id((assignment_id)):::pk --- ROOM_ASSIGNMENT
    ra_rid((reservation_id)):::attr --- ROOM_ASSIGNMENT
    ra_hid((hotel_id)):::attr --- ROOM_ASSIGNMENT
    ra_rn((room_number)):::attr --- ROOM_ASSIGNMENT
    ra_st((start_date)):::attr --- ROOM_ASSIGNMENT
    ra_en((end_date)):::attr --- ROOM_ASSIGNMENT
    R_RES_ASGN{assigned_to}:::rel
    RESERVATION ---|1| R_RES_ASGN ---|M| ROOM_ASSIGNMENT
    R_R_USED{uses}:::rel
    ROOMS ---|1| R_R_USED ---|M| ROOM_ASSIGNMENT

    OCCUPANT[OCCUPANT]:::entity
    o_id((occupant_id)):::pk --- OCCUPANT
    o_aid((assignment_id)):::attr --- OCCUPANT
    o_name((name)):::attr --- OCCUPANT
    R_RA_INC{includes}:::rel
    ROOM_ASSIGNMENT ---|1| R_RA_INC ---|M| OCCUPANT

    %% =========================================================
    %% BILL and SERVICE / SERVICE_CHARGE
    %% =========================================================
    BILL[BILL]:::entity
    b_id((bill_id)):::pk --- BILL
    b_rid((reservation_id)):::attr --- BILL
    b_date((bill_date)):::attr --- BILL
    b_total((total)):::attr --- BILL
    R_RES_BILL{bills_for}:::rel
    RESERVATION ---|1| R_RES_BILL ---|1| BILL

    SERVICE[SERVICE]:::entity
    svc_type((service_type)):::pk --- SERVICE
    svc_amt((amount)):::attr --- SERVICE

    SERVICE_CHARGE[SERVICE_CHARGE]:::entity
    sc_id((charge_id)):::pk --- SERVICE_CHARGE
    sc_bid((bill_id)):::attr --- SERVICE_CHARGE
    sc_st((service_type)):::attr --- SERVICE_CHARGE
    sc_date((charge_date)):::attr --- SERVICE_CHARGE
    R_B_CHG{has_charges}:::rel
    BILL ---|1| R_B_CHG ---|M| SERVICE_CHARGE
    R_SVC_REF{referenced_by}:::rel
    SERVICE ---|1| R_SVC_REF ---|M| SERVICE_CHARGE
```

Notation legend:
- Rectangle = entity, diamond = relationship, oval = attribute, underlined oval = primary-key attribute.
- Edge labels (`1`, `M`) give cardinality on each side of a relationship.
- Composite primary keys are shown by underlining each component oval (e.g., `(hotel_id, room_number)` for `ROOMS`).
- The `RESERVATION ─ bills_for ─ BILL` relationship is `1:1` to reflect the `UNIQUE` constraint on `bill.reservation_id`.

Static export (HW7 Chen-style diagram, retained for reference):
- ![Hotel ER model](./images/eer_model.png)

Changes since HW7:
- Added a `service` table to store service type and amount in one place.
- Updated `service_charge` to reference `service(service_type)` instead of storing amount directly in each charge row.
- Re-rendered the EER as a Mermaid Chen-style diagram (rectangles for entities, diamonds for relationships, ovals for attributes, underlined PK ovals, `1`/`M` cardinality on edges) so the diagram is text-versioned alongside the schema. Three issues from the original Chen-style PNG are corrected here: `SEASON.start_date` is now shown, the stray `GUEST./type` attribute is removed, and the missing `GUEST ─ makes ─ RESERVATION` relationship is now explicit.

## Relational Model
- ![Hotel relational model](./images/relational_model.png)

Changes since HW7:
- Added relation `service(service_type, amount)`.
- Preserved all existing table/file structure while extending billing-related schema.

## Database creation
- Create tables (no foreign keys): [00_create_tables_no_fks.sql](./database/00_create_tables_no_fks.sql)
- Add foreign keys: [00_add_foreign_keys.sql](./database/00_add_foreign_keys.sql)
- Drop foreign keys: [00_drop_foreign_keys.sql](./database/00_drop_foreign_keys.sql)
- Seed data: [01_seed_data.sql](./data/01_seed_data.sql)

Schema/index notes:
- Added index `idx_reservation_hotel_dates` on `reservation(hotel_id, check_in, check_out)`.
- Added index `idx_room_assignment_room_dates` on `room_assignment(hotel_id, room_number, start_date, end_date)`.
- Reasoning:
  - Query Set 1 and Query 5 use date-range filtering/overlap logic on reservations.
  - Query Set 2 and Query 4 repeatedly check occupancy by room and date.
  - These indexes reduce full table scans on reservation/assignment date lookups.

## Data setup for query testing
Additional data was inserted in `01_seed_data.sql` to fully test the assignment requirements:
- Added `vip` category and mapped a test guest to that category.
- Added reservations and room assignments so at least one requested room type is unavailable.
- Added a Hotel B reservation for Mrs. Smith and an overlapping occupied double room.
- Added room type features for billing statement output.
- Added multi-hotel billed stays for one guest (John Smith) to test one-year chain spending.

## Queries

### Query Set 1: Reservations
Code:
- [query1_reservations.sql](./queries/query1_reservations.sql)

Scenario used:
- New VIP guest request in **Hotel A** for **2026-07-15 to 2026-07-17**.

What the SQL does:
- Select query:
  - Computes all nights in stay (2 nights).
  - Applies season/day-of-week room prices.
  - Applies category discount for VIP.
  - Returns available room types only, plus average nightly price.
- Insert queries (inside a transaction):
  - Inserts new guest.
  - Inserts VIP category assignment.
  - Inserts reservation and reserved room type.

How requirements are satisfied:
- At least one room type is unavailable due to seeded overlap reservation.
- Price varies across the two nights by day-of-week.
- Customer category changes overall price through discount logic.

Screenshots:

Pre-state (existing Hotel A reservations overlapping 2026-07-15 to 2026-07-17 — `suite` is fully booked by reservation 1013):

![Query 1 preconditions](./images/query1/1a_preconditions.png)

Availability + VIP-discounted average nightly cost (only `double` is available; $132.00 average with the 20% VIP discount applied to Wed/Thu summer rates):

![Query 1 availability and average cost](./images/query1/1b_availability.png)

Insert transaction (new VIP guest 1200 and reservation 2200 inside `BEGIN`/`COMMIT`):

![Query 1 insert transaction](./images/query1/1c_insert_transaction.png)

Post-state (new guest, category assignment, reservation, and reserved type rows):

![Query 1 post-state](./images/query1/1d_post_state.png)

### Query Set 2: Checking In
Code:
- [query2_checking_in.sql](./queries/query2_checking_in.sql)

Scenario used:
- **Mrs. Smith** arrives at **Hotel B** for existing reservation `1020` (double room).

What the SQL does:
- Select query:
  - Lists unoccupied double rooms matching reservation hotel/type on check-in date.
  - Excludes currently occupied rooms via `NOT EXISTS` over `room_assignment`.
- Insert queries (inside a transaction):
  - Assigns a room to reservation `1020`.
  - Inserts occupants including Mr. Smith (new occupant record).

How requirements are satisfied:
- Reservation already exists before check-in query.
- At least one double room is occupied and not returned by availability select.

Screenshots:

Pre-state (Mrs. Smith's existing reservation 1020 in Hotel B, plus room 101 already occupied by reservation 1021):

![Query 2 preconditions](./images/query2/2a_preconditions.png)

Available double rooms for reservation 1020 (rooms 102 and 103 — room 101 correctly excluded):

![Query 2 available double rooms](./images/query2/2b_available_rooms.png)

Insert transaction (assigns room 102 and inserts both Mary Smith and Mr. Smith as occupants):

![Query 2 insert transaction](./images/query2/2c_insert_transaction.png)

Post-state (room assignment 5300 and two new occupant rows):

![Query 2 post-state](./images/query2/2d_post_state.png)

### Query Set 3: Checking Out
Code:
- [query3_checking_out.sql](./queries/query3_checking_out.sql)

Scenario used:
- After two nights, Smith reservation `1020` checks out.

What the SQL does:
- Insert/update transaction:
  - Inserts extra service (`minibar`) and service charge.
  - Inserts bill row if missing.
  - Updates room assignment end date to checkout date.
  - Recomputes and updates bill total from:
    - nightly room charges by day-of-week/season/category discount
    - plus service charges
- Final select:
  - Returns reserver, stay date range, room type, room features, and total cost.

How requirements are satisfied:
- Reservation is fully in one season.
- Room cost varies by day-of-week.
- Guest category affects room pricing.
- Checkout and billing history are recorded.

Screenshots:

Pre-state (no bill or `minibar` service yet, room assignment exists from Query Set 2):

![Query 3 preconditions](./images/query3/3a_preconditions.png)

Checkout transaction (inserts service, bill, charge; updates assignment and recomputes bill total):

![Query 3 checkout transaction](./images/query3/3b_checkout_transaction.png)

Billing statement (Mary Smith, 2026-07-15 to 2026-07-17, double, room features, total $315.50 — gold 15% discount on $160 + $170 plus a $35 minibar charge):

![Query 3 billing statement](./images/query3/3c_billing_statement.png)

Post-state (bill 7300 with computed total, `minibar` service row, service charge, and assignment with checkout date):

![Query 3 post-state](./images/query3/3d_post_state.png)

### Query 4: Find the occupants
Code:
- [query4_find_occupants.sql](./queries/query4_find_occupants.sql)

Scenario used:
- Lookup for **Hotel B**, room **102**, date **2026-07-16**.

What the SQL does:
- Returns the reserver name and all occupant names for that room/date.
- Uses `UNION` of reserver lookup and occupant lookup.

How requirements are satisfied:
- Returns at least two names (reserver + at least one occupant).

Screenshots:

Pre-state (room 102 in Hotel B on 2026-07-16: assignment 5300 with reserver Mary Smith, plus the two seeded occupant rows):

![Query 4 preconditions](./images/query4/4a_preconditions.png)

Query result (reserver Mary Smith plus both occupants, satisfying the "at least 2 people" requirement):

![Query 4 result](./images/query4/4b_result.png)

### Query 5: Total spending over a year
Code:
- [query5_total_spending_year.sql](./queries/query5_total_spending_year.sql)

Scenario used:
- Guest **John Smith**, period **2026-01-01 to 2027-01-01**.

What the SQL does:
- Sums billed totals across the chain for that one-year period.
- Enforces requirements with `HAVING`:
  - at least 2 reservations
  - in at least 2 distinct hotels

How requirements are satisfied:
- Seeded billing data includes qualifying reservations in multiple hotels.

Screenshots:

Pre-state (John Smith's two qualifying reservations — Hotel A bill $380, Hotel B bill $310 — both in 2026):

![Query 5 preconditions](./images/query5/5a_preconditions.png)

Query result (total chain spending of $690.00, with `HAVING` confirming 2 reservations across 2 distinct hotels):

![Query 5 result](./images/query5/5b_result.png)

## Transaction usage
Transactions are used for all insert/update workflows that should execute atomically:
- Query Set 1 insert workflow.
- Query Set 2 check-in workflow.
- Query Set 3 checkout and billing workflow.