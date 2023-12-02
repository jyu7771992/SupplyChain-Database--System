--After inserting a new row into the proj.OrderDetail table (adding new order details), the total price of the corresponding order in the proj.OrderInfo table is automatically updated.
CREATE TRIGGER UpdateOrderTotalPrice
AFTER INSERT ON proj.OrderDetail
FOR EACH ROW
BEGIN
    -- Calculate total order price from order detail
    DECLARE newTotal DECIMAL(10, 2);
    SELECT SUM(Price) INTO newTotal
    FROM proj.OrderDetail
    WHERE OrderID = NEW.OrderID;

    -- update the total order price
    UPDATE proj.OrderInfo
    SET TotalPrice = newTotal
    WHERE OrderID = NEW.OrderID;
END;

--HouseKeeping
DROP TRIGGER UpdateOrderTotalPrice

--After inserting a new row into the proj.OrderDetail table (adding new order details),  the Quantity of InventoryID and InventoryLocationUsage in InventoryLocationInfo table are automatically updated.
CREATE TRIGGER proj.UpdateInventoryAfterOrder
ON proj.OrderDetail
AFTER INSERT
AS
BEGIN
    -- Reduce inventory quantity
    UPDATE proj.InventoryItem
    SET Quantity = Quantity - 1
    FROM proj.InventoryItem
    INNER JOIN inserted i ON proj.InventoryItem.InventoryID = i.InventoryID;

    -- Update inventory usage
    UPDATE proj.InventoryLocationInfo
    SET InventoryLocationUsage = (
        SELECT II.Quantity * P.InventoryUsage
        FROM proj.Product P
        INNER JOIN proj.InventoryItem II ON P.EANUPCCodeID = II.EANUPCCodeID
        INNER JOIN inserted i ON II.InventoryID = i.InventoryID
    )
    FROM proj.InventoryLocationInfo
    INNER JOIN proj.InventoryItem ON proj.InventoryLocationInfo.InventoryLocationID = proj.InventoryItem.InventoryLocationID
    INNER JOIN inserted i ON proj.InventoryItem.InventoryID = i.InventoryID;
END;

--HouseKeeping
DROP TRIGGER proj.UpdateInventoryAfterOrder
    
--If the quantity is 0, then a new OrderDetail cannot be generated
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

