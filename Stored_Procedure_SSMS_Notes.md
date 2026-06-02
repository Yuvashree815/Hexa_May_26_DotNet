# Stored Procedure in SQL Server / SSMS

## What is a Stored Procedure?

A **Stored Procedure** is a saved SQL program inside SQL Server. Instead of writing the same SQL query again and again, we can save it once as a procedure and execute it whenever needed.

Example idea:

```sql
SELECT * FROM Employees;
```

Instead of writing this every time, we can create:

```sql
EXEC sp_GetAllEmployees;
```

---

## 1. Why use Stored Procedure?

Stored procedures are useful because they help us:

| Purpose | Explanation |
|---|---|
| Reuse SQL code | Write once, execute many times |
| Improve security | Users can execute procedure without directly accessing table |
| Reduce mistakes | Logic is written in one place |
| Accept input values | Example: get employee by department |
| Perform insert/update/delete | CRUD operations can be done |
| Use conditions | `IF ELSE` can be used |
| Use loops | `WHILE` loop can be used |
| Return output values | Use output parameters |
| Handle errors | Use `TRY...CATCH` |
| Use transactions | Commit or rollback operations |

---

## 2. Your Current Tables

You have two tables:

```sql
Employees
Department
```

Relationship:

```sql
Employees.DepartmentId = Department.DepartmentId
```

Example columns:

```text
Employees:
EmployeeId, Name, Gender, City, Salary, Email, MobileNo, DepartmentId

Department:
DepartmentId, DepartmentName, Location
```

---

## 3. Basic Syntax of Stored Procedure

```sql
CREATE PROCEDURE ProcedureName
AS
BEGIN
    SQL statements
END;
```

To execute:

```sql
EXEC ProcedureName;
```

---

## 4. Stored Procedure to Get All Employees

```sql
CREATE PROCEDURE sp_GetAllEmployees
AS
BEGIN
    SELECT * FROM Employees;
END;
```

Execute:

```sql
EXEC sp_GetAllEmployees;
```

---

## 5. Stored Procedure with JOIN

This procedure shows employee details along with department name.

```sql
CREATE PROCEDURE sp_GetEmployeeWithDepartment
AS
BEGIN
    SELECT 
        e.EmployeeId,
        e.Name,
        e.Gender,
        e.City,
        e.Salary,
        e.Email,
        e.MobileNo,
        d.DepartmentName,
        d.Location
    FROM Employees e
    INNER JOIN Department d
        ON e.DepartmentId = d.DepartmentId;
END;
```

Execute:

```sql
EXEC sp_GetEmployeeWithDepartment;
```

---

## 6. Stored Procedure with Input Parameter

Input parameter means we can pass a value to the procedure.

Example: Get employees by city.

```sql
CREATE PROCEDURE sp_GetEmployeesByCity
    @City VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE City = @City;
END;
```

Execute:

```sql
EXEC sp_GetEmployeesByCity 'Chennai';
```

or

```sql
EXEC sp_GetEmployeesByCity @City = 'Mumbai';
```

---

## 7. Stored Procedure to Get Employees by Department

```sql
CREATE PROCEDURE sp_GetEmployeesByDepartment
    @DepartmentName VARCHAR(100)
AS
BEGIN
    SELECT 
        e.EmployeeId,
        e.Name,
        e.City,
        e.Salary,
        d.DepartmentName,
        d.Location
    FROM Employees e
    INNER JOIN Department d
        ON e.DepartmentId = d.DepartmentId
    WHERE d.DepartmentName = @DepartmentName;
END;
```

Execute:

```sql
EXEC sp_GetEmployeesByDepartment 'IT';
```

---

## 8. Stored Procedure for INSERT

This procedure inserts a new employee.

