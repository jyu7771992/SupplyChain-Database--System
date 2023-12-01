USE SupplyChain;

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