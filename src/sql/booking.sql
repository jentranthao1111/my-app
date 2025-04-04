-- 2c.
--1. Find the total number of rooms available in each hotel chain (Aggregation Query)
SELECT hc.Chain_Name, COUNT(r.Room_ID) AS Total_Rooms
FROM public.Hotel_chain hc
JOIN public.Hotel h ON hc.Hotel_chain_ID = h.Hotel_chain_ID
JOIN public.Room r ON h.Hotel_ID = r.Hotel_ID
GROUP BY hc.Chain_Name
ORDER BY Total_Rooms DESC;


--2. Find all hotels that have at least one manager assigned (Nested Query)
SELECT Hotel_ID, Hotel_chain_ID, Email, Num_rooms, Category, Phone
FROM public.Hotel
WHERE Hotel_ID IN (
    SELECT DISTINCT Hotel_FID FROM public.Employee WHERE Role = 'Manager'
);

--3. Find the most expensive room in each hotel (Aggregation Query)
SELECT h.Hotel_ID, h.Hotel_chain_ID, h.Category, MAX(r.Price) AS Highest_Room_Price
FROM public.Hotel h
JOIN public.Room r ON h.Hotel_ID = r.Hotel_ID
GROUP BY h.Hotel_ID, h.Hotel_chain_ID, h.Category
ORDER BY Highest_Room_Price DESC;


--4. Find customers who have both booked and rented a room
SELECT DISTINCT c.Cust_ID, c.Full_Name, c.Address
FROM public.Customer c
WHERE c.Cust_ID IN (SELECT Cust_ID FROM public.Booking)
AND c.Cust_ID IN (SELECT Cust_ID FROM public.Renting);


-- 2d.
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


-- Trigger 2: Room cannot be rented and booked at the same time:
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



-- 2e.
-- Index on Booking (Room_ID, CheckInDate, CheckOutDate)
Drop index if exists idx_booking_room_dates;
CREATE INDEX idx_booking_room_dates
ON public.Booking (Room_ID, CheckInDate, CheckOutDate);

select * from public.booking;

SELECT * FROM public.Booking 
WHERE Room_ID = '111'
AND (CheckInDate BETWEEN '2025-05-01' AND '2025-06-01' OR CheckOutDate BETWEEN '2025-05-01' AND '2025-06-01');


drop index if exists idx_customer_name;
CREATE INDEX idx_customer_name
ON public.Customer (full_name);
SELECT * FROM public.Customer WHERE full_name = 'John Doe';


drop index if exists idx_room_hotel_price_capacity;
CREATE INDEX idx_room_hotel_price_capacity
ON public.Room (Hotel_ID, Price, Capacity);
SELECT * FROM public.Room WHERE Hotel_ID = 1 AND Price BETWEEN 100 AND 400 AND Capacity >= 2;



-- 2f.
--View 1: Number of Available Rooms per Area
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

SELECT * FROM public.AvailableRoomsPerArea; -- This will work now



--View 2: Aggregated Capacity of All Rooms in a Specific Hotel
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
