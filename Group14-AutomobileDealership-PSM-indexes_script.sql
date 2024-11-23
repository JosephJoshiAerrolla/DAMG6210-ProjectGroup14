-- Use the AutomobileDealership database
USE AutomobileDealership;
GO

-- ===============================
-- 1. Index on `AvailabilityStatus` in `StorageLot`
-- ===============================
-- Drop index if it exists
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_StorageLot_AvailabilityStatus')
    DROP INDEX IX_StorageLot_AvailabilityStatus ON StorageLot;
GO

-- Create index
CREATE NONCLUSTERED INDEX IX_StorageLot_AvailabilityStatus
ON StorageLot(AvailabilityStatus);
GO

-- ===============================
-- 2. Index on `DealerLicenseNumber` in `Dealer`
-- ===============================
-- Drop index if it exists
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Dealer_DealerLicenseNumber')
    DROP INDEX IX_Dealer_DealerLicenseNumber ON Dealer;
GO

-- Create index
CREATE NONCLUSTERED INDEX IX_Dealer_DealerLicenseNumber
ON Dealer(DealerLicenseNumber);
GO

-- ===============================
-- 3. Index on `VIN` in `Car`
-- ===============================
-- Drop index if it exists
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Car_VIN')
    DROP INDEX IX_Car_VIN ON Car;
GO

-- Create index
CREATE NONCLUSTERED INDEX IX_Car_VIN
ON Car(VIN);
GO

-- ===============================
-- 4. Index on `Mileage` in `VehicleHistory`
-- ===============================
-- Drop index if it exists
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_VehicleHistory_Mileage')
    DROP INDEX IX_VehicleHistory_Mileage ON VehicleHistory;
GO

-- Create index
CREATE NONCLUSTERED INDEX IX_VehicleHistory_Mileage
ON VehicleHistory(Mileage);
GO

-- ===============================
-- 5. Index on `Rating` in `Feedback`
-- ===============================
-- Drop index if it exists
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Feedback_Rating')
    DROP INDEX IX_Feedback_Rating ON Feedback;
GO

-- Create index
CREATE NONCLUSTERED INDEX IX_Feedback_Rating
ON Feedback(Rating);
GO

-- ===============================
-- 6. Index on `ServiceCost` in `CarServicing`
-- ===============================
-- Drop index if it exists
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CarServicing_ServiceCost')
    DROP INDEX IX_CarServicing_ServiceCost ON CarServicing;
GO

-- Create index
CREATE NONCLUSTERED INDEX IX_CarServicing_ServiceCost
ON CarServicing(ServiceCost);
GO



-- Test Index on `AvailabilityStatus`
SELECT * FROM StorageLot WHERE AvailabilityStatus = 'Available';

-- Test Index on `DealerLicenseNumber`
SELECT * FROM Dealer WHERE DealerLicenseNumber = 'K68M5UEVM1';

-- Test Index on `VIN`
SELECT * FROM Car WHERE VIN = '0NF8NE32HUAQ2TW2F';


-- Test Index on `Mileage`
SELECT * FROM VehicleHistory WHERE Mileage > 50000;

-- Test Index on `Rating`
SELECT AVG(Rating) AS AverageRating FROM Feedback WHERE Rating >= 4;

-- Test Index on `ServiceCost`
SELECT * FROM CarServicing WHERE ServiceCost > 300.00;
