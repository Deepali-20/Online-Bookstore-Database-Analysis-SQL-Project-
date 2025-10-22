-- Create Database
CREATE DATABASE OnlineBookstore;
-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM '‪C:\Users\deepu\Downloads\book.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM '‪C:\Users\deepu\Downloads\customer.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM '‪C:\Users\deepu\Downloads\Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books WHERE genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books WHERE published_year>1950 ORDER BY published_year;


-- 3) List all customers from the Canada:

SELECT * FROM customers WHERE country ='Canada';


-- 4) Show orders placed in November 2023:
SELECT * FROM orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';


-- 5) Retrieve the total stock of books available:
SELECT  COUNT(Book_ID) AS Tota_Stock FROM Books;


-- 6) Find the details of the most expensive book:
SELECT title,author, genre, price FROM books 
order by price DESC 
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT customer_id ,SUM (quantity) FROM Orders 
GROUP BY customer_id HAVING SUM(quantity)>1 ORDER BY 1;



-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders WHERE total_amount> 20;


-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders WHERE total_amount> 20;


-- 9) List all genres available in the Books table:
SELECT genre FROM Books GROUP BY (genre);


-- 10) Find the book with the lowest stock:
SELECT * FROM Books ORDER BY stock LIMIT 1;
-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS total_revenue FROM Orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT b.genre , COUNT(o.quantity) as total_book
FROM Books b
JOIN Orders o
on b.book_id = o.book_id
GROUP BY b.genre;



-- 2) Find the average price of books in the "Fantasy" genre:

SELECT genre , avg(price) FROM Books GROUP BY genre 
HAVING genre= 'Fantasy';

---- or other
SELECT AVG(price) AS average_price
FROM Books
WHERE genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT customer_id , COUNT(*) AS total_order
FROM Orders
GROUP BY 1
HAVING COUNT(*)>=2;

-- 4) Find the most frequently ordered book:
SELECT b.title,COUNT(O.*) AS frequent_order
FROM Books b
JOin Orders o
ON b.book_id = o.book_id
GROUP BY 1
ORDER BY COUNT(O.*) DESC
;
----- OR OTHER METHODS
SELECT title, frequent_order
FROM (
    SELECT b.title, COUNT(*) AS frequent_order,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM Books b
    JOIN Orders o
    ON b.book_id = o.book_id
    GROUP BY b.title
) AS ranked
WHERE rnk = 1;





-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT title , genre ,price FROM Books WHERE genre = 'Fantasy' 
ORDER BY price DESC limit 3;



-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author,SUM(o.quantity) AS Total_quantity
FROM Books b
 JOIN Orders o
ON b.book_id = o.book_id
GROUP BY b.author;




-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.total_amount > 30;
-- 8) Find the customer who spent the most on orders:

SELECT c.name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY SUM(o.total_amount) DESC
LIMIT 1;



--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.title, 
       GREATEST(b.stock - COALESCE(SUM(o.quantity), 0), 0) AS remaining_stock,
	CASE 
        WHEN b.stock - COALESCE(SUM(o.quantity), 0) <= 0 THEN 'Out of Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM Books b
LEFT JOIN Orders o
ON b.book_id = o.book_id
GROUP BY b.book_id, b.title;











