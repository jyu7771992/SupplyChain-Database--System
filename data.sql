USE Hui;

--insert data in ContactInfo
INSERT INTO proj.ContactInfo (ContactID, PhoneNumber, EmailAddress) VALUES
(1, '+72-328-5283-9327', 'rnlnovp@mail.com'),
(2, '+68-297-2870-1960', 'cczqo@example.com'),
(3, '+63-227-9619-1503', 'cwogroduj@test.org'),
(4, '+45-718-5443-5909', 'yaszzjb@example.com'),
(5, '+57-494-9964-5998', 'oajbvi@example.com'),
(6, '+37-805-3950-8967', 'dzbsjsktc@test.org'),
(7, '+57-544-4557-5305', 'iahrq@test.org'),
(8, '+63-257-4270-5932', 'tctkvawkzh@test.org'),
(9, '+46-823-7262-5239', 'kbrbuxrap@mail.com'),
(10, '+18-362-4245-7333', 'hsmzill@example.com'),
(11, '+66-669-5989-1177', 'mrqjhxyaug@mail.com'),
(12, '+44-590-7312-1869', 'jgvjpbqym@mail.com'),
(13, '+72-359-5102-7419', 'qiiwtvf@mail.com'),
(14, '+71-373-9442-9092', 'gwyoseqn@test.org'),
(15, '+70-219-6601-3694', 'hdflo@example.com');


--insert data in AddressInfo
INSERT INTO proj.AddressInfo (AddressID, StreetNumber, UnitNumber, City, State, Country, ZipCode) VALUES
(1, '48004', '9', 'Los Angeles', 'California', 'United States', '90001'),
(2, '07', '90', 'Philadelphia', 'Pennsylvania', 'United States', '19101'),
(3, '7527', '429', 'New York', 'New York', 'United States', '10001'),
(4, '6940', '8', 'Dallas', 'Texas', 'United States', '75201'),
(5, '36325', '98', 'San Diego', 'California', 'United States', '92101'),
(6, '32', '334', 'Phoenix', 'Arizona', 'United States', '85001'),
(7, '81212', '1', 'New York', 'New York', 'United States', '10001'),
(8, '46', '729', 'San Jose', 'California', 'United States', '95101'),
(9, '27240', '196', 'New York', 'New York', 'United States', '10001'),
(10, '57427', '511', 'Houston', 'Texas', 'United States', '77001'),
(11, '0', '32', 'New York', 'New York', 'United States', '10001'),
(12, '52', '68', 'Houston', 'Texas', 'United States', '77001'),
(13, '9', '8', 'New York', 'New York', 'United States', '10001'),
(14, '0', '99', 'San Diego', 'California', 'United States', '92101'),
(15, '293', '5', 'San Diego', 'California', 'United States', '92101');


--insert data in LocationType
INSERT INTO proj.LocationType (LocationTypeID, LocationTypeDescription) VALUES
(1, 'Warehouse'),
(2, 'Store'),
(3, 'Recycling Center');


--insert data in CategoryInfo
INSERT INTO proj.CategoryInfo (CategoryID, CategoryName) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home Appliances'),
(4, 'Books'),
(5, 'Groceries'),
(6, 'Sports Equipment'),
(7, 'Beauty Products'),
(8, 'Toys'),
(9, 'Automotive Parts'),
(10, 'Gardening Supplies');



--insert data in CompanyInfo
INSERT INTO proj.CompanyInfo (CompanyID, CompanyName, AddressID, ContactID) VALUES
(1, 'Bright Services', 12, 6),
(2, 'Dynamic Group', 5, 15),
(3, 'Bright Enterprises', 11, 14),
(4, 'Future Systems', 5, 2),
(5, 'Bright Industries', 7, 11),
(6, 'Quick Industries', 8, 3),
(7, 'Green Enterprises', 3, 6),
(8, 'Bright Concepts', 12, 15),
(9, 'Quick Systems', 1, 12),
(10, 'Innovative Group', 8, 6),
(11, 'Innovative Concepts', 1, 15),
(12, 'Innovative Solutions', 5, 2),
(13, 'Smart Holdings', 4, 3),
(14, 'Tech Holdings', 14, 7),
(15, 'Bright Industries', 12, 3);


