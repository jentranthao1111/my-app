-- Delete All Data If You Need To
-- DO $$ 
-- DECLARE 
--     r RECORD;
-- BEGIN 
--     FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') 
--     LOOP 
--         EXECUTE 'TRUNCATE TABLE public.' || quote_ident(r.tablename) || ' CASCADE'; 
--     END LOOP; 
-- END $$;

SET search_path TO public;

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ehotel_csi2132_prj') THEN
      CREATE DATABASE ehotel_csi2132_prj;
   END IF;
END $$;

-- Create Schema public if not exists
CREATE SCHEMA IF NOT EXISTS public;
DROP TABLE IF EXISTS public.Hotel_chain Cascade;

CREATE TABLE IF NOT EXISTS public.Hotel_chain (
    Hotel_chain_ID serial PRIMARY KEY,
	Chain_Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    Num_hotels INT CHECK (Num_hotels >= 1),
    Email VARCHAR(100),
    Phone VARCHAR(20)
);



DROP TABLE IF EXISTS public.Hotel CASCADE;

CREATE TABLE IF NOT EXISTS public.Hotel (
    Hotel_ID INT PRIMARY KEY,
	Hotel_Name Varchar(255),
    Hotel_chain_ID INT,
    Address VARCHAR(255),  -- New column for address
    City VARCHAR(100),      -- New column for city
    Email VARCHAR(255),
    Num_rooms INT CHECK (Num_rooms >= 1),
    Category VARCHAR(50),
    Phone VARCHAR(20),
    FOREIGN KEY (Hotel_chain_ID) REFERENCES public.Hotel_chain(Hotel_chain_ID)
);



DROP TABLE IF EXISTS public.Room cascade;
-- -- Creating Room table
CREATE TABLE IF NOT EXISTS public.Room (
    Hotel_chain_ID INT,
    Hotel_ID INT,
    Room_ID INT,
    Price DECIMAL(10, 2),
    Amenity VARCHAR(255),
    Capacity INT,
    View VARCHAR(50),
    Extension BOOLEAN,
    Damage BOOLEAN,
    PRIMARY KEY (Room_ID),  -- Room_ID is the primary key
    FOREIGN KEY (Hotel_ID) REFERENCES public.Hotel(Hotel_ID),
    FOREIGN KEY (Hotel_chain_ID) REFERENCES public.Hotel_chain(Hotel_chain_ID)
);



DROP TABLE IF EXISTS public.Employee Cascade;
-- Create Employee table
CREATE TABLE IF NOT EXISTS public.Employee (
    SSN_SID VARCHAR(20) PRIMARY KEY,
    Role VARCHAR(50) CHECK (Role IN ('Manager', 'Receptionist', 'Cleaner')),
    FullName VARCHAR(255),
    Hotel_FID INT,
    FOREIGN KEY (Hotel_FID) REFERENCES public.Hotel(Hotel_ID)
);


DROP TABLE IF EXISTS public.Customer Cascade;
-- Create Customer table
CREATE TABLE IF NOT EXISTS public.Customer (
    Cust_ID INT PRIMARY KEY,
    Address VARCHAR(255),
    Date_reg DATE CHECK (Date_reg <= CURRENT_DATE),
    Full_Name VARCHAR(255)
);


DROP TABLE IF EXISTS public.Booking Cascade;
-- Create Booking table
CREATE TABLE IF NOT EXISTS public.Booking (
    Booking_ID INT PRIMARY KEY,
    CheckInDate DATE,
    CheckOutDate DATE CHECK (CheckInDate < CheckOutDate),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled')),
    Cust_ID INT,
    Room_ID INT,
    Hotel_ID INT,
    FOREIGN KEY (Cust_ID) REFERENCES public.Customer(Cust_ID),
    FOREIGN KEY (Room_ID) REFERENCES public.Room(Room_ID),
    FOREIGN KEY (Hotel_ID) REFERENCES public.Hotel(Hotel_ID)
);




DROP TABLE IF EXISTS public.Renting Cascade;

