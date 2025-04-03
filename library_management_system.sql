-- 1. Search and Availability
/* NOTE: If a book is checked out, the corresponding book_loans.date_in if it exists will be NULL.
 * If it is checked in, book_loans.date_in will be a non-null value,
 * or it does not have a corresponding book_loans record.
 */
-- TODO: Consider when a book has never been loaned before (there won't be a corresponding book_loans record).
SELECT book.isbn, book.title, authors.name, book_loans.date_in
FROM book, book_authors, authors, book_loans
WHERE book.isbn = book_authors.isbn
    AND book_authors.author_id = authors.author_id
    AND book.isbn = book_loans.isbn
    AND (
        book.isbn LIKE '%<keyword>%'
        OR book.title LIKE '%<keyword>%'
        OR authors.name LIKE '%<keyword>%'
    );