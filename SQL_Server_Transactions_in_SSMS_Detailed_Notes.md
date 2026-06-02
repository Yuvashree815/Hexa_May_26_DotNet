# SQL Server Transactions in SSMS — Detailed Notes with Real-Time Use Case

## 1. What is a Transaction in SQL Server?

A **transaction** is a group of SQL operations treated as **one single unit of work**.

That means:

```sql
Either all statements should succeed
OR
all statements should fail and rollback
```

A transaction follows the **ACID** properties:

| Property | Meaning |
|---|---|
| Atomicity | All operations complete or none complete |
| Consistency | Data should remain valid before and after transaction |
| Isolation | One transaction should not wrongly affect another transaction |
| Durability | Once committed, data is permanently saved |

---

## 2. Why do we use Transactions?

We use transactions to protect data from becoming incorrect or incomplete.

### Real-time example

Imagine an **online shopping application**.

When a customer places an order:

1. Insert order details
2. Insert order items
3. Reduce product stock
4. Insert payment details

All these steps are connected.

If payment insertion fails, but stock is already reduced, then your data becomes wrong.

So we use a transaction:

```text
If all steps succeed → COMMIT
If any step fails → ROLLBACK
```

---

## 3. When to use Transactions in SSMS?

Use transactions when multiple SQL operations depend on each other.

Common scenarios:

| Scenario | Why Transaction is Needed |
|---|---|
| Bank money transfer | Debit and credit must both happen |
| Online order placement | Order, stock, and payment must be saved together |
| Employee salary update | Salary and audit record should both be saved |
| Inventory management | Stock should not become negative |
| Booking system | Seat booking and payment must be consistent |

---

## 4. Real-time Use Case: Online Order Processing

We will create a small e-commerce database.

### Business Rule

A customer buys a product.

The system should:

1. Create an order
2. Create order item
3. Reduce product stock
4. Insert payment
5. If anything fails, revert everything

---

## 5. Create Database from Scratch

Open SSMS and run this script.

```sql
CREATE DATABASE TransactionDemoDB;
GO

USE TransactionDemoDB;
GO
```

---

## 6. Create Tables

### Customers Table

```sql
CREATE TABLE Customers
(
    CustomerId INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL
);
GO
```

### Products Table

```sql
CREATE TABLE Products
(
    ProductId INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL
);
GO
```

### Orders Table

```sql
CREATE TABLE Orders
(
    OrderId INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL,
    OrderStatus VARCHAR(50) NOT NULL,

    CONSTRAINT FK_Orders_Customers
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);
GO
```

### OrderItems Table

```sql
CREATE TABLE OrderItems
(
    OrderItemId INT PRIMARY KEY IDENTITY(1,1),
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_OrderItems_Orders
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),

    CONSTRAINT FK_OrderItems_Products
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
GO
```

### Payments Table

```sql
CREATE TABLE Payments
(
    PaymentId INT PRIMARY KEY IDENTITY(1,1),
    OrderId INT NOT NULL,
    PaymentAmount DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(50) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Payments_Orders
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
);
GO
```

---

## 7. Insert Sample Data

```sql
INSERT INTO Customers (CustomerName, Email)
VALUES
('Arun Kumar', 'arun@gmail.com'),
('Priya Sharma', 'priya@gmail.com');

INSERT INTO Products (ProductName, Price, StockQuantity)
VALUES
('Laptop', 55000, 10),
('Mouse', 700, 50),
('Keyboard', 1500, 30);
GO
```

Check data:

```sql
SELECT * FROM Customers;
SELECT * FROM Products;
```

---

## 8. Implementing Transactions

### Basic Transaction Syntax

```sql
BEGIN TRANSACTION;

-- SQL statements

COMMIT TRANSACTION;
```

If everything is successful, use:

```sql
COMMIT TRANSACTION;
```

If something goes wrong, use:

```sql
ROLLBACK TRANSACTION;
```

---

## 9. Creating Transactions: Successful Order Example

### Scenario

Customer Arun buys 2 laptops.

Laptop price = 55000  
Quantity = 2  
Total = 110000

```sql
USE TransactionDemoDB;
GO

BEGIN TRANSACTION;

DECLARE @CustomerId INT = 1;
DECLARE @ProductId INT = 1;
DECLARE @Quantity INT = 2;
DECLARE @UnitPrice DECIMAL(10,2);
DECLARE @TotalAmount DECIMAL(10,2);
DECLARE @OrderId INT;

SELECT @UnitPrice = Price
FROM Products
WHERE ProductId = @ProductId;

SET @TotalAmount = @UnitPrice * @Quantity;

INSERT INTO Orders (CustomerId, TotalAmount, OrderStatus)
VALUES (@CustomerId, @TotalAmount, 'Confirmed');

SET @OrderId = SCOPE_IDENTITY();

INSERT INTO OrderItems (OrderId, ProductId, Quantity, UnitPrice)
VALUES (@OrderId, @ProductId, @Quantity, @UnitPrice);

UPDATE Products
SET StockQuantity = StockQuantity - @Quantity
WHERE ProductId = @ProductId;

INSERT INTO Payments (OrderId, PaymentAmount, PaymentStatus)
VALUES (@OrderId, @TotalAmount, 'Paid');

COMMIT TRANSACTION;
GO
```

