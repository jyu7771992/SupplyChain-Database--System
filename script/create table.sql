USE Hui;
CREATE SCHEMA proj;

DROP TABLE proj.ReturnOrderInfo
DROP TABLE proj.OrderDetail 
DROP TABLE proj.OrderInfo
DROP TABLE proj.InventoryItem
DROP TABLE proj.InventoryLocationInfo
DROP TABLE proj.ProductSerial
DROP TABLE proj.Batch
DROP TABLE proj.Product
DROP TABLE proj.CustomerInfo
DROP TABLE proj.ManufacturerInfo
DROP TABLE proj.SupplierInfo
DROP TABLE proj.CompanyInfo
DROP TABLE proj.CategoryInfo
DROP TABLE proj.LocationType
DROP TABLE proj.AddressInfo
DROP TABLE proj.ContactInfo



-- ContactInfo
CREATE TABLE proj.ContactInfo (
    ContactID INT PRIMARY KEY,
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR(255)
);



-- AddressInfo
CREATE TABLE proj.AddressInfo (
    AddressID INT PRIMARY KEY,
    StreetNumber VARCHAR(255),
    UnitNumber VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    ZipCode VARCHAR(20)
);



-- LocationType
CREATE TABLE proj.LocationType (
    LocationTypeID INT PRIMARY KEY,
    LocationTypeDescription VARCHAR(255)
);


-- CategoryInfo
CREATE TABLE proj.CategoryInfo (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255)
);



-- CompanyInfo
CREATE TABLE proj.CompanyInfo (
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(255),
    AddressID INT,
    ContactID INT,
    FOREIGN KEY (AddressID) REFERENCES proj.AddressInfo(AddressID),
    FOREIGN KEY (ContactID) REFERENCES proj.ContactInfo(ContactID)
);


-- SupplierInfo
CREATE TABLE proj.SupplierInfo (
    MaterialsID INT PRIMARY KEY,
    MaterialsName VARCHAR(255),
    CompanyID INT,
    FOREIGN KEY (CompanyID) REFERENCES proj.CompanyInfo(CompanyID)
);



-- ManufacturerInfo
CREATE TABLE proj.ManufacturerInfo (
    ManufacturerID INT PRIMARY KEY,
    ManufacturerName VARCHAR(255),
    AddressID INT,
    ContactID INT,
    FOREIGN KEY (AddressID) REFERENCES proj.AddressInfo(AddressID),
    FOREIGN KEY (ContactID) REFERENCES proj.ContactInfo(ContactID)
);


-- CustomerInfo
CREATE TABLE proj.CustomerInfo (
    CustomerID INT PRIMARY KEY,
    CustomerFirstName VARCHAR(255),
    CustomerLastName VARCHAR(255),
    AddressID INT,
    ContactID INT,
    FOREIGN KEY (AddressID) REFERENCES proj.AddressInfo(AddressID),
    FOREIGN KEY (ContactID) REFERENCES proj.ContactInfo(ContactID)
);


-- Product
CREATE TABLE proj.Product (
    EANUPCCodeID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    CategoryID INT,
    Size VARCHAR(50),
    Color VARCHAR(50),
    Style VARCHAR(50),
    Region VARCHAR(50),
    InventoryUsage INT,
    FOREIGN KEY (CategoryID) REFERENCES proj.CategoryInfo(CategoryID)
);



-- Batch
CREATE TABLE proj.Batch (
    BatchID INT PRIMARY KEY,
    ManufacturingID INT,
    MaterialsID INT,
    EANUPCCodeID INT,
    FOREIGN KEY (ManufacturingID) REFERENCES proj.ManufacturerInfo(ManufacturerID),
    FOREIGN KEY (MaterialsID) REFERENCES proj.SupplierInfo(MaterialsID),
    FOREIGN KEY (EANUPCCodeID) REFERENCES proj.Product(EANUPCCodeID)
);


-- ProductSerial
CREATE TABLE proj.ProductSerial (
    ProductSerialID INT PRIMARY KEY,
    BatchID INT,
    FOREIGN KEY (BatchID) REFERENCES proj.Batch(BatchID)
);



-- InventoryLocationInfo
CREATE TABLE proj.InventoryLocationInfo (
    InventoryLocationID INT PRIMARY KEY,
    InventoryLocationName VARCHAR(255),
    LocationTypeID INT,
    AddressID INT,
    InventoryLocationUsage INT,
    InventoryLocationCapacity INT,
    FOREIGN KEY (LocationTypeID) REFERENCES proj.LocationType(LocationTypeID),
    FOREIGN KEY (AddressID) REFERENCES proj.AddressInfo(AddressID)
);


-- InventoryItem
CREATE TABLE proj.InventoryItem (
    InventoryID INT PRIMARY KEY ,
    BatchID INT,
    EANUPCCodeID INT,
    InventoryLocationID INT,
    Quantity INT,
    DateToInventory DATE,
    Status VARCHAR(50),
    FOREIGN KEY (BatchID) REFERENCES proj.Batch(BatchID),
    FOREIGN KEY (EANUPCCodeID) REFERENCES proj.Product(EANUPCCodeID),
    FOREIGN KEY (InventoryLocationID) REFERENCES proj.InventoryLocationInfo(InventoryLocationID)
);


-- OrderInfo
CREATE TABLE proj.OrderInfo (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    TotalPrice DECIMAL(10, 2),
    Date DATE,
    FOREIGN KEY (CustomerID) REFERENCES proj.CustomerInfo(CustomerID)
);



-- OrderDetail
CREATE TABLE proj.OrderDetail (
    OrderDetailID INT PRIMARY KEY,
    ProductSerialID INT,
    OrderID INT,
    InventoryID INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (ProductSerialID) REFERENCES proj.ProductSerial(ProductSerialID),
    FOREIGN KEY (InventoryID) REFERENCES proj.InventoryItem(InventoryID),
    FOREIGN KEY (OrderID) REFERENCES proj.OrderInfo(OrderID)
);

ALTER TABLE proj.OrderDetail
ADD CONSTRAINT Unique_ProductSerialID UNIQUE (ProductSerialID);

-- ReturnOrderInfo
CREATE TABLE proj.ReturnOrderInfo (
    ReturnOrderID INT PRIMARY KEY,
    ProductSerialID INT,
    CustomerID INT,
    InventoryLocationID INT,
    ReturnDate DATE,
    Description VARCHAR(255),
    FOREIGN KEY (ProductSerialID) REFERENCES proj.OrderDetail(ProductSerialID),
    FOREIGN KEY (InventoryLocationID) REFERENCES proj.InventoryLocationInfo(InventoryLocationID),
    FOREIGN KEY (CustomerID) REFERENCES proj.CustomerInfo(CustomerID)
    
);

