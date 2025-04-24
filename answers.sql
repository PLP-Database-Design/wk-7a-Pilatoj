-- =============================================
-- Database Normalization Solutions
-- =============================================

-- QUESTION 1: Converting to First Normal Form (1NF)
-- Problem: Products column contains multiple values (violates atomicity)
-- Solution: Split multi-value Products into individual rows
-- =============================================

-- Step 1: Create new 1NF-compliant table structure
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50)  -- Single product per row
);

-- Step 2: Insert decomposed data (manual example for given data)
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
VALUES 
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');

-- Alternative approach if original table exists:
-- (This would require string splitting functions which vary by DBMS)
/*
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT 
    OrderID, 
    CustomerName,
    TRIM(value) AS Product
FROM 
    ProductDetail,
    STRING_SPLIT(Products, ',');
*/


-- =============================================
-- QUESTION 2: Converting to Second Normal Form (2NF)
-- Problem: CustomerName depends only on OrderID (partial dependency)
-- Solution: Split into two tables to remove partial dependencies
-- =============================================

-- Step 1: Create Orders table (removes CustomerName dependency)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Create OrderProducts table (full dependency on composite key)
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Populate Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 4: Populate OrderProducts table
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- =============================================
-- Verification queries (optional)
-- =============================================
-- SELECT * FROM ProductDetail_1NF;
-- SELECT * FROM Orders;
-- SELECT * FROM OrderProducts;