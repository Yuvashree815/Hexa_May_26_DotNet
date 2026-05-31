CREATE DATABASE ECOMMERCE

USE ECOMMERCE

CREATE TABLE Customer (
CustomerId INT PRIMARY KEY,
CustomerName VARCHAR(100),
Email VARCHAR(100),
MobileNo bigint,
City varchar(50),
Address varchar(150),
IsActive BIT,
CreatedDate DATE)

CREATE TABLE Seller (
    SellerId INT PRIMARY KEY,
    SellerName VARCHAR(100),
    Email VARCHAR(100),
    MobileNo VARCHAR(15),
    City VARCHAR(50),
    Rating DECIMAL(2,1),
    IsActive BIT)

CREATE TABLE Product (
    ProductId INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    StockQuantity INT,
    SellerId INT,
    CreatedDate DATE,
    FOREIGN KEY (SellerId) REFERENCES Seller(SellerId)
)

CREATE TABLE Orders (
    OrderId INT PRIMARY KEY,
    CustomerId INT,
    OrderDate DATE,
    OrderStatus VARCHAR(50),
    PaymentMode VARCHAR(50),
    DeliveryCity VARCHAR(50),
    FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
)

CREATE TABLE OrderItem (
    OrderItemId INT PRIMARY KEY,
    OrderId INT,
    ProductId INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
    FOREIGN KEY (ProductId) REFERENCES Product(ProductId)
)

ALTER TABLE Customer ADD CONSTRAINT UQ_Customer_Email UNIQUE(Email)

ALTER TABLE Seller ADD CONSTRAINT UQ_Seller_Email UNIQUE(Email)

ALTER TABLE Customer ALTER COLUMN CustomerName varchar(100) NOT NULL
ALTER TABLE Customer ALTER COLUMN MobileNo VARCHAR(15) NOT NULL

ALTER TABLE Seller ALTER COLUMN SellerName varchar(100) NOT NULL
ALTER TABLE Seller ALTER COLUMN MobileNo VARCHAR(15) NOT NULL

ALTER TABLE Product ALTER COLUMN ProductName varchar(100) NOT NULL
ALTER TABLE Product ALTER COLUMN Price DECIMAL(10,2) NOT NULL
ALTER TABLE Product ALTER COLUMN StockQuantity INT NOT NULL
ALTER TABLE Product ALTER COLUMN SellerId INT NOT NULL

ALTER TABLE Orders ALTER COLUMN CustomerId int NOT NULL
ALTER TABLE Orders ALTER COLUMN OrderStatus VARCHAR(50)
ALTER TABLE Orders ALTER COLUMN DeliveryCity VARCHAR(100) NOT NULL

ALTER TABLE OrderItem ALTER COLUMN OrderId int NOT NULL
ALTER TABLE OrderItem ALTER COLUMN ProductId int NOT NULL

ALTER TABLE Product ADD CONSTRAINT CHK_Product_Price CHECK (Price>0)

ALTER TABLE Product ADD CONSTRAINT CHK_Product_StockQuantity CHECK (StockQuantity>=0)

ALTER TABLE OrderItem ADD CONSTRAINT CHK_OrderItem_Quantity CHECK (Quantity>0)

ALTER TABLE Orders ADD CONSTRAINT DF_Orders_OrderDate DEFAULT GETDATE() FOR OrderDate

ALTER TABLE Orders ADD CONSTRAINT DF_Orders_OrderStatus DEFAULT 'Pending' FOR OrderStatus

ALTER TABLE Customer ADD CONSTRAINT DF_Customers_IsActive DEFAULT 1 FOR IsActive


INSERT INTO Customer VALUES
(1,'Yuva','yuva@gmail.com','9876543210','Vellore','Katpadi',1,GETDATE()),
(2,'Shree','shree@gmail.com','9876543211','Chennai','Anna Nagar',1,GETDATE()),
(3,'Jonas','jonas@gmail.com','9876543212','Coimbatore','Gandhipuram',1,GETDATE()),
(4,'Martha','martha@gmail.com','9876543213','Madurai','KK Nagar',1,GETDATE()),
(5,'Barthoz','barthoz@gmail.com','9876543214','Hyderabad','Madhapur',1,GETDATE());

SELECT * FROM Customer

