----For the UpdateInventoryAfterOrder Trigger
-- ContactInfo
INSERT INTO dbo.ContactInfo VALUES (111, '123-456-7890', 'email@example.com');

-- AddressInfo
INSERT INTO dbo.AddressInfo VALUES (111, '123', 'Unit 1', 'City', 'State', 'Country', '12345');

-- LocationType
INSERT INTO dbo.LocationType VALUES (111, 'Warehouse');

-- CategoryInfo
INSERT INTO dbo.CategoryInfo VALUES (111, 'Electronics');



-- CompanyInfo
INSERT INTO dbo.CompanyInfo VALUES (111, 'CompanyName', 1, 1);

-- CustomerInfo
INSERT INTO dbo.CustomerInfo VALUES (111, 'John', 'Doe', 1, 1);



-- Product
INSERT INTO dbo.Product VALUES (111, 'Smartphone', 11, 'Medium', 'Black', 'Modern', 'Global', 2);

-- SupplierInfo
INSERT INTO dbo.SupplierInfo VALUES (111, 'MaterialX', 11);

-- ManufacturerInfo
INSERT INTO dbo.ManufacturerInfo VALUES (111, 'ManufacturerX', 11, 11);



-- Batch
INSERT INTO dbo.Batch VALUES (111, 11, 11, 11);



-- ProductSerial
INSERT INTO dbo.ProductSerial VALUES (111, 11);


-- InventoryLocationInfo
INSERT INTO dbo.InventoryLocationInfo VALUES (111, 'Main Warehouse', 11, 11, 15, 1000);

-- InventoryItem
INSERT INTO dbo.InventoryItem VALUES (111, 11, 11, 1, 10, '2023-01-01', 'In Stock');



-- OrderInfo
INSERT INTO dbo.OrderInfo VALUES (111, 11, 100.00, '2023-01-01');

-- OrderDetail (TEST！！)
INSERT INTO dbo.OrderDetail VALUES (111, 11, 11, 1, 100.00);



--  CHECK！！ InventoryItem 
SELECT * FROM dbo.InventoryItem WHERE InventoryID = 1;

--  CKECK！！ InventoryLocationInfo 
SELECT * FROM dbo.InventoryLocationInfo WHERE InventoryLocationID = 1;

CREATE TRIGGER dbo.UpdateInventoryAfterOrder
ON dbo.OrderDetail
AFTER INSERT
AS
BEGIN
    UPDATE dbo.InventoryItem
    SET Quantity = Quantity - 1
    FROM dbo.InventoryItem
    INNER JOIN inserted i ON dbo.InventoryItem.InventoryID = i.InventoryID;

    UPDATE dbo.InventoryLocationInfo
    SET InventoryLocationUsage = (
        SELECT II.Quantity * P.InventoryUsage
        FROM dbo.Product P
        INNER JOIN dbo.InventoryItem II ON P.EANUPCCodeID = II.EANUPCCodeID
        INNER JOIN inserted i ON II.InventoryID = i.InventoryID
    )
    FROM dbo.InventoryLocationInfo
    INNER JOIN dbo.InventoryItem ON dbo.InventoryLocationInfo.InventoryLocationID = dbo.InventoryItem.InventoryLocationID
    INNER JOIN inserted i ON dbo.InventoryItem.InventoryID = i.InventoryID;
END;

DROP TRIGGER dbo.UpdateInventoryAfterOrder;

