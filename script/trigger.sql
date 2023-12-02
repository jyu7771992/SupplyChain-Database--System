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