INSERT INTO Seller VALUES
(101,'Ian','ian@gmail.com','9876543220','Bangalore',4.5,1),
(102,'Stefan','stefan@gmail.com','9876543221','Mumbai',4.8,1),
(103,'Lorenzo','lorenzo@gmail.com','9876543222','Delhi',4.3,1),
(104,'Klaus','klaus@gmail.com','9876543223','Kochi',4.7,1);

SELECT * FROM Seller

INSERT INTO Product VALUES
(1001,'iPhone 15','Mobile',75000,20,101,GETDATE()),
(1002,'Samsung Galaxy S24','Mobile',65000,15,101,GETDATE()),
(1003,'Dell Inspiron','Laptop',55000,10,102,GETDATE()),
(1004,'MacBook Air M3','Laptop',115000,8,102,GETDATE()),
(1005,'Boat Headphones','Accessories',2500,50,103,GETDATE()),
(1006,'Apple Watch','Wearables',45000,12,103,GETDATE()),
(1007,'iPad Air','Tablet',60000,7,104,GETDATE()),
(1008,'Sony Camera','Electronics',85000,5,104,GETDATE());

SELECT * FROM Product

INSERT INTO Orders VALUES
(5001,1,GETDATE(),'Delivered','UPI','Vellore'),
(5002,2,GETDATE(),'Pending','Card','Chennai'),
(5003,3,GETDATE(),'Shipped','Net Banking','Coimbatore'),
(5004,4,GETDATE(),'Delivered','UPI','Madurai'),
(5005,5,GETDATE(),'Pending','Cash On Delivery','Hyderabad');

SELECT * FROM Orders

INSERT INTO OrderItem VALUES
(1,5001,1001,1,75000),
(2,5001,1005,2,2500),
(3,5002,1003,1,55000),
(4,5002,1006,1,45000),
(5,5003,1002,1,65000),

(6,5003,1007,1,60000),
(7,5004,1004,1,115000),
(8,5004,1005,3,2500),
(9,5005,1008,1,85000),
(10,5005,1006,2,45000);

SELECT * FROM OrderItem

UPDATE Customer SET City='Trichy' WHERE CustomerId=5

UPDATE Product SET Price=25000 where ProductId=1006

UPDATE Orders SET OrderStatus='Shipped' where Orderid=5005

DELETE FROM OrderItem where ProductId=1008

DELETE FROM Product WHERE ProductId NOT IN
(
    SELECT ProductId
    FROM OrderItem
)

SELECT * FROM PRODUCT

SELECT * FROM Customer where city in('Chennai')
SELECT * FROM Customer where city not in('Chennai')

SELECT * FROM Product where price>50000
SELECT * FROM Product where price between 10000 and 60000
SELECT * FROM Product where Category ='Mobile' or  Category ='Laptop'

SELECT * FROM Customer where CustomerName like 'a%'
SELECT * FROM Customer where Email like '%gmail%'

SELECT * FROM Product where ProductName like '%phone%'

SELECT * FROM Orders where OrderStatus='Delivered'

SELECT * FROM Product where StockQuantity<10

SELECT * FROM Customer where MobileNo IS NOT NULL

SELECT * FROM Product where Price NOT BETWEEN 10000 and 50000

SELECT * FROM Customer where City in('Chennai','Bangalore')

SELECT * FROM Customer where city='Chennai' and IsActive=1

SELECT * FROM Customer where city <> 'Hyderabad'

SELECT  City, count(City) as Total_Cust from customer group by city

SELECT Category , count(Category) as Total_Prod from product group by Category

SELECT Category , sum(StockQuantity) as Total_Stock from product group by Category

SELECT Category ,MAX(PRICE) AS Max_Price from product group by category

SELECT Category ,Min(PRICE) AS Min_Price from product group by category

SELECT Category ,AVG(PRICE) AS Avg_Price from product group by category


SELECT c.CustomerId,c.CustomerName,SUM(oi.Quantity * oi.UnitPrice) AS TotalOrderAmount
FROM Customer c
JOIN Orders o ON c.CustomerId = o.CustomerId
JOIN OrderItem oi ON o.OrderId = oi.OrderId
GROUP BY c.CustomerId, c.CustomerName;

SELECT p.ProductId,p.ProductName,SUM(oi.Quantity * oi.UnitPrice) AS TotalSales
FROM Product p
JOIN OrderItem oi ON p.ProductId = oi.ProductId
GROUP BY p.ProductId, p.ProductName;
 
SELECT Category, COUNT(*) AS TotalProducts
FROM Product
GROUP BY Category
HAVING COUNT(*) > 1;