-- Create Renting table
CREATE TABLE IF NOT EXISTS public.Renting (
    Renting_ID INT PRIMARY KEY,
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(20) CHECK (Status IN ('Ongoing', 'Completed', 'Cancelled')),
    Payment DECIMAL(10, 2) CHECK (Payment > 0 OR Status = 'Cancelled'),
    Employ_SID VARCHAR(20),
    Cust_ID INT,
    Room_ID INT,
    Hotel_ID INT,
    FOREIGN KEY (Employ_SID) REFERENCES public.Employee(SSN_SID),
    FOREIGN KEY (Cust_ID) REFERENCES public.Customer(Cust_ID),
    FOREIGN KEY (Room_ID) REFERENCES public.Room(Room_ID),
    FOREIGN KEY (Hotel_ID) REFERENCES public.Hotel(Hotel_ID)
);



DROP TABLE IF EXISTS public.Works_for Cascade;

-- Create Works_for relationship table
CREATE TABLE IF NOT EXISTS public.Works_for (
    SSN_SID VARCHAR(20),
    PRIMARY KEY (SSN_SID),
    FOREIGN KEY (SSN_SID) REFERENCES public.Employee(SSN_SID)
);



DROP TABLE IF EXISTS public.Manages_at Cascade;
-- Create Manages_at relationship table
CREATE TABLE IF NOT EXISTS public.Manages_at (
    Hotel_chain_ID INT,
    Hotel_ID INT,
    SSN_SID VARCHAR(20),
    PRIMARY KEY (Hotel_chain_ID, Hotel_ID, SSN_SID),
    FOREIGN KEY (Hotel_chain_ID) REFERENCES public.Hotel_chain(Hotel_chain_ID),
    FOREIGN KEY (Hotel_ID) REFERENCES public.Hotel(Hotel_ID),
    FOREIGN KEY (SSN_SID) REFERENCES public.Employee(SSN_SID)
);


DELETE FROM public.Hotel_chain;
DELETE FROM public.Hotel;
DELETE FROM public.Manages_at;

-- Insert data into Hotel_chain table
INSERT INTO public.Hotel_chain (Hotel_chain_ID,Chain_Name, Address, Num_hotels, Email, Phone)
VALUES
(1, 'Luxury Stay', '123 Chain St, City, State, ZIP', 10, 'contact@chain1.com', '123-456-7890'),
(2, 'Comfort Inn', '456 Hotel Rd, City, State, ZIP', 15, 'info@chain2.com', '987-654-3210'),
(3, 'Budget Rooms', '789 Grand Ave, City, State, ZIP', 20, 'support@chain3.com', '555-123-4567'),
(4, 'Ocean View Resorts', '101 Resort Blvd, City, State, ZIP', 8, 'service@chain4.com', '444-555-6666'),
(5, 'Mountain Retreat', '202 Skyline St, City, State, ZIP', 12, 'hello@chain5.com', '333-777-8888');

-- Insert data for Hotel table with at least 8 hotels per chain, with at least two in the same area
INSERT INTO public.Hotel (Hotel_ID, Hotel_Name, Hotel_chain_ID, Address, City, Email, Num_rooms, Category, Phone)
VALUES
-- Luxury Stay Hotels
(1, 'Luxury Grand Hotel', 1, '10 Elite St', 'New York', 'info@luxury1.com', 50, '5-Star', '111-222-3333'),
(2, 'Luxury Central', 1, '20 Prestige Ave', 'New York', 'info@luxury2.com', 60, '4-Star', '111-222-3334'),
(3, 'Luxury Heights', 1, '30 Skyline Blvd', 'Los Angeles', 'info@luxury3.com', 70, '5-Star', '111-222-3335'),
(4, 'Luxury Riverside', 1, '40 Sunset Ct', 'Los Angeles', 'info@luxury4.com', 80, '3-Star', '111-222-3336'),
(5, 'Luxury Palace', 1, '50 Heritage Rd', 'Miami', 'info@luxury5.com', 90, '4-Star', '111-222-3337'),
(6, 'Luxury Tower', 1, '60 Crown Ln', 'Miami', 'info@luxury6.com', 100, '5-Star', '111-222-3338'),
(7, 'Luxury Suites', 1, '70 Elite Blvd', 'Chicago', 'info@luxury7.com', 110, '3-Star', '111-222-3339'),
(8, 'Luxury Retreat', 1, '80 Highview Dr', 'Chicago', 'info@luxury8.com', 120, '4-Star', '111-222-3340'),

