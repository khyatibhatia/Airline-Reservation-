-- Airline Reservation System - Schema + Sample Data
-- File: airline_reservation_system.sql
-- Tables: Airlines, Airports, Aircrafts, Routes, Flights, FareClasses, Seats, Passengers,
-- Bookings, Tickets, Payments, Crew, CrewAssignments

CREATE DATABASE airline;
USE airline;

-- DROP in correct order (child first)
DROP TABLE IF EXISTS CrewAssignments;
DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Seats;
DROP TABLE IF EXISTS Flights;
DROP TABLE IF EXISTS Routes;
DROP TABLE IF EXISTS Aircrafts;
DROP TABLE IF EXISTS FareClasses;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Crew;
DROP TABLE IF EXISTS Airports;
DROP TABLE IF EXISTS Airlines;

-- Core reference tables
CREATE TABLE Airlines (
    AirlineID     INT PRIMARY KEY AUTO_INCREMENT,
    Name          VARCHAR(100) NOT NULL,
    IATA_Code     CHAR(2) UNIQUE NOT NULL,
    Country       VARCHAR(100)
);

CREATE TABLE Airports (
    AirportID     INT PRIMARY KEY AUTO_INCREMENT,
    Name          VARCHAR(150) NOT NULL,
    City          VARCHAR(100),
    Country       VARCHAR(100),
    IATA_Code     CHAR(3) UNIQUE NOT NULL,
    ICAO_Code     CHAR(4),
    Latitude      DOUBLE,
    Longitude     DOUBLE
);

CREATE TABLE Aircrafts (
    AircraftID    INT PRIMARY KEY AUTO_INCREMENT,
    AirlineID     INT NOT NULL,
    Model         VARCHAR(50) NOT NULL,
    RegistrationNo VARCHAR(15) UNIQUE NOT NULL,
    Capacity      INT NOT NULL,
    ManufactureYear INT,
    FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID)
);

CREATE TABLE Routes (
    RouteID       INT PRIMARY KEY AUTO_INCREMENT,
    AirlineID     INT NOT NULL,
    OriginAirportID INT NOT NULL,
    DestinationAirportID INT NOT NULL,
    DistanceKM    INT,
    RouteCode     VARCHAR(10) UNIQUE,
    FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID),
    FOREIGN KEY (OriginAirportID) REFERENCES Airports(AirportID),
    FOREIGN KEY (DestinationAirportID) REFERENCES Airports(AirportID)
);

-- Scheduled flights (occurrences of a route on a date/time)
CREATE TABLE Flights (
    FlightID      INT PRIMARY KEY AUTO_INCREMENT,
    RouteID       INT NOT NULL,
    AircraftID    INT NOT NULL,
    FlightNumber  VARCHAR(10) NOT NULL,
    DepartureUTC  DATETIME NOT NULL,
    ArrivalUTC    DATETIME NOT NULL,
    Status        VARCHAR(20) DEFAULT 'Scheduled', -- Scheduled, Delayed, Cancelled, Completed
    Gate          VARCHAR(10),
    BlockTimeMins INT,
    FOREIGN KEY (RouteID) REFERENCES Routes(RouteID),
    FOREIGN KEY (AircraftID) REFERENCES Aircrafts(AircraftID)
);

CREATE TABLE FareClasses (
    FareClassID   INT PRIMARY KEY AUTO_INCREMENT,
    Code          CHAR(2) NOT NULL, -- e.g., Y, J, F, W (economy/business/first)
    Description   VARCHAR(50),
    Multiplier    DOUBLE NOT NULL -- multiplier on base fare
);

-- Seat inventory per flight (a seat map)
CREATE TABLE Seats (
    SeatID        INT PRIMARY KEY AUTO_INCREMENT,
    FlightID      INT NOT NULL,
    SeatNumber    VARCHAR(5) NOT NULL,
    FareClassID   INT NOT NULL,
    IsAvailable   TINYINT DEFAULT 1,
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID),
    FOREIGN KEY (FareClassID) REFERENCES FareClasses(FareClassID)
);

CREATE TABLE Passengers (
    PassengerID   INT PRIMARY KEY AUTO_INCREMENT,
    FirstName     VARCHAR(50) NOT NULL,
    LastName      VARCHAR(50) NOT NULL,
    DateOfBirth   DATE,
    Gender        CHAR(1),
    Email         VARCHAR(100),
    Phone         VARCHAR(20),
    PassportNo    VARCHAR(20),
    Nationality   VARCHAR(50)
);