Check output:

```sql
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM Payments;
SELECT * FROM Products;
```

Now product stock should reduce from:

```text
10 to 8
```

---

## 10. Creating Transactions Continued: Using TRY...CATCH

The above transaction works, but if an error happens, SQL Server will not automatically rollback in all cases.

So the professional way is to use:

```sql
BEGIN TRY
    BEGIN TRANSACTION;

    -- SQL statements

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

    -- Show error
END CATCH
```

---

## 11. Reverting Transactions Using ROLLBACK

### Scenario

Customer Priya tries to buy 100 laptops, but only 8 laptops are available.

We should not allow this order.

```sql
USE TransactionDemoDB;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @CustomerId INT = 2;
    DECLARE @ProductId INT = 1;
    DECLARE @Quantity INT = 100;
    DECLARE @AvailableStock INT;
    DECLARE @UnitPrice DECIMAL(10,2);
    DECLARE @TotalAmount DECIMAL(10,2);
    DECLARE @OrderId INT;

    SELECT 
        @AvailableStock = StockQuantity,
        @UnitPrice = Price
    FROM Products
    WHERE ProductId = @ProductId;

    IF @AvailableStock < @Quantity
    BEGIN
        RAISERROR('Insufficient stock. Order cannot be placed.', 16, 1);
    END

    SET @TotalAmount = @UnitPrice * @Quantity;

    INSERT INTO Orders (CustomerId, TotalAmount, OrderStatus)
    VALUES (@CustomerId, @TotalAmount, 'Confirmed');

    SET @OrderId = SCOPE_IDENTITY();

    INSERT INTO OrderItems (OrderId, ProductId, Quantity, UnitPrice)
    VALUES (@OrderId, @ProductId, @Quantity, @UnitPrice);

    UPDATE Products
    SET StockQuantity = StockQuantity - @Quantity
    WHERE ProductId = @ProductId;

    INSERT INTO Payments (OrderId, PaymentAmount, PaymentStatus)
    VALUES (@OrderId, @TotalAmount, 'Paid');

    COMMIT TRANSACTION;

    PRINT 'Order placed successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

    PRINT 'Transaction failed. All changes reverted.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO
```

Check data:

```sql
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM Payments;
SELECT * FROM Products;
```

The failed order should not be saved.

That is the purpose of `ROLLBACK`.

---

## 12. Implementing Transactional Integrity

Transactional integrity means your database remains correct even if an error happens in the middle.

### Example without Transaction

```sql
INSERT INTO Orders (CustomerId, TotalAmount, OrderStatus)
VALUES (1, 700, 'Confirmed');

UPDATE Products
SET StockQuantity = StockQuantity - 1
WHERE ProductId = 2;
```

Problem:

If order insertion succeeds but stock update fails, data becomes inconsistent.

### Example with Transactional Integrity

```sql
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Orders (CustomerId, TotalAmount, OrderStatus)
    VALUES (1, 700, 'Confirmed');

    UPDATE Products
    SET StockQuantity = StockQuantity - 1
    WHERE ProductId = 2;

    COMMIT TRANSACTION;

    PRINT 'Transaction completed successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

    PRINT 'Transaction failed and reverted.';
    PRINT ERROR_MESSAGE();
END CATCH;
```

Here both actions are protected.

---

## 13. Savepoints in Transactions

Sometimes we do not want to rollback the entire transaction. We may want to rollback only part of it.

For that, SQL Server provides:

```sql
SAVE TRANSACTION SavePointName;
```

### Example

```sql
BEGIN TRANSACTION;

INSERT INTO Customers (CustomerName, Email)
VALUES ('Test Customer 1', 'test1@gmail.com');

SAVE TRANSACTION SavePoint1;

INSERT INTO Customers (CustomerName, Email)
VALUES ('Test Customer 2', 'test2@gmail.com');

ROLLBACK TRANSACTION SavePoint1;

COMMIT TRANSACTION;
GO
```

Check:

```sql
SELECT * FROM Customers;
```

Result:

```text
Test Customer 1 will be saved.
Test Customer 2 will be rolled back.
```

---

