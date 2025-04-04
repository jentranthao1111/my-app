-- Trigger 1: Prevent Overlapping Room Bookings
CREATE OR REPLACE FUNCTION prevent_overlapping_bookings()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM public.Booking
        WHERE Room_ID = NEW.Room_ID
        AND Hotel_ID = NEW.Hotel_ID
        AND (
            (NEW.CheckInDate BETWEEN CheckInDate AND CheckOutDate) OR
            (NEW.CheckOutDate BETWEEN CheckInDate AND CheckOutDate) OR
            (CheckInDate BETWEEN NEW.CheckInDate AND NEW.CheckOutDate)
        )
    ) THEN
        RAISE EXCEPTION 'Room % is already booked for the selected dates.', NEW.Room_ID;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_overlapping_bookings
BEFORE INSERT OR UPDATE ON public.Booking
FOR EACH ROW EXECUTE FUNCTION prevent_overlapping_bookings();


-- Trigger 2: Prevent Room Being Rented and Booked at the Same Time
CREATE OR REPLACE FUNCTION prevent_room_rented_and_booked()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Booking
        WHERE Room_ID = NEW.Room_ID
        AND Status = 'Confirmed'
        AND NEW.CheckInDate < CheckOutDate
        AND NEW.CheckOutDate > CheckInDate
    ) THEN
        RAISE EXCEPTION 'Room is already booked for the selected dates';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_room_rented_and_booked_trigger
BEFORE INSERT ON Renting
FOR EACH ROW
EXECUTE FUNCTION prevent_room_rented_and_booked();


-- Trigger 3: Ensure Each Hotel Has At Least One Manager
CREATE OR REPLACE FUNCTION ensure_at_least_one_manager()
RETURNS TRIGGER AS $$
DECLARE
    remaining_managers INTEGER;
BEGIN
    IF OLD.Role = 'Manager' THEN
        SELECT COUNT(*) INTO remaining_managers
        FROM public.Employee
        WHERE Hotel_FID = OLD.Hotel_FID
        AND Role = 'Manager'
        AND Emp_ID != OLD.Emp_ID;

        IF remaining_managers = 0 THEN
            RAISE EXCEPTION 'Hotel % must have at least one manager.', OLD.Hotel_FID;
        END IF;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ensure_manager_removal
BEFORE DELETE ON public.Employee
FOR EACH ROW
EXECUTE FUNCTION ensure_at_least_one_manager();


-- Trigger 4: Ensure Each Hotel Chain Has At Least One Hotel
CREATE OR REPLACE FUNCTION prevent_hotel_chain_without_hotel()
RETURNS TRIGGER AS $$
DECLARE
    remaining_hotels INTEGER;
BEGIN
    SELECT COUNT(*) INTO remaining_hotels
    FROM public.Hotel
    WHERE Hotel_chain_ID = OLD.Hotel_chain_ID
    AND Hotel_ID != OLD.Hotel_ID;

    IF remaining_hotels = 0 THEN
        RAISE EXCEPTION 'Hotel chain % must have at least one hotel.', OLD.Hotel_chain_ID;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_chain_without_hotel
BEFORE DELETE ON public.Hotel
FOR EACH ROW
EXECUTE FUNCTION prevent_hotel_chain_without_hotel();


-- Trigger 5: Ensure Each Hotel Has At Least One Employee
CREATE OR REPLACE FUNCTION prevent_hotel_without_employees()
RETURNS TRIGGER AS $$
DECLARE
    remaining_employees INTEGER;
BEGIN
    SELECT COUNT(*) INTO remaining_employees
    FROM public.Employee
    WHERE Hotel_FID = OLD.Hotel_FID
    AND Emp_ID != OLD.Emp_ID;

    IF remaining_employees = 0 THEN
        RAISE EXCEPTION 'Hotel % must have at least one employee.', OLD.Hotel_FID;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_hotel_without_employees
BEFORE DELETE ON public.Employee
FOR EACH ROW
EXECUTE FUNCTION prevent_hotel_without_employees();



-- Aggregation Queries and Views

-- 1. Total number of rooms available in each hotel chain
SELECT hc.Chain_Name, COUNT(r.Room_ID) AS Total_Rooms
FROM public.Hotel_chain hc
JOIN public.Hotel h ON hc.Hotel_chain_ID = h.Hotel_chain_ID
JOIN public.Room r ON h.Hotel_ID = r.Hotel_ID
GROUP BY hc.Chain_Name
ORDER BY Total_Rooms DESC;


-- 2. All hotels that have at least one manager assigned
SELECT Hotel_ID, Hotel_chain_ID, Email, Num_rooms, Category, Phone
FROM public.Hotel
WHERE Hotel_ID IN (
    SELECT DISTINCT Hotel_FID FROM public.Employee WHERE Role = 'Manager'
);


-- 3. Most expensive room in each hotel
SELECT h.Hotel_ID, h.Hotel_chain_ID, h.Category, MAX(r.Price) AS Highest_Room_Price
FROM public.Hotel h
JOIN public.Room r ON h.Hotel_ID = r.Hotel_ID
GROUP BY h.Hotel_ID, h.Hotel_chain_ID, h.Category
ORDER BY Highest_Room_Price DESC;


-- 4. Customers who have both booked and rented a room
SELECT DISTINCT c.Cust_ID, c.Full_Name, c.Address
FROM public.Customer c
WHERE c.Cust_ID IN (SELECT Cust_ID FROM public.Booking)
AND c.Cust_ID IN (SELECT Cust_ID FROM public.Renting);


-- Index on Customer (Full_Name)
CREATE INDEX idx_customer_name
ON public.Customer (Full_Name);
SELECT * FROM public.Customer WHERE Full_Name = 'John Doe';


-- View 1: Number of Available Rooms per Area
CREATE VIEW public.AvailableRoomsPerArea AS
SELECT 
    h.Hotel_ID,
    h.Hotel_chain_ID,
    h.Category,
    COUNT(r.Room_ID) AS Available_Rooms
FROM public.Room r
JOIN public.Hotel h ON r.Hotel_ID = h.Hotel_ID
LEFT JOIN public.Booking b ON r.Room_ID = b.Room_ID 
    AND b.Status IN ('Pending', 'Confirmed') 
    AND CURRENT_DATE BETWEEN b.CheckInDate AND b.CheckOutDate
LEFT JOIN public.Renting rt ON r.Room_ID = rt.Room_ID 
    AND rt.Status = 'Ongoing'
WHERE b.Booking_ID IS NULL AND rt.Renting_ID IS NULL
GROUP BY h.Hotel_ID, h.Hotel_chain_ID, h.Category;

SELECT * FROM public.AvailableRoomsPerArea;


-- View 2: Aggregated Capacity of All Rooms in a Specific Hotel
CREATE VIEW public.HotelRoomCapacity AS
SELECT 
    h.Hotel_ID,
    h.Hotel_chain_ID,
    h.Category,
    SUM(r.Capacity) AS Total_Capacity
FROM public.Room r
JOIN public.Hotel h ON r.Hotel_ID = h.Hotel_ID
GROUP BY h.Hotel_ID, h.Hotel_chain_ID, h.Category;

SELECT * FROM public.HotelRoomCapacity WHERE Hotel_ID = 1;
