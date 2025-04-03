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
    Address VARCHAR(255), 
    City VARCHAR(100),    
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

--Drop the sequence
DROP SEQUENCE IF EXISTS employee_id_seq CASCADE;

-- Create a sequence for automatic employee numbering
CREATE SEQUENCE employee_id_seq START 0001;

CREATE TABLE IF NOT EXISTS public.Employee (
    SSN_SID VARCHAR(20) PRIMARY KEY DEFAULT 'E000' || nextval('employee_id_seq'),
    Role VARCHAR(50) CHECK (Role IN ('Manager', 'Receptionist', 'Cleaner')),
    FullName VARCHAR(255),
    Email VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Hotel_FID INT,
    FOREIGN KEY (Hotel_FID) REFERENCES public.Hotel(Hotel_ID)
);




DROP TABLE IF EXISTS public.Customer CASCADE;

--Drop the sequence
DROP SEQUENCE IF EXISTS cust_id_seq CASCADE;

-- Create a sequence for automatic employee numbering
CREATE SEQUENCE cust_id_seq START 00001;

-- Create Customer table
CREATE TABLE IF NOT EXISTS public.Customer (
   Cust_ID VARCHAR(20) PRIMARY KEY DEFAULT 'CU000' || nextval('cust_id_seq'),
    Full_Name VARCHAR(255),
    Email VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    Date_reg DATE DEFAULT CURRENT_DATE CHECK (Date_reg <= CURRENT_DATE)
);


Select * from public.customer;

DROP TABLE IF EXISTS public.Booking Cascade;
Drop sequence if exists booking_id_seq Cascade;
create sequence booking_id_seq start 001;
-- Create Booking table
CREATE TABLE IF NOT EXISTS public.Booking (
    Booking_ID VARCHAR PRIMARY KEY DEFAULT 'BK000' || nextval('booking_id_seq'),
    CheckInDate DATE,
    CheckOutDate DATE CHECK (CheckInDate < CheckOutDate),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled')),
    Cust_ID VARCHAR,
    Room_ID INT,
    Hotel_ID INT,
    FOREIGN KEY (Cust_ID) REFERENCES public.Customer(Cust_ID),
    FOREIGN KEY (Room_ID) REFERENCES public.Room(Room_ID),
    FOREIGN KEY (Hotel_ID) REFERENCES public.Hotel(Hotel_ID)
);



DROP TABLE IF EXISTS public.Renting Cascade;
Drop sequence if exists renting_id_seq cascade;
Create sequence renting_id_seq start 1;