## 14. @@TRANCOUNT

`@@TRANCOUNT` shows the number of active transactions in the current session.

```sql
SELECT @@TRANCOUNT AS ActiveTransactions;
```

Example:

```sql
BEGIN TRANSACTION;

SELECT @@TRANCOUNT AS ActiveTransactions;

COMMIT TRANSACTION;

SELECT @@TRANCOUNT AS ActiveTransactions;
```

---

## 15. XACT_STATE()

`XACT_STATE()` tells the current transaction state.

| Value | Meaning |
|---|---|
| 1 | Transaction is active and can be committed |
| 0 | No active transaction |
| -1 | Transaction is active but cannot be committed, only rollback is allowed |

Example:

```sql
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Orders (CustomerId, TotalAmount, OrderStatus)
    VALUES (999, 5000, 'Confirmed');

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
    BEGIN
        ROLLBACK TRANSACTION;
    END

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        XACT_STATE() AS TransactionState;
END CATCH;
```

Here `CustomerId = 999` does not exist, so foreign key error will occur.

---

## 16. Resolving Deadlocks

### What is a Deadlock?

A **deadlock** happens when two transactions wait for each other permanently.

Example:

```text
Transaction 1 locks Product table and waits for Orders table.
Transaction 2 locks Orders table and waits for Product table.
```

SQL Server detects the deadlock and automatically kills one transaction as the deadlock victim.

Error message usually looks like:

```text
Transaction was deadlocked on lock resources with another process and has been chosen as the deadlock victim.
```

---

## 17. Deadlock Example in SSMS

To understand deadlock, open **two query windows** in SSMS.

### Query Window 1

Run this first:

```sql
USE TransactionDemoDB;
GO

BEGIN TRANSACTION;

UPDATE Products
SET StockQuantity = StockQuantity - 1
WHERE ProductId = 1;

WAITFOR DELAY '00:00:10';

UPDATE Orders
SET OrderStatus = 'Processing'
WHERE OrderId = 1;

COMMIT TRANSACTION;
```

### Query Window 2

Immediately run this in another query window:

```sql
USE TransactionDemoDB;
GO

BEGIN TRANSACTION;

UPDATE Orders
SET OrderStatus = 'Packed'
WHERE OrderId = 1;

WAITFOR DELAY '00:00:10';

UPDATE Products
SET StockQuantity = StockQuantity - 1
WHERE ProductId = 1;

COMMIT TRANSACTION;
```

### What happens?

Window 1 locks `Products`.

Window 2 locks `Orders`.

Then:

```text
Window 1 waits for Orders
Window 2 waits for Products
```

This creates a deadlock.

SQL Server will kill one transaction.

---

## 18. How to Resolve Deadlocks

### Method 1: Access tables in same order

This is the best solution.

Both transactions should update tables in the same order.

Correct order:

```text
1. Products
2. Orders
```

So both transactions should follow the same order.

### Corrected Query Window 1

```sql
USE TransactionDemoDB;
GO

BEGIN TRANSACTION;

UPDATE Products
SET StockQuantity = StockQuantity - 1
WHERE ProductId = 1;

UPDATE Orders
SET OrderStatus = 'Processing'
WHERE OrderId = 1;

COMMIT TRANSACTION;
```

### Corrected Query Window 2

```sql
USE TransactionDemoDB;
GO

BEGIN TRANSACTION;

UPDATE Products
SET StockQuantity = StockQuantity - 1
WHERE ProductId = 1;

UPDATE Orders
SET OrderStatus = 'Packed'
WHERE OrderId = 1;

COMMIT TRANSACTION;
```

Now deadlock chance is reduced.

---

## 19. Method 2: Keep Transactions Short

Avoid writing long transactions like this:

```sql
BEGIN TRANSACTION;

UPDATE Products
SET StockQuantity = StockQuantity - 1
WHERE ProductId = 1;

WAITFOR DELAY '00:01:00';

UPDATE Orders
SET OrderStatus = 'Packed'
WHERE OrderId = 1;

COMMIT TRANSACTION;
```

Problem:

```text
It holds locks for long time.
Other users must wait.
Deadlock chance increases.
```

---

## 20. Method 3: Use Proper WHERE Conditions

Bad query:

```sql
UPDATE Products
SET StockQuantity = StockQuantity - 1;
```

This updates and locks all rows.

Good query:

```sql
UPDATE Products
SET StockQuantity = StockQuantity - 1
WHERE ProductId = 1;
```

This locks only required rows.

---

## 21. Method 4: Use TRY...CATCH and Retry Logic

If a deadlock occurs, SQL Server gives error number:

```text
1205
```

You can handle it.

