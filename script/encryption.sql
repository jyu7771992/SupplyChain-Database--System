USE hui;

-- Create DMK
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Level_Encrypti@n';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE SupplyChainCertificate
WITH SUBJECT = 'SupplyChain Protect Certificate',
EXPIRY_DATE = '2035-10-31';

-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY SupplyChainSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE SupplyChainCertificate;

-- Open symmetric key
OPEN SYMMETRIC KEY SupplyChainSymmetricKey
DECRYPTION BY CERTIFICATE SupplyChainCertificate;

--add encryption to the customer info table
ALTER TABLE proj.ContactInfo
ADD EncryptedPhoneNUmber VARBINARY(256),EncryptedEmailAddress VARBINARY(256);


--add encryption to the address info table
ALTER TABLE proj.AddressInfo
ADD EncryptedUnitNum VARBINARY(256), EncryptedStreetNum VARBINARY(256);


--Encrypt the sensitive data using the symmetric key: customer


UPDATE proj.ContactInfo
SET EncryptedPhoneNUmber = EncryptByKey(Key_GUID('SupplyChainSymmetricKey'), PhoneNumber),
  EncryptedEmailAddress = EncryptByKey(Key_GUID('SupplyChainSymmetricKey'), EmailAddress);

--Encrypt the sensitive data using the symmetric key: address

UPDATE proj.AddressInfo
SET EncryptedUnitNum = EncryptByKey(Key_GUID('SupplyChainSymmetricKey'), UnitNumber),
  EncryptedStreetNum = EncryptByKey(Key_GUID('SupplyChainSymmetricKey'), StreetNumber);
 
 
 --test waht we got in the contact info & addressInfo, please make sure excute create table.sql and data.sql first
SELECT * FROM proj.ContactInfo;
SELECT * FROM proj.AddressInfo;


--Decryption the sensitive data

SELECT 
  CONVERT(VARCHAR(20), DecryptByKey(EncryptedPhoneNUmber)) AS PhoneNumber,
  CONVERT(VARCHAR(255), DecryptByKey(EncryptedEmailAddress)) AS EmailAddress
FROM proj.ContactInfo;

SELECT
  CONVERT(VARCHAR(255), DecryptByKey(EncryptedUnitNum)) AS UnitNumber,
  CONVERT(VARCHAR(255), DecryptByKey(EncryptedStreetNum)) AS StreetNumber
FROM proj.AddressInfo;


-- Do housekeeping
DROP TABLE proj.ContactInfo;
DROP TABLE proj.AddressInfo;

-- Close the symmetric key
CLOSE SYMMETRIC KEY SupplyChainSymmetricKey;

-- Drop the symmetric key
DROP SYMMETRIC KEY SupplyChainSymmetricKey;

-- Drop the certificate
DROP CERTIFICATE SupplyChainCertificate;

--Drop the DMK
DROP MASTER KEY;
