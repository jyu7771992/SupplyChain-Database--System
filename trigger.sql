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
