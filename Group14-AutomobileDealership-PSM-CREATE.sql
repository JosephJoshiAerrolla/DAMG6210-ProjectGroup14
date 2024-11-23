-- Check for active connections and drop the database if it is not in use
IF NOT EXISTS (SELECT * FROM sys.dm_exec_sessions WHERE DB_NAME(database_id) = 'AutomobileDealership')
BEGIN
    PRINT 'Dropping AutomobileDealership database...';
    DROP DATABASE IF EXISTS AutomobileDealership;
    PRINT 'Database dropped successfully.';

    -- Create the database after dropping
    CREATE DATABASE AutomobileDealership;
    PRINT 'Database AutomobileDealership created successfully.';
END
ELSE
BEGIN
    PRINT 'Cannot drop AutomobileDealership database because it has active connections.';
END;
GO

-- Use the AutomobileDealership database
USE AutomobileDealership;
GO

-- Drop tables 
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Financing;
DROP TABLE IF EXISTS DealerSupplies;
DROP TABLE IF EXISTS SalesOrder;
DROP TABLE IF EXISTS Test_Drive;
DROP TABLE IF EXISTS CarServicing;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS VehicleHistory;
DROP TABLE IF EXISTS New_Car;
DROP TABLE IF EXISTS Used_Car;
DROP TABLE IF EXISTS SalesPerson;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Parts;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Dealer;
DROP TABLE IF EXISTS Financer;
DROP TABLE IF EXISTS StorageLot;
DROP TABLE IF EXISTS [User];

-- Main tables without foreign key dependencies
CREATE TABLE [User] (
    UserID INT PRIMARY KEY IDENTITY(100000, 1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(200) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(200) UNIQUE NOT NULL,
    Street VARCHAR(100),
    City VARCHAR(50),
    [State] VARCHAR(50) NOT NULL, 
    Added_on DATETIME DEFAULT GETDATE(),
    Updated_On DATETIME
);


CREATE TABLE StorageLot (
    StorageLotID INT PRIMARY KEY IDENTITY(100,1),
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    [Location] VARCHAR(100),
    AvailabilityStatus VARCHAR(20) CHECK (AvailabilityStatus IN ('Available', 'Reserved', 'Out of Stock')),
    Added_on DATETIME DEFAULT GETDATE(),
    Updated_On DATETIME
);


CREATE TABLE Financer (
    FinancerID INT PRIMARY KEY IDENTITY(100,1),
    FinanceName VARCHAR(100) NOT NULL,
    AuthorizationNumber VARCHAR(50) UNIQUE NOT NULL,
    Added_on DATETIME DEFAULT GETDATE(),
    Updated_On DATETIME
);

CREATE TABLE Dealer (
    DealerID INT PRIMARY KEY IDENTITY(4000,1),
    DealerName VARCHAR(100) NOT NULL,
    DealerLocation VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    DealerLicenseNumber VARCHAR(50) UNIQUE NOT NULL,
    Added_on DATETIME DEFAULT GETDATE(),
    Updated_On DATETIME
);

CREATE TABLE Parts (
    PartID INT PRIMARY KEY IDENTITY(20000,1),
    PartName VARCHAR(50) NOT NULL,
    PartCost DECIMAL(15, 2) CHECK (PartCost >= 0),
    [Status] VARCHAR(20) CHECK ([Status] IN ('Available', 'Ordered', 'Out of Stock')),
    StorageLotID INT,
    Added_On DATETIME DEFAULT GETDATE(),
    Updated_On DATETIME
    CONSTRAINT FK_Parts_StorageLotID FOREIGN KEY (StorageLotID) REFERENCES StorageLot(StorageLotID) ON DELETE SET NULL
);

CREATE TABLE Car (
    CarID INT PRIMARY KEY IDENTITY(10000,1),
    VIN VARCHAR(200) UNIQUE NOT NULL,
    Make VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    [Year] INT CHECK ([Year] > 1900),
    Price DECIMAL(15, 2) CHECK (Price >= 0),
    StorageLotID INT,
    Added_on DATETIME DEFAULT GETDATE(),
    Updated_On DATETIME
    CONSTRAINT FK_Car_StorageLotID FOREIGN KEY (StorageLotID) REFERENCES StorageLot(StorageLotID) ON DELETE SET NULL
);

-- Dependent tables with foreign keys
CREATE TABLE New_Car (
    CarID INT PRIMARY KEY,
    WarrantyPeriod VARCHAR(10) NOT NULL CHECK (WarrantyPeriod IN (
        '1 year', '2 years', '3 years', '4 years', '5 years', 
        '6 years', '7 years', '8 years', '9 years', '10 years'
    )),
    CONSTRAINT FK_NewCar_CarID FOREIGN KEY (CarID) REFERENCES Car(CarID) ON DELETE CASCADE
);

CREATE TABLE Used_Car (
    CarID INT PRIMARY KEY,
    Used_Duration VARCHAR(10) NOT NULL CHECK (Used_Duration IN (
    '1 years', '2 years', '3 years', '4 years', '5 years', 
    '6 years', '7 years', '8 years', '9 years'
)),
    CONSTRAINT FK_UsedCar_CarID FOREIGN KEY (CarID) REFERENCES Car(CarID) ON DELETE CASCADE
);

CREATE TABLE VehicleHistory (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),
    PreviousOwners INT NOT NULL CHECK  (PreviousOwners >= 0),
    DamageRecords VARCHAR(200),
    ServiceRecords VARCHAR(200),
    Mileage INT CHECK (Mileage >= 0),
    CarID INT NOT NULL,
    Added_On DATETIME DEFAULT GETDATE(),
    Updated_On DATETIME
    CONSTRAINT FK_VehicleHistory_CarID FOREIGN KEY (CarID) REFERENCES Used_Car(CarID) ON DELETE CASCADE
);