SELECT c.CustomerId,c.CustomerName,SUM(oi.Quantity * oi.UnitPrice) AS TotalOrderAmount
FROM Customer c
JOIN Orders o ON c.CustomerId = o.CustomerId
JOIN OrderItem oi ON o.OrderId = oi.OrderId
GROUP BY c.CustomerId, c.CustomerName
HAVING SUM(oi.Quantity * oi.UnitPrice) > 50000;

SELECT s.SellerId,s.SellerName,COUNT(p.ProductId) AS TotalProducts
FROM Seller s
JOIN Product p ON s.SellerId = p.SellerId
GROUP BY s.SellerId, s.SellerName;

SELECT s.SellerId,s.SellerName,SUM(oi.Quantity * oi.UnitPrice) AS TotalSalesAmount
FROM Seller s
JOIN Product p ON s.SellerId = p.SellerId
JOIN OrderItem oi ON p.ProductId = oi.ProductId
GROUP BY s.SellerId, s.SellerName;

SELECT OrderStatus,COUNT(*) AS TotalOrders
FROM Orders
GROUP BY OrderStatus;

SELECT City,COUNT(*) AS TotalCustomers
FROM Customer
GROUP BY City
ORDER BY TotalCustomers DESC;

SELECT * FROM Product ORDER BY Price ASC;

SELECT * FROM Product ORDER BY Price DESC;

SELECT * FROM Customer ORDER BY City ASC, CustomerName ASC;

SELECT * FROM Orders ORDER BY OrderDate DESC;

SELECT * FROM Product ORDER BY Category ASC, Price DESC;

SELECT TOP 3 * FROM Product ORDER BY Price DESC;

SELECT TOP 5 * FROM Orders ORDER BY OrderDate DESC;

SELECT * FROM Customer ORDER BY IsActive DESC, CustomerName ASC;


SELECT * FROM Orders o
INNER JOIN Customer c
ON o.CustomerId = c.CustomerId;


SELECT * FROM Product p
INNER JOIN Seller s
ON p.SellerId = s.SellerId;


SELECT * FROM OrderItem oi
INNER JOIN Product p
ON oi.ProductId = p.ProductId;

SELECT 
    c.CustomerName,
    o.OrderId,
    o.OrderDate,
    o.OrderStatus,
    p.ProductName,
    s.SellerName,
    oi.Quantity,
    oi.UnitPrice,
    (oi.Quantity * oi.UnitPrice) AS TotalAmount
FROM Customer c
INNER JOIN Orders o
    ON c.CustomerId = o.CustomerId
INNER JOIN OrderItem oi
    ON o.OrderId = oi.OrderId
INNER JOIN Product p
    ON oi.ProductId = p.ProductId
INNER JOIN Seller s
    ON p.SellerId = s.SellerId;



SELECT *
FROM Customer c
LEFT JOIN Orders o
ON c.CustomerId = o.CustomerId;


SELECT *
FROM Customer c
RIGHT JOIN Orders o
ON c.CustomerId = o.CustomerId;


SELECT *
FROM Customer c
FULL OUTER JOIN Orders o
ON c.CustomerId = o.CustomerId;



SELECT c.CustomerName,p.ProductName
FROM Customer c
CROSS JOIN Product p;



SELECT c.*
FROM Customer c LEFT JOIN Orders o
ON c.CustomerId = o.CustomerId
WHERE o.OrderId IS NULL;


SELECT p.* FROM Product p
LEFT JOIN OrderItem oi ON p.ProductId = oi.ProductId
WHERE oi.OrderItemId IS NULL;


SELECT s.SellerName,p.ProductName,p.Category,p.Price
FROM Seller s
INNER JOIN Product p ON s.SellerId = p.SellerId
ORDER BY s.SellerName;


SELECT c.CustomerName,o.OrderId,p.ProductName, oi.Quantity,oi.UnitPrice
FROM Customer c
INNER JOIN Orders o ON c.CustomerId = o.CustomerId
INNER JOIN OrderItem oi ON o.OrderId = oi.OrderId
INNER JOIN Product p ON oi.ProductId = p.ProductId
ORDER BY c.CustomerName;


SELECT o.OrderId, SUM(oi.Quantity * oi.UnitPrice) AS TotalAmount
FROM Orders o
INNER JOIN OrderItem oi
ON o.OrderId = oi.OrderId
GROUP BY o.OrderId;


