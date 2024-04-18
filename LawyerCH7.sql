/* Lawyer, Craig Assignment 7 */
    
/*DELETE FROM mysql.user WHERE host='localhost' AND user!='mysql.infoschema' AND
    user!='mysql.session' AND user!='mysql.sys' AND user!='root';*/
DROP USER dean@localhost;

DROP USER sam@localhost;

DROP USER bobby@localhost;

USE Painters;

DROP INDEX idx_fullName on CUSTOMER;

DROP INDEX idx_jobnum on JOB;

DROP INDEX idx_keys on EMPJOB;

DROP VIEW vwFullName;

DROP VIEW vwTotalPay;

DROP TABLE IF EXISTS EMPJOB;
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS JOB;
DROP TABLE IF EXISTS CUSTOMER;

DROP DATABASE Painters;

CREATE DATABASE Painters;

USE Painters;

CREATE TABLE CUSTOMER(
    custphone CHAR(12) PRIMARY KEY UNIQUE,
    ctype ENUM('C', 'R'), 
    clname VARCHAR(35) NOT NULL,
    cfname VARCHAR(15) NOT NULL,
    caddr VARCHAR(40),
    ccity VARCHAR(20),
    cstate CHAR(2) DEFAULT ('SC'),
    CONSTRAINT chk_custphone CHECK
    (custphone like '%%% %%%-%%%%')
)ENGINE=InnoDB;

CREATE TABLE JOB(
    jobnum SMALLINT UNSIGNED
            PRIMARY KEY,
    custphone CHAR(12),
    jobstartdate DATE,
    description TEXT,
    amobilled DECIMAL(7,2),
    CONSTRAINT chk_jobnum CHECK(
        jobnum <= 65000),
    FOREIGN KEY (custphone) REFERENCES CUSTOMER (custphone),
    CONSTRAINT chk_description CHECK(
        description <= 2000),
    CONSTRAINT chk_amobilled CHECK (
        amobilled < 100000)
) ENGINE=InnoDB;


CREATE TABLE EMPLOYEE(
    essn CHAR(9) PRIMARY KEY,
    elname VARCHAR(35) NOT NULL,
    efname VARCHAR(15) NOT NULL,
    ephone VARCHAR(12),
    hrrate DECIMAL(5,2),
    CONSTRAINT chk_essn CHECK(
        essn not like ('%-%')
    ),
    CONSTRAINT chk_ephone CHECK(
        ephone like '%%% %%%-%%%%'
    ),
    CONSTRAINT chk_hrrate CHECK(
        hrrate <= 100.00
    )
) ENGINE=InnoDB;

CREATE TABLE EMPJOB(
    essn CHAR(9),
    jobnum SMALLINT UNSIGNED,
    hrsperjob DECIMAL(5,2),
    PRIMARY KEY (essn, jobnum),
    FOREIGN KEY (essn) REFERENCES EMPLOYEE (essn),
    FOREIGN KEY (jobnum) REFERENCES JOB (jobnum),
    CONSTRAINT ck_hrsperjob CHECK(
        hrsperjob <= 500)
) ENGINE=InnoDB;

CREATE INDEX idx_fullName on CUSTOMER (cfname, clname);

CREATE INDEX idx_jobnum on JOB (jobnum);

CREATE INDEX idx_keys on EMPJOB (essn, jobnum);

DROP VIEW vwFullName;

CREATE USER dean@localhost
IDENTIFIED BY 'password1';

CREATE USER sam@localhost
IDENTIFIED BY 'password2';

CREATE USER bobby@localhost
IDENTIFIED BY 'password3';

GRANT ALL 
ON Painters.*
TO dean@localhost;

GRANT SELECT
ON Painters.*
TO sam@localhost;

GRANT ALL
ON Painters.CUSTOMER
TO bobby@localhost;

GRANT ALL
ON Painters.JOB
TO bobby@localhost;

GRANT SELECT
ON Painters.EMPLOYEE
TO bobby@localhost;

GRANT SELECT
ON Painters.EMPJOB
TO bobby@localhost;

INSERT INTO CUSTOMER (custphone, ctype, clname, cfname, caddr, ccity, cstate)
VALUES ('123 456-7890', 'R', 'Smith', 'John', '111 Aiken Dr.', 'Aiken', 'SC');

INSERT INTO CUSTOMER (custphone, ctype, clname, cfname, caddr, ccity, cstate)
VALUES ('234 567-8901', 'C', 'Black', 'David', '112 Aiken Dr.', 'Aiken', 'SC');

INSERT INTO CUSTOMER (custphone, ctype, clname, cfname, caddr, ccity, cstate)
VALUES ('345 678-9012', 'R', 'Johnson', 'James', '113 Aiken Dr.', 'Aiken', 'SC');

INSERT INTO JOB (jobnum, custphone, jobstartdate, description, amobilled)
VALUES (1, '123 456-7890', '2022-09-05', 'Single Room', 384.79);

INSERT INTO JOB (jobnum, custphone, jobstartdate, description, amobilled)
VALUES (2, '234 567-8901', '2022-011-01', 'exterior full paint', 5765.45);

INSERT INTO JOB (jobnum, custphone, jobstartdate, description, amobilled)
VALUES (3, '234 567-8901', '2022-07-21', 'estimate', 0.00);

INSERT INTO EMPLOYEE (essn, elname, efname, ephone, hrrate)
VALUES ('874884385', 'Skywalker', 'Luke', '987 654-3210', 32.50);

INSERT INTO EMPLOYEE (essn, elname, efname, ephone, hrrate)
VALUES ('274992754', 'Kenobi', 'Obi-Wan', '876 543-2109', 48.79);

INSERT INTO EMPLOYEE (essn, elname, efname, ephone, hrrate)
VALUES ('367336745', 'Vader', 'Darth', '765 432-1098', 51.99);

INSERT INTO EMPJOB (essn, jobnum, hrsperjob)
VALUES ('874884385', 1, 2.30);

INSERT INTO EMPJOB (essn, jobnum, hrsperjob)
VALUES ('274992754', 2, 22.15);

INSERT INTO EMPJOB (essn, jobnum, hrsperjob)
VALUES ('367336745', 3, 1.80);

UPDATE CUSTOMER 
SET ctype = 'C'
WHERE clname = 'Smith';

UPDATE JOB
SET jobstartdate = '2022-07-22'
WHERE jobnum = 3;

UPDATE EMPLOYEE
SET hrrate = 34.75
WHERE elname = 'Skywalker';

UPDATE EMPJOB
SET hrsperjob = 1.75
WHERE jobnum = 3;

DELETE FROM CUSTOMER
WHERE clname = 'Johnson';

DELETE FROM EMPJOB
WHERE jobnum = 3;

DELETE FROM JOB
WHERE jobnum = 3;

DELETE FROM EMPLOYEE
WHERE elname = 'Vader';

CREATE VIEW vwFullName AS 
SELECT CONCAT(cfname, ' ', clname) AS 'Customer Name', 
jobnum, jobstartdate, CONCAT(efname, ' ', elname) AS 'Employe Name'
FROM CUSTOMER INNER JOIN JOB
USING (custphone)
INNER JOIN EMPJOB
USING (jobnum)
INNER JOIN EMPLOYEE
USING (essn);

SELECT * FROM vwFullName;

CREATE VIEW vwTotalPay AS
SELECT elname, SUM(amobilled)
FROM JOB INNER JOIN EMPJOB
USING (jobnum)
INNER JOIN EMPLOYEE
USING (essn)
GROUP BY elname;

SELECT * FROM vwTotalPay;