--insert data in SupplierInfo 
INSERT INTO proj.SupplierInfo (MaterialsID, MaterialsName, CompanyID) VALUES
(1, 'FlexWood', 8),
(2, 'PolyWood', 15),
(3, 'BioFabric', 12),
(4, 'ThermoFiber', 4),
(5, 'EcoPlastic', 10),
(6, 'BioFoam', 9),
(7, 'PolyGlass', 15),
(8, 'PolyPlastic', 12),
(9, 'ThermoFoam', 10),
(10, 'BioWood', 3),
(11, 'MicroFiber', 11),
(12, 'FlexWood', 15),
(13, 'ThermoFiber', 2),
(14, 'PolyGlass', 13),
(15, 'TechnoFabric', 14);

--insert data in maufacturer
INSERT INTO proj.ManufacturerInfo (ManufacturerID, ManufacturerName, AddressID, ContactID) VALUES
(1, 'Manufacturing Machine', 1, 7),
(2, 'Manufacturing Steel', 3, 3),
(3, 'Manufacturing Global', 1, 4),
(4, 'Manufacturing Electro', 13, 9),
(5, 'Manufacturing Plastic', 13, 4),
(6, 'Manufacturing Machine', 6, 11),
(7, 'Manufacturing Electro', 14, 4),
(8, 'Manufacturing Auto', 13, 11),
(9, 'Manufacturing Global', 13, 15),
(10, 'Manufacturing Tech', 15, 4),
(11, 'Manufacturing Food', 4, 13),
(12, 'Manufacturing Textile', 2, 15),
(13, 'Manufacturing Furniture', 4, 14),
(14, 'Manufacturing Global', 13, 8),
(15, 'Manufacturing Tech', 6, 12);

--insert data in CustomerInfo 
INSERT INTO proj.CustomerInfo (CustomerID, CustomerFirstName, CustomerLastName, AddressID, ContactID) VALUES
(1, 'Michael', 'Hernandez', 13, 5),
(2, 'Joseph', 'Davis', 2, 7),
(3, 'Barbara', 'Moore', 3, 11),
(4, 'Linda', 'Gonzalez', 2, 7),
(5, 'John', 'Garcia', 5, 5),
(6, 'Joseph', 'Wilson', 9, 14),
(7, 'Barbara', 'Miller', 15, 7),
(8, 'Linda', 'Jackson', 7, 13),
(9, 'James', 'Miller', 4, 1),
(10, 'Linda', 'Martinez', 13, 13),
(11, 'Patricia', 'Miller', 6, 10),
(12, 'Jessica', 'Anderson', 3, 5),
(13, 'David', 'Garcia', 4, 15),
(14, 'Michael', 'Miller', 3, 8),
(15, 'Susan', 'Davis', 15, 1);

