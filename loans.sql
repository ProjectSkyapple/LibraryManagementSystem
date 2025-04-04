-- 3. Book Loans

-- 1. Check if a book is available (not currently checked out)
SELECT COUNT(*) AS is_checked_out
FROM book_loans
WHERE book_loans.isbn = ?
AND book_loans.date_in IS NULL;

-- 2. Count active loans for a borrower (to check if under 3 book limit)
SELECT COUNT(*) AS active_loans_count
FROM book_loans
WHERE book_loans.card_id = ?
AND book_loans.date_in IS NULL;

-- 3. Check if borrower has unpaid fines
SELECT COUNT(*) AS has_unpaid_fines
FROM fines, book_loans
WHERE fines.loan_id = book_loans.loan_id
AND book_loans.card_id = ?
AND fines.paid = FALSE;

-- 4. Create new book loan (checkout a book)
INSERT INTO book_loans (isbn, card_id, date_out, due_date, date_in)
VALUES (
    ?,
    ?,
    CURRENT_DATE(),
    DATE_ADD(CURRENT_DATE(), INTERVAL 14 DAY),
    NULL
);

-- 5. Search for checked out books by ISBN, borrower ID, or borrower name
SELECT book_loans.loan_id, book.isbn, book.title, borrower.card_id, borrower.bname, 
       book_loans.date_out, book_loans.due_date
FROM book_loans
JOIN book ON book_loans.isbn = book.isbn
JOIN borrower ON book_loans.card_id = borrower.card_id
WHERE (book.isbn LIKE CONCAT('%', ?, '%')
       OR borrower.card_id LIKE CONCAT('%', ?, '%')
       OR borrower.bname LIKE CONCAT('%', ?, '%'))
AND book_loans.date_in IS NULL;

-- 6. Check in a book (return a book)
UPDATE book_loans
SET date_in = CURRENT_DATE()
WHERE loan_id = ?;

-- 7. Get details of a specific loan
SELECT book_loans.loan_id, book.isbn, book.title, 
       GROUP_CONCAT(authors.name SEPARATOR ', ') AS authors,
       borrower.card_id, borrower.bname, 
       book_loans.date_out, book_loans.due_date, book_loans.date_in
FROM book_loans
JOIN book ON book_loans.isbn = book.isbn
JOIN book_authors ON book.isbn = book_authors.isbn
JOIN authors ON book_authors.author_id = authors.author_id
JOIN borrower ON book_loans.card_id = borrower.card_id
WHERE book_loans.loan_id = ?
GROUP BY book_loans.loan_id, book.isbn, book.title, 
         borrower.card_id, borrower.bname, 
         book_loans.date_out, book_loans.due_date, book_loans.date_in;

-- 8. Get all active loans (books currently checked out)
SELECT book_loans.loan_id, book.isbn, book.title, 
       borrower.card_id, borrower.bname, 
       book_loans.date_out, book_loans.due_date,
       DATEDIFF(CURRENT_DATE(), book_loans.due_date) AS days_overdue
FROM book_loans
JOIN book ON book_loans.isbn = book.isbn
JOIN borrower ON book_loans.card_id = borrower.card_id
WHERE book_loans.date_in IS NULL
ORDER BY book_loans.due_date ASC;

-- 9. Get overdue books (where current date is past the due date)
SELECT book_loans.loan_id, book.isbn, book.title, 
       borrower.card_id, borrower.bname, 
       book_loans.date_out, book_loans.due_date,
       DATEDIFF(CURRENT_DATE(), book_loans.due_date) AS days_overdue
FROM book_loans
JOIN book ON book_loans.isbn = book.isbn
JOIN borrower ON book_loans.card_id = borrower.card_id
WHERE book_loans.date_in IS NULL
AND book_loans.due_date < CURRENT_DATE()
ORDER BY days_overdue DESC;

-- 10. Get loan history by borrower
SELECT book_loans.loan_id, book.isbn, book.title, 
       book_loans.date_out, book_loans.due_date, book_loans.date_in,
       CASE 
           WHEN book_loans.date_in IS NULL THEN 'Checked Out'
           ELSE 'Returned'
       END AS status
FROM book_loans
JOIN book ON book_loans.isbn = book.isbn
WHERE book_loans.card_id = ?
ORDER BY book_loans.date_out DESC;