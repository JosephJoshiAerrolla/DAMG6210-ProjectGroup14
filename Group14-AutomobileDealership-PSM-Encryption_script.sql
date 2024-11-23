-- Use the AutomobileDealership database
USE AutomobileDealership;
GO


-- Drop the symmetric key if it exists
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'UserCarInfoSymKey')
    DROP SYMMETRIC KEY UserCarInfoSymKey;
GO

-- Drop the certificate if it exists
IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'UserCarInfoCert')
    DROP CERTIFICATE UserCarInfoCert;
GO

-- Drop the master key if it exists
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
    DROP MASTER KEY;
GO


-- Step 1: Drop existing keys and certificates
-- Drop the symmetric key if it exists
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'UserCarInfoSymKey')
    DROP SYMMETRIC KEY UserCarInfoSymKey;
GO

-- Drop the certificate if it exists
IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'UserCarInfoCert')
    DROP CERTIFICATE UserCarInfoCert;
GO

-- Drop the master key if it exists
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
    DROP MASTER KEY;
GO

-- Step 2: Create a master key for the database
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SecureEncryptionPass2024!';
GO

-- Step 3: Create a certificate for encryption and decryption
CREATE CERTIFICATE UserCarInfoCert
WITH SUBJECT = 'User and Car Information Encryption Certificate';
GO

-- Step 4: Create a symmetric key using AES 256 algorithm, encrypted by the certificate
CREATE SYMMETRIC KEY UserCarInfoSymKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE UserCarInfoCert;
GO

-- Step 5: Encrypt `PhoneNumber` and `Email` in the `User` table
OPEN SYMMETRIC KEY UserCarInfoSymKey DECRYPTION BY CERTIFICATE UserCarInfoCert;

UPDATE [User]
SET 
    PhoneNumber = EncryptByKey(Key_GUID('UserCarInfoSymKey'), PhoneNumber),
    Email = EncryptByKey(Key_GUID('UserCarInfoSymKey'), Email);

-- Step 6: Encrypt `VIN` in the `Car` table
UPDATE Car
SET 
    VIN = EncryptByKey(Key_GUID('UserCarInfoSymKey'), VIN);

CLOSE SYMMETRIC KEY UserCarInfoSymKey;
GO

-- Step 7: Verify the encrypted data
-- Encrypted Data in `User` table
SELECT 
    UserID,
    PhoneNumber AS EncryptedPhoneNumber,
    Email AS EncryptedEmail
FROM [User];

-- Encrypted Data in `Car` table
SELECT 
    CarID,
    VIN AS EncryptedVIN
FROM Car;
GO

-- Step 8: Decrypt and View the Data
-- Decrypt and view `PhoneNumber` and `Email` from the `User` table
OPEN SYMMETRIC KEY UserCarInfoSymKey DECRYPTION BY CERTIFICATE UserCarInfoCert;

SELECT 
    UserID,
    CAST(DECRYPTBYKEY(PhoneNumber) AS VARCHAR(15)) AS DecryptedPhoneNumber,
    CAST(DECRYPTBYKEY(Email) AS VARCHAR(100)) AS DecryptedEmail,
    FirstName,
    LastName,
    Street,
    City,
    [State]
FROM [User];

-- Decrypt and view `VIN` from the `Car` table
SELECT 
    CarID,
    CAST(DECRYPTBYKEY(VIN) AS VARCHAR(20)) AS DecryptedVIN,
    Make,
    Model,
    [Year],
    Price,
    StorageLotID
FROM Car;

CLOSE SYMMETRIC KEY UserCarInfoSymKey;
GO

-- Check the data after encryption
SELECT * FROM Car;
SELECT * FROM [User];
GO

---VARBINARY
-- Step 1: Drop existing keys and certificates if they exist
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'UserCarInfoSymKey')
    DROP SYMMETRIC KEY UserCarInfoSymKey;
GO

IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'UserCarInfoCert')
    DROP CERTIFICATE UserCarInfoCert;
GO

IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
    DROP MASTER KEY;
GO

-- Step 2: Create a master key for the database
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SecureEncryptionPass2024!';
GO

-- Step 3: Create a certificate for encryption and decryption
CREATE CERTIFICATE UserCarInfoCert
WITH SUBJECT = 'User and Car Information Encryption Certificate';
GO

-- Step 4: Create a symmetric key using AES 256 algorithm, encrypted by the certificate
CREATE SYMMETRIC KEY UserCarInfoSymKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE UserCarInfoCert;
GO

-- Step 5: Modify the `Financer` table to use `VARBINARY` for encrypted data
ALTER TABLE Financer
ADD EncryptedAuthorizationNumber VARBINARY(MAX);
GO

-- Step 6: Encrypt the `AuthorizationNumber` column into the new `VARBINARY` column
OPEN SYMMETRIC KEY UserCarInfoSymKey DECRYPTION BY CERTIFICATE UserCarInfoCert;

UPDATE Financer
SET 
    EncryptedAuthorizationNumber = EncryptByKey(Key_GUID('UserCarInfoSymKey'), CAST(AuthorizationNumber AS NVARCHAR(MAX)));

CLOSE SYMMETRIC KEY UserCarInfoSymKey;
GO

-- Step 7: Verify the encrypted data
SELECT 
    FinancerID,
    AuthorizationNumber AS OriginalAuthorizationNumber,
    EncryptedAuthorizationNumber AS EncryptedAuthorizationNumber
FROM Financer;

-- Step 8: Decrypt and View the Data
OPEN SYMMETRIC KEY UserCarInfoSymKey DECRYPTION BY CERTIFICATE UserCarInfoCert;

SELECT 
    FinancerID,
    CAST(DECRYPTBYKEY(EncryptedAuthorizationNumber) AS NVARCHAR(MAX)) AS DecryptedAuthorizationNumber,
    FinanceName
FROM Financer;

CLOSE SYMMETRIC KEY UserCarInfoSymKey;
GO
