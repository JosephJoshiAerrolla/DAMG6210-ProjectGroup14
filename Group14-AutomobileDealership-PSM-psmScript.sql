-- Use the AutomobileDealership database
USE AutomobileDealership;
GO

--STORED PROCEDURES

-- Monthly Sales Report Procedure
-- Drop procedure if it exists
IF OBJECT_ID('GetMonthlySalesReport', 'P') IS NOT NULL
    DROP PROCEDURE GetMonthlySalesReport;
GO

CREATE PROCEDURE GetMonthlySalesReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        SO.Date,
        C.Model AS CarModel,
        C.Price AS CarPrice,
        COUNT(SO.OrderID) AS TotalSales,
        SUM(SO.TotalPrice) AS TotalRevenue
    FROM 
        SalesOrder SO
    INNER JOIN 
        Car C ON SO.CarID = C.CarID
    WHERE 
        SO.Date BETWEEN @StartDate AND @EndDate
    GROUP BY 
        SO.Date, C.Model, C.Price
    ORDER BY 
        SO.Date ASC;
END;

EXEC GetMonthlySalesReport @StartDate = '2024-01-01', @EndDate = '2024-01-31';
GO




--Procedure to Get Top Customers
-- Drop procedure if it exists
IF OBJECT_ID('GetTopCustomers', 'P') IS NOT NULL
    DROP PROCEDURE GetTopCustomers;
GO

CREATE PROCEDURE GetTopCustomers
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        C.UserID,
        U.FirstName,
        U.LastName,
        COUNT(SO.OrderID) AS TotalPurchases,
        SUM(SO.TotalPrice) AS TotalRevenue
    FROM 
        SalesOrder SO
    INNER JOIN 
        Customer C ON SO.CustomerID = C.UserID
    INNER JOIN 
        [User] U ON C.UserID = U.UserID
    WHERE 
        SO.Date BETWEEN @StartDate AND @EndDate
    GROUP BY 
        C.UserID, U.FirstName, U.LastName
    ORDER BY 
        TotalRevenue DESC;
END;

EXEC GetTopCustomers @StartDate = '2024-01-01', @EndDate = '2024-01-31';
GO

-- Stored Procedure to List All Available Cars in a Specific Storage Lot
-- Drop procedure if it exists
IF OBJECT_ID('ListAvailableCars', 'P') IS NOT NULL
    DROP PROCEDURE ListAvailableCars;
GO


CREATE PROCEDURE ListAvailableCars
    @StorageLotID INT
AS
BEGIN
    SELECT CarID, Make, Model, [Year], Price
    FROM Car
    WHERE StorageLotID = @StorageLotID AND CarID NOT IN (
        SELECT CarID FROM SalesOrder WHERE CarID IS NOT NULL
    );
END;
GO

EXEC ListAvailableCars @StorageLotID = 102

-- Stored Procedure to Update Car Availability After Sale
-- Drop procedure if it exists
IF OBJECT_ID('UpdateCarAvailability', 'P') IS NOT NULL
    DROP PROCEDURE UpdateCarAvailability;
GO

CREATE PROCEDURE UpdateCarAvailability
    @CarID INT
AS
BEGIN
    UPDATE StorageLot
    SET Quantity = Quantity - 1
    WHERE StorageLotID = (SELECT StorageLotID FROM Car WHERE CarID = @CarID);
END;
GO

EXEC UpdateCarAvailability @CarID = 10001;


--Fetches a customer's purchase history, including car details and total spending.
-- Drop procedure if it exists
IF OBJECT_ID('GetCustomerPurchaseHistory', 'P') IS NOT NULL
    DROP PROCEDURE GetCustomerPurchaseHistory;
GO

CREATE PROCEDURE GetCustomerPurchaseHistory
    @CustomerID INT
AS
BEGIN
    SELECT 
        SO.OrderID, 
        SO.[Date] AS PurchaseDate, 
        C.Make AS CarMake, 
        C.Model AS CarModel, 
        SO.TotalPrice
    FROM SalesOrder SO
    JOIN Car C ON SO.CarID = C.CarID
    WHERE SO.CustomerID = @CustomerID;
END;
GO


EXEC GetCustomerPurchaseHistory @CustomerID = 100105;
GO



