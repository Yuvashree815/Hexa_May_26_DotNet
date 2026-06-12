CREATE DATABASE FleetMaintenanceDb;

USE FleetMaintenanceDb

CREATE TABLE Vehicles
(VehicleId INT IDENTITY(1,1) PRIMARY KEY,
VehicleNumber VARCHAR(20) NOT NULL,
VehicleType VARCHAR(50) NOT NULL,
Brand VARCHAR(50) NOT NULL,
Model VARCHAR(50) NOT NULL,
PurchaseYear INT NOT NULL,
IsActive BIT NOT NULL
);

CREATE TABLE Drivers
(DriverId INT IDENTITY(1,1) PRIMARY KEY,
DriverName VARCHAR(100) NOT NULL,
LicenseNumber VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL,City VARCHAR(50) NOT NULL,
IsAvailable BIT NOT NULL
);

CREATE TABLE MaintenanceRecords
(
MaintenanceId INT IDENTITY(1,1) PRIMARY KEY,
VehicleId INT NOT NULL,
DriverId INT NOT NULL,
ServiceDate DATE NOT NULL,
ServiceType VARCHAR(100) NOT NULL,
ServiceCost DECIMAL(18,2) NOT NULL,
ServiceStatus VARCHAR(30) NOT NULL,
Remarks VARCHAR(250) NULL,
CreatedDate DATETIME NOT NULL,
CONSTRAINT FK_MaintenanceRecords_Vehicles
FOREIGN KEY (VehicleId) REFERENCES Vehicles(VehicleId),
CONSTRAINT FK_MaintenanceRecords_Drivers
FOREIGN KEY (DriverId) REFERENCES Drivers(DriverId)
);

INSERT INTO Vehicles
(VehicleNumber, VehicleType, Brand, Model, PurchaseYear, IsActive)
VALUES
('TN01AB1001', 'Truck', 'Tata', 'Prima', 2020, 1),
('TN01AB1002', 'Truck', 'Ashok Leyland', 'Boss', 2019, 1),
('TN01AB1003', 'Van', 'Mahindra', 'Supro', 2021, 1),
('TN01AB1004', 'Bus', 'Volvo', '9400', 2018, 1),
('TN01AB1005', 'Truck', 'Eicher', 'Pro 3015', 2022, 1),
('TN01AB1006', 'Van', 'Maruti', 'Eeco', 2020, 1),
('TN01AB1007', 'Bus', 'Tata', 'Starbus', 2019, 1),
('TN01AB1008', 'Truck', 'BharatBenz', '1217C', 2021, 1),
('TN01AB1009', 'SUV', 'Toyota', 'Fortuner', 2023, 1),
('TN01AB1010', 'Pickup', 'Mahindra', 'Bolero Pickup', 2022, 1);

INSERT INTO Drivers
(DriverName, LicenseNumber, PhoneNumber, City, IsAvailable)
VALUES
('Ramesh Kumar', 'TN012345678901', '9876543210', 'Chennai', 1),
('Suresh Babu', 'TN012345678902', '9876543211', 'Coimbatore', 1),
('Karthik Raj', 'TN012345678903', '9876543212', 'Madurai', 1),
('Arun Prakash', 'TN012345678904', '9876543213', 'Trichy', 0),
('Vijay Kumar', 'TN012345678905', '9876543214', 'Salem', 1),
('Dinesh Kumar', 'TN012345678906', '9876543215', 'Erode', 1),
('Praveen Raj', 'TN012345678907', '9876543216', 'Vellore', 0),
('Manikandan', 'TN012345678908', '9876543217', 'Tirunelveli', 1),
('Senthil Kumar', 'TN012345678909', '9876543218', 'Thanjavur', 1),
('Rajesh Kumar', 'TN012345678910', '9876543219', 'Chengalpattu', 1);

INSERT INTO MaintenanceRecords
(VehicleId, DriverId, ServiceDate, ServiceType, ServiceCost,
 ServiceStatus, Remarks, CreatedDate)