-- Comfort Inn Hotels
(9, 'Comfort Plaza', 2, '15 Cozy St', 'Dallas', 'info@comfort1.com', 45, '3-Star', '222-333-4444'),
(10, 'Comfort Suites', 2, '25 Warmth Ave', 'Dallas', 'info@comfort2.com', 55, '4-Star', '222-333-4445'),
(11, 'Comfort City', 2, '35 Tranquil Rd', 'Orlando', 'info@comfort3.com', 65, '3-Star', '222-333-4446'),
(12, 'Comfort Hills', 2, '45 Serene Blvd', 'Orlando', 'info@comfort4.com', 75, '2-Star', '222-333-4447'),
(13, 'Comfort Stay', 2, '55 Relax Ct', 'Houston', 'info@comfort5.com', 85, '4-Star', '222-333-4448'),
(14, 'Comfort Inn', 2, '65 Peaceful Ln', 'Houston', 'info@comfort6.com', 95, '3-Star', '222-333-4449'),
(15, 'Comfort Hub', 2, '75 Easy St', 'San Antonio', 'info@comfort7.com', 105, '2-Star', '222-333-4450'),
(16, 'Comfort View', 2, '85 Calm Way', 'San Antonio', 'info@comfort8.com', 115, '4-Star', '222-333-4451'),

-- Budget Rooms Hotels
(17, 'Budget Stay', 3, '12 Simple St', 'Atlanta', 'info@budget1.com', 40, '2-Star', '333-444-5555'),
(18, 'Budget Inn', 3, '22 Frugal Ave', 'Atlanta', 'info@budget2.com', 50, '3-Star', '333-444-5556'),
(19, 'Budget Lodge', 3, '32 Affordable Rd', 'Seattle', 'info@budget3.com', 60, '2-Star', '333-444-5557'),
(20, 'Budget Plaza', 3, '42 Modest Blvd', 'Seattle', 'info@budget4.com', 70, '1-Star', '333-444-5558'),
(21, 'Budget Haven', 3, '52 Value Ct', 'Dallas', 'info@budget5.com', 80, '3-Star', '333-444-5559'),
(22, 'Budget Suites', 3, '62 Smart Ln', 'Phoenix', 'info@budget6.com', 90, '2-Star', '333-444-5560'),
(23, 'Budget Choice', 3, '72 Savings Dr', 'Portland', 'info@budget7.com', 100, '1-Star', '333-444-5561'),
(24, 'Budget Friendly', 3, '82 Costwise Blvd', 'Portland', 'info@budget8.com', 110, '3-Star', '333-444-5562'),

-- Ocean View Resorts Hotels
(25, 'Ocean Pearl Resort', 4, '10 Seaside Blvd', 'Miami', 'info@ocean1.com', 55, '5-Star', '444-555-6666'),
(26, 'Ocean Paradise', 4, '20 Beachfront Ave', 'Miami', 'info@ocean2.com', 65, '4-Star', '444-555-6667'),
(27, 'Coastal Escape', 4, '30 Coastal Rd', 'Los Angeles', 'info@ocean3.com', 75, '5-Star', '444-555-6668'),
(28, 'Wavefront Hotel', 4, '40 Wave Ct', 'Los Angeles', 'info@ocean4.com', 85, '3-Star', '444-555-6669'),
(29, 'Seaside Haven', 4, '50 Marine St', 'San Diego', 'info@ocean5.com', 95, '4-Star', '444-555-6670'),
(30, 'Bluewater Resort', 4, '60 Bluewater Ln', 'San Diego', 'info@ocean6.com', 105, '3-Star', '444-555-6671'),
(31, 'Tropical Escape', 4, '70 Oceanview Dr', 'Dallas', 'info@ocean7.com', 115, '2-Star', '444-555-6672'),
(32, 'Lagoon Breeze', 4, '80 Lagoon Way', 'Honolulu', 'info@ocean8.com', 125, '5-Star', '444-555-6673'),

