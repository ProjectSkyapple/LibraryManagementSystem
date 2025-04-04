-- 1. Search and Availability
/* NOTE: If a book is checked out, the corresponding book_loans.date_in if it exists will be NULL.
 * If it is checked in, book_loans.date_in will be a non-null value,
 * or it does not have a corresponding book_loans record.
 */
SELECT book.isbn, book.title, authors.name, book_loans.date_out, book_loans.date_in
FROM (
    ((book JOIN book_authors ON book.isbn = book_authors.isbn)
        JOIN authors ON book_authors.author_id = authors.author_id)
        LEFT JOIN book_loans ON book.isbn = book_loans.isbn
)
WHERE
    book.isbn LIKE '%will%'
    OR book.title LIKE '%will%'
    OR authors.name LIKE '%will%'
;