SELECT s.SellerId,s.SellerName,SUM(oi.Quantity * oi.UnitPrice) AS TotalSales
FROM Seller s
INNER JOIN Product p ON s.SellerId = p.SellerId
INNER JOIN OrderItem oi ON p.ProductId = oi.ProductId
GROUP BY s.SellerId, s.SellerName;


SELECT p.ProductId,p.ProductName,SUM(oi.Quantity) AS TotalQuantitySold
FROM Product p
INNER JOIN OrderItem oi
ON p.ProductId = oi.ProductId
GROUP BY p.ProductId, p.ProductName;

-- DAY 2 ASSIGNMENT
-- SUBQUERIES

SELECT * FROM CUSTOMER
SELECT * FROM SELLER
SELECT * FROM PRODUCT
SELECT * FROM ORDERS
SELECT * FROM ORDERITEM


SELECT * FROM PRODUCT WHERE PRICE > (SELECT AVG(PRICE) FROM PRODUCT)

SELECT * FROM PRODUCT WHERE STOCKQUANTITY < (SELECT AVG(STOCKQUANTITY) FROM PRODUCT)

SELECT * FROM CUSTOMER  WHERE CUSTOMERID IN(SELECT CUSTOMERID FROM ORDERS )

SELECT * FROM CUSTOMER  WHERE CUSTOMERID NOT IN(SELECT CUSTOMERID FROM ORDERS )

SELECT * FROM PRODUCT WHERE PRODUCTID IN (SELECT PRODUCTID FROM ORDERITEM)

SELECT * FROM PRODUCT WHERE PRODUCTID NOT IN (SELECT PRODUCTID FROM ORDERITEM)

SELECT * FROM SELLER WHERE SELLERID IN (SELECT SELLERID FROM PRODUCT)

SELECT * FROM SELLER WHERE SELLERID NOT IN (SELECT SELLERID FROM PRODUCT)

SELECT * FROM ORDERS WHERE CUSTOMERID IN(SELECT CUSTOMERID FROM CUSTOMER WHERE CITY='CHENNAI')

SELECT * FROM PRODUCT WHERE SELLERID IN(SELECT SELLERID FROM SELLER WHERE CITY='BANGALORE')

SELECT * FROM CUSTOMER WHERE CUSTOMERID IN (SELECT CUSTOMERID FROM ORDERITEM)

SELECT * FROM CUSTOMER WHERE CUSTOMERID NOT IN (SELECT CUSTOMERID FROM ORDERITEM)

SELECT * FROM PRODUCT WHERE PRODUCTID IN(SELECT PRODUCTID FROM ORDERITEM)

SELECT * FROM PRODUCT WHERE PRODUCTID NOT IN(SELECT PRODUCTID FROM ORDERITEM)

SELECT * FROM SELLER WHERE SELLERID IN (SELECT SELLERID FROM PRODUCT)

SELECT * FROM SELLER WHERE SELLERID NOT IN (SELECT SELLERID FROM PRODUCT)

SELECT * FROM ORDERS WHERE ORDERID IN(SELECT ORDERID FROM ORDERITEM WHERE PRODUCTID IN(SELECT PRODUCTID FROM PRODUCT WHERE CATEGORY='MOBILE'))

SELECT * FROM ORDERS WHERE ORDERID NOT IN(SELECT ORDERID FROM ORDERITEM WHERE PRODUCTID IN(SELECT PRODUCTID FROM PRODUCT WHERE CATEGORY='LAPTOP'))

SELECT * FROM PRODUCT WHERE PRICE=(SELECT MAX(PRICE) FROM PRODUCT)

SELECT * FROM PRODUCT WHERE PRICE=(SELECT MIN(PRICE) FROM PRODUCT)

SELECT * FROM PRODUCT WHERE PRICE>(SELECT AVG(PRICE) FROM PRODUCT)

SELECT * FROM PRODUCT WHERE PRICE<(SELECT AVG(PRICE) FROM PRODUCT)

SELECT 
    c.CustomerId,
    c.CustomerName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalOrderAmount
FROM Customer c
JOIN Orders o ON c.CustomerId = o.CustomerId
JOIN OrderItem oi ON o.OrderId = oi.OrderId
GROUP BY c.CustomerId, c.CustomerName
HAVING SUM(oi.Quantity * oi.UnitPrice) >
(
    SELECT AVG(OrderTotal)
    FROM
    (
        SELECT 
            oi.OrderId,
            SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
        FROM OrderItem oi
        GROUP BY oi.OrderId
    ) AS OrderAmounts
)