-- Create Renting table
CREATE TABLE IF NOT EXISTS public.Renting (
    Renting_ID Varchar PRIMARY KEY default 'RNT000' || Nextval('renting_id_seq'),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(20) CHECK (Status IN ('Ongoing', 'Completed', 'Cancelled')),
    Payment DECIMAL(10, 2) CHECK (Payment > 0 OR Status = 'Cancelled'),
    Employ_SID VARCHAR(20),
    Cust_ID VARCHAR(20),
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
-- Adding more rooms to Luxury Stay hotels (Chain 1, Hotels 1-8)
INSERT INTO public.Room (Hotel_chain_ID, Hotel_ID, Room_ID, Price, Amenity, Capacity, View, Extension, Damage)
VALUES
-- Hotel 1 (already has 5 rooms, adding 5 more)
(1, 1, 111, 180, 'TV, WiFi', 1, 'City View', 'No', 'No'),
(1, 1, 112, 230, 'TV, WiFi, Fridge', 2, 'City View', 'No', 'No'),
(1, 1, 113, 280, 'TV, WiFi, Balcony', 3, 'Park View', 'Yes', 'No'),
(1, 1, 114, 330, 'TV, WiFi, Kitchenette', 4, 'Park View', 'Yes', 'No'),
(1, 1, 115, 380, 'TV, WiFi, Jacuzzi', 5, 'Garden View', 'Yes', 'No'),

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
-- Hotel 3 (adding 5 rooms)
(1, 3, 301, 210, 'TV, WiFi, Air Conditioning', 1, 'City View', 'No', 'No'),
(1, 3, 302, 260, 'TV, WiFi, Mini Bar', 2, 'City View', 'Yes', 'No'),
(1, 3, 303, 310, 'TV, WiFi, Mini Bar, Balcony', 3, 'Sea View', 'Yes', 'No'),
(1, 3, 304, 360, 'TV, WiFi, Mini Bar, Jacuzzi', 4, 'Sea View', 'Yes', 'No'),
(1, 3, 305, 410, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 5, 'Sea View', 'Yes', 'No'),

-- Hotel 4 (adding 5 rooms)
(1, 4, 401, 190, 'TV, WiFi, Air Conditioning', 1, 'City View', 'No', 'No'),
(1, 4, 402, 240, 'TV, WiFi, Mini Bar', 2, 'City View', 'Yes', 'No'),
(1, 4, 403, 290, 'TV, WiFi, Mini Bar, Balcony', 3, 'Sea View', 'Yes', 'No'),
(1, 4, 404, 340, 'TV, WiFi, Mini Bar, Jacuzzi', 4, 'Sea View', 'Yes', 'No'),
(1, 4, 405, 390, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 5, 'Sea View', 'Yes', 'No'),

-- Hotel 5 (adding 5 rooms)
(1, 5, 501, 220, 'TV, WiFi, Air Conditioning', 1, 'City View', 'No', 'No'),
(1, 5, 502, 270, 'TV, WiFi, Mini Bar', 2, 'City View', 'Yes', 'No'),
(1, 5, 503, 320, 'TV, WiFi, Mini Bar, Balcony', 3, 'Sea View', 'Yes', 'No'),
(1, 5, 504, 370, 'TV, WiFi, Mini Bar, Jacuzzi', 4, 'Sea View', 'Yes', 'No'),
(1, 5, 505, 420, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 5, 'Sea View', 'Yes', 'No'),

-- Hotel 8 (adding 5 rooms)
(1, 8, 801, 230, 'TV, WiFi, Air Conditioning', 1, 'City View', 'No', 'No'),
(1, 8, 802, 280, 'TV, WiFi, Mini Bar', 2, 'City View', 'Yes', 'No'),
(1, 8, 803, 330, 'TV, WiFi, Mini Bar, Balcony', 3, 'Sea View', 'Yes', 'No'),
(1, 8, 804, 380, 'TV, WiFi, Mini Bar, Jacuzzi', 4, 'Sea View', 'Yes', 'No'),
(1, 8, 805, 430, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 5, 'Sea View', 'Yes', 'No'),

-- Adding more rooms to Comfort Inn hotels (Chain 2, Hotels 9-16)
-- Hotel 13 (adding 5 rooms)
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

(2, 13, 1301, 90, 'TV, WiFi', 1, 'Garden View', 'No', 'No'),
(2, 13, 1302, 110, 'TV, WiFi, Fridge', 2, 'Garden View', 'No', 'No'),
(2, 13, 1303, 130, 'TV, WiFi, Balcony', 3, 'Pool View', 'Yes', 'No'),
(2, 13, 1304, 150, 'TV, WiFi, Kitchenette', 4, 'Pool View', 'Yes', 'No'),
(2, 13, 1305, 170, 'TV, WiFi, Jacuzzi', 5, 'Garden View', 'Yes', 'No'),

-- Hotel 14 (adding 5 rooms)
(2, 14, 1401, 95, 'TV, WiFi', 1, 'Garden View', 'No', 'No'),
(2, 14, 1402, 115, 'TV, WiFi, Fridge', 2, 'Garden View', 'No', 'No'),
(2, 14, 1403, 135, 'TV, WiFi, Balcony', 3, 'Pool View', 'Yes', 'No'),
(2, 14, 1404, 155, 'TV, WiFi, Kitchenette', 4, 'Pool View', 'Yes', 'No'),
(2, 14, 1405, 175, 'TV, WiFi, Jacuzzi', 5, 'Garden View', 'Yes', 'No'),

-- Hotel 15 (adding 5 rooms)
(2, 15, 1501, 85, 'TV, WiFi', 1, 'Garden View', 'No', 'No'),
(2, 15, 1502, 105, 'TV, WiFi, Fridge', 2, 'Garden View', 'No', 'No'),
(2, 15, 1503, 125, 'TV, WiFi, Balcony', 3, 'Pool View', 'Yes', 'No'),
(2, 15, 1504, 145, 'TV, WiFi, Kitchenette', 4, 'Pool View', 'Yes', 'No'),
(2, 15, 1505, 165, 'TV, WiFi, Jacuzzi', 5, 'Garden View', 'Yes', 'No'),

-- Hotel 16 (adding 5 rooms)
(2, 16, 1601, 100, 'TV, WiFi', 1, 'Garden View', 'No', 'No'),
(2, 16, 1602, 120, 'TV, WiFi, Fridge', 2, 'Garden View', 'No', 'No'),
(2, 16, 1603, 140, 'TV, WiFi, Balcony', 3, 'Pool View', 'Yes', 'No'),
(2, 16, 1604, 160, 'TV, WiFi, Kitchenette', 4, 'Pool View', 'Yes', 'No'),
(2, 16, 1605, 180, 'TV, WiFi, Jacuzzi', 5, 'Garden View', 'Yes', 'No'),

-- Adding more rooms to Budget Rooms hotels (Chain 3, Hotels 17-24)
-- Hotel 21 (adding 5 rooms)
(3, 17, 3301, 50, 'WiFi', 1, 'Street View', 'No', 'No'),
(3, 17, 3302, 70, 'WiFi, Fridge', 2, 'City View', 'No', 'No'),
(3, 17, 3303, 90, 'WiFi, Mini Bar', 3, 'City View', 'Yes', 'No'),
(3, 17, 3304, 110, 'TV, WiFi, Kitchenette', 4, 'Park View', 'Yes', 'No'),
(3, 17, 3305, 130, 'WiFi, Jacuzzi', 5, 'Pool View', 'Yes', 'No'),

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

(3, 21, 2101, 55, 'WiFi', 1, 'Street View', 'No', 'No'),
(3, 21, 2102, 75, 'WiFi, Fridge', 2, 'City View', 'No', 'No'),
(3, 21, 2103, 95, 'WiFi, Mini Bar', 3, 'City View', 'Yes', 'No'),
(3, 21, 2104, 115, 'TV, WiFi, Kitchenette', 4, 'Park View', 'Yes', 'No'),
(3, 21, 2105, 135, 'WiFi, Jacuzzi', 5, 'Pool View', 'Yes', 'No'),

-- Hotel 22 (adding 5 rooms)
(3, 22, 2201, 60, 'WiFi', 1, 'Street View', 'No', 'No'),
(3, 22, 2202, 80, 'WiFi, Fridge', 2, 'City View', 'No', 'No'),
(3, 22, 2203, 100, 'WiFi, Mini Bar', 3, 'City View', 'Yes', 'No'),
(3, 22, 2204, 120, 'TV, WiFi, Kitchenette', 4, 'Park View', 'Yes', 'No'),
(3, 22, 2205, 140, 'WiFi, Jacuzzi', 5, 'Pool View', 'Yes', 'No'),

-- Hotel 23 (adding 5 rooms)
(3, 23, 2301, 65, 'WiFi', 1, 'Street View', 'No', 'No'),
(3, 23, 2302, 85, 'WiFi, Fridge', 2, 'City View', 'No', 'No'),
(3, 23, 2303, 105, 'WiFi, Mini Bar', 3, 'City View', 'Yes', 'No'),
(3, 23, 2304, 125, 'TV, WiFi, Kitchenette', 4, 'Park View', 'Yes', 'No'),
(3, 23, 2305, 145, 'WiFi, Jacuzzi', 5, 'Pool View', 'Yes', 'No'),

-- Hotel 24 (adding 5 rooms)
(3, 24, 2401, 70, 'WiFi', 1, 'Street View', 'No', 'No'),
(3, 24, 2402, 90, 'WiFi, Fridge', 2, 'City View', 'No', 'No'),
(3, 24, 2403, 110, 'WiFi, Mini Bar', 3, 'City View', 'Yes', 'No'),
(3, 24, 2404, 130, 'TV, WiFi, Kitchenette', 4, 'Park View', 'Yes', 'No'),
(3, 24, 2405, 150, 'WiFi, Jacuzzi', 5, 'Pool View', 'Yes', 'No'),

-- Adding more rooms to Ocean View Resorts (Chain 4, Hotels 25-32)
-- Hotel 29 (adding 5 rooms)
(4, 25, 4401, 180, 'TV, WiFi, Mini Bar', 1, 'Sea View', 'Yes', 'No'),
(4, 25, 4402, 220, 'TV, WiFi, Mini Bar, Balcony', 2, 'Sea View', 'Yes', 'No'),
(4, 25, 4403, 260, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Oceanfront', 'Yes', 'No'),
(4, 25, 4404, 300, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Oceanfront', 'Yes', 'No'),
(4, 25, 4405, 350, 'TV, WiFi, Jacuzzi, Kitchenette, Lounge', 5, 'Oceanfront', 'Yes', 'No'),

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

(4, 29, 2901, 190, 'TV, WiFi, Mini Bar', 1, 'Sea View', 'Yes', 'No'),
(4, 29, 2902, 230, 'TV, WiFi, Mini Bar, Balcony', 2, 'Sea View', 'Yes', 'No'),
(4, 29, 2903, 270, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Oceanfront', 'Yes', 'No'),
(4, 29, 2904, 310, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Oceanfront', 'Yes', 'No'),
(4, 29, 2905, 360, 'TV, WiFi, Jacuzzi, Kitchenette, Lounge', 5, 'Oceanfront', 'Yes', 'No'),

-- Hotel 30 (adding 5 rooms)
(4, 30, 3001, 200, 'TV, WiFi, Mini Bar', 1, 'Sea View', 'Yes', 'No'),
(4, 30, 3002, 240, 'TV, WiFi, Mini Bar, Balcony', 2, 'Sea View', 'Yes', 'No'),
(4, 30, 3003, 280, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Oceanfront', 'Yes', 'No'),
(4, 30, 3004, 320, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Oceanfront', 'Yes', 'No'),
(4, 30, 3005, 370, 'TV, WiFi, Jacuzzi, Kitchenette, Lounge', 5, 'Oceanfront', 'Yes', 'No'),

-- Hotel 31 (adding 5 rooms)
(4, 31, 3101, 170, 'TV, WiFi, Mini Bar', 1, 'Sea View', 'Yes', 'No'),
(4, 31, 3102, 210, 'TV, WiFi, Mini Bar, Balcony', 2, 'Sea View', 'Yes', 'No'),
(4, 31, 3103, 250, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Oceanfront', 'Yes', 'No'),
(4, 31, 3104, 290, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Oceanfront', 'Yes', 'No'),
(4, 31, 3105, 340, 'TV, WiFi, Jacuzzi, Kitchenette, Lounge', 5, 'Oceanfront', 'Yes', 'No'),

-- Hotel 32 (adding 5 rooms)
(4, 32, 3201, 220, 'TV, WiFi, Mini Bar', 1, 'Sea View', 'Yes', 'No'),
(4, 32, 3202, 260, 'TV, WiFi, Mini Bar, Balcony', 2, 'Sea View', 'Yes', 'No'),
(4, 32, 3203, 300, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Oceanfront', 'Yes', 'No'),
(4, 32, 3204, 340, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Oceanfront', 'Yes', 'No'),
(4, 32, 3205, 390, 'TV, WiFi, Jacuzzi, Kitchenette, Lounge', 5, 'Oceanfront', 'Yes', 'No'),

-- Adding more rooms to Mountain Retreat (Chain 5, Hotels 33-40)
-- Hotel 37 (adding 5 rooms)
(5, 33, 5501, 200, 'TV, WiFi, Mini Bar', 1, 'Mountain View', 'Yes', 'No'),
(5, 33, 5502, 250, 'TV, WiFi, Mini Bar, Balcony', 2, 'Mountain View', 'Yes', 'No'),
(5, 33, 5503, 300, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Valley View', 'Yes', 'No'),
(5, 33, 5504, 350, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Valley View', 'Yes', 'No'),
(5, 33, 5505, 400, 'TV, WiFi, Jacuzzi, Kitchenette, Fireplace', 5, 'Valley View', 'Yes', 'No'),

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
(5, 36, 515, 500, 'WiFi, Mini Bar, Jacuzzi', 5, 'Forest View', 'Yes', 'No'),


(5, 37, 3701, 210, 'TV, WiFi, Mini Bar', 1, 'Mountain View', 'Yes', 'No'),
(5, 37, 3702, 260, 'TV, WiFi, Mini Bar, Balcony', 2, 'Mountain View', 'Yes', 'No'),
(5, 37, 3703, 310, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Valley View', 'Yes', 'No'),
(5, 37, 3704, 360, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Valley View', 'Yes', 'No'),
(5, 37, 3705, 410, 'TV, WiFi, Jacuzzi, Kitchenette, Fireplace', 5, 'Valley View', 'Yes', 'No'),

-- Hotel 38 (adding 5 rooms)
(5, 38, 3801, 220, 'TV, WiFi, Mini Bar', 1, 'Mountain View', 'Yes', 'No'),
(5, 38, 3802, 270, 'TV, WiFi, Mini Bar, Balcony', 2, 'Mountain View', 'Yes', 'No'),
(5, 38, 3803, 320, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Valley View', 'Yes', 'No'),
(5, 38, 3804, 370, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Valley View', 'Yes', 'No'),
(5, 38, 3805, 420, 'TV, WiFi, Jacuzzi, Kitchenette, Fireplace', 5, 'Valley View', 'Yes', 'No'),

-- Hotel 39 (adding 5 rooms)
(5, 39, 3901, 230, 'TV, WiFi, Mini Bar', 1, 'Mountain View', 'Yes', 'No'),
(5, 39, 3902, 280, 'TV, WiFi, Mini Bar, Balcony', 2, 'Mountain View', 'Yes', 'No'),
(5, 39, 3903, 330, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Valley View', 'Yes', 'No'),
(5, 39, 3904, 380, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Valley View', 'Yes', 'No'),
(5, 39, 3905, 430, 'TV, WiFi, Jacuzzi, Kitchenette, Fireplace', 5, 'Valley View', 'Yes', 'No'),

-- Hotel 40 (adding 5 rooms)
(5, 40, 4001, 240, 'TV, WiFi, Mini Bar', 1, 'Mountain View', 'Yes', 'No'),
(5, 40, 4002, 290, 'TV, WiFi, Mini Bar, Balcony', 2, 'Mountain View', 'Yes', 'No'),
(5, 40, 4003, 340, 'TV, WiFi, Mini Bar, Jacuzzi', 3, 'Valley View', 'Yes', 'No'),
(5, 40, 4004, 390, 'TV, WiFi, Mini Bar, Jacuzzi, Kitchenette', 4, 'Valley View', 'Yes', 'No'),
(5, 40, 4005, 440, 'TV, WiFi, Jacuzzi, Kitchenette, Fireplace', 5, 'Valley View', 'Yes', 'No');

Delete From public.Customer;
-- Insert data into Customer table
INSERT INTO public.Customer ( Full_Name, Email, Password, Address)
VALUES
( 'John Doe', 'john.doe@email.com', 'password123', '123 Main St, New York'),
( 'Emma Watson', 'emma.watson@email.com', 'mypassword', '456 Elm St, Los Angeles'),
( 'Liam Smith', 'liam.smith@email.com', 'liamPass99', '789 Pine St, Chicago'),
( 'Sophia Brown', 'sophia.brown@email.com', 'sophiaSecret', '101 Maple St, Miami'),
( 'Michael Johnson', 'michael.johnson@email.com', 'michael2024', '222 Oak St, Houston'),
( 'Olivia Martinez', 'olivia.martinez@email.com', 'oliviaPass', '333 Cedar St, San Francisco'),
( 'William Davis', 'william.davis@email.com', 'william123', '444 Birch St, Seattle'),
( 'Ava Wilson', 'ava.wilson@email.com', 'avaSecret', '555 Walnut St, Boston');

Delete from public.Employee;
-- Insert data into Employee table
INSERT INTO public.Employee ( Role, FullName, Email, Password, Hotel_FID)
VALUES
-- Luxury Stay Hotels (Chain 1)
('Manager', 'John Smith', 'john.smith@luxurystay.com', 'manager123', 1),
('Receptionist', 'Sarah Johnson', 'sarah.johnson@luxurystay.com', 'reception123', 1),
('Manager', 'Michael Brown', 'michael.brown@luxurystay.com', 'manager123', 2),
('Cleaner', 'Emily Davis', 'emily.davis@luxurystay.com', 'cleaner123', 2),
('Manager', 'David Wilson', 'david.wilson@luxurystay.com', 'manager123', 3),
('Receptionist', 'Jessica Martinez', 'jessica.martinez@luxurystay.com', 'reception123', 3),
('Manager', 'Robert Taylor', 'robert.taylor@luxurystay.com', 'manager123', 4),
('Cleaner', 'Jennifer Anderson', 'jennifer.anderson@luxurystay.com', 'cleaner123', 4),
('Manager', 'Daniel Thomas', 'daniel.thomas@luxurystay.com', 'manager123', 5),
('Receptionist', 'Lisa Jackson', 'lisa.jackson@luxurystay.com', 'reception123', 5),
('Manager', 'Paul White', 'paul.white@luxurystay.com', 'manager123', 6),
('Cleaner', 'Amy Harris', 'amy.harris@luxurystay.com', 'cleaner123', 6),
('Manager', 'Kevin Martin', 'kevin.martin@luxurystay.com', 'manager123', 7),
('Receptionist', 'Michelle Clark', 'michelle.clark@luxurystay.com', 'reception123', 7),
('Manager', 'Mark Rodriguez', 'mark.rodriguez@luxurystay.com', 'manager123', 8),
('Cleaner', 'Laura Lewis', 'laura.lewis@luxurystay.com', 'cleaner123', 8),

-- Comfort Inn Hotels (Chain 2)
('Manager', 'James Lee', 'james.lee@comfortinn.com', 'manager123', 9),
('Receptionist', 'Patricia Walker', 'patricia.walker@comfortinn.com', 'reception123', 9),
('Manager', 'Christopher Hall', 'christopher.hall@comfortinn.com', 'manager123', 10),
('Cleaner', 'Nancy Allen', 'nancy.allen@comfortinn.com', 'cleaner123', 10),
('Manager', 'Matthew Young', 'matthew.young@comfortinn.com', 'manager123', 11),
('Receptionist', 'Karen Hernandez', 'karen.hernandez@comfortinn.com', 'reception123', 11),
('Manager', 'Andrew King', 'andrew.king@comfortinn.com', 'manager123', 12),
('Cleaner', 'Betty Wright', 'betty.wright@comfortinn.com', 'cleaner123', 12),
('Manager', 'Edward Scott', 'edward.scott@comfortinn.com', 'manager123', 13),
('Receptionist', 'Helen Green', 'helen.green@comfortinn.com', 'reception123', 13),
('Manager', 'Brian Adams', 'brian.adams@comfortinn.com', 'manager123', 14),
('Cleaner', 'Sandra Baker', 'sandra.baker@comfortinn.com', 'cleaner123', 14),
('Manager', 'Ronald Nelson', 'ronald.nelson@comfortinn.com', 'manager123', 15),
('Receptionist', 'Donna Carter', 'donna.carter@comfortinn.com', 'reception123', 15),
('Manager', 'Jason Mitchell', 'jason.mitchell@comfortinn.com', 'manager123', 16),
('Cleaner', 'Rebecca Perez', 'rebecca.perez@comfortinn.com', 'cleaner123', 16),

-- Budget Rooms Hotels (Chain 3)
('Manager', 'Jeffrey Roberts', 'jeffrey.roberts@budgetrooms.com', 'manager123', 17),
('Receptionist', 'Sharon Turner', 'sharon.turner@budgetrooms.com', 'reception123', 17),
('Manager', 'Ryan Phillips', 'ryan.phillips@budgetrooms.com', 'manager123', 18),
('Cleaner', 'Deborah Campbell', 'deborah.campbell@budgetrooms.com', 'cleaner123', 18),
('Manager', 'Gary Parker', 'gary.parker@budgetrooms.com', 'manager123', 19),
('Receptionist', 'Carol Evans', 'carol.evans@budgetrooms.com', 'reception123', 19),
('Manager', 'Timothy Edwards', 'timothy.edwards@budgetrooms.com', 'manager123', 20),
('Cleaner', 'Ruth Collins', 'ruth.collins@budgetrooms.com', 'cleaner123', 20),
('Manager', 'Joshua Stewart', 'joshua.stewart@budgetrooms.com', 'manager123', 21),
('Receptionist', 'Anna Sanchez', 'anna.sanchez@budgetrooms.com', 'reception123', 21),
('Manager', 'Kenneth Morris', 'kenneth.morris@budgetrooms.com', 'manager123', 22),
('Cleaner', 'Brenda Rogers', 'brenda.rogers@budgetrooms.com', 'cleaner123', 22),
('Manager', 'Stephen Reed', 'stephen.reed@budgetrooms.com', 'manager123', 23),
('Receptionist', 'Pamela Cook', 'pamela.cook@budgetrooms.com', 'reception123', 23),
('Manager', 'Patrick Morgan', 'patrick.morgan@budgetrooms.com', 'manager123', 24),
('Cleaner', 'Ashley Bell', 'ashley.bell@budgetrooms.com', 'cleaner123', 24),

-- Ocean View Resorts Hotels (Chain 4)
('Manager', 'Gregory Murphy', 'gregory.murphy@oceanview.com', 'manager123', 25),
('Receptionist', 'Katherine Bailey', 'katherine.bailey@oceanview.com', 'reception123', 25),
('Manager', 'Benjamin Rivera', 'benjamin.rivera@oceanview.com', 'manager123', 26),
('Cleaner', 'Virginia Cooper', 'virginia.cooper@oceanview.com', 'cleaner123', 26),
('Manager', 'Dennis Richardson', 'dennis.richardson@oceanview.com', 'manager123', 27),
('Receptionist', 'Rachel Cox', 'rachel.cox@oceanview.com', 'reception123', 27),
('Manager', 'Peter Howard', 'peter.howard@oceanview.com', 'manager123', 28),
('Cleaner', 'Janet Ward', 'janet.ward@oceanview.com', 'cleaner123', 28),
('Manager', 'Frank Torres', 'frank.torres@oceanview.com', 'manager123', 29),
('Receptionist', 'Maria Peterson', 'maria.peterson@oceanview.com', 'reception123', 29),
('Manager', 'Raymond Gray', 'raymond.gray@oceanview.com', 'manager123', 30),
('Cleaner', 'Heather Ramirez', 'heather.ramirez@oceanview.com', 'cleaner123', 30),
('Manager', 'Lawrence James', 'lawrence.james@oceanview.com', 'manager123', 31),
('Receptionist', 'Diane Watson', 'diane.watson@oceanview.com', 'reception123', 31),
('Manager', 'Nicholas Brooks', 'nicholas.brooks@oceanview.com', 'manager123', 32),
('Cleaner', 'Olivia Kelly', 'olivia.kelly@oceanview.com', 'cleaner123', 32),

-- Mountain Retreat Hotels (Chain 5)
('Manager', 'Scott Sanders', 'scott.sanders@mountainretreat.com', 'manager123', 33),
('Receptionist', 'Christina Price', 'christina.price@mountainretreat.com', 'reception123', 33),
('Manager', 'Walter Bennett', 'walter.bennett@mountainretreat.com', 'manager123', 34),
('Cleaner', 'Joyce Wood', 'joyce.wood@mountainretreat.com', 'cleaner123', 34),
('Manager', 'Eric Barnes', 'eric.barnes@mountainretreat.com', 'manager123', 35),
('Receptionist', 'Victoria Ross', 'victoria.ross@mountainretreat.com', 'reception123', 35),
('Manager', 'Samuel Henderson', 'samuel.henderson@mountainretreat.com', 'manager123', 36),
('Cleaner', 'Kelly Coleman', 'kelly.coleman@mountainretreat.com', 'cleaner123', 36),
('Manager', 'Brandon Jenkins', 'brandon.jenkins@mountainretreat.com', 'manager123', 37),
('Receptionist', 'Theresa Perry', 'theresa.perry@mountainretreat.com', 'reception123', 37),
('Manager', 'Harry Powell', 'harry.powell@mountainretreat.com', 'manager123', 38),
('Cleaner', 'Megan Long', 'megan.long@mountainretreat.com', 'cleaner123', 38),
('Manager', 'Jeremy Hughes', 'jeremy.hughes@mountainretreat.com', 'manager123', 39),
('Receptionist', 'Amanda Foster', 'amanda.foster@mountainretreat.com', 'reception123', 39),
('Manager', 'Jacob Butler', 'jacob.butler@mountainretreat.com', 'manager123', 40),
('Cleaner', 'Melissa Simmons', 'melissa.simmons@mountainretreat.com', 'cleaner123', 40);


Delete From public.Renting;
-- Insert data into Renting table
INSERT INTO public.Renting ( StartDate, EndDate, Status, Payment, Employ_SID, Cust_ID, Room_ID, Hotel_ID)
VALUES
    -- Hotel 17 (Budget Stay) - Rooms 301-305
    ('2025-04-01', '2025-04-05', 'Completed', 500, 'E0001', 'CU0001', 3301, 17),
    ('2025-04-02', '2025-04-06', 'Ongoing', 650, 'E0001', 'CU0002', 3302, 17),
    
    -- Hotel 25 (Ocean Pearl Resort) - Rooms 401-405
    ('2025-04-03', '2025-04-07', 'Completed', 700, 'E0002', 'CU0003', 4401, 25),
    ('2025-04-04', '2025-04-08', 'Cancelled', 0, 'E0002', 'CU0004', 4402, 25),
    
    -- Hotel 33 (Alpine Resort) - Rooms 501-505
    ('2025-04-05', '2025-04-09', 'Completed', 550, 'E0003', 'CU0005', 5501, 33),
    ('2025-04-06', '2025-04-10', 'Ongoing', 600, 'E0003', 'CU0006', 5502, 33),
    
    -- Hotel 1 (Luxury Grand Hotel) - Rooms 101-105
    ('2025-04-07', '2025-04-11', 'Completed', 750, 'E0004', 'CU0007', 111, 1),
    ('2025-04-08', '2025-04-12', 'Ongoing', 800, 'E0004', 'CU0008', 112, 1),
    
    -- Hotel 9 (Comfort Plaza) - Rooms 201-205
    ('2025-04-09', '2025-04-13', 'Completed', 850, 'E0005', 'CU0001', 201, 9),
    ('2025-04-10', '2025-04-14', 'Ongoing', 900, 'E0005', 'CU0002', 202, 9),
    
    -- Hotel 6 (Luxury Tower) - Rooms 141-145
    ('2025-04-11', '2025-04-15', 'Completed', 950, 'E0006', 'CU0003', 141, 6),
    
    -- Hotel 11 (Comfort City) - Rooms 271-275
    ('2025-04-12', '2025-04-16', 'Completed', 1000, 'E0007', 'CU0004', 271, 11),
    
    -- Hotel 19 (Budget Lodge) - Rooms 381-385
    ('2025-04-13', '2025-04-17', 'Completed', 1050, 'E0008', 'CU0005', 381, 19),
    
    -- Hotel 2 (Luxury Central) - Rooms 106-110
    ('2025-04-14', '2025-04-18', 'Ongoing', 1100, 'E0009', 'CU0006', 106, 2),
    
    -- Hotel 3 (Luxury Heights) - Rooms 301-305
    ('2025-04-15', '2025-04-19', 'Completed', 1150, 'E00014', 'CU0007', 301, 3),
    
    -- Hotel 4 (Luxury Riverside) - Rooms 401-405
    ('2025-04-16', '2025-04-20', 'Ongoing', 1200, 'E00011', 'CU0008', 401, 4);

Delete From public.Booking;
-- Insert data into Booking table
INSERT INTO public.Booking ( CheckInDate, CheckOutDate, Status, Cust_ID, Room_ID, Hotel_ID)
VALUES
   -- Hotel 17 (Budget Stay) - Rooms 301-305
    ('2025-05-01', '2025-05-05', 'Confirmed', 'CU0001', 3301, 17),
    ('2025-05-06', '2025-05-10', 'Pending', 'CU0002', 3302, 17),
    
    -- Hotel 25 (Ocean Pearl Resort) - Rooms 401-405
    ('2025-05-02', '2025-05-07', 'Confirmed', 'CU0003', 4401, 25),
    ('2025-05-08', '2025-05-12', 'Pending', 'CU0004', 4402, 25),
    
    -- Hotel 33 (Alpine Resort) - Rooms 501-505
    ('2025-05-03', '2025-05-08', 'Confirmed', 'CU0005', 5501, 33),
    ('2025-05-09', '2025-05-13', 'Pending', 'CU0006', 5502, 33),
    
    -- Hotel 1 (Luxury Grand Hotel) - Rooms 101-105
    ('2025-05-04', '2025-05-09', 'Confirmed', 'CU0007', 111, 1),
    ('2025-05-10', '2025-05-14', 'Pending', 'CU0008', 112, 1),
    
    -- Hotel 9 (Comfort Plaza) - Rooms 201-205
    ('2025-05-05', '2025-05-10', 'Confirmed', 'CU0001', 201, 9),
    ('2025-05-11', '2025-05-15', 'Pending', 'CU0002', 202, 9),
    
    -- Hotel 6 (Luxury Tower) - Rooms 141-145
    ('2025-05-06', '2025-05-11', 'Confirmed', 'CU0003', 141, 6),
    
    -- Hotel 11 (Comfort City) - Rooms 271-275
    ('2025-05-07', '2025-05-12', 'Confirmed', 'CU0004', 271, 11),
    
    -- Hotel 19 (Budget Lodge) - Rooms 381-385
    ('2025-05-08', '2025-05-13', 'Confirmed', 'CU0005', 381, 19),
    
    -- Hotel 2 (Luxury Central) - Rooms 106-110
    ('2025-05-09', '2025-05-14', 'Pending', 'CU0006', 106, 2),
    
    -- Hotel 3 (Luxury Heights) - Rooms 301-305
    ('2025-05-10', '2025-05-15', 'Confirmed', 'CU0007', 301, 3),
    
    -- Hotel 4 (Luxury Riverside) - Rooms 401-405
    ('2025-05-11', '2025-05-16', 'Pending', 'CU0008', 401, 4),
    
    -- Additional bookings to show different statuses
    ('2025-05-12', '2025-05-17', 'Cancelled', 'CU0001', 3303, 17),
    ('2025-05-13', '2025-05-18', 'Confirmed', 'CU0002', 403, 25),
    ('2025-05-14', '2025-05-19', 'Cancelled', 'CU0003', 503, 33),
    ('2025-05-15', '2025-05-20', 'Confirmed', 'CU0004', 113, 1);


	
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



