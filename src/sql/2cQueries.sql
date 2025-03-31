-- Query 1: Get all managers
SELECT *
FROM Employee
WHERE role = 'Manager';


-- Query 2: Get all bookings with customer and room details
SELECT B.booking_id, C.full_name AS customer_name, R.room_id, R.amenity, R.view, B.checkindate AS checkin_date, B.checkoutdate
FROM Booking B
JOIN customer C ON B.cust_id = C.cust_id
JOIN Room R ON B.room_id = R.room_id;


-- Query 3: List all employees working at a specific hotel
SELECT E.fullname, E.role, H.hotel_name
FROM Employee E
JOIN Hotel H ON E.hotel_fid = H.hotel_id
WHERE H.hotel_name = 'Luxury Stay';


-- Query 4: Find details of most recent booking (Nested)
SELECT *
FROM booking
WHERE booking_id = (
    SELECT MAX(booking_id)
    FROM booking
);
