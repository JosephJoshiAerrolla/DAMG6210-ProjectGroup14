-- Use the AutomobileDealership database
USE AutomobileDealership;
GO

SET IDENTITY_INSERT [User] ON;

INSERT INTO [User] (UserID, FirstName, LastName, Email, PhoneNumber, Street, City, [State])
VALUES
(100000, 'John', 'Doe', 'johndoe@example.com', '1234567890', '123 Main St', 'Springfield', 'IL'),
(100001, 'Jane', 'Smith', 'janesmith@example.com', '1234567891', '456 Oak St', 'Greenfield', 'CA'),
(100002, 'Alice', 'Johnson', 'alicejohnson@example.com', '1234567892', '789 Pine St', 'Fairview', 'NY'),
(100003, 'Bob', 'Brown', 'bobbrown@example.com', '1234567893', '101 Maple St', 'Lakeside', 'TX'),
(100004, 'Charlie', 'Davis', 'charliedavis@example.com', '1234567894', '202 Birch St', 'Hilltop', 'FL'),
(100005, 'Eve', 'Miller', 'evemiller@example.com', '1234567895', '303 Cedar St', 'Riverton', 'WA'),
(100006, 'Frank', 'Wilson', 'frankwilson@example.com', '1234567896', '404 Elm St', 'Brookville', 'OH'),
(100007, 'Grace', 'Lee', 'gracelee@example.com', '1234567897', '505 Willow St', 'Clearwater', 'AZ'),
(100008, 'Hank', 'Clark', 'hankclark@example.com', '1234567898', '606 Chestnut St', 'Summerville', 'MA'),
(100009, 'Ivy', 'Walker', 'ivywalker@example.com', '1234567899', '707 Walnut St', 'Sunnydale', 'NV'),
(100010, 'Jack', 'Martinez', 'jackmartinez@example.com', '1234567800', '808 Spruce St', 'Grove City', 'PA'),
(100011, 'Kate', 'Robinson', 'katerobinson@example.com', '1234567801', '909 Ash St', 'Parkville', 'OR'),
(100012, 'Liam', 'Taylor', 'liamtaylor@example.com', '1234567802', '123 Cedar St', 'Fairmont', 'TX'),
(100013, 'Mia', 'Garcia', 'miagarcia@example.com', '1234567803', '456 Willow St', 'Forest', 'CO'),
(100014, 'Noah', 'White', 'noahwhite@example.com', '1234567804', '789 Oak St', 'Highland', 'ME'),
(100015, 'Olivia', 'Martin', 'oliviamartin@example.com', '1234567805', '101 Elm St', 'Lakewood', 'NJ'),
(100016, 'Lucas', 'Lopez', 'lucaslopez@example.com', '1234567806', '202 Pine St', 'Woodland', 'MD'),
(100017, 'Sophia', 'Anderson', 'sophiaanderson@example.com', '1234567807', '303 Maple St', 'Edgewood', 'NH'),
(100018, 'Mason', 'Thomas', 'masonthomas@example.com', '1234567808', '404 Birch St', 'Brighton', 'UT'),
(100019, 'Amelia', 'Harris', 'ameliaharris@example.com', '1234567809', '505 Walnut St', 'Evergreen', 'MT'),
(100020, 'Benjamin', 'Clark', 'benjaminclark@example.com', '1234567810', '101 Maple St', 'Highland', 'CA'),
(100021, 'Charlotte', 'Jones', 'charlottejones@example.com', '1234567811', '102 Pine St', 'Oak Ridge', 'SC'),
(100022, 'Ethan', 'Brown', 'ethanbrown@example.com', '1234567812', '123 Oak St', 'Redwood', 'NV'),
(100023, 'Ava', 'Davis', 'avadavis@example.com', '1234567813', '456 Cedar St', 'Ridgefield', 'NM');
SET IDENTITY_INSERT [User] OFF;
GO

INSERT INTO StorageLot (Quantity, [Location], AvailabilityStatus)
VALUES
(50, 'Lot A', 'Available'),
(20, 'Lot B', 'Reserved'),
(0, 'Lot C', 'Out of Stock'),
(100, 'Lot D', 'Available'),
(30, 'Lot E', 'Reserved'),
(70, 'Lot F', 'Available'),
(0, 'Lot G', 'Out of Stock'),
(45, 'Lot H', 'Reserved'),
(60, 'Lot I', 'Available'),
(15, 'Lot J', 'Out of Stock'),
(25, 'Lot K', 'Available'),
(80, 'Lot L', 'Reserved');


