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