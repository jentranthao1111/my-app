CREATE OR REPLACE VIEW available_rooms_per_area AS
SELECT h.city AS area, COUNT(r.room_id) AS available_rooms
FROM hotel h
JOIN room r ON h.hotel_id = r.hotel_id
WHERE r.room_id NOT IN (
    SELECT b.room_id
    FROM booking b
    WHERE CURRENT_DATE BETWEEN b.checkindate AND b.checkoutdate
)
GROUP BY h.city;

SELECT * FROM available_rooms_per_area;