INSERT INTO Financer (FinanceName, AuthorizationNumber)
VALUES
('Bank of America', 'AUTH12345'),
('Chase', 'AUTH67890'),
('Wells Fargo', 'AUTH11121'),
('Citi Bank', 'AUTH31415'),
('Capital One', 'AUTH16171'),
('PNC Bank', 'AUTH18192'),
('US Bank', 'AUTH20212'),
('TD Bank', 'AUTH22232'),
('HSBC', 'AUTH24242'),
('Bank of NY', 'AUTH26272'),
('Ally Financial', 'AUTH27282'),
('BB&T Bank', 'AUTH28383');


INSERT INTO Dealer (DealerName, DealerLocation, Phone, DealerLicenseNumber)
VALUES
('AutoMax', '123 Car St, Springfield', '1112223333', 'DL12345'),
('CarHub', '456 Motor Ave, Riverton', '2223334444', 'DL67890'),
('DriveTime', '789 Auto Blvd, Greenfield', '3334445555', 'DL11121'),
('AutoNation', '101 Speed Rd, Fairview', '4445556666', 'DL31415'),
('CarMax', '202 Drive Ave, Lakeside', '5556667777', 'DL16171'),
('Big Motors', '303 Ride St, Hilltop', '6667778888', 'DL18192'),
('City Cars', '404 Route St, Clearwater', '7778889999', 'DL20212'),
('All Auto', '505 Speed St, Brookville', '8889990000', 'DL22232'),
('Fast Lane', '606 Way Dr, Sunnydale', '9990001111', 'DL24242'),
('Quick Cars', '707 Run Rd, Summerville', '0001112222', 'DL26272'),
('Star Motors', '808 Drive St, Hill City', '1112223344', 'DL27282'),
('Speedy Auto', '909 Race St, Mountville', '2223334455', 'DL28383');



INSERT INTO Parts (PartName, PartCost, [Status], StorageLotID)
VALUES
('Brake Pad', 25.50, 'Available', 100),
('Oil Filter', 10.00, 'Ordered', 101),
('Air Filter', 15.25, 'Available', 102),
('Spark Plug', 5.75, 'Out of Stock', 103),
('Battery', 75.00, 'Available', 104),
('Alternator', 150.00, 'Ordered', 105),
('Radiator', 200.50, 'Out of Stock', 106),
('Shock Absorber', 45.25, 'Available', 107),
('Fuel Pump', 65.00, 'Ordered', 108),
('Timing Belt', 40.75, 'Available', 109),
('Transmission Filter', 55.00, 'Ordered', 110),
('Wiper Blades', 12.50, 'Available', 111);


SET IDENTITY_INSERT Car ON;

INSERT INTO Car (CarID, VIN, Make, Model, [Year], Price, StorageLotID)
VALUES
(10000, 'VIN1000001', 'Honda', 'Civic', 2023, 20000.00, 100),
(10001, 'VIN1000002', 'Toyota', 'Corolla', 2022, 18000.00, 101),
(10002, 'VIN1000003', 'Nissan', 'Altima', 2021, 22000.00, 102),
(10003, 'VIN1000004', 'Ford', 'Focus', 2020, 17000.00, 103),
(10004, 'VIN1000005', 'Chevrolet', 'Cruze', 2023, 21000.00, 104),
(10005, 'VIN1000006', 'Volkswagen', 'Jetta', 2022, 21000.00, 105),
(10006, 'VIN1000007', 'Acura', 'TLX', 2021, 25000.00, 106),
(10007, 'VIN1000008', 'Volkswagen', 'Golf', 2023, 20000.00, 107),
(10008, 'VIN1000009', 'Honda', 'Accord', 2020, 24000.00, 108),
(10009, 'VIN1000010', 'Ford', 'Edge', 2021, 27000.00, 109),
(10010, 'VIN1000011', 'Mazda', 'CX-5', 2022, 23000.00, 110),
(10011, 'VIN1000012', 'Hyundai', 'Elantra', 2023, 19000.00, 111),
(10012, 'VIN2000001', 'Audi', 'A4', 2018, 15000.00, 100),
(10013, 'VIN2000002', 'BMW', '3 Series', 2019, 18000.00, 101),
(10014, 'VIN2000003', 'Mercedes', 'C Class', 2017, 16000.00, 102),
(10015, 'VIN2000004', 'Lexus', 'IS', 2016, 14000.00, 103),
(10016, 'VIN2000005', 'Toyota', 'Camry', 2018, 17000.00, 104),
(10017, 'VIN2000006', 'Ford', 'Mustang', 2017, 21000.00, 105),
(10018, 'VIN2000007', 'Chevrolet', 'Malibu', 2016, 13000.00, 106),
(10019, 'VIN2000008', 'Honda', 'Pilot', 2019, 20000.00, 107),
(10020, 'VIN2000009', 'Jeep', 'Wrangler', 2018, 22000.00, 108),
(10021, 'VIN2000010', 'Subaru', 'Forester', 2017, 16000.00, 109),
(10022, 'VIN2000011', 'Kia', 'Sorento', 2019, 18000.00, 110),
(10023, 'VIN2000012', 'Mazda', '3', 2018, 15000.00, 111);