--Adds a new car into the inventory.
-- Drop procedure if it exists
IF OBJECT_ID('AddNewCar', 'P') IS NOT NULL
    DROP PROCEDURE AddNewCar;
GO

-- Create procedure
CREATE PROCEDURE AddNewCar
    @Make NVARCHAR(50),
    @Model NVARCHAR(50),
    @Year INT,
    @Price DECIMAL(10, 2),
    @StorageLotID INT
AS
BEGIN
    -- Declare a variable for VIN
    DECLARE @VIN NVARCHAR(17);

    -- Generate a 17-character VIN with random letters and digits
    SET @VIN = LEFT(REPLACE(NEWID(), '-', ''), 17);

    -- Insert the new car record
    INSERT INTO Car (VIN, Make, Model, Year, Price, StorageLotID)
    VALUES (@VIN, @Make, @Model, @Year, @Price, @StorageLotID);

    -- Return all the details of the inserted car
    SELECT 
        VIN AS VIN, 
        Make, 
        Model, 
        Year, 
        Price, 
        StorageLotID
    FROM Car
    WHERE VIN = @VIN;
END;
GO


EXEC SP_AddNewCar 
    @Make = 'Toyota', 
    @Model = 'Corolla', 
    @Year = 2022, 
    @Price = 25000.00, 
    @StorageLotID = 101;

GO


--Retrieves the top financers by the number of financed orders.
-- Drop procedure if it exists
IF OBJECT_ID('GetTopFinancers', 'P') IS NOT NULL
    DROP PROCEDURE GetTopFinancers;
GO

CREATE PROCEDURE GetTopFinancers
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        F.FinancerID,
        COUNT(F.OrderID) AS TotalFinancedOrders,
        SUM(SO.TotalPrice) AS TotalFinancedAmount
    FROM Financing F
    JOIN SalesOrder SO ON F.OrderID = SO.OrderID
    WHERE SO.[Date] BETWEEN @StartDate AND @EndDate
    GROUP BY F.FinancerID;
END;
GO


EXEC GetTopFinancers @StartDate = '2024-01-01', @EndDate = '2024-12-31';
GO

--Lists storage lots with available cars.
-- Drop procedure if it exists
IF OBJECT_ID('SP_GetAvailableStorageLots', 'P') IS NOT NULL
    DROP PROCEDURE SP_GetAvailableStorageLots;
GO

CREATE PROCEDURE SP_GetAvailableStorageLots
AS
BEGIN
    SELECT 
        SL.StorageLotID, 
        SL.[Location], 
        SL.Quantity, 
        SL.AvailabilityStatus
    FROM StorageLot SL
    WHERE SL.AvailabilityStatus = 'Available';
END;
GO

EXEC SP_GetAvailableStorageLots;
GO


--VIEWS

--Displays detailed information about sales orders, including customer andsales person details.
-- Drop if it exists
IF OBJECT_ID('SalesOrderDetails', 'V') IS NOT NULL
    DROP VIEW SalesOrderDetails;
GO

-- Create view
CREATE VIEW SalesOrderDetails AS
SELECT 
    SO.OrderID,
    SO.[Date] AS SaleDate,
    SO.TotalPrice AS SaleAmount,
    U.FirstName AS FirstName,
    U.LastName AS LastName
FROM SalesOrder SO
LEFT JOIN Customer CU ON SO.CustomerID = CU.UserID
LEFT JOIN [User] U ON CU.UserID = U.UserID
LEFT JOIN SalesPerson SP ON SO.SalesPersonID = SP.UserID;
GO

SELECT * FROM SalesOrderDetails WHERE SaleAmount > 10000;
GO



--Lists all cars in the inventory with the status Available
-- Drop if it exists
IF OBJECT_ID('AvailableCars', 'V') IS NOT NULL
    DROP VIEW AvailableCars;
GO

-- Create view
CREATE VIEW AvailableCars AS
SELECT 
    C.CarID, 
    C.Make, 
    C.Model, 
    C.Price, 
    SL.AvailabilityStatus,
    SL.[Location]
FROM Car C
JOIN StorageLot SL ON C.StorageLotID = SL.StorageLotID
WHERE SL.AvailabilityStatus = 'Available';
GO