-- Mountain Retreats Hotels
(33, 'Alpine Resort', 5, '10 Alpine Rd', 'Honolulu', 'info@mountain1.com', 50, '4-Star', '555-666-7777'),
(34, 'Summit Lodge', 5, '20 Summit Ave', 'Atlanta', 'info@mountain2.com', 60, '3-Star', '555-666-7778'),
(35, 'Highland Retreat', 5, '30 Highland Ct', 'Aspen', 'info@mountain3.com', 70, '5-Star', '555-666-7779'),
(36, 'Glacier Lodge', 5, '40 Glacier St', 'Aspen', 'info@mountain4.com', 80, '2-Star', '555-666-7780'),
(37, 'Valley View Hotel', 5, '50 Valley Dr', 'Salt Lake City', 'info@mountain5.com', 90, '4-Star', '555-666-7781'),
(38, 'Ridge Retreat', 5, '60 Ridge Way', 'Salt Lake City', 'info@mountain6.com', 100, '3-Star', '555-666-7782'),
(39, 'Peak Lodge', 5, '70 Peak Blvd', 'Lake Tahoe', 'info@mountain7.com', 110, '5-Star', '555-666-7783'),
(40, 'Snowy Pass Resort', 5, '80 Snowy Pass', 'Lake Tahoe', 'info@mountain8.com', 120, '2-Star', '555-666-7784');



-- Insert data for Room table ensuring at least 5 rooms of different capacity per hotel
INSERT INTO public.Room (Hotel_chain_ID, Hotel_ID, Room_ID, Price, Amenity, Capacity, View, Extension, Damage)
VALUES
-- Rooms for Luxury Stay Hotel 1
(1, 1, 101, 200, 'TV, WiFi, Air Conditioning', 1, 'City View', 'Yes', 'No'),
(1, 1, 102, 250, 'TV, WiFi, Mini Bar', 2, 'City View', 'Yes', 'No'),
(1, 1, 103, 300, 'TV, WiFi, Mini Bar, Balcony', 3, 'Sea View', 'Yes', 'No'),
(1, 1, 104, 350, 'TV, WiFi, Mini Bar, Jacuzzi', 4, 'Sea View', 'Yes', 'No'),
(1, 1, 105, 400, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 5, 'Sea View', 'Yes', 'No'),

-- Rooms for Comfort Inn Hotel 9
(2, 9, 201, 80, 'TV, WiFi', 1, 'Garden View', 'No', 'No'),
(2, 9, 202, 100, 'TV, WiFi, Fridge', 2, 'Garden View', 'No', 'No'),
(2, 9, 203, 120, 'TV, WiFi, Balcony', 3, 'Pool View', 'Yes', 'No'),
(2, 9, 204, 140, 'TV, WiFi, Kitchenette', 4, 'Pool View', 'Yes', 'No'),
(2, 9, 205, 160, 'TV, WiFi, Kitchenette, Jacuzzi', 5, 'Garden View', 'Yes', 'No');