SET IDENTITY_INSERT Car OFF;
GO

INSERT INTO New_Car (CarID, WarrantyPeriod)
VALUES
(10000, '5 years'),
(10001, '6 years'),
(10002, '7 years'),
(10003, '8 years'),
(10004, '9 years'),
(10005, '10 years'),
(10006, '3 years'),
(10007, '4 years'),
(10008, '2 years'),
(10009, '1 year'),
(10010, '5 years'),
(10011, '4 years');


INSERT INTO Used_Car (CarID, Used_Duration)
VALUES
(10012, '3 years'),
(10013, '4 years'),
(10014, '5 years'),
(10015, '6 years'),
(10016, '7 years'),
(10017, '8 years'),
(10018, '3 years'),
(10019, '4 years'),
(10020, '6 years'),
(10021, '7 years'),
(10022, '8 years'),
(10023, '9 years');


INSERT INTO VehicleHistory (PreviousOwners, DamageRecords, ServiceRecords, Mileage, CarID)
VALUES
(1, 'None', 'Oil change', 5000, 10012),
(2, 'Minor scratches', 'Tire replacement', 10000, 10013),
(1, 'None', 'Brake pad replacement', 15000, 10014),
(3, 'Rear bumper', 'Battery replacement', 20000, 10015),
(1, 'None', 'Transmission service', 25000, 10016),
(0, 'None', 'Full service', 30000, 10017),
(1, 'Front fender', 'Oil change', 3500, 10018),
(0, 'None', 'Brake service', 20000, 10019),
(2, 'Rear door', 'Full inspection', 5000, 10020),
(1, 'None', 'Battery replacement', 12000, 10021),
(2, 'Minor scratches', 'Alignment check', 25000, 10022),
(1, 'Windshield replaced', 'Oil change', 10000, 10023);


INSERT INTO SalesPerson (UserID, HireDate, Salary)
VALUES
(100000, '2020-01-15', 50000.00),
(100001, '2019-03-22', 52000.00),
(100002, '2021-07-18', 54000.00),
(100003, '2018-05-29', 56000.00),
(100004, '2017-10-13', 58000.00),
(100005, '2022-08-21', 60000.00),
(100006, '2016-12-10', 62000.00),
(100007, '2023-02-11', 64000.00),
(100008, '2015-04-15', 66000.00),
(100009, '2014-11-30', 68000.00),
(100010, '2023-05-20', 55000.00),
(100011, '2019-11-13', 62000.00);


INSERT INTO Customer (UserID)
VALUES
(100012),
(100013),
(100014),
(100015),
(100016),
(100017),
(100018),
(100019),
(100020),
(100021),
(100022),
(100023);

INSERT INTO Feedback (Rating, Comments, [Date], CustomerID)
VALUES
(5, 'Excellent service!', '2024-01-10', 100012),
(4, 'Very good experience.', '2024-02-15', 100013),
(3, 'Average, room for improvement.', '2024-03-20', 100014),
(5, 'Highly recommend!', '2024-04-25', 100015),
(2, 'Not satisfied with the delay.', '2024-05-05', 100016),
(4, 'Good service but a bit slow.', '2024-06-10', 100017),
(5, 'Perfect experience!', '2024-07-15', 100018),
(3, 'Okay service.', '2024-08-20', 100019),
(4, 'Pretty good overall.', '2024-09-10', 100020),
(5, 'Amazing!', '2024-10-12', 100021),
(3, 'Average service.', '2024-10-15', 100022),
(4, 'Quick and efficient.', '2024-11-01', 100023);


INSERT INTO SalesOrder ([Date], TotalPrice, OrderQuantity, CarID, CustomerID, SalesPersonID)
VALUES
('2024-01-10', 20000.00, 1, 10000, 100012, 100000),
('2024-02-15', 18000.00, 1, 10001, 100013, 100001),
('2024-03-20', 22000.00, 1, 10002, 100014, 100002),
('2024-04-25', 17000.00, 1, 10003, 100015, 100003),
('2024-05-05', 16000.00, 1, 10004, 100016, 100004),
('2024-06-10', 21000.00, 1, 10005, 100017, 100005),
('2024-07-15', 25000.00, 1, 10006, 100018, 100006),
('2024-08-20', 24000.00, 1, 10007, 100019, 100007),
('2024-09-10', 27000.00, 1, 10008, 100020, 100008),
('2024-10-12', 30000.00, 1, 10009, 100021, 100009),
('2024-11-05', 29000.00, 1, 10010, 100022, 100010),
('2024-12-15', 31000.00, 1, 10011, 100023, 100011);


