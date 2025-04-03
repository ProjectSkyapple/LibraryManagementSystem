import csv
import re
import os

def normalize_books_csv():
    """
    Normalizes the books.csv file into:
    1. book.csv (Isbn, Title)
    2. book_authors.csv (Author_id, Isbn)
    3. authors.csv (Author_id, Name)
    """

    books = {}  # isbn -> title
    authors = {}  # author_id -> author_name (previously swapped)
    book_authors = []  # list of (author_id, isbn) tuples
    
    author_id_counter = 0
    
    
    try:
        books_path = os.path.join(os.path.dirname(__file__), 'normalized/books.csv')
        with open(books_path, 'r', encoding='utf-8') as books_file:
            reader = csv.reader(books_file, delimiter='\t')
            
            header = next(reader, None)
            
            for row in reader:
                isbn = row[0].strip()
                title = row[2].strip().lower()

                # Make BOOK table
                books[isbn] = title

                # If there is an author for this book tuple:
                if row[3].strip():
                    author_name = row[3].strip().lower()

                    # Make AUTHORS table, ensure no duplicates in AUTHORS
                    if author_name not in authors.values():
                        author_id_counter += 1
                        authors[author_id_counter] = author_name
                        
                    # Make BOOK_AUTHORS table
                    book_authors.append((author_id_counter, isbn))
            
            """
            for row in reader:
                if len(row) >= 2:  
                    isbn = row[0].strip()
                    title = row[1].strip()
                    
                    books[isbn] = title
                    
                    
                    if len(row) > 2:
                        for i in range(2, len(row)):
                            if row[i].strip():
                                author_name = row[i].strip()
                                
                                if author_name not in authors:
                                    authors[author_name] = author_id_counter
                                    author_id_counter += 1
                                
                                
                                book_authors.append((authors[author_name], isbn))
            """
        
        with open('normalized/book.csv', 'w', newline='', encoding='utf-8') as book_file:
            writer = csv.writer(book_file)
            writer.writerow(['Isbn', 'Title'])
            for isbn, title in books.items():
                writer.writerow([isbn, title])
        
        
        with open('normalized/authors.csv', 'w', newline='', encoding='utf-8') as authors_file:
            writer = csv.writer(authors_file)
            writer.writerow(['Author_id', 'Name'])
            for author_id, author_name in authors.items(): # EDIT: AJ swapped id, name
                writer.writerow([author_id, author_name])
        
        
        with open('normalized/book_authors.csv', 'w', newline='', encoding='utf-8') as book_authors_file:
            writer = csv.writer(book_authors_file)
            writer.writerow(['Author_id', 'Isbn'])
            for author_id, isbn in book_authors:
                writer.writerow([author_id, isbn])
        
        print("Books data normalized successfully!")
        
    except Exception as e:
        print(f"Error normalizing books.csv: {e}, author {author_id_counter}")

def normalize_borrowers_csv():
    """
    Normalizes the borrowers.csv file into:
    1. borrower.csv (Card_id, Ssn, Bname, Address, Phone)
    """
    try:
        borrowers = []  # list of (card_id, ssn, name, address, phone) tuples
        
        # card_id_counter = 1 
        
        borrowers_path = os.path.join(os.path.dirname(__file__), 'normalized/borrowers.csv')
        with open(borrowers_path, 'r', encoding='utf-8') as borrowers_file:
            reader = csv.reader(borrowers_file)
            
            header = next(reader, None)
            
            for row in reader:
                if len(row) >= 5:  
                    id_value = row[0].strip()
                    ssn = row[1].strip()
                    first_name = row[2].strip()
                    last_name = row[3].strip()
                    email = row[4].strip()
                    address = row[5].strip() if len(row) > 5 else ""
                    city = row[6].strip() if len(row) > 6 else ""
                    state = row[7].strip() if len(row) > 7 else ""
                    phone = row[8].strip() if len(row) > 8 else ""
                    
                    full_name = f"{first_name} {last_name}".lower()
                    
                    full_address = f"{address}, {city}, {state}" if address and city and state else address
                    
                    
                    borrowers.append((id_value, ssn, full_name, full_address, phone))
                    # card_id_counter += 1
        
        
        with open('normalized/borrower.csv', 'w', newline='', encoding='utf-8') as borrower_file:
            writer = csv.writer(borrower_file)
            writer.writerow(['Card_id', 'Ssn', 'Bname', 'Address', 'Phone'])
            for borrower in borrowers:
                writer.writerow(borrower)
        
        print("Borrowers data normalized successfully!")
        
    except Exception as e:
        print(f"Error normalizing borrowers.csv: {e}")

def main():
    
    normalize_books_csv()
    normalize_borrowers_csv()
    
    print("Normalization completed!")

if __name__ == "__main__":
    main()