SELECT
    s.SellerId,
    s.SellerName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSalesAmount
FROM Seller s
INNER JOIN Product p
    ON s.SellerId = p.SellerId
INNER JOIN OrderItem oi
    ON p.ProductId = oi.ProductId
GROUP BY
    s.SellerId,
    s.SellerName
HAVING SUM(oi.Quantity * oi.UnitPrice) > 50000;

SELECT
    p.ProductId,
    p.ProductName,
    SUM(oi.Quantity) AS TotalSoldQuantity
FROM Product p
JOIN OrderItem oi ON p.ProductId = oi.ProductId
GROUP BY p.ProductId, p.ProductName
HAVING SUM(oi.Quantity) >
(
    SELECT AVG(TotalQuantity)
    FROM
    (
        SELECT 
            ProductId,
            SUM(Quantity) AS TotalQuantity
        FROM OrderItem
        GROUP BY ProductId
    ) AS ProductQuantity
);

SELECT TOP 1
    c.CustomerId,
    c.CustomerName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
FROM Customer c
JOIN Orders o ON c.CustomerId = o.CustomerId
JOIN OrderItem oi ON o.OrderId = oi.OrderId
GROUP BY c.CustomerId, c.CustomerName
ORDER BY TotalSpent DESC;

SELECT TOP 1
    p.ProductId,
    p.ProductName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSalesAmount
FROM Product p
JOIN OrderItem oi ON p.ProductId = oi.ProductId
GROUP BY p.ProductId, p.ProductName
ORDER BY TotalSalesAmount DESC;

SELECT TOP 1
    s.SellerId,
    s.SellerName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSalesAmount
FROM Seller s
JOIN Product p ON s.SellerId = p.SellerId
JOIN OrderItem oi ON p.ProductId = oi.ProductId
GROUP BY s.SellerId, s.SellerName
ORDER BY TotalSalesAmount DESC;

SELECT *
FROM Product p
WHERE Price > (
    SELECT AVG(Price)
    FROM Product
    WHERE Category = p.Category)


SELECT *
FROM Product p
WHERE Price < (
    SELECT AVG(Price)
    FROM Product
    WHERE Category = p.Category)

SELECT *
FROM Seller s
WHERE 2 < (
    SELECT COUNT(*)
    FROM Product p
    WHERE p.SellerId = s.SellerId)

SELECT *
FROM Customer c
WHERE 1 < (
    SELECT COUNT(*)
    FROM Orders o
    WHERE o.CustomerId = c.CustomerId)

SELECT 
    o.OrderId,
    o.CustomerId,
    o.OrderDate,
    o.OrderStatus,
    o.PaymentMode,
    o.DeliveryCity,
    (
        SELECT SUM(oi.Quantity * oi.UnitPrice)
        FROM OrderItem oi
        WHERE oi.OrderId = o.OrderId
    ) AS OrderAmount
FROM Orders o
WHERE (
    SELECT SUM(oi.Quantity * oi.UnitPrice)
    FROM OrderItem oi
    WHERE oi.OrderId = o.OrderId
) >
(
    SELECT AVG(OrderAmount)
    FROM
    (
        SELECT 
            OrderId,
            SUM(Quantity * UnitPrice) AS OrderAmount
        FROM OrderItem
        GROUP BY OrderId
    ) AS OrderTotals)

SELECT * FROM Product p
WHERE StockQuantity > (SELECT AVG(StockQuantity) FROM Product WHERE Category = p.Category)

SELECT * FROM Seller s WHERE 
(SELECT AVG(p.Price) FROM Product p WHERE p.SellerId = s.SellerId) >(SELECT AVG(Price)FROM Product)


SELECT *
FROM Customer c
WHERE EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.CustomerId = c.CustomerId
)


SELECT *
FROM Customer c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.CustomerId = c.CustomerId
);


SELECT *
FROM Product p
WHERE EXISTS
(
    SELECT 1
    FROM OrderItem oi
    WHERE oi.ProductId = p.ProductId
)


SELECT *
FROM Product p
WHERE NOT EXISTS
(
    SELECT 1
    FROM OrderItem oi
    WHERE oi.ProductId = p.ProductId
)


