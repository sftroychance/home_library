## App description
home_library.rb

Basic personal book library app with set of books and casual borrowers, allowing CRUD for both. Buttons on book and borrower screens allow a user to borrow a book. Can list borrowed books. Can list borrowers with borrowed books and count of books. Each book screen lists borrow history. Each borrower screen lists borrow history.

## Workflow
Opening the app, the user can log in (will have a demo login).
Then dashboard shows library statistics: which books are being borrowed and by whom, total number of books in system, total number of borrowed books.
Nav: list books, list borrowers, list borrows (add buttons next to them maybe)
add book: list books -> add book -> return to list of books
edit/delete book: list books -> edit book -> return to list of books
add author: list books -> add book -> add author
edit/delete author: list books -> book view -> edit author -> return to book view
  - also, click on book title on any borrow list
add borrower: borrower list -> add borrower -> return to borrower list
edit/delete borrower: borrower list -> edit borrower -> return to borrower list
  - also, click on borrower name on any borrow list
loan a book: list books -> view book -> button to check out -> borrow view -> back to list of books
return a book: dashboard (list of borrowed books) -> edit borrow (return button) -> return to dashboard
edit borrow record: dashboard -> edit borrow -> return to dashboard

## Screens
Persistent left menu: dashboard, books, users, add buttons for books and users
Welcome and user login
Dashboard '/dashboard'
  - shows list of borrowed books and their borrowers and length of time borrowed
  - statistics: shows count of all books, borrowed books
Books - '/book-list' - list of all books - sort by sort title, borrowed in red, ADD button for new book
Book - '/book/:id' shows info and borrow history (current in red) update and delete buttons, button to borrow, button to return book; borrow button is hidden if book is on hold or is on loan
Borrowers - '/borrower-list'- list of all borrowers on file, current borrowers in red, ADD button for new borrower
Borrower - '/borrower/:id' - shows info and borrow history (current in red), update and delete buttons
Borrow - '/borrow/:id' - here by clicking check borrow button on book page - borrower select list (list of names), borrower add button

Error/success messages with create, update, delete.

## User-facing Data
Books:
Title
Title sort order (variation on title, remove A, An, The) - automatically generated but can be edited (JS)
Author
Published year
Publisher
notes
hold (don't loan out)
Borrow history sort reverse borrow date, red if currently borrowed

Borrowers:
Name FL
Phone  number
email
notes
Borrow history (current in red)

Borrows:
Book
Title
Borrow date
Return date
notes

## Schema

### for session implementation
session[:books] \[{id:, title:, author-first: , author-last:, year:, publisher:, notes:}, . . .\ ] (note: author not relational)
session[:borrowers] \[{id:, fname:, lname:, notes}, ... \]
session[:borrows] \[{id:, book_id:, borrower_id:, borrow_date:, return_date:, notes: }]

### for database implementation
Books
id int PK auto
title varchar(100) NOT NULL
sort title varchar(100) NOT NULL
author id int FK authors.id NOT NULL
published year int CHECK four digits
publisher name varchar(50)
notes text
hold boolean
(INDEX sort title)

Authors (note add UNKNOWN and ANON options)
id int PK auto
first name varchar(50) (null ok for single-name values)
last name varchar(50) NOT NULL
(INDEX last, first)

Books_authors (books can have multiple authors)
id int PK auto
book id int FK books.id NOT NULL DELETE ON CASC
author id int FK authors.id NOT NULL DELETE ON CASC

Borrowers
id int PK auto
first name varchar(50) NOT NULL
last name varchar(50) NOT NULL
phone (varchar 10)
email varchar(50)
borrower notes text
(INDEX last, first)

Borrows
id int PK auto
book id  FK books.id NOT NULL (likely not DELETE ON CASC - there should be a warning maybe)
borrower id FK borrowers.id NOT NULL (again, not likely DELETE ON CASC)
borrow_date date NOT NULL
borrow notes text
return date date

## Notes
- intended for casual borrowing - e.g., if I have a lot of books and a lot of friends, and I want to keep track of friends borrowing books and their contact info
- notes fields for books allows additional freeform info
- View book is where a book is borrowed
- When a new book is added, use select list populated with authors, with button to add new author and return to current screen upon adding author
- When a book is borrowed, use select list of names of borrowers with add button (return to this screen after add)
- notes fields for borrower and also borrow for freeform info about either (e.g. book returned damaged, borrower's impression of book, borrower who is slow to return books)
- On book list, clicking on title goes to book view, clicking on borrower goes to borrower view
- There is added complexity when first implementing this as a session, because the data is relational. Can opt to do a simple version (just a book list) when using a session and then expand it to borrowing capability when using the database. Or just go ahead and simulate the relational aspect.

## Approach

- Create project directory and initialize git
- Start working on .rb file, implementing sessions for maintaining data
- Work on templates and helpers as the routes are coded
- Implement some basic CSS, just to be neat
- Pull out session persistence to its own class and implement
- Replace session persistence with database
