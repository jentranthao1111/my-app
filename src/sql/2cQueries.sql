-- Query 1: Get all managers
SELECT *
FROM Employee
WHERE role = 'Manager';


-- Query 2: Get all bookings with customer names
SELECT B.booking_id, C.full_name, R.RoomType, B.checkindate, B.checkoutdate
FROM booking B
JOIN customer C ON B.cust_id = C.cust_id
JOIN room R ON B.room_id = R.room_id;

-- Query 3: Count number of bookings per room type (Aggregation)            UNFINISHED
SELECT R.RoomType, COUNT(B.Booking_ID) AS booking_count
FROM Booking B
JOIN Room R ON B.Room_ID = R.Room_ID
GROUP BY R.RoomType;

-- Query 4: Find details of most recent booking (Nested)
SELECT *
FROM booking
WHERE booking_id = (
    SELECT MAX(booking_id)
    FROM booking
);
