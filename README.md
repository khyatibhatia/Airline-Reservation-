# ✈ Airline Management DBMS

## 📝 Project Details
*Group:* 12  
*Section:* C  
*Team Members:*  
- Khyati  - 341149
- Jaspreet Singh - 341139
- Pooja Batra - 341161 

---

# 🛠 Database Schema Description
This section provides a detailed description of all tables in the *Airline Management Database System*, including their attributes, data types, and key relationships.  
The database is designed to handle airline operations such as flights, routes, bookings, tickets, payments, aircrafts, passengers, and crew assignments.

---

## 🛩 Aircrafts Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| AircraftID | INT | PK | Unique identifier for each aircraft. |
| AirlineID | INT | FK | Links to Airline table. |
| Model | VARCHAR(50) | | Aircraft model name. |
| RegistrationNo | VARCHAR | | Government aircraft registration number. |
| Capacity | INT | | Seating capacity of the aircraft. |
| ManufactureYear | INT | | Year the aircraft was manufactured. |

---

## 🏳 Airlines Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| AirlineID | INT | PK | Unique airline identifier. |
| Name | VARCHAR(100) | | Airline name. |
| IATA_Code | CHAR(2) | | 2-letter IATA airline code. |
| Country | VARCHAR | | Country where airline is based. |

---

## 🛬 Airports Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| AirportID | INT | PK | Unique airport identifier. |
| Name | VARCHAR(150) | | Airport name. |
| City | VARCHAR(100) | | City of the airport. |
| Country | VARCHAR | | Country of the airport. |
| IATA_Code | CHAR(3) | | 3-letter IATA code. |
| ICAO_Code | CHAR(4) | | 4-letter ICAO code. |
| Latitude | DOUBLE | | GPS Latitude. |
| Longitude | DOUBLE | | GPS Longitude. |

---

## 📘 Bookings Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| BookingID | INT | PK | Unique booking identifier. |
| BookingRef | VARCHAR(12) | | Booking reference number. |
| PassengerID | INT | FK | Passenger who made the booking. |
| BookingDate | DATETIME | | Date/time the booking was created. |
| TotalAmount | DECIMAL(10,2) | | Total booking amount. |
| BookingStatus | VARCHAR(20) | | Status (Confirmed, Canceled, etc.). |

---

## 🧑‍✈ Crew Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| CrewID | INT | PK | Crew member ID. |
| FirstName | VARCHAR(50) | | Crew first name. |
| LastName | VARCHAR(50) | | Crew last name. |
| Role | VARCHAR(30) | | Pilot, Co-Pilot, Cabin Crew, etc. |
| LicenseNo | VARCHAR(50) | | Aviation license number. |
| ContactPhone | VARCHAR | | Crew contact number. |

---

## 🛫 Crew Assignments Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| AssignmentID | INT | PK | Assignment identifier. |
| FlightID | INT | FK | Flight assigned. |
| CrewID | INT | FK | Crew member assigned. |
| AssignedRole | VARCHAR | | Role during the flight. |

---

## 💺 Fare Classes Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| FareClassID | INT | PK | Fare class ID. |
| Code | CHAR(2) | | Class code (EC, BS, FC). |
| Description | VARCHAR | | Fare class name. |
| Multiplier | DOUBLE | | Price multiplier for class. |

---

## ✈ Flights Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| FlightID | INT | PK | Unique flight identifier. |
| RouteID | INT | FK | Route of the flight. |
| AircraftID | INT | FK | Aircraft assigned. |
| FlightNumber | VARCHAR | | Public flight number. |
| DepartureUTC | DATETIME | | UTC departure time. |
| ArrivalUTC | DATETIME | | UTC arrival time. |
| Status | VARCHAR(20) | | Scheduled, Active, Completed, Canceled. |
| Gate | VARCHAR(10) | | Departure gate. |
| BlockTimeMins | INT | | Total block time in minutes. |

---

## 🧍 Passengers Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| PassengerID | INT | PK | Passenger identifier. |
| FirstName | VARCHAR(50) | | Passenger first name. |
| LastName | VARCHAR(50) | | Passenger last name. |
| DateOfBirth | DATE | | Date of birth. |
| Gender | CHAR(1) | | Gender (M/F/O). |
| Email | VARCHAR(100) | | Email address. |
| Phone | VARCHAR(20) | | Phone number. |
| PassportNo | VARCHAR | | Passport number. |
| Nationality | VARCHAR(50) | | Nationality. |

---

## 💰 Payments Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| PaymentID | INT | PK | Unique payment identifier. |
| BookingID | INT | FK | Related booking. |
| PaidAmount | DECIMAL(10,2) | | Amount paid. |
| PaidOn | DATETIME | | Payment date/time. |
| PaymentMethod | VARCHAR | | UPI, Card, Cash, NetBanking. |
| TransactionRef | VARCHAR(50) | | Payment gateway reference. |

---

## 🗺 Routes Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| RouteID | INT | PK | Unique route identifier. |
| AirlineID | INT | FK | Operating airline. |
| OriginAirportID | INT | FK | Starting airport. |
| DestinationAirportID | INT | FK | Ending airport. |
| DistanceKM | INT | | Distance in kilometers. |
| RouteCode | VARCHAR(10) | | Code identifying the route. |

---

## 💺 Seats Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| SeatID | INT | PK | Seat identifier. |
| FlightID | INT | FK | Flight assigned. |
| SeatNumber | VARCHAR | | Seat number (e.g., 12A). |
| FareClassID | INT | FK | Fare class type. |
| IsAvailable | TINYINT | | 1 = available, 0 = booked. |

---

## 🎟 Tickets Table
| Column Name | Data Type | Key Type | Description |
|------------|-----------|----------|-------------|
| TicketID | INT | PK | Ticket identifier. |
| BookingID | INT | FK | Related booking. |
| FlightID | INT | FK | Flight booked. |
| SeatID | INT | FK | Assigned seat. |
| TicketNo | VARCHAR(20) | | Ticket number. |
| FareAmount | DECIMAL(10,2) | | Fare charged. |
| TicketStatus | VARCHAR(20) | | Active, Cancelled, Checked-in. |

---

# 💾 Sample Data (DML)
The SQL file includes sample INSERT statements for:
- Airlines  
- Airports  
- Flights  
- Aircrafts  
- Passengers  
- Tickets  
- Seats  
- Crew & Crew Assignments  
- Payments  
- Bookings  
- Routes  

These records help in testing joins, foreign keys, and complete system workflows.

---



