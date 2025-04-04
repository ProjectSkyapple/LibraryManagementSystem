-- Borrower Management SQL Queries

-- 1. Create BORROWER table if it doesn't exist
CREATE TABLE IF NOT EXISTS BORROWER (
    Card_id TEXT PRIMARY KEY,
    Ssn TEXT UNIQUE NOT NULL,
    Bname TEXT NOT NULL,
    Address TEXT NOT NULL,
    Phone TEXT
);

-- 2. Create a new borrower
-- Note: Card_id is generated in application logic based on the highest existing ID
INSERT INTO BORROWER (Card_id, Ssn, Bname, Address, Phone) 
VALUES (?, ?, ?, ?, ?);

-- 3. Check if an SSN is already registered (used before creating a new borrower)
-- Returns a count > 0 if the SSN exists, 0 if it doesn't
SELECT COUNT(*) 
FROM BORROWER 
WHERE Ssn = ?;

-- 4. Find the highest existing Card_id (used for generating the next Card_id)
-- Application logic will extract the numeric part, increment it, and format as 'ID######'
SELECT MAX(Card_id) 
FROM BORROWER;

-- 5. Search for borrowers by card_id, name, or SSN (case-insensitive substring matching)
-- Used for finding borrowers in the system
SELECT Card_id, Ssn, Bname, Address, Phone 
FROM BORROWER 
WHERE Card_id LIKE ? OR 
      Ssn LIKE ? OR 
      Bname LIKE ?;

-- 6. Retrieve a specific borrower by Card_id
SELECT Card_id, Ssn, Bname, Address, Phone 
FROM BORROWER 
WHERE Card_id = ?;

-- 7. Retrieve a specific borrower by SSN
SELECT Card_id, Ssn, Bname, Address, Phone 
FROM BORROWER 
WHERE Ssn = ?;

-- Note: The following application-level validations and business rules are implemented in Python:
-- 1. SSN must be in format XXX-XX-XXXX
-- 2. Phone number must be in format (XXX) XXX-XXXX (if provided)
-- 3. Names are stored in lowercase for consistent searching
-- 4. Card_id is auto-generated in the format 'ID######' where ###### is a 6-digit number
-- 5. Each SSN can only be associated with one library card 