CREATE TABLE Bookings (
    BookingID     INT PRIMARY KEY AUTO_INCREMENT,
    BookingRef    VARCHAR(12) UNIQUE NOT NULL, -- PNR-like reference
    PassengerID   INT NOT NULL,
    BookingDate   DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount   DECIMAL(10,2) NOT NULL,
    BookingStatus VARCHAR(20) DEFAULT 'Confirmed', -- Confirmed, Cancelled, Pending
    FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID)
);

CREATE TABLE Tickets (
    TicketID      INT PRIMARY KEY AUTO_INCREMENT,
    BookingID     INT NOT NULL,
    FlightID      INT NOT NULL,
    SeatID        INT,
    TicketNo      VARCHAR(20) UNIQUE NOT NULL,
    FareAmount    DECIMAL(10,2) NOT NULL,
    TicketStatus  VARCHAR(20) DEFAULT 'Issued', -- Issued, CheckedIn, Cancelled, NoShow
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID),
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID)
);

CREATE TABLE Payments (
    PaymentID     INT PRIMARY KEY AUTO_INCREMENT,
    BookingID     INT NOT NULL,
    PaidAmount    DECIMAL(10,2) NOT NULL,
    PaidOn        DATETIME DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(30), -- Card, NetBanking, UPI, Cash
    TransactionRef VARCHAR(50),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

CREATE TABLE Crew (
    CrewID        INT PRIMARY KEY AUTO_INCREMENT,
    FirstName     VARCHAR(50),
    LastName      VARCHAR(50),
    Role          VARCHAR(30), -- Pilot, CoPilot, CabinCrew, Engineer
    LicenseNo     VARCHAR(50),
    ContactPhone  VARCHAR(20)
);

CREATE TABLE CrewAssignments (
    AssignmentID  INT PRIMARY KEY AUTO_INCREMENT,
    FlightID      INT NOT NULL,
    CrewID        INT NOT NULL,
    AssignedRole  VARCHAR(30),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID),
    FOREIGN KEY (CrewID) REFERENCES Crew(CrewID)
);

-- SAMPLE DATA INSERTS (small but illustrative)
-- Airlines
INSERT INTO Airlines (Name, IATA_Code, Country) VALUES ('IndiGo', '6E', 'India');
INSERT INTO Airlines (Name, IATA_Code, Country) VALUES ('Air India', 'AI', 'India');
INSERT INTO Airlines (Name, IATA_Code, Country) VALUES ('SpiceJet', 'SG', 'India');
INSERT INTO Airlines (Name, IATA_Code, Country) VALUES ('Emirates', 'EK', 'UAE');
INSERT INTO Airlines (Name, IATA_Code, Country) VALUES ('British Airways', 'BA', 'UK');

-- Airports (10)
INSERT INTO Airports (Name, City, Country, IATA_Code, ICAO_Code, Latitude, Longitude) VALUES ('Indira Gandhi International', 'New Delhi', 'India', 'DEL', 'VIDP', 28.5562, 77.1000);
INSERT INTO Airports (Name, City, Country, IATA_Code, ICAO_Code, Latitude, Longitude) VALUES ('Chhatrapati Shivaji Maharaj', 'Mumbai', 'India', 'BOM', 'VABB', 19.0896, 72.8656);
INSERT INTO Airports (Name, City, Country, IATA_Code, ICAO_Code, Latitude, Longitude) VALUES ('Kempegowda International', 'Bengaluru', 'India', 'BLR', 'VOBL', 13.1986, 77.7066);
INSERT INTO Airports (Name, City, Country, IATA_Code, ICAO_Code, Latitude, Longitude) VALUES ('Chennai International', 'Chennai', 'India', 'MAA', 'VOMM', 12.9941, 80.1709);
INSERT INTO Airports (Name, City, Country, IATA_Code, ICAO_Code, Latitude, Longitude) VALUES ('Netaji Subhash Chandra Bose', 'Kolkata', 'India', 'CCU', 'VECC', 22.6547, 88.4467);
INSERT INTO Airports (Name, City, Country, IATA_Code, ICAO_Code, Latitude, Longitude) VALUES ('Heathrow', 'London', 'UK', 'LHR', 'EGLL', 51.4700, -0.4543);
INSERT INTO Airports (Name, City, Country, IATA_Code, ICAO_Code, Latitude, Longitude) VALUES ('Dubai International', 'Dubai', 'UAE', 'DXB', 'OMDB', 25.2532, 55.3657);
INSERT INTO Airports (Name, City, Country, IATA_Code, ICAO_Code, Latitude, Longitude) VALUES ('Singapore Changi', 'Singapore', 'Singapore', 'SIN', 'WSSS', 1.3644, 103.9915);
INSERT INTO Airports (Name, City, Country, IATA_Code, ICAO_Code, Latitude, Longitude) VALUES ('Bangkok Suvarnabhumi', 'Bangkok', 'Thailand', 'BKK', 'VTBS', 13.689999, 100.750111);
INSERT INTO Airports (Name, City, Country, IATA_Code, ICAO_Code, Latitude, Longitude) VALUES ('Kochi', 'Kochi', 'India', 'COK', 'VOCI', 10.1520, 76.4019);