SELECT *
FROM Seller s
WHERE EXISTS
(
    SELECT 1
    FROM Product p
    WHERE p.SellerId = s.SellerId
)


SELECT *
FROM Seller s
WHERE NOT EXISTS
(
    SELECT 1
    FROM Product p
    WHERE p.SellerId = s.SellerId
)

SELECT *
FROM Customer c
WHERE EXISTS
(
    SELECT 1
    FROM Orders o
    JOIN OrderItem oi
        ON o.OrderId = oi.OrderId
    JOIN Product p
        ON oi.ProductId = p.ProductId
    WHERE o.CustomerId = c.CustomerId
    AND p.Category = 'Mobile'
)


SELECT *
FROM Customer c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Orders o
    JOIN OrderItem oi
        ON o.OrderId = oi.OrderId
    JOIN Product p
        ON oi.ProductId = p.ProductId
    WHERE o.CustomerId = c.CustomerId
    AND p.Category = 'Laptop'
)


CREATE OR ALTER PROCEDURE sp_DisplayAllCustomers
AS
BEGIN
    SELECT * FROM Customer;
END;
GO


CREATE OR ALTER PROCEDURE sp_DisplayAllProducts
AS
BEGIN
    SELECT * FROM Product;
END;
GO


CREATE OR ALTER PROCEDURE sp_DisplayAllSellers
AS
BEGIN
    SELECT * FROM Seller;
END;
GO

CREATE OR ALTER PROCEDURE sp_DisplayAllOrders
AS
BEGIN
    SELECT * FROM Orders;
END;
GO


CREATE OR ALTER PROCEDURE sp_DisplayAllOrderItems
AS
BEGIN
    SELECT * FROM OrderItem;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetCustomerById
    @CustomerId INT
AS
BEGIN
    SELECT * FROM Customer
    WHERE CustomerId = @CustomerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetProductById
    @ProductId INT
AS
BEGIN
    SELECT * FROM Product
    WHERE ProductId = @ProductId;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetSellerById
    @SellerId INT
AS
BEGIN
    SELECT * FROM Seller
    WHERE SellerId = @SellerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetOrderById
    @OrderId INT
AS
BEGIN
    SELECT * FROM Orders
    WHERE OrderId = @OrderId;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetCustomersByCity
    @City VARCHAR(50)
AS
BEGIN
    SELECT * FROM Customer
    WHERE City = @City;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetProductsByCategory
    @Category VARCHAR(50)
AS
BEGIN
    SELECT * FROM Product
    WHERE Category = @Category;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetProductsBySellerId
    @SellerId INT
AS
BEGIN
    SELECT * FROM Product
    WHERE SellerId = @SellerId;
END;
GO

CREATE OR ALTER PROCEDURE sp_GetOrdersByCustomerId
    @CustomerId INT
AS
BEGIN
    SELECT * FROM Orders
    WHERE CustomerId = @CustomerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetOrderItemsByOrderId
    @OrderId INT
AS
BEGIN
    SELECT * FROM OrderItem
    WHERE OrderId = @OrderId;
END;
GO

-- 15
CREATE OR ALTER PROCEDURE sp_GetProductsGreaterThanPrice
    @Price DECIMAL(10,2)
AS
BEGIN
    SELECT * FROM Product
    WHERE Price > @Price;
END;
GO



CREATE OR ALTER PROCEDURE sp_InsertCustomer
    @CustomerId INT,
    @CustomerName VARCHAR(100),
    @Email VARCHAR(100),
    @MobileNo VARCHAR(15),
    @City VARCHAR(50),
    @Address VARCHAR(200),
    @IsActive BIT,
    @CreatedDate DATE
AS
BEGIN
    INSERT INTO Customer
    VALUES
    (@CustomerId,@CustomerName,@Email,@MobileNo,@City,@Address,@IsActive,@CreatedDate);
END;
GO



CREATE OR ALTER PROCEDURE sp_InsertSeller
    @SellerId INT,
    @SellerName VARCHAR(100),
    @Email VARCHAR(100),
    @MobileNo VARCHAR(15),
    @City VARCHAR(50),
    @Rating DECIMAL(3,2),
    @IsActive BIT
AS
BEGIN
    INSERT INTO Seller
    VALUES
    (@SellerId,@SellerName,@Email,@MobileNo,@City,@Rating,@IsActive);
END;
GO



