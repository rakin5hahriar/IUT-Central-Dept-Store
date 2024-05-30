-- Drop sequences if they exist
BEGIN
EXECUTE IMMEDIATE 'DROP SEQUENCE customer_seq';
EXECUTE IMMEDIATE 'DROP SEQUENCE product_seq';
EXECUTE IMMEDIATE 'DROP SEQUENCE category_seq';
EXECUTE IMMEDIATE 'DROP SEQUENCE branch_seq';
EXECUTE IMMEDIATE 'DROP SEQUENCE staff_seq';
EXECUTE IMMEDIATE 'DROP SEQUENCE sale_seq';
EXECUTE IMMEDIATE 'DROP SEQUENCE saleitem_seq';
EXECUTE IMMEDIATE 'DROP SEQUENCE payment_seq';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
END IF;
END;
/


-- Drop tables if they exist
BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Payments CASCADE CONSTRAINTS';
EXECUTE IMMEDIATE 'DROP TABLE SaleItems CASCADE CONSTRAINTS';
EXECUTE IMMEDIATE 'DROP TABLE Sales CASCADE CONSTRAINTS';
EXECUTE IMMEDIATE 'DROP TABLE Staff CASCADE CONSTRAINTS';
EXECUTE IMMEDIATE 'DROP TABLE Branches CASCADE CONSTRAINTS';
EXECUTE IMMEDIATE 'DROP TABLE Products CASCADE CONSTRAINTS';
EXECUTE IMMEDIATE 'DROP TABLE Categories CASCADE CONSTRAINTS';
EXECUTE IMMEDIATE 'DROP TABLE Customers CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
END IF;
END;
/

-- Customer Management
CREATE TABLE Customers (
                           CustomerID NUMBER PRIMARY KEY,
                           FirstName VARCHAR2(50) NOT NULL,
                           LastName VARCHAR2(50) NOT NULL,
                           Email VARCHAR2(100) UNIQUE NOT NULL,
                           PhoneNumber VARCHAR2(15),
                           Address VARCHAR2(255),
                           PurchaseHistory CLOB,
                           Preferences CLOB
);

-- Product Management
CREATE TABLE Categories (
                            CategoryID NUMBER PRIMARY KEY,
                            CategoryName VARCHAR2(100) UNIQUE NOT NULL,
                            Description CLOB
);

CREATE TABLE Products (
                          ProductID NUMBER PRIMARY KEY,
                          ProductName VARCHAR2(100) NOT NULL,
                          CategoryID NUMBER NOT NULL,
                          StockLevel NUMBER NOT NULL,
                          Price NUMBER(10, 2) NOT NULL,
                          Description CLOB,
                          CONSTRAINT fk_Category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Branch Management
CREATE TABLE Branches (
                          BranchID NUMBER PRIMARY KEY,
                          BranchName VARCHAR2(100) UNIQUE NOT NULL,
                          Location VARCHAR2(255) NOT NULL,
                          ManagerName VARCHAR2(100),
                          ContactNumber VARCHAR2(15)
);

CREATE TABLE Staff (
                       StaffID NUMBER PRIMARY KEY,
                       FirstName VARCHAR2(50) NOT NULL,
                       LastName VARCHAR2(50) NOT NULL,
                       Email VARCHAR2(100) UNIQUE NOT NULL,
                       PhoneNumber VARCHAR2(15),
                       BranchID NUMBER NOT NULL,
                       Position VARCHAR2(50),
                       CONSTRAINT fk_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- Sales Management
CREATE TABLE Sales (
                       SaleID NUMBER PRIMARY KEY,
                       SaleDate DATE DEFAULT SYSDATE,
                       CustomerID NUMBER NOT NULL,
                       BranchID NUMBER NOT NULL,
                       TotalAmount NUMBER(10, 2) NOT NULL,
                       CONSTRAINT fk_SaleCustomer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
                       CONSTRAINT fk_SaleBranch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

CREATE TABLE SaleItems (
                           SaleItemID NUMBER PRIMARY KEY,
                           SaleID NUMBER NOT NULL,
                           ProductID NUMBER NOT NULL,
                           Quantity NUMBER NOT NULL,
                           PriceAtSale NUMBER(10, 2) NOT NULL,
                           CONSTRAINT fk_Sale FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
                           CONSTRAINT fk_SaleProduct FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Payment Management
CREATE TABLE Payments (
                          PaymentID NUMBER PRIMARY KEY,
                          SaleID NUMBER NOT NULL,
                          PaymentDate DATE DEFAULT SYSDATE,
                          Amount NUMBER(10, 2) NOT NULL,
                          PaymentMethod VARCHAR2(50) NOT NULL,
                          CONSTRAINT fk_PaymentSale FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
);



-- Sample sequences for ID generation
CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE product_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE category_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE branch_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE staff_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sale_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE saleitem_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1;

-- Triggers to auto-increment primary keys using sequences
CREATE OR REPLACE TRIGGER trg_Customers_BI
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
SELECT customer_seq.NEXTVAL INTO :NEW.CustomerID FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_Categories_BI
BEFORE INSERT ON Categories
FOR EACH ROW
BEGIN
SELECT category_seq.NEXTVAL INTO :NEW.CategoryID FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_Products_BI
BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
SELECT product_seq.NEXTVAL INTO :NEW.ProductID FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_Branches_BI
BEFORE INSERT ON Branches
FOR EACH ROW
BEGIN
SELECT branch_seq.NEXTVAL INTO :NEW.BranchID FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_Staff_BI
BEFORE INSERT ON Staff
FOR EACH ROW
BEGIN
SELECT staff_seq.NEXTVAL INTO :NEW.StaffID FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_Sales_BI
BEFORE INSERT ON Sales
FOR EACH ROW
BEGIN
SELECT sale_seq.NEXTVAL INTO :NEW.SaleID FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_SaleItems_BI
BEFORE INSERT ON SaleItems
FOR EACH ROW
BEGIN
SELECT saleitem_seq.NEXTVAL INTO :NEW.SaleItemID FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_Payments_BI
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
SELECT payment_seq.NEXTVAL INTO :NEW.PaymentID FROM dual;
END;
/
