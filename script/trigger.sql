--------------------------------------  Trigger  ----------------------------------------------------
-----After inserting a new row into the proj.OrderDetail table (adding new order details), the total price of the corresponding order in the proj.OrderInfo table is automatically updated.
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

-----After inserting a new row into the proj.OrderDetail table (adding new order details),  the Quantity of InventoryID and InventoryLocationUsage in InventoryLocationInfo table are automatically updated.
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