CREATE OR ALTER PROCEDURE sp_InsertProduct
    @ProductId INT,
    @ProductName VARCHAR(100),
    @Category VARCHAR(50),
    @Price DECIMAL(10,2),
    @StockQuantity INT,
    @SellerId INT,
    @CreatedDate DATE
AS
BEGIN
    INSERT INTO Product
    VALUES
    (@ProductId,@ProductName,@Category,@Price,@StockQuantity,@SellerId,@CreatedDate);
END;
GO


CREATE OR ALTER PROCEDURE sp_InsertOrder
    @OrderId INT,
    @CustomerId INT,
    @OrderDate DATE,
    @OrderStatus VARCHAR(50),
    @PaymentMode VARCHAR(50),
    @DeliveryCity VARCHAR(50)
AS
BEGIN
    INSERT INTO Orders
    VALUES
    (@OrderId,@CustomerId,@OrderDate,@OrderStatus,@PaymentMode,@DeliveryCity);
END;
GO


CREATE OR ALTER PROCEDURE sp_InsertOrderItem
    @OrderItemId INT,
    @OrderId INT,
    @ProductId INT,
    @Quantity INT,
    @UnitPrice DECIMAL(10,2)
AS
BEGIN
    INSERT INTO OrderItem
    VALUES
    (@OrderItemId,@OrderId,@ProductId,@Quantity,@UnitPrice);
END;
GO


CREATE OR ALTER PROCEDURE sp_UpdateCustomerCity
    @CustomerId INT,
    @City VARCHAR(50)
AS
BEGIN
    UPDATE Customer
    SET City = @City
    WHERE CustomerId = @CustomerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_UpdateCustomerMobile
    @CustomerId INT,
    @MobileNo VARCHAR(15)
AS
BEGIN
    UPDATE Customer
    SET MobileNo = @MobileNo
    WHERE CustomerId = @CustomerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_UpdateProductPrice
    @ProductId INT,
    @Price DECIMAL(10,2)
AS
BEGIN
    UPDATE Product
    SET Price = @Price
    WHERE ProductId = @ProductId;
END;
GO



CREATE OR ALTER PROCEDURE sp_UpdateProductStock
    @ProductId INT,
    @StockQuantity INT
AS
BEGIN
    UPDATE Product
    SET StockQuantity = @StockQuantity
    WHERE ProductId = @ProductId;
END;
GO


CREATE OR ALTER PROCEDURE sp_UpdateOrderStatus
    @OrderId INT,
    @OrderStatus VARCHAR(50)
AS
BEGIN
    UPDATE Orders
    SET OrderStatus = @OrderStatus
    WHERE OrderId = @OrderId;
END;
GO


CREATE OR ALTER PROCEDURE sp_UpdateSellerRating
    @SellerId INT,
    @Rating DECIMAL(3,2)
AS
BEGIN
    UPDATE Seller
    SET Rating = @Rating
    WHERE SellerId = @SellerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_UpdateCustomerStatus
    @CustomerId INT,
    @IsActive BIT
AS
BEGIN
    UPDATE Customer
    SET IsActive = @IsActive
    WHERE CustomerId = @CustomerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_UpdateSellerStatus
    @SellerId INT,
    @IsActive BIT
AS
BEGIN
    UPDATE Seller
    SET IsActive = @IsActive
    WHERE SellerId = @SellerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_DeleteCustomer
    @CustomerId INT
AS
BEGIN
    DELETE FROM Customer
    WHERE CustomerId = @CustomerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_DeleteSeller
    @SellerId INT
AS
BEGIN
    DELETE FROM Seller
    WHERE SellerId = @SellerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_DeleteProduct
    @ProductId INT
AS
BEGIN
    DELETE FROM Product
    WHERE ProductId = @ProductId;
END;
GO




CREATE OR ALTER PROCEDURE sp_DeleteOrder
    @OrderId INT
AS
BEGIN
    DELETE FROM Orders
    WHERE OrderId = @OrderId;
END;
GO




CREATE OR ALTER PROCEDURE sp_DeleteOrderItem
    @OrderItemId INT
AS
BEGIN
    DELETE FROM OrderItem
    WHERE OrderItemId = @OrderItemId;
END;
GO


CREATE OR ALTER PROCEDURE sp_CustomerWiseOrderDetails
AS
BEGIN
    SELECT 
        c.CustomerId,
        c.CustomerName,
        o.OrderId,
        o.OrderDate,
        o.OrderStatus,
        o.PaymentMode,
        o.DeliveryCity
    FROM Customer c
    INNER JOIN Orders o ON c.CustomerId = o.CustomerId;