--insert data in Product
INSERT INTO proj.Product (EANUPCCodeID, ProductName, CategoryID, Size, Color, Style, Region, InventoryUsage) VALUES
(1, 'Arctic Explorer Jacket', 9, 'Compact', 'Vibrant Yellow', 'Modern', 'Australia', 100),
(2, 'SuperView Television', 3, 'One Size', 'N/A', 'Sporty', 'Antarctica', 10),
(3, 'Arctic Explorer Jacket', 3, 'Extra Large', 'Pristine White', 'Sporty', 'North America', 50),
(4, 'Galaxy Smartphone', 8, 'Medium', 'Jet Black', 'Retro', 'Global', 10),
(5, 'Bloom Garden Pot', 7, 'Compact', 'Vibrant Yellow', 'Casual', 'Africa', 20),
(6, 'Best Cereal', 10, 'Extra Large', 'Jet Black', 'N/A', 'N/A', 20),
(7, 'Space Odyssey Novel', 7, 'Extra Large', 'Jet Black', 'Sporty', 'North America', 50),
(8, 'Ace Tennis Racket', 3, 'Medium', 'Jet Black', 'Modern', 'N/A', 70),
(9, 'Zen Yoga Mat', 9, 'One Size', 'N/A', 'Vintage', 'Antarctica', 50),
(10, 'Best Cereal', 4, 'Extra Large', 'Crimson Red', 'Elegant', 'Global', 10),
(11, 'Endurance Car Battery', 2, 'One Size', 'Jet Black', 'Retro', 'Global', 100),
(12, 'Arctic Explorer Jacket', 2, 'One Size', 'Jet Black', 'Sporty', 'Africa', 100),
(13, 'Space Odyssey Novel', 10, 'Extra Large', 'N/A', 'Sporty', 'South America', 90),
(14, 'Green Thumb Garden Shovel', 4, 'N/A', 'Crimson Red', 'N/A', 'Europe', 90),
(15, 'Heroes of History Biography', 7, 'Extra Large', 'Vibrant Yellow', 'Elegant', 'Antarctica', 90),
(16, 'Heroes of History Biography', 7, 'N/A', 'Ocean Blue', 'Elegant', 'South America', 30),
(17, 'Brain Teaser Puzzle', 9, 'One Size', 'Pristine White', 'Casual', 'Antarctica', 90),
(18, 'MaxStop Brake Pads', 3, 'One Size', 'Crimson Red', 'Sporty', 'North America', 70),
(19, 'SuperView Television', 9, 'Medium', 'Vibrant Yellow', 'Sporty', 'South America', 50),
(20, 'Green Thumb Garden Shovel', 10, 'Medium', 'Vibrant Yellow', 'Sporty', 'North America', 10);


--insert data in Batch
INSERT INTO proj.Batch (BatchID, ManufacturingID, MaterialsID, EANUPCCodeID) VALUES
(1, 3, 6, 4),
(2, 9, 8, 10),
(3, 7, 14, 18),
(4, 15, 2, 19),
(5, 10, 2, 12),
(6, 6, 4, 19),
(7, 13, 7, 7),
(8, 14, 8, 11),
(9, 14, 1, 5),
(10, 3, 4, 18),
(11, 4, 11, 2),
(12, 9, 15, 10),
(13, 2, 12, 2),
(14, 6, 1, 16),
(15, 7, 9, 1),
(16, 2, 7, 18),
(17, 4, 11, 5),
(18, 1, 11, 15),
(19, 12, 14, 18),
(20, 7, 5, 11);

--insert data in ProductSerial
INSERT INTO proj.ProductSerial (ProductSerialID, BatchID) VALUES
(1, 4),(2, 4),(3, 14),(4, 14),(5, 20),(6, 20),(7, 8),(8, 15),(9, 12),(10, 16),(11, 1),(12, 10),(13, 5),
(14, 5),(15, 9),(16, 14),(17, 10),(18, 17),(19, 20),(20, 15),(21, 16),(22, 13),(23, 10),(24, 5),(25, 10),
(26, 1),(27, 11),(28, 2),(29, 6),(30, 20),(31, 6),(32, 4),(33, 15),(34, 19),(35, 13),(36, 15),(37, 14),
(38, 19),(39, 9),(40, 18),(41, 7),(42, 8),(43, 20),(44, 12),(45, 11),(46, 7),(47, 19),(48, 6),(49, 6),(50, 19),
(51, 9),(52, 9),(53, 5),(54, 1),(55, 17),(56, 3),(57, 10),(58, 16),(59, 6),(60, 6),(61, 4),(62, 20),
(63, 18),(64, 1),(65, 17),(66, 8),(67, 13),(68, 12),(69, 5),(70, 12),(71, 16),(72, 2),(73, 12),(74, 17),
(75, 19),(76, 1),(77, 9),(78, 3),(79, 17),(80, 6),(81, 19),(82, 14),(83, 7),(84, 5),(85, 2),(86, 14),(87, 10),
(88, 5),(89, 1),(90, 19),(91, 8),(92, 17),(93, 19),(94, 13),(95, 10),(96, 19),(97, 11),(98, 15),(99, 15),(100, 17);