-- Aircrafts
INSERT INTO Aircrafts (AirlineID, Model, RegistrationNo, Capacity, ManufactureYear) VALUES (1, 'A320-200', 'VT-INO', 180, 2015);
INSERT INTO Aircrafts (AirlineID, Model, RegistrationNo, Capacity, ManufactureYear) VALUES (1, 'A320-200', 'VT-INP', 180, 2016);
INSERT INTO Aircrafts (AirlineID, Model, RegistrationNo, Capacity, ManufactureYear) VALUES (2, 'Boeing 777', 'VT-ANI', 300, 2010);
INSERT INTO Aircrafts (AirlineID, Model, RegistrationNo, Capacity, ManufactureYear) VALUES (4, 'Boeing 777', 'A6-EMR', 350, 2014);
INSERT INTO Aircrafts (AirlineID, Model, RegistrationNo, Capacity, ManufactureYear) VALUES (5, 'Boeing 787', 'G-BAAA', 240, 2017);
INSERT INTO Aircrafts (AirlineID, Model, RegistrationNo, Capacity, ManufactureYear) VALUES (3, 'Boeing 737', 'VT-SPG', 160, 2014);
INSERT INTO Aircrafts (AirlineID, Model, RegistrationNo, Capacity, ManufactureYear) VALUES (2, 'A320', 'VT-AIN', 150, 2018);
INSERT INTO Aircrafts (AirlineID, Model, RegistrationNo, Capacity, ManufactureYear) VALUES (1, 'A321', 'VT-INQ', 220, 2019);

-- Routes
INSERT INTO Routes (AirlineID, OriginAirportID, DestinationAirportID, DistanceKM, RouteCode) VALUES (1, 1, 2, 1400, '6E-DEL-BOM');
INSERT INTO Routes (AirlineID, OriginAirportID, DestinationAirportID, DistanceKM, RouteCode) VALUES (1, 1, 3, 2150, '6E-DEL-BLR');
INSERT INTO Routes (AirlineID, OriginAirportID, DestinationAirportID, DistanceKM, RouteCode) VALUES (2, 2, 6, 8300, 'AI-BOM-LHR');
INSERT INTO Routes (AirlineID, OriginAirportID, DestinationAirportID, DistanceKM, RouteCode) VALUES (4, 7, 8, 5800, 'EK-DXB-SIN');
INSERT INTO Routes (AirlineID, OriginAirportID, DestinationAirportID, DistanceKM, RouteCode) VALUES (1, 3, 2, 2150, '6E-BLR-BOM');
INSERT INTO Routes (AirlineID, OriginAirportID, DestinationAirportID, DistanceKM, RouteCode) VALUES (3, 1, 2, 1400, 'SG-DEL-BOM');
INSERT INTO Routes (AirlineID, OriginAirportID, DestinationAirportID, DistanceKM, RouteCode) VALUES (2, 1, 6, 7200, 'AI-DEL-LHR');
INSERT INTO Routes (AirlineID, OriginAirportID, DestinationAirportID, DistanceKM, RouteCode) VALUES (1, 4, 3, 2000, '6E-MAA-BLR');
INSERT INTO Routes (AirlineID, OriginAirportID, DestinationAirportID, DistanceKM, RouteCode) VALUES (1, 5, 1, 1300, '6E-CCU-DEL');
INSERT INTO Routes (AirlineID, OriginAirportID, DestinationAirportID, DistanceKM, RouteCode) VALUES (1, 1, 10, 780, '6E-DEL-COK');

