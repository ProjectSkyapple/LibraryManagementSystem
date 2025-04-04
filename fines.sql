-- 5. Fines
-- For getting all fines
SELECT * FROM fines;

-- Is a loan's fine paid?
SELECT fines.paid
FROM fines
WHERE fines.loan_id = '<loan_id_arg>';

-- Get the date_in for a specific loan
SELECT book_loans.date_in
FROM book_loans
WHERE book_loans.loan_id = '<loan_id_arg>';

-- Get the due_date for a specific loan
SELECT book_loans.due_date
FROM book_loans
WHERE book_loans.loan_id = '<loan_id_arg>';

-- Display of fines
SELECT borrower.card_id, borrower.bname, SUM(fines.fine_amt) AS total_fines_owed
FROM fines, book_loans, borrower
WHERE fines.loan_id = book_loans.loan_id
    AND book_loans.card_id = borrower.card_id
    AND fines.paid = '<falsy value>'
GROUP BY borrower.card_id;