```sql
CREATE PROCEDURE sp_InsertEmployee
    @Name VARCHAR(100),
    @Gender VARCHAR(10),
    @City VARCHAR(50),
    @Salary MONEY,
    @Email VARCHAR(50),
    @MobileNo BIGINT,
    @DepartmentId INT
AS
BEGIN
    INSERT INTO Employees
    (
        Name,
        Gender,
        City,
        Salary,
        Email,
        MobileNo,
        DepartmentId
    )
    VALUES
    (
        @Name,
        @Gender,
        @City,
        @Salary,
        @Email,
        @MobileNo,
        @DepartmentId
    );
END;
```

Execute:

```sql
EXEC sp_InsertEmployee
    @Name = 'Karthik',
    @Gender = 'Male',
    @City = 'Coimbatore',
    @Salary = 42000,
    @Email = 'karthik@mail.com',
    @MobileNo = 9876543220,
    @DepartmentId = 2;
```

---

## 9. Stored Procedure for UPDATE

This procedure updates employee salary.

```sql
CREATE PROCEDURE sp_UpdateEmployeeSalary
    @EmployeeId INT,
    @Salary MONEY
AS
BEGIN
    UPDATE Employees
    SET Salary = @Salary
    WHERE EmployeeId = @EmployeeId;
END;
```

Execute:

```sql
EXEC sp_UpdateEmployeeSalary
    @EmployeeId = 1,
    @Salary = 45000;
```

---

## 10. Stored Procedure for DELETE

This procedure deletes an employee by `EmployeeId`.

```sql
CREATE PROCEDURE sp_DeleteEmployee
    @EmployeeId INT
AS
BEGIN
    DELETE FROM Employees
    WHERE EmployeeId = @EmployeeId;
END;
```

Execute:

```sql
EXEC sp_DeleteEmployee @EmployeeId = 8;
```

---

## 11. Stored Procedure with IF ELSE

Example: Check employee salary category.

```sql
CREATE PROCEDURE sp_CheckSalaryCategory
    @EmployeeId INT
AS
BEGIN
    DECLARE @Salary MONEY;

    SELECT @Salary = Salary
    FROM Employees
    WHERE EmployeeId = @EmployeeId;

    IF @Salary >= 40000
    BEGIN
        SELECT 'High Salary Employee' AS SalaryCategory;
    END
    ELSE
    BEGIN
        SELECT 'Normal Salary Employee' AS SalaryCategory;
    END
END;
```

Execute:

```sql
EXEC sp_CheckSalaryCategory @EmployeeId = 1;
```

---

## 12. Stored Procedure with Output Parameter

Output parameter returns a value from procedure.

Example: Get total employees in a department.

```sql
CREATE PROCEDURE sp_GetEmployeeCountByDepartment
    @DepartmentId INT,
    @TotalEmployees INT OUTPUT
AS
BEGIN
    SELECT @TotalEmployees = COUNT(*)
    FROM Employees
    WHERE DepartmentId = @DepartmentId;
END;
```

Execute:

```sql
DECLARE @Count INT;

EXEC sp_GetEmployeeCountByDepartment
    @DepartmentId = 2,
    @TotalEmployees = @Count OUTPUT;

SELECT @Count AS TotalEmployees;
```

---

## 13. Stored Procedure with Validation

Before inserting employee, check if department exists.

```sql
CREATE PROCEDURE sp_InsertEmployeeWithValidation
    @Name VARCHAR(100),
    @Gender VARCHAR(10),
    @City VARCHAR(50),
    @Salary MONEY,
    @Email VARCHAR(50),
    @MobileNo BIGINT,
    @DepartmentId INT
AS
BEGIN
    IF EXISTS
    (
        SELECT 1
        FROM Department
        WHERE DepartmentId = @DepartmentId
    )
    BEGIN
        INSERT INTO Employees
        (
            Name,
            Gender,
            City,
            Salary,
            Email,
            MobileNo,
            DepartmentId
        )
        VALUES
        (
            @Name,
            @Gender,
            @City,
            @Salary,
            @Email,
            @MobileNo,
            @DepartmentId
        );

        SELECT 'Employee inserted successfully' AS Message;
    END
    ELSE
    BEGIN
        SELECT 'Invalid DepartmentId. Department does not exist.' AS Message;
    END
END;
```

