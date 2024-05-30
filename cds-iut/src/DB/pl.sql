CREATE OR REPLACE PROCEDURE CalculateBill (
    p_CustomerID IN NUMBER
) AS
    v_TotalPurchase NUMBER;
    v_DiscountRate  NUMBER;
    v_FinalBill     NUMBER;
BEGIN
    -- Calculate the total purchase amount
SELECT SUM(si.Quantity * si.PriceAtSale)
INTO v_TotalPurchase
FROM Sales s
         JOIN SaleItems si ON s.SaleID = si.SaleID
WHERE s.CustomerID = p_CustomerID;

-- Determine discount rate based on total purchase amount
IF v_TotalPurchase >= 1000 THEN
        v_DiscountRate := 0.1;  -- 10% discount for purchases >= 1000
    ELSIF v_TotalPurchase >= 500 THEN
        v_DiscountRate := 0.05;  -- 5% discount for purchases >= 500
ELSE
        v_DiscountRate := 0;  -- No discount for purchases < 500
END IF;

    -- Calculate final bill after applying discount
    v_FinalBill := v_TotalPurchase - (v_TotalPurchase * v_DiscountRate);

    DBMS_OUTPUT.PUT_LINE('Total Purchase Amount: ' || v_TotalPurchase);
    DBMS_OUTPUT.PUT_LINE('Final Bill after Discount: ' || v_FinalBill);
END;
/


CREATE OR REPLACE PROCEDURE FetchCustomerBranch (
    p_CustomerID IN NUMBER,
    p_BranchID   IN NUMBER
) AS
    v_CustomerName VARCHAR2(100);
    v_BranchName   VARCHAR2(100);
BEGIN
    -- Retrieve customer and branch names
SELECT c.FirstName || ' ' || c.LastName, b.BranchName
INTO v_CustomerName, v_BranchName
FROM Customers c
         JOIN Branches b ON b.BranchID = p_BranchID
WHERE c.CustomerID = p_CustomerID;

DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_CustomerName);
    DBMS_OUTPUT.PUT_LINE('Branch Name: ' || v_BranchName);
END;
/


CREATE TABLE Suppliers (
                           SupplierID NUMBER PRIMARY KEY,
                           SupplierName VARCHAR2(100) NOT NULL
);

CREATE TABLE SupplierProducts (
                                  SupplierProductID NUMBER PRIMARY KEY,
                                  SupplierID NUMBER NOT NULL,
                                  ProductID NUMBER NOT NULL,
                                  SupplyDate DATE NOT NULL,
                                  CONSTRAINT fk_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
                                  CONSTRAINT fk_SupplierProduct FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE OR REPLACE PROCEDURE RetrieveSupplierProduct (
    p_SupplyDate IN DATE
) AS
    v_SupplierName VARCHAR2(100);
    v_ProductName  VARCHAR2(100);
BEGIN
    -- Retrieve supplier and product names based on supply date
SELECT s.SupplierName, p.ProductName
INTO v_SupplierName, v_ProductName
FROM Suppliers s
         JOIN SupplierProducts sp ON s.SupplierID = sp.SupplierID
         JOIN Products p ON sp.ProductID = p.ProductID
WHERE sp.SupplyDate = p_SupplyDate;

DBMS_OUTPUT.PUT_LINE('Supplier Name: ' || v_SupplierName);
    DBMS_OUTPUT.PUT_LINE('Product Name: ' || v_ProductName);
END;
/


CREATE TABLE Users (
                       UserID NUMBER PRIMARY KEY,
                       UserName VARCHAR2(100),
                       UserEmail VARCHAR2(100) UNIQUE
);

CREATE OR REPLACE TRIGGER Update_UserInfo
AFTER INSERT OR UPDATE OR DELETE ON Users
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        -- Logic for after insert
        DBMS_OUTPUT.PUT_LINE('User inserted: ' || :NEW.UserName);
    ELSIF UPDATING THEN
        -- Logic for after update
        DBMS_OUTPUT.PUT_LINE('User updated from ' || :OLD.UserName || ' to ' || :NEW.UserName);
    ELSIF DELETING THEN
        -- Logic for after delete
        DBMS_OUTPUT.PUT_LINE('User deleted: ' || :OLD.UserName);
END IF;

    -- Update related data in other tables if necessary


    -- Example: Update Customer table if user details are linked
    -- UPDATE Customers SET Email = :NEW.UserEmail WHERE Email = :OLD.UserEmail;


END;
/


