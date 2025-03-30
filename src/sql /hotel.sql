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



DROP TABLE IF EXISTS public.Hotel cascade;
-- Create Hotel table
CREATE TABLE IF NOT EXISTS public.Hotel (
    Hotel_ID INT PRIMARY KEY,
    Hotel_chain_ID INT,
    Email VARCHAR(255),
    Num_rooms INT CHECK (Num_rooms >= 1),
    Category VARCHAR(50),
    Phone VARCHAR(20),
    FOREIGN KEY (Hotel_chain_ID) REFERENCES public.Hotel_chain(Hotel_chain_ID)
);


DROP TABLE IF EXISTS public.Room cascade;
-- Create Room table
-- CREATE TABLE IF NOT EXISTS public.Room (
--     Hotel_chain_ID INT,
--     Hotel_ID INT,
--     Room_ID INT,
--     Price DECIMAL(10, 2) CHECK (Price > 0),
--     Amenity TEXT,
--     Capacity INT CHECK (Capacity >= 1),
--     View VARCHAR(100),
--     Extension VARCHAR(10),
--     Damage VARCHAR(10),
--     PRIMARY KEY (Hotel_chain_ID, Hotel_ID, Room_ID),
--     FOREIGN KEY (Hotel_chain_ID) REFERENCES public.Hotel_chain(Hotel_chain_ID),
--     FOREIGN KEY (Hotel_ID) REFERENCES public.Hotel(Hotel_ID)
-- );

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
-- Insert data into the Hotel_chain table with the new Chain_Name column
INSERT INTO public.Hotel_chain (Hotel_chain_ID,Chain_Name, Address, Num_hotels, Email, Phone)
VALUES
(1, 'Luxury Stay', '123 Chain St, City, State, ZIP', 10, 'contact@chain1.com', '123-456-7890'),
(2, 'Comfort Inn', '456 Hotel Rd, City, State, ZIP', 15, 'info@chain2.com', '987-654-3210'),
(3, 'Budget Rooms', '789 Grand Ave, City, State, ZIP', 20, 'support@chain3.com', '555-123-4567'),
(4, 'Ocean View Resorts', '101 Resort Blvd, City, State, ZIP', 8, 'service@chain4.com', '444-555-6666'),
(5, 'Mountain Retreat', '202 Skyline St, City, State, ZIP', 12, 'hello@chain5.com', '333-777-8888');

-- Insert data into Hotel table
INSERT INTO public.Hotel (Hotel_ID, Hotel_chain_ID, Email, Num_rooms, Category, Phone)
VALUES
    (1, 1, 'info@miamibeachhotel.com', 100, '4-Star', '305-555-0001'),
    (2, 1, 'contact@keywestresort.com', 150, '5-Star', '305-555-0012'),
    (3, 2, 'reception@mountainpeakresort.com', 120, '3-Star', '303-555-0123'),
    (4, 2, 'info@rockysummithotel.com', 80, '4-Star', '303-555-0456'),
    (5, 3, 'contact@newyorkcityhotel.com', 200, '3-Star', '212-555-0101'),
    (6, 3, 'info@citycentrehotel.com', 90, '2-Star', '212-555-0222'),
    (7, 4, 'info@oceansideluxury.com', 60, '5-Star', '858-555-0333'),
    (8, 4, 'contact@sunnybeachhotel.com', 80, '4-Star', '858-555-0444'),
    (9, 5, 'reservations@rainforestinn.com', 70, '3-Star', '206-555-0555'),
    (10, 5, 'bookings@forestviewhotel.com', 110, '4-Star', '206-555-0666');

-- Insert data into Room table
INSERT INTO public.Room (Hotel_chain_ID, Hotel_ID, Room_ID, Price, Amenity, Capacity, View, Extension, Damage)
VALUES
    (1, 1, 101, 150, 'TV, Air Conditioning, Fridge', 2, 'Sea View', 'Yes', 'No'),
    (1, 1, 102, 180, 'TV, Air Conditioning, Fridge', 2, 'Sea View', 'Yes', 'No'),
    (1, 2, 201, 250, 'TV, Air Conditioning, Fridge, Balcony', 4, 'Sea View', 'Yes', 'No'),
    (1, 2, 202, 220, 'TV, Air Conditioning, Fridge', 2, 'Sea View', 'Yes', 'Yes'),
    (2, 3, 301, 120, 'TV, Air Conditioning', 1, 'Mountain View', 'No', 'No'),
    (2, 3, 302, 150, 'TV, Air Conditioning, Fridge', 2, 'Mountain View', 'Yes', 'No'),
    (2, 4, 401, 180, 'TV, Air Conditioning, Fridge, Balcony', 3, 'Mountain View', 'Yes', 'No'),
    (3, 5, 501, 100, 'TV, Air Conditioning', 1, 'City View', 'No', 'No'),
    (3, 5, 502, 130, 'TV, Air Conditioning, Fridge', 2, 'City View', 'No', 'No'),
    (4, 7, 601, 200, 'TV, Air Conditioning, Fridge, Balcony', 2, 'Ocean View', 'Yes', 'No'),
    (4, 7, 602, 250, 'TV, Air Conditioning, Fridge, Balcony', 2, 'Ocean View', 'Yes', 'No'),
    (5, 9, 701, 120, 'TV, Air Conditioning', 2, 'Forest View', 'No', 'No'),
    (5, 9, 702, 150, 'TV, Air Conditioning, Fridge', 2, 'Forest View', 'No', 'Yes');

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
    (2, '2025-03-16', '2025-03-19', 'Pending', 2, 301, 3),
    (3, '2025-03-20', '2025-03-23', 'Confirmed', 3, 501, 5),
    (4, '2025-03-21', '2025-03-24', 'Cancelled', 4, 701, 7);

-- Insert data into Renting table
INSERT INTO public.Renting (Renting_ID, StartDate, EndDate, Status, Payment, Employ_SID, Cust_ID, Room_ID, Hotel_ID)
VALUES
    (1, '2025-03-15', '2025-03-18', 'Completed', 450, 'SSN001', 1, 101, 1),
    (2, '2025-03-16', '2025-03-19', 'Ongoing', 600, 'SSN003', 2, 301, 3),
    (3, '2025-03-20', '2025-03-23', 'Completed', 600, 'SSN005', 3, 501, 5),
    (4, '2025-03-21', '2025-03-24', 'Cancelled', 0, 'SSN004', 4, 701, 7);