-- Sample Query to Use
SELECT * FROM AvailableCars ORDER BY Price DESC;
GO


--Displays the top financers based on the total financing amount.
-- Drop if it exists
IF OBJECT_ID('TopFinancers', 'V') IS NOT NULL
    DROP VIEW TopFinancers;
GO


-- Create view
CREATE VIEW TopFinancers AS
SELECT 
    F.FinancerID,
    FN.FinanceName,
    SUM(SO.TotalPrice) AS TotalFinancedAmount,
    COUNT(F.OrderID) AS TotalOrdersFinanced
FROM Financing F
JOIN SalesOrder SO ON F.OrderID = SO.OrderID
JOIN Financer FN ON F.FinancerID = FN.FinancerID
GROUP BY F.FinancerID, FN.FinanceName;
GO

-- Sample Query to Use
SELECT * 
FROM TopFinancers
WHERE TotalFinancedAmount > 50000
ORDER BY TotalFinancedAmount DESC;
GO



--Used car details 
-- Drop if it exists
IF OBJECT_ID('UsedCarDetails', 'V') IS NOT NULL
    DROP VIEW UsedCarDetails;
GO

-- Create view
CREATE VIEW UsedCarDetails AS
SELECT 
    C.CarID, 
    C.Make, 
    C.Model, 
    UC.Used_Duration,
    VH.Mileage,
    VH.PreviousOwners
FROM Car C
JOIN Used_Car UC ON C.CarID = UC.CarID
LEFT JOIN VehicleHistory VH ON UC.CarID = VH.CarID;
GO

-- Sample Query to Use
SELECT * FROM UsedCarDetails WHERE Mileage > 50000;
GO

--salesperfinancer
-- Drop if it exists
IF OBJECT_ID('SalesPerFinancer', 'V') IS NOT NULL
    DROP VIEW SalesPerFinancer;
GO

-- Create view
CREATE VIEW SalesPerFinancer AS
SELECT 
    F.FinancerID,
    FN.FinanceName,
    COUNT(SO.OrderID) AS TotalFinancedOrders,
    SUM(SO.TotalPrice) AS TotalFinancedAmount
FROM Financing F
JOIN SalesOrder SO ON F.OrderID = SO.OrderID
JOIN Financer FN ON F.FinancerID = FN.FinancerID
GROUP BY F.FinancerID, FN.FinanceName;
GO

-- Sample Query to Use
SELECT * 
FROM SalesPerFinancer
WHERE TotalFinancedOrders > 5;
GO


--Summarizes test drives taken by customers.
-- Drop if it exists
IF OBJECT_ID('TestDriveSummary', 'V') IS NOT NULL
    DROP VIEW TestDriveSummary;
GO

-- Create view
CREATE VIEW TestDriveSummary AS
SELECT 
    TD.TestDriveID,
    TD.TestDriveDate,
    C.Make AS CarMake,
    C.Model AS CarModel,
    U.FirstName AS CustomerFirstName,
    U.LastName AS CustomerLastName
FROM Test_Drive TD
JOIN Car C ON TD.CarID = C.CarID
JOIN Appointments A ON TD.AppointmentID = A.AppointmentID
JOIN [User] U ON A.CustomerID = U.UserID;
GO

-- Sample Query to Use
SELECT * FROM TestDriveSummary WHERE TestDriveDate > '2024-03-01';
GO



--Displays details of supplies provided by dealers to storage lots.
-- Drop if it exists
IF OBJECT_ID('DealerSuppliesSummary', 'V') IS NOT NULL
    DROP VIEW DealerSuppliesSummary;
GO

-- Create view
CREATE VIEW DealerSuppliesSummary AS
SELECT 
    DS.StorageLotID,
    SL.[Location],
    DS.DealerID,
    D.DealerName,
    DS.Quantity,
    DS.SupplyDate
FROM DealerSupplies DS
JOIN StorageLot SL ON DS.StorageLotID = SL.StorageLotID
JOIN Dealer D ON DS.DealerID = D.DealerID;
GO

-- Sample Query to Use
SELECT * FROM DealerSuppliesSummary WHERE Quantity > 3;
GO


