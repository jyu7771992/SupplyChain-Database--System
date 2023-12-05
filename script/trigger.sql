--------------------------------------  Trigger  ----------------------------------------------------

--------------------------update orderinfo price by orderdetail
CREATE TRIGGER UpdateOrderTotalPrice
ON proj.OrderDetail
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    -- Temporarily store the OrderID from the newly inserted row(s)
    DECLARE @OrderID INT;

    -- Process each newly inserted row
    DECLARE inserted_cursor CURSOR FOR
        SELECT OrderID FROM inserted;
    OPEN inserted_cursor;
    FETCH NEXT FROM inserted_cursor INTO @OrderID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calculate the total order price for this particular order
        DECLARE @newTotal DECIMAL(10, 2);
        SELECT @newTotal = SUM(Price)
        FROM proj.OrderDetail
        WHERE OrderID = @OrderID;

        -- Update the total order price in OrderInfo for this particular order
        UPDATE proj.OrderInfo
        SET TotalPrice = @newTotal
        WHERE OrderID = @OrderID;

        FETCH NEXT FROM inserted_cursor INTO @OrderID;
    END;

    CLOSE inserted_cursor;
    DEALLOCATE inserted_cursor;
END;



----------------------update usage of inventory location after modify inventoryItem data

CREATE TRIGGER UpdateInventoryLocationUsageOnItemChange
ON proj.InventoryItem
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Create a table variable to store the InventoryLocationIDs that have been affected.
    DECLARE @AffectedLocations TABLE (InventoryLocationID INT);

    -- Insert the affected InventoryLocationIDs from the inserted and deleted tables.
    INSERT INTO @AffectedLocations (InventoryLocationID)
    SELECT InventoryLocationID FROM inserted
    UNION
    SELECT InventoryLocationID FROM deleted;

    -- Update InventoryLocationUsage for each affected InventoryLocationID.
    UPDATE InventoryLocationInfo
    SET InventoryLocationUsage = 
        (SELECT ISNULL(SUM(ii.Quantity * p.InventoryUsage), 0)
         FROM InventoryItem ii
         INNER JOIN Product p ON ii.EANUPCCodeID = p.EANUPCCodeID
         WHERE ii.InventoryLocationID = InventoryLocationInfo.InventoryLocationID
         GROUP BY ii.InventoryLocationID)
    FROM InventoryLocationInfo
    WHERE InventoryLocationID IN (SELECT InventoryLocationID FROM @AffectedLocations);
END;



------------------------update inventory item after order
CREATE TRIGGER DecreaseInventoryOnOrder
ON proj.OrderDetail
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON; -- This line is added to prevent extra result sets from interfering with SELECT statements.

    -- Declare a cursor for the inserted table to handle multiple inserts.
    DECLARE @ProductSerialID INT, @InventoryID INT;
    
    -- Cursor for the newly inserted OrderDetail records.
    DECLARE cur_OrderDetail CURSOR FOR 
        SELECT ProductSerialID, InventoryID FROM inserted;
    
    -- Open the cursor.
    OPEN cur_OrderDetail;
    
    -- Fetch the first row from the cursor.
    FETCH NEXT FROM cur_OrderDetail INTO @ProductSerialID, @InventoryID;
    
    -- Loop through all inserted records.
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Decrease the InventoryItem quantity by 1 for the corresponding InventoryID.
        UPDATE proj.InventoryItem
        SET Quantity = Quantity - 1
        WHERE InventoryID = @InventoryID 
          AND EANUPCCodeID = (SELECT EANUPCCodeID FROM proj.Batch WHERE BatchID = (SELECT BatchID FROM proj.ProductSerial WHERE ProductSerialID = @ProductSerialID));

        -- Fetch the next row from the cursor.
        FETCH NEXT FROM cur_OrderDetail INTO @ProductSerialID, @InventoryID;
    END
    
    -- Close and deallocate the cursor.
    CLOSE cur_OrderDetail;
    DEALLOCATE cur_OrderDetail;
END;

---------------------update usage of inventory location after return order
CREATE TRIGGER trg_UpdateInventoryLocationUsageOnReturn
ON proj.ReturnOrderInfo
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE ili
    SET InventoryLocationUsage = InventoryLocationUsage +
        (SELECT p.InventoryUsage
         FROM proj.Product p
         INNER JOIN proj.Batch b ON p.EANUPCCodeID = b.EANUPCCodeID
         INNER JOIN proj.ProductSerial ps ON b.BatchID = ps.BatchID
         WHERE ps.ProductSerialID = i.ProductSerialID)
    FROM proj.InventoryLocationInfo ili
    INNER JOIN inserted i ON ili.InventoryLocationID = i.InventoryLocationID;
END;


