-- Double-booking Prevention (Room cannot be double-booked):
CREATE OR REPLACE FUNCTION prevent_double_booking()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Booking
               WHERE Room_ID = NEW.Room_ID
               AND ((NEW.CheckInDate BETWEEN CheckInDate AND CheckOutDate)
                    OR (NEW.CheckOutDate BETWEEN CheckInDate AND CheckOutDate))) THEN
        RAISE EXCEPTION 'Room is already booked for the selected dates';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_double_booking_trigger
BEFORE INSERT ON Booking
FOR EACH ROW
EXECUTE FUNCTION prevent_double_booking();


--Room cannot be rented and booked at the same time:
CREATE OR REPLACE FUNCTION prevent_room_rented_and_booked()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Booking
               WHERE Room_ID = NEW.Room_ID
               AND Status = 'Confirmed'
               AND NEW.CheckInDate < CheckOutDate
               AND NEW.CheckOutDate > CheckInDate) THEN
        RAISE EXCEPTION 'Room is already booked for the selected dates';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_room_rented_and_booked_trigger
BEFORE INSERT ON Renting
FOR EACH ROW
EXECUTE FUNCTION prevent_room_rented_and_booked();