--Displays history details for used vehicles.
-- Drop if it exists
IF OBJECT_ID('VehicleHistoryDetails', 'V') IS NOT NULL
    DROP VIEW VehicleHistoryDetails;
GO

-- Create view
CREATE VIEW VehicleHistoryDetails AS
SELECT 
    VH.HistoryID,
    C.CarID,
    C.Make,
    C.Model,
    VH.Mileage,
    VH.PreviousOwners,
    VH.DamageRecords
FROM VehicleHistory VH
JOIN Used_Car UC ON VH.CarID = UC.CarID
JOIN Car C ON UC.CarID = C.CarID;
GO

-- Sample Query to Use
SELECT * FROM VehicleHistoryDetails WHERE PreviousOwners > 3;
GO


--Summarizes the total purchases and spending of each customer.
-- Drop if it exists
IF OBJECT_ID('CustomerSalesSummary', 'V') IS NOT NULL
    DROP VIEW CustomerSalesSummary;
GO

-- Create view
CREATE VIEW CustomerSalesSummary AS
SELECT 
    CU.UserID AS CustomerID,
    U.FirstName,
    U.LastName,
    COUNT(SO.OrderID) AS TotalOrders,
    SUM(SO.TotalPrice) AS TotalSpent
FROM Customer CU
JOIN [User] U ON CU.UserID = U.UserID
JOIN SalesOrder SO ON CU.UserID = SO.CustomerID
GROUP BY CU.UserID, U.FirstName, U.LastName;
GO

-- Sample Query to Use
SELECT * FROM CustomerSalesSummary WHERE TotalSpent > 20000;
GO

--User-Defined Functions (UDFs)


--UDF_CalculateCarAge
-- Drop function if it exists
IF OBJECT_ID('CalculateCarAge', 'FN') IS NOT NULL
    DROP FUNCTION CalculateCarAge;
GO

-- Create function
CREATE FUNCTION CalculateCarAge (@CarID INT)
RETURNS INT
AS
BEGIN
    DECLARE @CarAge INT;
    SELECT @CarAge = YEAR(GETDATE()) - [Year]
    FROM Car
    WHERE CarID = @CarID;
    RETURN @CarAge;
END;
GO

-- Sample Query to Use
SELECT dbo.CalculateCarAge(10132) AS CarAge;
GO


--Calculates the total spending of a customer across all purchases.

-- Drop function if it exists
IF OBJECT_ID('CustomerLifetimeValue', 'FN') IS NOT NULL
    DROP FUNCTION CustomerLifetimeValue;
GO

-- Drop function if it exists
IF OBJECT_ID('CustomerLifetimeValue', 'FN') IS NOT NULL
    DROP FUNCTION CustomerLifetimeValue;
GO

-- Create function to calculate customer lifetime value
CREATE FUNCTION CustomerLifetimeValue (@CustomerID INT)
RETURNS DECIMAL(15, 2)
AS
BEGIN
    DECLARE @TotalSpent DECIMAL(15, 2);
    SELECT @TotalSpent = SUM(TotalPrice)
    FROM SalesOrder
    WHERE CustomerID = @CustomerID;
    RETURN ISNULL(@TotalSpent, 0);
END;
GO


-- Sample Query to Use
SELECT dbo.CustomerLifetimeValue(100192) AS LifetimeValue;



--Calculates the average price of cars in a specific storage lot.
-- Drop function if it exists
IF OBJECT_ID('AverageCarPriceInLot', 'FN') IS NOT NULL
    DROP FUNCTION AverageCarPriceInLot;
GO

-- Create function
CREATE FUNCTION AverageCarPriceInLot (@StorageLotID INT)
RETURNS DECIMAL(15, 2)
AS
BEGIN
    DECLARE @AveragePrice DECIMAL(15, 2);
    SELECT @AveragePrice = AVG(Price)
    FROM Car
    WHERE StorageLotID = @StorageLotID;
    RETURN ISNULL(@AveragePrice, 0);
END;
GO

-- Sample Query to Use
SELECT dbo.AverageCarPriceInLot(101) AS AveragePrice;


--Calculates the total car capacity of a storage lot.
-- Drop function if it exists
IF OBJECT_ID('StorageLotCapacity', 'FN') IS NOT NULL
    DROP FUNCTION StorageLotCapacity;