------------------------update inventoryItem after return order
CREATE TRIGGER trg_InsertInventoryItemOnReturn
ON proj.ReturnOrderInfo
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NewInventoryID INT;

    -- Get the last InventoryID and add 1 to it
    SELECT @NewInventoryID = ISNULL(MAX(InventoryID), 0) + 1 FROM proj.InventoryItem;

    -- Insert a new record into InventoryItem with the new InventoryID
    INSERT INTO proj.InventoryItem (InventoryID, BatchID, EANUPCCodeID, InventoryLocationID, Quantity, DateToInventory, Status)
    SELECT 
        @NewInventoryID, -- Use the new InventoryID
        ps.BatchID, 
        b.EANUPCCodeID, 
        i.InventoryLocationID, 
        1 AS Quantity, 
        i.ReturnDate, 
        'Returned' AS Status
    FROM 
        inserted i
    INNER JOIN 
        proj.ProductSerial ps ON i.ProductSerialID = ps.ProductSerialID
    INNER JOIN 
        proj.Batch b ON ps.BatchID = b.BatchID;
END;

-----When there is a new ReturnOrderInfo, a new Inventory Item is automatically generated
CREATE TRIGGER trg_AutoGenerateInventoryOnReturn
ON proj.ReturnOrderInfo
AFTER INSERT
AS
BEGIN
    -- Preventing trigger from firing multiple times for a single batch operation
    SET NOCOUNT ON;

    -- Inserting new record in InventoryItem for each new return order
    INSERT INTO proj.InventoryItem (BatchID, EANUPCCodeID, InventoryLocationID, Quantity, DateToInventory, Status)
    SELECT 
        i.BatchID,
        i.EANUPCCodeID,
        i.InventoryLocationID,
        i.Quantity,
        inserted.ReturnDate,
        'Returned'
    FROM 
        inserted
    INNER JOIN proj.InventoryItem i ON inserted.InventoryID = i.InventoryID;
END;

--Housekeeping
DROP TRIGGER trg_AutoGenerateInventoryOnReturn;

--------------------------------------  Function  ----------------------------------------------------
-----If the quantity is 0, then a new OrderDetail cannot be generated
CREATE FUNCTION proj.CheckInventoryQuantity(@InventoryID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @IsAvailable BIT;

    SELECT @IsAvailable = CASE 
                              WHEN Quantity > 0 THEN 1
                              ELSE 0 
                           END
    FROM proj.InventoryItem
    WHERE InventoryID = @InventoryID;

    RETURN @IsAvailable;
END;

ALTER TABLE proj.OrderDetail
ADD CONSTRAINT chk_InventoryQuantity
CHECK (proj.CheckInventoryQuantity(InventoryID) = 1);

--HouseKeeping
IF OBJECT_ID('proj.chk_InventoryQuantity', 'C') IS NOT NULL
BEGIN
    ALTER TABLE proj.OrderDetail
    DROP CONSTRAINT chk_InventoryQuantity;
END
--HouseKeeping
IF OBJECT_ID('proj.CheckInventoryQuantity', 'FN') IS NOT NULL
BEGIN
    DROP FUNCTION proj.CheckInventoryQuantity;
END

-----Before generating a new row of ReturnOrderInfo, there must be a corresponding OrderDetailID in the OrderDetail table.
CREATE FUNCTION proj.CheckOrderDetailExists(@OrderDetailID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Exists BIT

    IF EXISTS (SELECT 1 FROM proj.OrderDetail WHERE OrderDetailID = @OrderDetailID)
        SET @Exists = 1
    ELSE
        SET @Exists = 0

    RETURN @Exists
END

ALTER TABLE proj.ReturnOrderInfo
ADD CONSTRAINT CHK_OrderDetailExists CHECK (proj.CheckOrderDetailExists(OrderDetailID) = 1);

-- Housekeeping
ALTER TABLE proj.ReturnOrderInfo
DROP CONSTRAINT CHK_OrderDetailExists;

DROP FUNCTION proj.CheckOrderDetailExists;

-----Tracking from specific material ID to the product in inventory and sale 
CREATE FUNCTION proj.GetProductsFromMaterial (@MaterialsID INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        P.EANUPCCodeID AS ProductID,
        P.ProductName,
        II.InventoryID,
        II.Quantity,
        II.Status,
        OD.OrderID,
        OD.Price
    FROM proj.SupplierInfo SI
    JOIN proj.Batch B ON SI.MaterialsID = B.MaterialsID
    JOIN proj.ProductSerial PS ON B.BatchID = PS.BatchID
    JOIN proj.Product P ON B.EANUPCCodeID = P.EANUPCCodeID
    LEFT JOIN proj.InventoryItem II ON P.EANUPCCodeID = II.EANUPCCodeID
    LEFT JOIN proj.OrderDetail OD ON II.InventoryID = OD.InventoryID
    WHERE SI.MaterialsID = @MaterialsID
)

SELECT * FROM proj.GetProductsFromMaterial(6);

-- Housekeeping
DROP FUNCTION proj.GetProductsFromMaterial