VALUES

(1,1,'2026-01-05','Oil Change',2500,'Completed',
 'Routine oil replacement',GETDATE()),

(2,2,'2026-01-08','Brake Inspection',3500,'Completed',
 'Brake pads checked',GETDATE()),

(3,3,'2026-01-10','Battery Check',1200,'Completed',
 'Battery condition good',GETDATE()),

(4,4,'2026-01-15','General Service',8500,'Completed',
 'Full vehicle inspection',GETDATE()),

(5,5,'2026-01-18','Tyre Replacement',18000,'Completed',
 'Rear tyres replaced',GETDATE()),

(6,6,'2026-01-20','Oil Change',2200,'Completed',
 'Engine oil replaced',GETDATE()),

(7,7,'2026-01-22','Brake Inspection',3000,'InProgress',
 'Brake system under inspection',GETDATE()),

(8,8,'2026-01-25','Engine Repair',25000,'InProgress',
 'Minor engine repair',GETDATE()),

(9,9,'2026-01-28','Battery Check',1500,'Completed',
 'Battery replaced',GETDATE()),

(10,10,'2026-02-01','General Service',7000,'Completed',
 'Periodic maintenance',GETDATE()),

(1,2,'2026-02-05','Tyre Replacement',16000,'Completed',
 'Front tyres replaced',GETDATE()),

(2,3,'2026-02-08','Oil Change',2600,'Completed',
 'Regular service',GETDATE()),

(3,4,'2026-02-10','Brake Inspection',3200,'Cancelled',
 'Vehicle unavailable',GETDATE()),

(4,5,'2026-02-12','Engine Repair',30000,'Completed',
 'Engine overhaul completed',GETDATE()),

(5,6,'2026-02-15','Battery Check',1400,'Completed',
 'Battery healthy',GETDATE()),

(6,7,'2026-02-18','General Service',7500,'Scheduled',
 'Scheduled monthly service',GETDATE()),

(7,8,'2026-02-20','Oil Change',2400,'Completed',
 'Oil filter changed',GETDATE()),

(8,9,'2026-02-22','Tyre Replacement',20000,'Completed',
 'All tyres replaced',GETDATE()),

(9,10,'2026-02-25','Brake Inspection',3400,'Completed',
 'Brake discs cleaned',GETDATE()),

(10,1,'2026-02-28','Engine Repair',28000,'InProgress',
 'Engine diagnostics ongoing',GETDATE()),

(1,3,'2026-03-02','Battery Check',1300,'Completed',
 'Battery terminals cleaned',GETDATE()),

(2,4,'2026-03-05','General Service',8200,'Completed',
 'Routine maintenance',GETDATE()),

(3,5,'2026-03-08','Oil Change',2300,'Completed',
 'Engine oil replaced',GETDATE()),

(4,6,'2026-03-10','Tyre Replacement',17500,'Scheduled',
 'Tyres ordered',GETDATE()),

(5,7,'2026-03-12','Brake Inspection',3100,'Completed',
 'Brake fluid replaced',GETDATE()),

(6,8,'2026-03-15','Engine Repair',22000,'Cancelled',
 'Repair postponed',GETDATE()),

(7,9,'2026-03-18','Battery Check',1600,'Completed',
 'Battery tested',GETDATE()),

(8,10,'2026-03-20','General Service',9000,'Completed',
 'Full service completed',GETDATE()),

(9,1,'2026-03-22','Oil Change',2500,'Scheduled',
 'Upcoming service',GETDATE()),

(10,2,'2026-03-25','Brake Inspection',3300,'InProgress',
 'Inspection in progress',GETDATE());


 --CHECK

 SELECT *
FROM MaintenanceRecords mr
INNER JOIN Vehicles v
ON mr.VehicleId = v.VehicleId
INNER JOIN Drivers d
ON mr.DriverId = d.DriverId;