CREATE TABLE SalesPerson (
    UserID INT PRIMARY KEY,
    HireDate DATE NOT NULL,
    Salary DECIMAL(15, 2) CHECK (Salary > 0),
    CONSTRAINT FK_SalesPerson_UserID FOREIGN KEY (UserID) REFERENCES [User](UserID) ON DELETE CASCADE
);

CREATE TABLE Customer (
    UserID INT PRIMARY KEY,
    CONSTRAINT FK_Customer_UserID FOREIGN KEY (UserID) REFERENCES [User](UserID) ON DELETE CASCADE
);

CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comments VARCHAR(500),
    [Date] DATE NOT NULL,
    CustomerID INT NOT NULL,
    Added_On DATETIME DEFAULT GETDATE(),
    Updated_On DATETIME
    CONSTRAINT FK_Feedback_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(UserID) ON DELETE CASCADE
);

CREATE TABLE SalesOrder (
    OrderID INT PRIMARY KEY IDENTITY(200,1),
    [Date] DATE NOT NULL,
    TotalPrice DECIMAL(15, 2) NOT NULL CHECK (TotalPrice > 0),
    OrderQuantity INT NOT NULL CHECK (OrderQuantity > 0),
    CarID INT,
    CustomerID INT NULL,
    SalesPersonID INT NULL,
    Added_On DATETIME DEFAULT GETDATE(),
    Updated_On DATETIME
    CONSTRAINT FK_SalesOrder_CarID FOREIGN KEY (CarID) REFERENCES Car(CarID) ON DELETE SET NULL,
    CONSTRAINT FK_SalesOrder_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(UserID) ON DELETE NO ACTION,
    CONSTRAINT FK_SalesOrder_SalesPersonID FOREIGN KEY (SalesPersonID) REFERENCES SalesPerson(UserID) ON DELETE NO ACTION
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    Amount DECIMAL(15, 2) NOT NULL CHECK (Amount > 0),
    PaymentDate DATE NOT NULL,
    PaymentMethod VARCHAR(20) NOT NULL CHECK (PaymentMethod IN ('Credit', 'Debit', 'Cash', 'Online')),
    OrderID INT NOT NULL,
    CONSTRAINT FK_Payments_OrderID FOREIGN KEY (OrderID) REFERENCES SalesOrder(OrderID) ON DELETE CASCADE
);

CREATE TABLE Financing (
    OrderID INT NOT NULL,
    FinancerID INT NOT NULL,  
    NumberOfInstallments INT NOT NULL CHECK (NumberOfInstallments > 0),
    InterestRate DECIMAL(5, 2) NOT NULL CHECK (InterestRate >= 0 AND InterestRate <= 100),
    InstallmentAmount DECIMAL(15, 2) NOT NULL CHECK (InstallmentAmount > 0),
    PRIMARY KEY (OrderID, FinancerID),
    CONSTRAINT FK_Financing_OrderID FOREIGN KEY (OrderID) REFERENCES SalesOrder(OrderID) ON DELETE CASCADE,
    CONSTRAINT FK_Financing_FinancerID FOREIGN KEY (FinancerID) REFERENCES Financer(FinancerID) ON DELETE CASCADE 
);


CREATE TABLE DealerSupplies (
    StorageLotID INT NOT NULL,
    DealerID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    SupplyDate DATE,
    PRIMARY KEY (StorageLotID, DealerID),
    CONSTRAINT FK_DealerSupplies_StorageLotID FOREIGN KEY (StorageLotID) REFERENCES StorageLot(StorageLotID) ON DELETE CASCADE,
    CONSTRAINT FK_DealerSupplies_DealerID FOREIGN KEY (DealerID) REFERENCES Dealer(DealerID) ON DELETE CASCADE
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    [Date] DATE NOT NULL,
    CustomerID INT NOT NULL,
    CONSTRAINT FK_Appointments_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(UserID) ON DELETE CASCADE
);

CREATE TABLE Test_Drive (
    TestDriveID INT PRIMARY KEY IDENTITY(1,1),
    TestDriveDate DATE NOT NULL,
    AppointmentID INT NOT NULL,
    CarID INT,
    CONSTRAINT FK_TestDrive_AppointmentID FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID) ON DELETE CASCADE,
    CONSTRAINT FK_TestDrive_CarID FOREIGN KEY (CarID) REFERENCES Car(CarID) ON DELETE SET NULL
);

CREATE TABLE CarServicing (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceDate DATE NOT NULL,
    ServiceDescription VARCHAR(200),
    ServiceCost DECIMAL(15, 2) CHECK (ServiceCost >= 0),
    CarID INT,
    AppointmentID INT NOT NULL,
    PartID INT,
    CONSTRAINT FK_CarServicing_CarID FOREIGN KEY (CarID) REFERENCES Car(CarID) ON DELETE SET NULL,
    CONSTRAINT FK_CarServicing_AppointmentID FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID) ON DELETE CASCADE,
    CONSTRAINT FK_CarServicing_PartID FOREIGN KEY (PartID) REFERENCES Parts(PartID) ON DELETE SET NULL
);



 