-- Flights (sample scheduled flights)
INSERT INTO Flights (RouteID, AircraftID, FlightNumber, DepartureUTC, ArrivalUTC, Status, Gate, BlockTimeMins) VALUES (1, 1, '6E101', '2025-12-01 05:30:00', '2025-12-01 07:00:00', 'Scheduled', 'A1', 90);
INSERT INTO Flights (RouteID, AircraftID, FlightNumber, DepartureUTC, ArrivalUTC, Status, Gate, BlockTimeMins) VALUES (2, 2, '6E201', '2025-12-01 09:00:00', '2025-12-01 11:30:00', 'Scheduled', 'B2', 150);
INSERT INTO Flights (RouteID, AircraftID, FlightNumber, DepartureUTC, ArrivalUTC, Status, Gate, BlockTimeMins) VALUES (3, 3, 'AI303', '2025-12-02 02:00:00', '2025-12-02 09:30:00', 'Scheduled', 'C3', 450);
INSERT INTO Flights (RouteID, AircraftID, FlightNumber, DepartureUTC, ArrivalUTC, Status, Gate, BlockTimeMins) VALUES (4, 4, 'EK401', '2025-12-05 18:00:00', '2025-12-06 00:30:00', 'Scheduled', 'D5', 390);
INSERT INTO Flights (RouteID, AircraftID, FlightNumber, DepartureUTC, ArrivalUTC, Status, Gate, BlockTimeMins) VALUES (5, 8, '6E301', '2025-12-03 14:00:00', '2025-12-03 16:15:00', 'Scheduled', 'F1', 135);
INSERT INTO Flights (RouteID, AircraftID, FlightNumber, DepartureUTC, ArrivalUTC, Status, Gate, BlockTimeMins) VALUES (6, 6, 'SG601', '2025-12-04 06:00:00', '2025-12-04 07:40:00', 'Scheduled', 'G2', 100);
INSERT INTO Flights (RouteID, AircraftID, FlightNumber, DepartureUTC, ArrivalUTC, Status, Gate, BlockTimeMins) VALUES (7, 7, 'AI701', '2025-12-06 22:00:00', '2025-12-07 05:30:00', 'Scheduled', 'H4', 450);
INSERT INTO Flights (RouteID, AircraftID, FlightNumber, DepartureUTC, ArrivalUTC, Status, Gate, BlockTimeMins) VALUES (8, 1, '6E401', '2025-12-02 07:00:00', '2025-12-02 09:40:00', 'Scheduled', 'E2', 160);
INSERT INTO Flights (RouteID, AircraftID, FlightNumber, DepartureUTC, ArrivalUTC, Status, Gate, BlockTimeMins) VALUES (9, 2, '6E501', '2025-12-03 20:00:00', '2025-12-03 21:50:00', 'Scheduled', 'A3', 110);
INSERT INTO Flights (RouteID, AircraftID, FlightNumber, DepartureUTC, ArrivalUTC, Status, Gate, BlockTimeMins) VALUES (10, 1, '6E601', '2025-12-04 12:30:00', '2025-12-04 14:00:00', 'Scheduled', 'B5', 90);

-- Fare classes
INSERT INTO FareClasses (Code, Description, Multiplier) VALUES ('Y', 'Economy', 1.00);
INSERT INTO FareClasses (Code, Description, Multiplier) VALUES ('J', 'Business', 2.50);
INSERT INTO FareClasses (Code, Description, Multiplier) VALUES ('F', 'First', 4.00);