END;
GO


CREATE OR ALTER PROCEDURE sp_SellerWiseProductDetails
AS
BEGIN
    SELECT
        s.SellerId,
        s.SellerName,
        p.ProductId,
        p.ProductName,
        p.Category,
        p.Price,
        p.StockQuantity
    FROM Seller s
    INNER JOIN Product p ON s.SellerId = p.SellerId;
END;
GO



CREATE OR ALTER PROCEDURE sp_OrderWiseProductDetails
AS
BEGIN
    SELECT
        o.OrderId,
        o.OrderDate,
        p.ProductId,
        p.ProductName,
        oi.Quantity,
        oi.UnitPrice
    FROM Orders o
    INNER JOIN OrderItem oi ON o.OrderId = oi.OrderId
    INNER JOIN Product p ON oi.ProductId = p.ProductId;
END;
GO



CREATE OR ALTER PROCEDURE sp_CompleteOrderReport
AS
BEGIN
    SELECT
        c.CustomerName,
        o.OrderId,
        p.ProductName,
        s.SellerName,
        oi.Quantity,
        oi.UnitPrice,
        (oi.Quantity * oi.UnitPrice) AS TotalAmount
    FROM Customer c
    INNER JOIN Orders o ON c.CustomerId = o.CustomerId
    INNER JOIN OrderItem oi ON o.OrderId = oi.OrderId
    INNER JOIN Product p ON oi.ProductId = p.ProductId
    INNER JOIN Seller s ON p.SellerId = s.SellerId;
END;
GO



CREATE OR ALTER PROCEDURE sp_CustomerWiseTotalOrderAmount
AS
BEGIN
    SELECT
        c.CustomerId,
        c.CustomerName,
        SUM(oi.Quantity * oi.UnitPrice) AS TotalOrderAmount
    FROM Customer c
    INNER JOIN Orders o ON c.CustomerId = o.CustomerId
    INNER JOIN OrderItem oi ON o.OrderId = oi.OrderId
    GROUP BY c.CustomerId, c.CustomerName;
END;
GO



CREATE OR ALTER PROCEDURE sp_SellerWiseTotalSalesAmount
AS
BEGIN
    SELECT
        s.SellerId,
        s.SellerName,
        SUM(oi.Quantity * oi.UnitPrice) AS TotalSalesAmount
    FROM Seller s
    INNER JOIN Product p ON s.SellerId = p.SellerId
    INNER JOIN OrderItem oi ON p.ProductId = oi.ProductId
    GROUP BY s.SellerId, s.SellerName;
END;
GO


CREATE OR ALTER PROCEDURE sp_ProductWiseTotalSalesQuantity
AS
BEGIN
    SELECT
        p.ProductId,
        p.ProductName,
        SUM(oi.Quantity) AS TotalSalesQuantity
    FROM Product p
    INNER JOIN OrderItem oi ON p.ProductId = oi.ProductId
    GROUP BY p.ProductId, p.ProductName;
END;
GO



CREATE OR ALTER PROCEDURE sp_GetTotalCustomers
    @TotalCustomers INT OUTPUT
AS
BEGIN
    SELECT @TotalCustomers = COUNT(*)
    FROM Customer;
END;
GO



CREATE OR ALTER PROCEDURE sp_GetTotalProducts
    @TotalProducts INT OUTPUT
AS
BEGIN
    SELECT @TotalProducts = COUNT(*)
    FROM Product;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetTotalOrders
    @TotalOrders INT OUTPUT
AS
BEGIN
    SELECT @TotalOrders = COUNT(*)
    FROM Orders;
END;
GO



CREATE OR ALTER PROCEDURE sp_GetProductTotalSales
    @ProductId INT,
    @TotalSales DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @TotalSales = ISNULL(SUM(Quantity * UnitPrice), 0)
    FROM OrderItem
    WHERE ProductId = @ProductId;
END;
GO


CREATE OR ALTER PROCEDURE sp_GetCustomerTotalPurchase
    @CustomerId INT,
    @TotalPurchase DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @TotalPurchase = ISNULL(SUM(oi.Quantity * oi.UnitPrice), 0)
    FROM Orders o
    INNER JOIN OrderItem oi ON o.OrderId = oi.OrderId
    WHERE o.CustomerId = @CustomerId;
END;
GO