GO

-- Create function
CREATE FUNCTION StorageLotCapacity (@StorageLotID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalCapacity INT;
    SELECT @TotalCapacity = COUNT(CarID)
    FROM Car
    WHERE StorageLotID = @StorageLotID;
    RETURN @TotalCapacity;
END;
GO

-- Sample Query to Use
SELECT dbo.StorageLotCapacity(109) AS TotalCapacity;
GO





--Returns the total mileage recorded for a specific car.
-- Drop function if it exists
IF OBJECT_ID('TotalMileageForCar', 'FN') IS NOT NULL
    DROP FUNCTION TotalMileageForCar;
GO

-- Create function
CREATE FUNCTION TotalMileageForCar (@CarID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Mileage INT;
    SELECT @Mileage = Mileage
    FROM VehicleHistory
    WHERE CarID = @CarID;
    RETURN ISNULL(@Mileage, 0);
END;
GO

-- Sample Query to Use
SELECT dbo.TotalMileageForCar(10196) AS TotalMileage;
GO


--Calculates the average feedback rating for a customer.
-- Drop function if it exists
IF OBJECT_ID('AverageRatingForCustomer', 'FN') IS NOT NULL
    DROP FUNCTION AverageRatingForCustomer;
GO

-- Create function
CREATE FUNCTION AverageRatingForCustomer (@CustomerID INT)
RETURNS DECIMAL(5, 2)
AS
BEGIN
    DECLARE @AverageRating DECIMAL(5, 2);
    SELECT @AverageRating = AVG(CAST(Rating AS DECIMAL(5, 2)))
    FROM Feedback
    WHERE CustomerID = @CustomerID;
    RETURN ISNULL(@AverageRating, 0);
END;
GO

-- Sample Query to Use
SELECT dbo.AverageRatingForCustomer(100028) AS AverageRating;
GO



--Calculates the installment amount for an order in financing.
-- Drop function if it exists
IF OBJECT_ID('InstallmentAmountForOrder', 'FN') IS NOT NULL
    DROP FUNCTION InstallmentAmountForOrder;
GO

-- Create function
CREATE FUNCTION InstallmentAmountForOrder (@OrderID INT)
RETURNS DECIMAL(15, 2)
AS
BEGIN
    DECLARE @InstallmentAmount DECIMAL(15, 2);
    SELECT @InstallmentAmount = InstallmentAmount
    FROM Financing
    WHERE OrderID = @OrderID;
    RETURN ISNULL(@InstallmentAmount, 0);
END;
GO

-- Sample Query to Use
SELECT dbo.InstallmentAmountForOrder(266) AS InstallmentAmount;
GO

--Check if a Customer Has Made a Purchase
-- Drop function if it exists
IF OBJECT_ID('HasCustomerMadePurchase', 'FN') IS NOT NULL
    DROP FUNCTION HasCustomerMadePurchase;
GO

-- Create function
CREATE FUNCTION HasCustomerMadePurchase (@CustomerID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @HasPurchased BIT;
    SELECT @HasPurchased = CASE 
        WHEN EXISTS (SELECT 1 FROM SalesOrder WHERE CustomerID = @CustomerID) THEN 1 ELSE 0 END;
    RETURN @HasPurchased;
END;
GO

-- Sample Query to Use
SELECT dbo.HasCustomerMadePurchase(100191) AS HasPurchased;
GO

--to Calculate Total Value of Available Inventory

-- Drop function if it exists
IF OBJECT_ID('TotalInventoryValue', 'FN') IS NOT NULL
    DROP FUNCTION TotalInventoryValue;
GO

CREATE FUNCTION TotalInventoryValue (@StorageLotID INT)
RETURNS DECIMAL(15, 2)
AS
BEGIN
    DECLARE @TotalValue DECIMAL(15, 2);
    SELECT @TotalValue = SUM(Price)
    FROM Car
    WHERE StorageLotID = @StorageLotID AND CarID NOT IN (
        SELECT CarID FROM SalesOrder WHERE CarID IS NOT NULL
    );
    RETURN ISNULL(@TotalValue, 0);
END;
GO

-- EXEC Statement to test the function
DECLARE @Result DECIMAL(15, 2);
SET @Result = dbo.TotalInventoryValue(102);
SELECT @Result AS InventoryValue;
GO
------------------------------------------------------------------
---Triggers
--Updates the AvailabilityStatus of a car to Reserved after a sales order is created.

-- Drop trigger if it exists
IF OBJECT_ID('TR_UpdateAvailabilityAfterSale', 'TR') IS NOT NULL
    DROP TRIGGER TR_UpdateAvailabilityAfterSale;
GO

-- Create trigger
CREATE TRIGGER TR_UpdateAvailabilityAfterSale
ON SalesOrder
AFTER INSERT
AS
BEGIN
    -- Check if the CarID exists in the INSERTED table
    IF EXISTS (SELECT CarID FROM INSERTED WHERE CarID IS NOT NULL)
    BEGIN
        -- Update the availability status of the storage lot
        UPDATE StorageLot
        SET AvailabilityStatus = 'Reserved'
        WHERE StorageLotID IN (
            SELECT StorageLotID 
            FROM Car 
            WHERE CarID IN (SELECT CarID FROM INSERTED)
        );
    END
END;
GO


-- Test the trigger
INSERT INTO SalesOrder ([Date], TotalPrice, OrderQuantity, CarID, CustomerID, SalesPersonID)
VALUES ('2024-03-22', 25300, 1, 10001, 100080, 100016);
GO

select * from salesorder where CustomerID = 100080;
GO


---------------------------------------------------------------------------------------------


-- Trigger to Update Storage Lot After Sale
CREATE TRIGGER ModifyStorageAfterSale
ON SalesOrder
AFTER INSERT
AS
BEGIN
    UPDATE StorageLot
    SET Quantity = Quantity - 1
    WHERE StorageLotID = (SELECT StorageLotID FROM Car WHERE CarID = (SELECT CarID FROM INSERTED));
END;
GO

-- Set IDENTITY_INSERT ON for the SalesOrder table
SET IDENTITY_INSERT SalesOrder ON;

-- Perform the INSERT operation
INSERT INTO SalesOrder (OrderID, [Date], TotalPrice, OrderQuantity, CarID, CustomerID, SalesPersonID, Added_on, Updated_On)
VALUES (381, '2024-11-22', 25000.00, 1, 10017, 100043, 100019, GETDATE(), GETDATE());

-- Set IDENTITY_INSERT OFF after the operation
SET IDENTITY_INSERT SalesOrder OFF;
GO
---------------------------------------------------------------------------------------------
 --Trigger to create logs details of deleted sales orders


DROP TABLE IF EXISTS SalesOrderLog;

CREATE TABLE SalesOrderLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    TotalPrice DECIMAL(15,2),
    OrderQuantity INT,
    CarID INT,
    CustomerID INT,
    SalesPersonID INT,
    Deleted_On DATETIME
);
GO
IF OBJECT_ID('LogSalesOrderDeletion', 'TR') IS NOT NULL
    DROP TRIGGER LogSalesOrderDeletion;
GO

CREATE TRIGGER LogSalesOrderDeletion
ON SalesOrder
AFTER DELETE
AS
BEGIN
    INSERT INTO SalesOrderLog (OrderID, TotalPrice, OrderQuantity, CarID, CustomerID, SalesPersonID, Deleted_On)
    SELECT 
        OrderID, TotalPrice, OrderQuantity, CarID, CustomerID, SalesPersonID, GETDATE()
    FROM DELETED;
    
    PRINT 'Sales order deletion logged successfully.';
END;
GO

-- Set IDENTITY_INSERT ON for the SalesOrder table
SET IDENTITY_INSERT SalesOrder ON;

-- Perform the INSERT operation
INSERT INTO SalesOrder (OrderID, [Date], TotalPrice, OrderQuantity, CarID, CustomerID, SalesPersonID, Added_on, Updated_On)
VALUES (400, '2024-11-22', 25700.00, 1, 10020, 100043, 100019, GETDATE(), GETDATE());

-- Set IDENTITY_INSERT OFF after the operation
SET IDENTITY_INSERT SalesOrder OFF;


-- Delete the test record
DELETE FROM SalesOrder
WHERE OrderID = 381;

--Test the log
SELECT * 
FROM SalesOrderLog;
GO