-- Seats for Flight 1 (simple layout: 12 rows x 6 seats = 72 seats but we'll insert sample)
-- We'll insert few seats per flight for brevity
INSERT INTO Seats (FlightID, SeatNumber, FareClassID, IsAvailable) VALUES (1, '1A', 2, 1);
INSERT INTO Seats (FlightID, SeatNumber, FareClassID, IsAvailable) VALUES (1, '1B', 2, 1);
INSERT INTO Seats (FlightID, SeatNumber, FareClassID, IsAvailable) VALUES (1, '10A', 1, 1);
INSERT INTO Seats (FlightID, SeatNumber, FareClassID, IsAvailable) VALUES (1, '10B', 1, 1);
INSERT INTO Seats (FlightID, SeatNumber, FareClassID, IsAvailable) VALUES (2, '5A', 1, 1);
INSERT INTO Seats (FlightID, SeatNumber, FareClassID, IsAvailable) VALUES (2, '5B', 1, 1);
INSERT INTO Seats (FlightID, SeatNumber, FareClassID, IsAvailable) VALUES (3, '2A', 3, 1);
INSERT INTO Seats (FlightID, SeatNumber, FareClassID, IsAvailable) VALUES (3, '2B', 3, 1);
INSERT INTO Seats (FlightID, SeatNumber, FareClassID, IsAvailable) VALUES (4, '15A', 1, 1);
INSERT INTO Seats (FlightID, SeatNumber, FareClassID, IsAvailable) VALUES (5, '12A', 1, 1);

-- Passengers (sample)
INSERT INTO Passengers (FirstName, LastName, DateOfBirth, Gender, Email, Phone, PassportNo, Nationality) VALUES ('Aarav', 'Sharma', '1990-05-10', 'M', 'aarav.sharma@example.com', '+919900112233', 'X1234567', 'India');
INSERT INTO Passengers (FirstName, LastName, DateOfBirth, Gender, Email, Phone, PassportNo, Nationality) VALUES ('Priya', 'Mehta', '1988-08-22', 'F', 'priya.mehta@example.com', '+919810223344', 'Y9876543', 'India');
INSERT INTO Passengers (FirstName, LastName, DateOfBirth, Gender, Email, Phone, PassportNo, Nationality) VALUES ('John', 'Doe', '1985-01-12', 'M', 'john.doe@example.com', '+441632960000', 'P1122334', 'UK');
INSERT INTO Passengers (FirstName, LastName, DateOfBirth, Gender, Email, Phone, PassportNo, Nationality) VALUES ('Sara', 'Lee', '1992-03-02', 'F', 'sara.lee@example.com', '+6591234567', 'S9988776', 'Singapore');
INSERT INTO Passengers (FirstName, LastName, DateOfBirth, Gender, Email, Phone, PassportNo, Nationality) VALUES ('Mohammed', 'Khan', '1978-11-11', 'M', 'm.khan@example.com', '+971501234567', 'M4455667', 'UAE');

-- Bookings
INSERT INTO Bookings (BookingRef, PassengerID, BookingDate, TotalAmount, BookingStatus) VALUES ('PNR0001', 1, '2025-11-01 10:00:00', 8000.00, 'Confirmed');
INSERT INTO Bookings (BookingRef, PassengerID, BookingDate, TotalAmount, BookingStatus) VALUES ('PNR0002', 2, '2025-11-02 11:00:00', 12000.00, 'Confirmed');
INSERT INTO Bookings (BookingRef, PassengerID, BookingDate, TotalAmount, BookingStatus) VALUES ('PNR0003', 3, '2025-11-03 12:15:00', 45000.00, 'Confirmed');
INSERT INTO Bookings (BookingRef, PassengerID, BookingDate, TotalAmount, BookingStatus) VALUES ('PNR0004', 4, '2025-11-04 09:30:00', 35000.00, 'Confirmed');
INSERT INTO Bookings (BookingRef, PassengerID, BookingDate, TotalAmount, BookingStatus) VALUES ('PNR0005', 5, '2025-11-05 14:10:00', 15000.00, 'Confirmed');

-- Payments
INSERT INTO Payments (BookingID, PaidAmount, PaidOn, PaymentMethod, TransactionRef) VALUES (1, 8000.00, '2025-11-01 10:05:00', 'Card', 'TXN10001');
INSERT INTO Payments (BookingID, PaidAmount, PaidOn, PaymentMethod, TransactionRef) VALUES (2, 12000.00, '2025-11-02 11:05:00', 'UPI', 'TXN10002');
INSERT INTO Payments (BookingID, PaidAmount, PaidOn, PaymentMethod, TransactionRef) VALUES (3, 45000.00, '2025-11-03 12:20:00', 'Card', 'TXN10003');
INSERT INTO Payments (BookingID, PaidAmount, PaidOn, PaymentMethod, TransactionRef) VALUES (4, 35000.00, '2025-11-04 09:35:00', 'NetBanking', 'TXN10004');
INSERT INTO Payments (BookingID, PaidAmount, PaidOn, PaymentMethod, TransactionRef) VALUES (5, 15000.00, '2025-11-05 14:15:00', 'Card', 'TXN10005');

-- Tickets (link bookings to flights & seats)
INSERT INTO Tickets (BookingID, FlightID, SeatID, TicketNo, FareAmount, TicketStatus) VALUES (1, 1, 1, 'TKT00001', 5000.00, 'Issued');
INSERT INTO Tickets (BookingID, FlightID, SeatID, TicketNo, FareAmount, TicketStatus) VALUES (2, 2, 5, 'TKT00002', 6000.00, 'Issued');
INSERT INTO Tickets (BookingID, FlightID, SeatID, TicketNo, FareAmount, TicketStatus) VALUES (3, 3, 7, 'TKT00003', 30000.00, 'Issued');
INSERT INTO Tickets (BookingID, FlightID, SeatID, TicketNo, FareAmount, TicketStatus) VALUES (4, 4, 9, 'TKT00004', 32000.00, 'Issued');
INSERT INTO Tickets (BookingID, FlightID, SeatID, TicketNo, FareAmount, TicketStatus) VALUES (5, 5, 10, 'TKT00005', 12000.00, 'Issued');

-- Crew
INSERT INTO Crew (FirstName, LastName, Role, LicenseNo, ContactPhone) VALUES ('Rahul', 'Verma', 'Pilot', 'LIC-P-1001', '+919988776655');
INSERT INTO Crew (FirstName, LastName, Role, LicenseNo, ContactPhone) VALUES ('Aisha', 'Khan', 'CoPilot', 'LIC-P-1002', '+919977665544');
INSERT INTO Crew (FirstName, LastName, Role, LicenseNo, ContactPhone) VALUES ('Vikram', 'Singh', 'CabinCrew', 'LIC-C-2001', '+919966554433');
INSERT INTO Crew (FirstName, LastName, Role, LicenseNo, ContactPhone) VALUES ('Meera', 'Patel', 'CabinCrew', 'LIC-C-2002', '+919955443322');
INSERT INTO Crew (FirstName, LastName, Role, LicenseNo, ContactPhone) VALUES ('Sam', 'Williams', 'Engineer', 'LIC-E-3001', '+441632960111');

-- Crew Assignments
INSERT INTO CrewAssignments (FlightID, CrewID, AssignedRole) VALUES (1, 1, 'Pilot');
INSERT INTO CrewAssignments (FlightID, CrewID, AssignedRole) VALUES (1, 2, 'CoPilot');
INSERT INTO CrewAssignments (FlightID, CrewID, AssignedRole) VALUES (1, 3, 'CabinCrew');
INSERT INTO CrewAssignments (FlightID, CrewID, AssignedRole) VALUES (2, 4, 'CabinCrew');
INSERT INTO CrewAssignments (FlightID, CrewID, AssignedRole) VALUES (3, 5, 'Engineer');

-- Indexes for performance
CREATE INDEX idx_flightnumber ON Flights(FlightNumber);
CREATE INDEX idx_bookingref ON Bookings(BookingRef);
CREATE INDEX idx_ticketno ON Tickets(TicketNo);

-- Sample queries you can run for viva / demo
-- 1) Get flights between DEL and BOM
-- SELECT f.FlightNumber, a1.IATA_Code AS Origin, a2.IATA_Code AS Destination, f.DepartureUTC, f.ArrivalUTC
-- FROM Flights f JOIN Routes r ON f.RouteID = r.RouteID
-- JOIN Airports a1 ON r.OriginAirportID = a1.AirportID
-- JOIN Airports a2 ON r.DestinationAirportID = a2.AirportID
-- WHERE a1.IATA_Code='DEL' AND a2.IATA_Code='BOM';

-- 2) Passenger booking history
-- SELECT p.FirstName, p.LastName, b.BookingRef, b.TotalAmount, b.BookingDate
-- FROM Passengers p JOIN Bookings b ON p.PassengerID = b.PassengerID
-- WHERE p.PassportNo='X1234567';

-- 3) Seats available on a flight
-- SELECT SeatNumber, IsAvailable FROM Seats WHERE FlightID=1 AND IsAvailable=1;

-- End of SQL file