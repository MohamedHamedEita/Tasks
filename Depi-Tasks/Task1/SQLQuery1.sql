
USE Test;

CREATE TABLE Employee (
    SSN VARCHAR(9) NOT NULL,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    Birth_Date DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    DNUM INTEGER,
    Supervisor_SSN VARCHAR(9),
    PRIMARY KEY (SSN),
    CONSTRAINT chk_gender CHECK (Gender IN ('M', 'F'))
);

CREATE TABLE Department (
    DNUM INTEGER NOT NULL,
    DName VARCHAR(100) NOT NULL,
    Manager_SSN VARCHAR(9),
    Hiring_Date DATE,
    PRIMARY KEY (DNUM),
    CONSTRAINT uk_dname UNIQUE (DName),
    CONSTRAINT uk_manager_ssn UNIQUE (Manager_SSN)
);

CREATE TABLE Department_Locations (
    DNUM INTEGER NOT NULL,
    Location VARCHAR(100) NOT NULL,
    PRIMARY KEY (DNUM, Location),
    FOREIGN KEY (DNUM) REFERENCES Department(DNUM)
);

CREATE TABLE Project (
    PNumber INTEGER NOT NULL,
    Pname VARCHAR(100) NOT NULL,
    Location_City VARCHAR(100) NOT NULL,
    DNUM INTEGER NOT NULL,
    PRIMARY KEY (PNumber),
    FOREIGN KEY (DNUM) REFERENCES Department(DNUM),
    CONSTRAINT uk_pname UNIQUE (Pname)
);

CREATE TABLE Dependent (
    Dependent_Name VARCHAR(50) NOT NULL,
    Employee_SSN VARCHAR(9) NOT NULL,
    Gender CHAR(1) NOT NULL,
    Birthdate DATE NOT NULL,
    PRIMARY KEY (Dependent_Name, Employee_SSN),
    FOREIGN KEY (Employee_SSN) REFERENCES Employee(SSN) ON DELETE CASCADE,
    CONSTRAINT chk_dep_gender CHECK (Gender IN ('M', 'F'))
);

CREATE TABLE Works_On (
    Employee_SSN VARCHAR(9) NOT NULL,
    PNumber INTEGER NOT NULL,
    Working_Hours INTEGER NOT NULL,
    PRIMARY KEY (Employee_SSN, PNumber),
    FOREIGN KEY (Employee_SSN) REFERENCES Employee(SSN),
    FOREIGN KEY (PNumber) REFERENCES Project(PNumber),
    CONSTRAINT chk_hours CHECK (Working_Hours >= 0)
);
ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_Department FOREIGN KEY (DNUM) REFERENCES Department(DNUM);

ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_Supervisor FOREIGN KEY (Supervisor_SSN) REFERENCES Employee(SSN);

ALTER TABLE Department
ADD CONSTRAINT FK_Department_Employee FOREIGN KEY (Manager_SSN) REFERENCES Employee(SSN);
-- Create Indexes for Performance
-- Non-clustered indexes on foreign keys (DNUM, Supervisor_SSN, Manager_SSN, etc.)
-- improve join performance for queries involving relationships.
-- Indexes on frequently queried columns (e.g., SSN, PNumber) enhance lookup speed.
CREATE NONCLUSTERED INDEX IX_Employee_DNUM ON Employee(DNUM);
CREATE NONCLUSTERED INDEX IX_Employee_Supervisor_SSN ON Employee(Supervisor_SSN);
CREATE NONCLUSTERED INDEX IX_Department_Manager_SSN ON Department(Manager_SSN);
CREATE NONCLUSTERED INDEX IX_Department_Locations_DNUM ON Department_Locations(DNUM);
CREATE NONCLUSTERED INDEX IX_Project_DNUM ON Project(DNUM);
CREATE NONCLUSTERED INDEX IX_Dependent_Employee_SSN ON Dependent(Employee_SSN);
CREATE NONCLUSTERED INDEX IX_WorksOn_Employee_SSN ON Works_On(Employee_SSN);
CREATE NONCLUSTERED INDEX IX_WorksOn_PNumber ON Works_On(PNumber);
--
INSERT INTO Department (DNUM, DName, Manager_SSN, Hiring_Date)
VALUES (0, 'Temporary Dept', NULL, '2020-01-01');

--
INSERT INTO Department (DNUM, DName, Manager_SSN, Hiring_Date)
VALUES (1, 'Engineering', '234567890', '2020-01-01'),
(2, 'Sales', '345678901', '2021-02-15');

--
SELECT * FROM Department ;
INSERT INTO Employee (SSN, Fname, Lname, Birth_Date, Gender, DNUM, Supervisor_SSN)
VALUES ('123456789', 'John', 'Doe', '1980-05-15', 'M', 0, '123456789');
--
INSERT INTO Employee (SSN, Fname, Lname, Birth_Date, Gender, DNUM, Supervisor_SSN) VALUES
('234567890', 'Jane', 'Smith', '1985-08-22', 'F', 0, '123456789'),
('345678901', 'Mike', 'Johnson', '1990-03-10', 'M', 0, '123456789'),
('456789012', 'Sarah', 'Williams', '1982-11-30', 'F', 0, '123456789'),
('567890123', 'Emily', 'Brown', '1995-07-25', 'F', 0, '456789012');
SELECT * FROM Employee ;

-- 
INSERT INTO Department_Locations (DNUM, Location) VALUES
(1, 'New York'),
(1, 'Boston'),
(2, 'Chicago');
SELECT * FROM Department_Locations;
INSERT INTO Project (PNumber, Pname, Location_City, DNUM) VALUES
(101, 'Project Alpha', 'New York', 1),
(102, 'Project Beta', 'Boston', 1),
(103, 'Project Gamma', 'Chicago', 2);
SELECT * FROM Project;
INSERT INTO Works_On (Employee_SSN, PNumber, Working_Hours) VALUES
('123456789', 101, 20),
('123456789', 102, 15),
('234567890', 101, 30),
('345678901', 102, 25),
('456789012', 103, 40),
('567890123', 103, 35);
SELECT * FROM Works_On;
-- Test Queries to Verify Relationships
-- 1. Works In: Employees and their departments
SELECT e.SSN, e.Fname, e.Lname, d.DName
FROM Employee e
JOIN Department d ON e.DNUM = d.DNUM;