```sql
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Products
    SET StockQuantity = StockQuantity - 1
    WHERE ProductId = 1;

    UPDATE Orders
    SET OrderStatus = 'Packed'
    WHERE OrderId = 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
    BEGIN
        ROLLBACK TRANSACTION;
    END

    IF ERROR_NUMBER() = 1205
    BEGIN
        PRINT 'Deadlock occurred. Please retry the transaction.';
    END
    ELSE
    BEGIN
        PRINT ERROR_MESSAGE();
    END
END CATCH;
```

---

## 22. Method 5: Use Indexes Properly

If there is no index, SQL Server may scan and lock more rows.

For example, `ProductId` is already primary key, so it has an index.

But for columns frequently used in `WHERE`, create indexes.

Example:

```sql
CREATE INDEX IX_Orders_CustomerId
ON Orders(CustomerId);
```

This helps SQL Server find rows quickly and lock fewer records.

---

## 23. Final Professional Transaction Example

This is a complete stored procedure for placing an order safely.

```sql
CREATE OR ALTER PROCEDURE usp_PlaceOrder
    @CustomerId INT,
    @ProductId INT,
    @Quantity INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @AvailableStock INT;
        DECLARE @UnitPrice DECIMAL(10,2);
        DECLARE @TotalAmount DECIMAL(10,2);
        DECLARE @OrderId INT;

        SELECT 
            @AvailableStock = StockQuantity,
            @UnitPrice = Price
        FROM Products
        WHERE ProductId = @ProductId;

        IF @AvailableStock IS NULL
        BEGIN
            RAISERROR('Invalid product id.', 16, 1);
        END

        IF @AvailableStock < @Quantity
        BEGIN
            RAISERROR('Insufficient stock.', 16, 1);
        END

        SET @TotalAmount = @UnitPrice * @Quantity;

        INSERT INTO Orders (CustomerId, TotalAmount, OrderStatus)
        VALUES (@CustomerId, @TotalAmount, 'Confirmed');

        SET @OrderId = SCOPE_IDENTITY();

        INSERT INTO OrderItems (OrderId, ProductId, Quantity, UnitPrice)
        VALUES (@OrderId, @ProductId, @Quantity, @UnitPrice);

        UPDATE Products
        SET StockQuantity = StockQuantity - @Quantity
        WHERE ProductId = @ProductId;

        INSERT INTO Payments (OrderId, PaymentAmount, PaymentStatus)
        VALUES (@OrderId, @TotalAmount, 'Paid');

        COMMIT TRANSACTION;

        SELECT 
            @OrderId AS OrderId,
            'Order placed successfully.' AS Message;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage,
            'Transaction failed. All changes reverted.' AS StatusMessage;
    END CATCH
END;
GO
```

---

## 24. Execute the Stored Procedure

### Successful Order

```sql
EXEC usp_PlaceOrder
    @CustomerId = 1,
    @ProductId = 2,
    @Quantity = 3;
```

### Failed Order

```sql
EXEC usp_PlaceOrder
    @CustomerId = 1,
    @ProductId = 1,
    @Quantity = 1000;
```

The failed order should rollback automatically.

---

## 25. Check Final Data

```sql
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM Payments;
```

---

## 26. Important Transaction Commands Summary

| Command | Use |
|---|---|
| `BEGIN TRANSACTION` | Starts a transaction |
| `COMMIT TRANSACTION` | Permanently saves changes |
| `ROLLBACK TRANSACTION` | Reverts changes |
| `SAVE TRANSACTION` | Creates savepoint |
| `@@TRANCOUNT` | Shows active transaction count |
| `XACT_STATE()` | Shows transaction state |
| `TRY...CATCH` | Handles errors safely |
| `ERROR_MESSAGE()` | Displays actual error message |
| `ERROR_NUMBER()` | Shows SQL Server error number |

---

## 27. Simple Trainer Explanation

You can explain transactions like this:

```text
A transaction is like an online payment process.

If money is debited from the customer but order is not created, that is a serious problem.

So all related operations are grouped inside a transaction.

If all operations succeed, we commit.

If any one operation fails, we rollback.

This keeps the database safe and consistent.
```

---

## 28. Assignment Questions for Practice

1. Create a database named `BankTransactionDB`.
2. Create an `Accounts` table with `AccountId`, `AccountHolderName`, and `Balance`.
3. Insert two accounts.
4. Write a transaction to transfer ₹5000 from Account 1 to Account 2.
5. If Account 1 does not have enough balance, rollback the transaction.
6. Create a transaction using `TRY...CATCH`.
7. Use `COMMIT` for successful transfer.
8. Use `ROLLBACK` for failed transfer.
9. Create a deadlock example using two SSMS query windows.
10. Resolve the deadlock by accessing tables in the same order.