INSERT INTO Payments (Amount, PaymentDate, PaymentMethod, OrderID)
VALUES
(20000.00, '2024-01-15', 'Credit', 1),
(18000.00, '2024-02-20', 'Debit', 2),
(22000.00, '2024-03-25', 'Cash', 3),
(17000.00, '2024-04-30', 'Online', 4),
(16000.00, '2024-05-15', 'Credit', 5),
(21000.00, '2024-06-20', 'Debit', 6),
(25000.00, '2024-07-25', 'Cash', 7),
(24000.00, '2024-08-30', 'Online', 8),
(27000.00, '2024-09-15', 'Credit', 9),
(30000.00, '2024-10-20', 'Debit', 10),
(29000.00, '2024-11-25', 'Cash', 11),
(31000.00, '2024-12-30', 'Online', 12);


INSERT INTO Financing (OrderID, FinancerID, NumberOfInstallments, InterestRate, InstallmentAmount)
VALUES
(1, 100, 12, 5.5, 1666.67),
(2, 101, 24, 6.0, 750.00),
(3, 102, 36, 4.8, 611.11),
(4, 103, 18, 5.2, 944.44),
(5, 104, 12, 5.9, 1333.33),
(6, 105, 24, 6.3, 875.00),
(7, 106, 36, 4.9, 694.44),
(8, 107, 18, 5.4, 1333.33),
(9, 108, 12, 6.1, 2250.00),
(10, 109, 24, 5.7, 1250.00),
(11, 100, 12, 5.8, 2416.67),
(12, 101, 24, 5.4, 1270.83);

INSERT INTO DealerSupplies (StorageLotID, DealerID, Quantity, SupplyDate)
VALUES
(20000, 4000, 100, '2024-01-01'),
(20001, 4001, 150, '2024-02-01'),
(20002, 4002, 120, '2024-03-01'),
(20003, 4003, 200, '2024-04-01'),
(20004, 4004, 250, '2024-05-01'),
(20005, 4005, 300, '2024-06-01'),
(20006, 4006, 180, '2024-07-01'),
(20007, 4007, 210, '2024-08-01'),
(20008, 4008, 160, '2024-09-01'),
(20009, 4009, 130, '2024-10-01'),
(20010, 4000, 100, '2024-11-01'),
(20011, 4001, 150, '2024-12-01');


INSERT INTO Appointments ([Date], CustomerID)
VALUES
('2024-01-10', 100012),
('2024-02-15', 100013),
('2024-03-20', 100014),
('2024-04-25', 100015),
('2024-05-05', 100016),
('2024-06-10', 100017),
('2024-07-15', 100018),
('2024-08-20', 100019),
('2024-09-10', 100020),
('2024-10-12', 100021),
('2024-11-15', 100022),
('2024-12-10', 100023);


INSERT INTO Test_Drive (TestDriveDate, AppointmentID, CarID)
VALUES
('2024-01-12', 1, 10000),
('2024-02-18', 2, 10001),
('2024-03-22', 3, 10002),
('2024-04-27', 4, 10003),
('2024-05-07', 5, 10004),
('2024-06-12', 6, 10005),
('2024-07-17', 7, 10006),
('2024-08-22', 8, 10007),
('2024-09-12', 9, 10008),
('2024-10-15', 10, 10009),
('2024-11-19', 11, 10010),
('2024-12-22', 12, 10011);


INSERT INTO CarServicing (ServiceDate, ServiceDescription, ServiceCost, CarID, AppointmentID, PartID)
VALUES
('2024-01-13', 'Oil Change', 50.00, 10000, 1, 20000),
('2024-02-19', 'Brake Replacement', 150.00, 10001, 2, 20001),
('2024-03-23', 'Battery Replacement', 120.00, 10002, 3, 20002),
('2024-04-28', 'Tire Rotation', 40.00, 10003, 4, 20003),
('2024-05-08', 'Transmission Check', 200.00, 10004, 5, 20004),
('2024-06-13', 'Alignment', 80.00, 10005, 6, 20005),
('2024-07-18', 'Fuel System Cleaning', 100.00, 10006, 7, 20006),
('2024-08-23', 'Spark Plug Replacement', 60.00, 10007, 8, 20007),
('2024-09-13', 'Coolant Flush', 90.00, 10008, 9, 20008),
('2024-10-16', 'Engine Tune-Up', 250.00, 10009, 10, 20009),
('2024-11-21', 'Brake Fluid Replacement', 110.00, 10010, 11, 20010),
('2024-12-25', 'Radiator Replacement', 300.00, 10011, 12, 20011);