Execute:

```sql
EXEC sp_InsertEmployeeWithValidation
    @Name = 'Naveen',
    @Gender = 'Male',
    @City = 'Salem',
    @Salary = 39000,
    @Email = 'naveen@mail.com',
    @MobileNo = 9876543221,
    @DepartmentId = 2;
```

---

## 14. Stored Procedure with TRY CATCH

`TRY CATCH` is used to handle errors.

Example: If duplicate email is inserted, instead of showing SQL error directly, we can show a custom message.

```sql
CREATE PROCEDURE sp_InsertEmployeeTryCatch
    @Name VARCHAR(100),
    @Gender VARCHAR(10),
    @City VARCHAR(50),
    @Salary MONEY,
    @Email VARCHAR(50),
    @MobileNo BIGINT,
    @DepartmentId INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Employees
        (
            Name,
            Gender,
            City,
            Salary,
            Email,
            MobileNo,
            DepartmentId
        )
        VALUES
        (
            @Name,
            @Gender,
            @City,
            @Salary,
            @Email,
            @MobileNo,
            @DepartmentId
        );

        SELECT 'Employee inserted successfully' AS Message;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_LINE() AS ErrorLine;
    END CATCH
END;
```

Execute:

```sql
EXEC sp_InsertEmployeeTryCatch
    @Name = 'Test User',
    @Gender = 'Male',
    @City = 'Chennai',
    @Salary = 30000,
    @Email = 'lohanraj@mail.com',
    @MobileNo = 9999999999,
    @DepartmentId = 1;
```

If email already exists, it will show error message.

---

## 15. Stored Procedure with Transaction

Transaction is useful when multiple operations should happen together.

Example: Insert department and employee together. If employee insert fails, department insert should also rollback.

```sql
CREATE PROCEDURE sp_InsertDepartmentAndEmployee
    @DepartmentName VARCHAR(100),
    @Location VARCHAR(100),
    @Name VARCHAR(100),
    @Gender VARCHAR(10),
    @City VARCHAR(50),
    @Salary MONEY,
    @Email VARCHAR(50),
    @MobileNo BIGINT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Department
        (
            DepartmentName,
            Location
        )
        VALUES
        (
            @DepartmentName,
            @Location
        );

        DECLARE @NewDepartmentId INT;

        SET @NewDepartmentId = SCOPE_IDENTITY();

        INSERT INTO Employees
        (
            Name,
            Gender,
            City,
            Salary,
            Email,
            MobileNo,
            DepartmentId
        )
        VALUES
        (
            @Name,
            @Gender,
            @City,
            @Salary,
            @Email,
            @MobileNo,
            @NewDepartmentId
        );

        COMMIT TRANSACTION;

        SELECT 'Department and employee inserted successfully' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
```

Execute:

```sql
EXEC sp_InsertDepartmentAndEmployee
    @DepartmentName = 'Admin',
    @Location = 'Coimbatore',
    @Name = 'Divya',
    @Gender = 'Female',
    @City = 'Coimbatore',
    @Salary = 41000,
    @Email = 'divya@mail.com',
    @MobileNo = 9876543222;
```

---

## 16. Stored Procedure to Search Employees

This procedure searches employees by name, city, or department.

```sql
CREATE PROCEDURE sp_SearchEmployees
    @SearchText VARCHAR(100)
AS
BEGIN
    SELECT 
        e.EmployeeId,
        e.Name,
        e.Gender,
        e.City,
        e.Salary,
        e.Email,
        e.MobileNo,
        d.DepartmentName,
        d.Location
    FROM Employees e
    LEFT JOIN Department d
        ON e.DepartmentId = d.DepartmentId
    WHERE e.Name LIKE '%' + @SearchText + '%'
       OR e.City LIKE '%' + @SearchText + '%'
       OR d.DepartmentName LIKE '%' + @SearchText + '%';
END;
```

