USE hui;

-- Create DMK
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Level_Encrypti@n';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE TestCertificate
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
OPEN SYMMETRIC KEY SupplyChainSymmetricKey
  DECRYPTION BY MASTER KEY;

UPDATE proj.ContactInfo
SET EncryptedPhoneNUmber = EncryptByKey(Key_GUID('SupplyChainSymmetricKey'), PhoneNumber),
  EncryptedEmailAddress = EncryptByKey(Key_GUID('SupplyChainSymmetricKey'), EmailAddress);

--Encrypt the sensitive data using the symmetric key: address

UPDATE proj.AddressInfo
SET EncryptedUnitNum = EncryptByKey(Key_GUID('SupplyChainSymmetricKey'), UnitNumber),
  EncryptedStreetNum = EncryptByKey(Key_GUID('SupplyChainSymmetricKey'), StreetNumber);


--Decryption the sensitive data
OPEN SYMMETRIC KEY SupplyChainSymmetricKey
  DECRYPTION BY PASSWORD = 'Level_Encrypti@n';

SELECT
  CONVERT(NVARCHAR(50), DecryptByKey(EncryptedPhoneNUmber)) AS PhoneNumber,
  CONVERT(NVARCHAR(50), DecryptByKey(EncryptedEmailAddress)) AS EmailAddress
FROM proj.ContactInfo;

SELECT
  CONVERT(NVARCHAR(50), DecryptByKey(EncryptedUnitNum)) AS UnitNumber,
  CONVERT(NVARCHAR(50), DecryptByKey(EncryptedStreetNum)) AS StreetNumber
FROM proj.AddressInfo;
