-- --Delete All Data If You Need To


-- DO $$ 
-- DECLARE 
--     r RECORD;
-- BEGIN 
--     FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') 
--     LOOP 
--         EXECUTE 'TRUNCATE TABLE public.' || quote_ident(r.tablename) || ' CASCADE'; 
--     END LOOP; 
-- END $$;

-- SET search_path TO public;

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



DROP TABLE IF EXISTS public.Employee CASCADE;
-- Create Employee table
CREATE TABLE IF NOT EXISTS public.Employee (
    SSN_SID VARCHAR(20) PRIMARY KEY,
    Role VARCHAR(50) CHECK (Role IN ('Manager', 'Receptionist', 'Cleaner')),
    FullName VARCHAR(255),
    Email VARCHAR(255) UNIQUE NOT NULL, -- New column for email
    Password VARCHAR(255) NOT NULL, -- New column for password
    Hotel_FID INT,
    FOREIGN KEY (Hotel_FID) REFERENCES public.Hotel(Hotel_ID)
);

DROP TABLE IF EXISTS public.Customer CASCADE;
-- Create Customer table
CREATE TABLE IF NOT EXISTS public.Customer (
   Cust_ID INT PRIMARY KEY,
    Full_Name VARCHAR(255),
    Email VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    Date_reg DATE DEFAULT CURRENT_DATE CHECK (Date_reg <= CURRENT_DATE)
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

-- Insert data into Hotel_chain table
INSERT INTO public.Hotel_chain (Hotel_chain_ID,Chain_Name, Address, Num_hotels, Email, Phone)
VALUES
(1, 'Luxury Stay', '123 Chain St, City, State, ZIP', 10, 'contact@chain1.com', '123-456-7890'),
(2, 'Comfort Inn', '456 Hotel Rd, City, State, ZIP', 15, 'info@chain2.com', '987-654-3210'),
(3, 'Budget Rooms', '789 Grand Ave, City, State, ZIP', 20, 'support@chain3.com', '555-123-4567'),
(4, 'Ocean View Resorts', '101 Resort Blvd, City, State, ZIP', 8, 'service@chain4.com', '444-555-6666'),
(5, 'Mountain Retreat', '202 Skyline St, City, State, ZIP', 12, 'hello@chain5.com', '333-777-8888');

DELETE FROM public.Hotel;

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

Delete From public.Room;
-- Insert data for Room table ensuring at least 5 rooms of different capacity per hotel
INSERT INTO public.Room (Hotel_chain_ID, Hotel_ID, Room_ID, Price, Amenity, Capacity, View, Extension, Damage)
VALUES
-- Rooms for Luxury Stay Hotel 1 (Hotel_IDs 1-8)
(1, 1, 101, 200, 'TV, WiFi, Air Conditioning', 1, 'City View', 'Yes', 'No'),
(1, 1, 102, 250, 'TV, WiFi, Mini Bar', 2, 'City View', 'Yes', 'No'),
(1, 1, 103, 300, 'TV, WiFi, Mini Bar, Balcony', 3, 'Sea View', 'Yes', 'No'),
(1, 1, 104, 350, 'TV, WiFi, Mini Bar, Jacuzzi', 4, 'Sea View', 'Yes', 'No'),
(1, 1, 105, 400, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 5, 'Sea View', 'Yes', 'No'),

(1, 2, 106, 220, 'WiFi, Fridge, Air Conditioning', 1, 'City View', 'No', 'No'),
(1, 2, 107, 270, 'WiFi, Mini Bar', 2, 'Park View', 'Yes', 'No'),
(1, 2, 108, 320, 'WiFi, Mini Bar, Balcony', 3, 'Sea View', 'Yes', 'No'),
(1, 2, 109, 370, 'TV, WiFi, Kitchenette', 4, 'Sea View', 'Yes', 'No'),
(1, 2, 110, 420, 'WiFi, Jacuzzi', 5, 'Skyline View', 'Yes', 'No'),

(1, 6, 141, 230, 'TV, WiFi, Air Conditioning', 1, 'City View', 'No', 'No'),
(1, 6, 142, 280, 'TV, WiFi, Mini Bar', 2, 'City View', 'Yes', 'No'),
(1, 6, 143, 330, 'TV, WiFi, Mini Bar, Balcony', 3, 'Sea View', 'Yes', 'No'),
(1, 6, 144, 380, 'TV, WiFi, Mini Bar, Jacuzzi', 4, 'Sea View', 'Yes', 'No'),
(1, 6, 145, 450, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 5, 'Sea View', 'Yes', 'No'),

(1, 7, 151, 240, 'TV, WiFi, Air Conditioning', 1, 'City View', 'No', 'No'),
(1, 7, 152, 290, 'TV, WiFi, Mini Bar', 2, 'City View', 'Yes', 'No'),
(1, 7, 153, 340, 'TV, WiFi, Mini Bar, Balcony', 3, 'Skyline View', 'Yes', 'No'),
(1, 7, 154, 390, 'TV, WiFi, Kitchenette', 4, 'Skyline View', 'Yes', 'No'),
(1, 7, 155, 460, 'TV, WiFi, Mini Bar, Jacuzzi', 5, 'Skyline View', 'Yes', 'No'),

-- (Hotel_chain_ID, Hotel_ID, Room_ID, Price, Amenity, Capacity, View, Extension, Damage)
-- Rooms for each hotel in Comfort Inn (Hotel_IDs 9-16)
(2, 9, 201, 80, 'TV, WiFi', 1, 'Garden View', 'No', 'No'),
(2, 9, 202, 100, 'TV, WiFi, Fridge', 2, 'Garden View', 'No', 'No'),
(2, 9, 203, 120, 'TV, WiFi, Balcony', 3, 'Pool View', 'Yes', 'No'),
(2, 9, 204, 140, 'TV, WiFi, Kitchenette', 4, 'Pool View', 'Yes', 'No'),
(2, 9, 205, 160, 'TV, WiFi, Kitchenette, Jacuzzi', 5, 'Garden View', 'Yes', 'No'),

(2, 10, 206, 220, 'WiFi, Fridge, Air Conditioning', 1, 'City View', 'No', 'No'),
(2, 10, 207, 270, 'WiFi, Mini Bar', 2, 'Park View', 'Yes', 'No'),
(2, 10, 208, 320, 'WiFi, Mini Bar, Balcony', 3, 'Sea View', 'Yes', 'No'),
(2, 10, 209, 370, 'TV, WiFi, Kitchenette', 4, 'Sea View', 'Yes', 'No'),
(2, 10, 210, 420, 'WiFi, Jacuzzi', 5, 'Skyline View', 'Yes', 'No'),

(2, 12, 261, 90, 'WiFi, TV', 1, 'Garden View', 'No', 'No'),
(2, 12, 262, 110, 'WiFi, Fridge', 2, 'Garden View', 'No', 'No'),
(2, 12, 263, 130, 'WiFi, Balcony', 3, 'Pool View', 'Yes', 'No'),
(2, 12, 264, 150, 'WiFi, Kitchenette', 4, 'Pool View', 'Yes', 'No'),
(2, 12, 265, 180, 'WiFi, Jacuzzi', 5, 'Garden View', 'Yes', 'No'),

(2, 11, 271, 100, 'WiFi, TV, Air Conditioning', 1, 'Street View', 'No', 'No'),
(2, 11, 272, 120, 'WiFi, Mini Bar', 2, 'Street View', 'Yes', 'No'),
(2, 11, 273, 140, 'WiFi, Mini Bar, Balcony', 3, 'Park View', 'Yes', 'No'),
(2, 11, 274, 160, 'WiFi, Kitchenette', 4, 'Park View', 'Yes', 'No'),
(2, 11, 275, 200, 'WiFi, Mini Bar, Jacuzzi', 5, 'Park View', 'Yes', 'No'),

-- (Hotel_chain_ID, Hotel_ID, Room_ID, Price, Amenity, Capacity, View, Extension, Damage)
-- Rooms for each hotel in Budget Rooms (Hotel_IDs 17-24)
(3, 17, 301, 50, 'WiFi', 1, 'Street View', 'No', 'No'),
(3, 17, 302, 70, 'WiFi, Fridge', 2, 'City View', 'No', 'No'),
(3, 17, 303, 90, 'WiFi, Mini Bar', 3, 'City View', 'Yes', 'No'),
(3, 17, 304, 110, 'TV, WiFi, Kitchenette', 4, 'Park View', 'Yes', 'No'),
(3, 17, 305, 130, 'WiFi, Jacuzzi', 5, 'Pool View', 'Yes', 'No'),

(3, 18, 311, 220, 'TV, WiFi, Air Conditioning', 1, 'City View', 'No', 'No'),
(3, 18, 312, 270, 'TV, WiFi, Mini Bar', 2, 'City View', 'Yes', 'No'),
(3, 18, 313, 320, 'TV, WiFi, Mini Bar, Balcony', 3, 'Skyline View', 'Yes', 'No'),
(3, 18, 314, 370, 'TV, WiFi, Mini Bar, Jacuzzi', 4, 'Skyline View', 'Yes', 'No'),
(3, 18, 315, 420, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 5, 'Skyline View', 'Yes', 'No'),

(3, 19, 381, 60, 'WiFi, TV', 1, 'City View', 'No', 'No'),
(3, 19, 382, 80, 'WiFi, Fridge', 2, 'City View', 'No', 'No'),
(3, 19, 383, 100, 'WiFi, Balcony', 3, 'Street View', 'Yes', 'No'),
(3, 19, 384, 120, 'WiFi, Kitchenette', 4, 'Street View', 'Yes', 'No'),
(3, 19, 385, 140, 'WiFi, Mini Bar, Jacuzzi', 5, 'Street View', 'Yes', 'No'),

(3, 20, 391, 65, 'WiFi, TV, Air Conditioning', 1, 'City View', 'No', 'No'),
(3, 20, 392, 85, 'WiFi, Mini Bar', 2, 'City View', 'Yes', 'No'),
(3, 20, 393, 105, 'WiFi, Mini Bar, Balcony', 3, 'Skyline View', 'Yes', 'No'),
(3, 20, 394, 125, 'WiFi, Kitchenette', 4, 'Skyline View', 'Yes', 'No'),
(3, 20, 395, 160, 'WiFi, Mini Bar, Jacuzzi', 5, 'Skyline View', 'Yes', 'No'),

-- (Hotel_chain_ID, Hotel_ID, Room_ID, Price, Amenity, Capacity, View, Extension, Damage)
-- Rooms for each hotel in Ocean View Resorts (Hotel_IDs 25-32)
(4, 25, 401, 180, 'TV, WiFi, Mini Bar', 1, 'Sea View', 'Yes', 'No'),
(4, 25, 402, 220, 'TV, WiFi, Mini Bar, Balcony', 2, 'Sea View', 'Yes', 'No'),
(4, 25, 403, 260, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Oceanfront', 'Yes', 'No'),
(4, 25, 404, 300, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Oceanfront', 'Yes', 'No'),
(4, 25, 405, 350, 'TV, WiFi, Jacuzzi, Kitchenette, Lounge', 5, 'Oceanfront', 'Yes', 'No'),

(4, 26, 421, 210, 'WiFi, Fridge, Air Conditioning', 1, 'River View', 'No', 'No'),
(4, 26, 422, 260, 'WiFi, Mini Bar', 2, 'River View', 'Yes', 'No'),
(4, 26, 423, 310, 'WiFi, Mini Bar, Balcony', 3, 'Sunset View', 'Yes', 'No'),
(4, 26, 424, 360, 'TV, WiFi, Kitchenette', 4, 'Sunset View', 'Yes', 'No'),
(4, 26, 425, 410, 'WiFi, Jacuzzi', 5, 'Sunset View', 'Yes', 'No'),

(4, 27, 431, 300, 'WiFi, TV, Air Conditioning', 1, 'Ocean View', 'No', 'No'),
(4, 27, 432, 350, 'WiFi, Mini Bar', 2, 'Ocean View', 'Yes', 'No'),
(4, 27, 433, 400, 'WiFi, Mini Bar, Balcony', 3, 'Sunset View', 'Yes', 'No'),
(4, 27, 434, 450, 'WiFi, Kitchenette', 4, 'Sunset View', 'Yes', 'No'),
(4, 27, 435, 500, 'WiFi, Mini Bar, Jacuzzi', 5, 'Sunset View', 'Yes', 'No'),

(4, 28, 411, 320, 'WiFi, TV, Air Conditioning', 1, 'Beach View', 'No', 'No'),
(4, 28, 412, 370, 'WiFi, Mini Bar', 2, 'Beach View', 'Yes', 'No'),
(4, 28, 413, 420, 'WiFi, Mini Bar, Balcony', 3, 'Coast View', 'Yes', 'No'),
(4, 28, 414, 470, 'WiFi, Kitchenette', 4, 'Coast View', 'Yes', 'No'),
(4, 28, 415, 520, 'WiFi, Mini Bar, Jacuzzi', 5, 'Coast View', 'Yes', 'No'),

--(Hotel_chain_ID, Hotel_ID, Room_ID, Price, Amenity, Capacity, View, Extension, Damage)
-- Rooms for each hotel in Mountain Retreat (Hotel_IDs 33-40)
(5, 33, 501, 200, 'TV, WiFi, Mini Bar', 1, 'Mountain View', 'Yes', 'No'),
(5, 33, 502, 250, 'TV, WiFi, Mini Bar, Balcony', 2, 'Mountain View', 'Yes', 'No'),
(5, 33, 503, 300, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Valley View', 'Yes', 'No'),
(5, 33, 504, 350, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Valley View', 'Yes', 'No'),
(5, 33, 505, 400, 'TV, WiFi, Jacuzzi, Kitchenette, Fireplace', 5, 'Valley View', 'Yes', 'No'),

(5, 34, 531, 250, 'TV, WiFi, Air Conditioning', 1, 'Garden View', 'Yes', 'No'),
(5, 34, 532, 280, 'TV, WiFi, Mini Bar', 2, 'Garden View', 'Yes', 'No'),
(5, 34, 533, 330, 'TV, WiFi, Mini Bar, Balcony', 3, 'Pool View', 'Yes', 'No'),
(5, 34, 534, 380, 'TV, WiFi, Mini Bar, Jacuzzi', 4, 'Pool View', 'Yes', 'No'),
(5, 34, 535, 430, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 5, 'Pool View', 'Yes', 'No'),

(5, 35, 521, 280, 'WiFi, TV, Air Conditioning', 1, 'Mountain View', 'No', 'No'),
(5, 35, 522, 330, 'WiFi, Mini Bar', 2, 'Mountain View', 'Yes', 'No'),
(5, 35, 523, 380, 'WiFi, Mini Bar, Balcony', 3, 'Valley View', 'Yes', 'No'),
(5, 35, 524, 430, 'WiFi, Kitchenette', 4, 'Valley View', 'Yes', 'No'),
(5, 35, 525, 480, 'WiFi, Mini Bar, Jacuzzi', 5, 'Valley View', 'Yes', 'No'),

(5, 36, 511, 290, 'WiFi, TV, Air Conditioning', 1, 'Snow View', 'No', 'No'),
(5, 36, 512, 340, 'WiFi, Mini Bar', 2, 'Snow View', 'Yes', 'No'),
(5, 36, 513, 390, 'WiFi, Mini Bar, Balcony', 3, 'Forest View', 'Yes', 'No'),
(5, 36, 514, 440, 'WiFi, Kitchenette', 4, 'Forest View', 'Yes', 'No'),
(5, 36, 515, 500, 'WiFi, Mini Bar, Jacuzzi', 5, 'Forest View', 'Yes', 'No');


Delete from public.Employee;

-- Insert data into Employee table
INSERT INTO public.Employee (SSN_SID, Role, FullName, Email, Password, Hotel_FID)
VALUES
('E001', 'Manager', 'Alice Johnson', 'alice.johnson@hotel.com', 'securePass1', 1),
('E002', 'Receptionist', 'Bob Smith', 'bob.smith@hotel.com', 'securePass2', 1),
('E003', 'Cleaner', 'Charlie Brown', 'charlie.brown@hotel.com', 'securePass3', 2),
('E004', 'Manager', 'Diana Ross', 'diana.ross@hotel.com', 'securePass4', 3),
('E005', 'Receptionist', 'Ethan Hunt', 'ethan.hunt@hotel.com', 'securePass5', 4),
('E006', 'Cleaner', 'Fiona Blake', 'fiona.blake@hotel.com', 'securePass6', 5),
('E007', 'Manager', 'George Miller', 'george.miller@hotel.com', 'securePass7', 6),
('E008', 'Receptionist', 'Hannah Davis', 'hannah.davis@hotel.com', 'securePass8', 7);

Delete From public.Customer;
-- Insert data into Customer table
INSERT INTO public.Customer (Cust_ID, Full_Name, Email, Password, Address, Date_reg)
VALUES
(101, 'John Doe', 'john.doe@email.com', 'password123', '123 Main St, New York', '2024-03-01'),
(102, 'Emma Watson', 'emma.watson@email.com', 'mypassword', '456 Elm St, Los Angeles', '2024-03-05'),
(103, 'Liam Smith', 'liam.smith@email.com', 'liamPass99', '789 Pine St, Chicago', '2024-03-10'),
(104, 'Sophia Brown', 'sophia.brown@email.com', 'sophiaSecret', '101 Maple St, Miami', '2024-03-15'),
(105, 'Michael Johnson', 'michael.johnson@email.com', 'michael2024', '222 Oak St, Houston', '2024-03-20'),
(106, 'Olivia Martinez', 'olivia.martinez@email.com', 'oliviaPass', '333 Cedar St, San Francisco', '2024-03-22'),
(107, 'William Davis', 'william.davis@email.com', 'william123', '444 Birch St, Seattle', '2024-03-25'),
(108, 'Ava Wilson', 'ava.wilson@email.com', 'avaSecret', '555 Walnut St, Boston', '2024-03-28');

INSERT INTO public.Customer (Cust_ID, Full_Name, Email, Password, Address)
VALUES
(110, 'Test2','test2@gmail.com','pw2','');

select* from room;
Delete From public.Booking;
-- Insert data into Booking table
INSERT INTO public.Booking (Booking_ID, CheckInDate, CheckOutDate, Status, Cust_ID, Room_ID, Hotel_ID)
VALUES
    (1, '2025-04-05', '2025-04-10', 'Confirmed', 101, 301, 17),
    (2, '2025-04-06', '2025-04-09', 'Pending', 102, 401, 25),
    (3, '2025-04-07', '2025-04-12', 'Confirmed', 103, 501, 33),
    (4, '2025-04-08', '2025-04-11', 'Cancelled', 104, 101, 1),
    (5, '2025-04-10', '2025-04-14', 'Confirmed', 105, 201, 9),
    (6, '2025-04-11', '2025-04-16', 'Pending', 106, 102, 1),
    (7, '2025-04-12', '2025-04-15', 'Confirmed', 107, 202, 9),
    (8, '2025-04-13', '2025-04-18', 'Cancelled', 108, 302, 17);

Delete From public.Renting;
-- Insert data into Renting table
INSERT INTO public.Renting (Renting_ID, StartDate, EndDate, Status, Payment, Employ_SID, Cust_ID, Room_ID, Hotel_ID)
VALUES
    (1, '2025-04-01', '2025-04-05', 'Completed', 500, 'E001', 101, 305, 17),
    (2, '2025-04-02', '2025-04-06', 'Ongoing', 650, 'E002', 102, 405, 25),
    (3, '2025-04-03', '2025-04-07', 'Completed', 700, 'E003', 103, 505, 33),
    (4, '2025-04-04', '2025-04-08', 'Cancelled', 0, 'E004', 104, 105, 1),
    (5, '2025-04-05', '2025-04-09', 'Completed', 550, 'E005', 105, 205, 9),
    (6, '2025-04-06', '2025-04-10', 'Ongoing', 600, 'E006', 106, 145, 6),
    (7, '2025-04-07', '2025-04-11', 'Completed', 750, 'E007', 107, 275, 11),
    (8, '2025-04-08', '2025-04-12', 'Ongoing', 800, 'E008', 108, 385, 19);

	
-- CREATE VIEW public.AvailableRoomsPerArea AS
-- SELECT 
--     h.Hotel_ID,
--     h.Hotel_chain_ID,
--     h.Category,
--     COUNT(r.Room_ID) AS Available_Rooms
-- FROM public.Room r
-- JOIN public.Hotel h ON r.Hotel_ID = h.Hotel_ID
-- LEFT JOIN public.Booking b ON r.Room_ID = b.Room_ID 
--     AND b.Status IN ('Pending', 'Confirmed') 
--     AND CURRENT_DATE BETWEEN b.CheckInDate AND b.CheckOutDate
-- LEFT JOIN public.Renting rt ON r.Room_ID = rt.Room_ID 
--     AND rt.Status = 'Ongoing'
-- WHERE b.Booking_ID IS NULL AND rt.Renting_ID IS NULL
-- GROUP BY h.Hotel_ID, h.Hotel_chain_ID, h.Category;

-- SELECT * FROM public.AvailableRoomsPerArea; 