Execute:

```sql
EXEC sp_SearchEmployees 'Chennai';
```

or

```sql
EXEC sp_SearchEmployees 'IT';
```

---

## 17. Stored Procedure for Department-wise Report

```sql
CREATE PROCEDURE sp_DepartmentWiseEmployeeReport
AS
BEGIN
    SELECT 
        d.DepartmentId,
        d.DepartmentName,
        d.Location,
        COUNT(e.EmployeeId) AS TotalEmployees,
        ISNULL(SUM(e.Salary), 0) AS TotalSalary,
        ISNULL(AVG(e.Salary), 0) AS AverageSalary,
        ISNULL(MIN(e.Salary), 0) AS MinimumSalary,
        ISNULL(MAX(e.Salary), 0) AS MaximumSalary
    FROM Department d
    LEFT JOIN Employees e
        ON d.DepartmentId = e.DepartmentId
    GROUP BY 
        d.DepartmentId,
        d.DepartmentName,
        d.Location;
END;
```

Execute:

```sql
EXEC sp_DepartmentWiseEmployeeReport;
```

---

## 18. How to Modify Stored Procedure

Use `ALTER PROCEDURE`.

```sql
ALTER PROCEDURE sp_GetAllEmployees
AS
BEGIN
    SELECT 
        EmployeeId,
        Name,
        Gender,
        City,
        Salary
    FROM Employees;
END;
```

Execute:

```sql
EXEC sp_GetAllEmployees;
```

---

## 19. How to Delete Stored Procedure

```sql
DROP PROCEDURE sp_GetAllEmployees;
```

---

## 20. How to See Stored Procedures in SSMS

In Object Explorer:

```text
Database
  Programmability
    Stored Procedures
```

After creating procedure, refresh **Stored Procedures** folder.

---

## 21. What Can Be Performed Inside Stored Procedure?

You can perform these things:

| Operation | Possible in Stored Procedure? |
|---|---|
| `SELECT` | Yes |
| `INSERT` | Yes |
| `UPDATE` | Yes |
| `DELETE` | Yes |
| `JOIN` | Yes |
| `WHERE` condition | Yes |
| `GROUP BY` | Yes |
| `ORDER BY` | Yes |
| `IF ELSE` | Yes |
| Variables | Yes |
| Input parameters | Yes |
| Output parameters | Yes |
| Transactions | Yes |
| Error handling | Yes |
| Loops | Yes |
| Calling another procedure | Yes |
| Temporary tables | Yes |

---

## 22. Important Naming Suggestion

Avoid naming your procedure starting with `sp_`.

SQL Server system procedures also start with `sp_`, like:

```sql
sp_help
sp_rename
```

Better naming:

```sql
usp_GetAllEmployees
usp_InsertEmployee
usp_UpdateEmployeeSalary
usp_DeleteEmployee
```

`usp` means **User Stored Procedure**.

Example better name:

```sql
CREATE PROCEDURE usp_GetAllEmployees
AS
BEGIN
    SELECT * FROM Employees;
END;
```

Execute:

```sql
EXEC usp_GetAllEmployees;
```

---

## Simple Assignment for Practice

Create these stored procedures using your `Employees` and `Department` tables:

```text
1. usp_GetAllEmployees
2. usp_GetEmployeeWithDepartment
3. usp_GetEmployeesByCity
4. usp_GetEmployeesByDepartment
5. usp_InsertEmployee
6. usp_UpdateEmployeeSalary
7. usp_DeleteEmployee
8. usp_DepartmentWiseEmployeeReport
```

These procedures cover the main stored procedure concepts in SQL Server.
