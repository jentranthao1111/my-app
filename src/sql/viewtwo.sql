CREATE OR REPLACE VIEW hotel_total_capacity AS
SELECT h.hotel_id, h.hotel_name, SUM(r.capacity) AS total_capacity
FROM hotel h
JOIN room r ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_id, h.hotel_name;

SELECT * FROM hotel_total_capacity;