-- Insert data into Room table
-- INSERT INTO public.Room (Hotel_chain_ID, Hotel_ID, Room_ID, Price, Amenity, Capacity, View, Extension, Damage)
-- VALUES
--     (1, 1, 101, 150, 'TV, Air Conditioning, Fridge', 2, 'Sea View', 'Yes', 'No'),
--     (1, 1, 102, 180, 'TV, Air Conditioning, Fridge', 2, 'Sea View', 'Yes', 'No'),
--     (1, 2, 201, 250, 'TV, Air Conditioning, Fridge, Balcony', 4, 'Sea View', 'Yes', 'No'),
--     (1, 2, 202, 220, 'TV, Air Conditioning, Fridge', 2, 'Sea View', 'Yes', 'Yes'),
--     (2, 3, 301, 120, 'TV, Air Conditioning', 1, 'Mountain View', 'No', 'No'),
--     (2, 3, 302, 150, 'TV, Air Conditioning, Fridge', 2, 'Mountain View', 'Yes', 'No'),
--     (2, 4, 401, 180, 'TV, Air Conditioning, Fridge, Balcony', 3, 'Mountain View', 'Yes', 'No'),
--     (3, 5, 501, 100, 'TV, Air Conditioning', 1, 'City View', 'No', 'No'),
--     (3, 5, 502, 130, 'TV, Air Conditioning, Fridge', 2, 'City View', 'No', 'No'),
--     (4, 7, 601, 200, 'TV, Air Conditioning, Fridge, Balcony', 2, 'Ocean View', 'Yes', 'No'),
--     (4, 7, 602, 250, 'TV, Air Conditioning, Fridge, Balcony', 2, 'Ocean View', 'Yes', 'No'),
--     (5, 9, 701, 120, 'TV, Air Conditioning', 2, 'Forest View', 'No', 'No'),
--     (5, 9, 702, 150, 'TV, Air Conditioning, Fridge', 2, 'Forest View', 'No', 'Yes');

-- Insert data into Employee table
INSERT INTO public.Employee (SSN_SID, Role, FullName, Hotel_FID)
VALUES
    ('SSN001', 'Manager', 'John Doe', 1),
    ('SSN002', 'Receptionist', 'Jane Smith', 1),
    ('SSN003', 'Manager', 'Alice Johnson', 2),
    ('SSN004', 'Receptionist', 'Bob Brown', 3),
    ('SSN005', 'Manager', 'Charlie Lee', 4),
    ('SSN006', 'Cleaner', 'Diana White', 5),
    ('SSN007', 'Receptionist', 'Emily Green', 6),
    ('SSN008', 'Manager', 'Frank Black', 7);

-- Insert data into Customer table
INSERT INTO public.Customer (Cust_ID, Address, Date_reg, Full_Name)
VALUES
    (1, '101 Main St, Miami, FL', '2025-03-01', 'Lucas Park'),
    (2, '202 Oak Dr, Denver, CO', '2025-02-15', 'Nina Turner'),
    (3, '303 Pine St, New York, NY', '2025-03-20', 'Michael Scott'),
    (4, '404 Elm Ave, San Diego, CA', '2025-01-05', 'Rachel Adams'),
    (5, '505 Cedar Rd, Seattle, WA', '2025-02-28', 'David Lee');

-- Insert data into Booking table
INSERT INTO public.Booking (Booking_ID, CheckInDate, CheckOutDate, Status, Cust_ID, Room_ID, Hotel_ID)
VALUES
    (1, '2025-03-15', '2025-03-18', 'Confirmed', 1, 101, 1),
    (2, '2025-03-16', '2025-03-19', 'Pending', 2, 201, 3),
    (3, '2025-03-20', '2025-03-23', 'Confirmed', 3, 102, 5),
    (4, '2025-03-21', '2025-03-24', 'Cancelled', 4, 202, 7);

-- Insert data into Renting table
INSERT INTO public.Renting (Renting_ID, StartDate, EndDate, Status, Payment, Employ_SID, Cust_ID, Room_ID, Hotel_ID)
VALUES
    (1, '2025-03-15', '2025-03-18', 'Completed', 450, 'SSN001', 1, 101, 1),
    (2, '2025-03-16', '2025-03-19', 'Ongoing', 600, 'SSN003', 2, 201, 3),
    (3, '2025-03-20', '2025-03-23', 'Completed', 600, 'SSN005', 3, 102, 5),
    (4, '2025-03-21', '2025-03-24', 'Cancelled', 0, 'SSN004', 4, 202, 7);


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


-- SELECT h.Hotel_ID, h.Hotel_chain_ID, h.Category, MAX(r.Price) AS Highest_Room_Price
-- FROM public.Hotel h
-- JOIN public.Room r ON h.Hotel_ID = r.Hotel_ID
-- GROUP BY h.Hotel_ID, h.Hotel_chain_ID, h.Category
-- ORDER BY Highest_Room_Price DESC;


