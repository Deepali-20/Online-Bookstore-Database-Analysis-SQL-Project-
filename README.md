# Online-Bookstore-Database-Analysis-SQL-Project-
This project contains SQL scripts for creating, populating, and analyzing an **Online Bookstore** database.   It demonstrates database design, data import, and analytical SQL queries useful for business insights such as sales trends, customer analysis, and inventory tracking.
Welcome to the **Online Bookstore Database Project**!  
This project demonstrates how to design, populate, and analyze an online bookstore database using **PostgreSQL**.  
It includes:
- 📘 Database creation  
- 📥 CSV data import  
- 🔍 Analytical SQL queries  
- 📊 Business insights  

---

## 🧾 Table of Contents
- [Overview](#overview)
- [Database Schema](#database-schema)
- [Data Import](#data-import)
- [Basic Queries](#basic-queries)
- [Advanced Queries](#advanced-queries)
- [Key Learnings](#key-learnings)
- [Technologies Used](#technologies-used)
- [Author](#author)

---

## 🗂️ Overview

This database contains three tables:

| Table | Description |
|--------|--------------|
| **Books** | Stores book information such as title, author, genre, and price |
| **Customers** | Stores customer details like name, contact info, and location |
| **Orders** | Tracks customer purchases and total order amount |

---

## 🏗️ Database Schema

<details>
<summary>📜 Click to view SQL schema</summary>

```sql
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

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
</details>
📥 Data Import
<details> <summary>📂 Click to view CSV import commands</summary>
sql
Copy code
-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\\Users\\deepu\\Downloads\\book.csv'
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:\\Users\\deepu\\Downloads\\customer.csv'
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\\Users\\deepu\\Downloads\\Orders.csv'
CSV HEADER;
</details>
🔍 Basic Queries
<details> <summary>🧩 Click to view basic SQL queries</summary>
sql
Copy code
-- 1️⃣ Retrieve all books in the "Fiction" genre
SELECT * FROM Books WHERE genre = 'Fiction';

-- 2️⃣ Find books published after the year 1950
SELECT * FROM Books WHERE published_year > 1950 ORDER BY published_year;

-- 3️⃣ List all customers from Canada
SELECT * FROM Customers WHERE country = 'Canada';

-- 4️⃣ Show orders placed in November 2023
SELECT * FROM Orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5️⃣ Retrieve the total stock of books available
SELECT COUNT(Book_ID) AS Total_Stock FROM Books;

-- 6️⃣ Find the details of the most expensive book
SELECT title, author, genre, price FROM Books
ORDER BY price DESC
LIMIT 1;

-- 7️⃣ Show all customers who ordered more than 1 quantity of a book
SELECT customer_id, SUM(quantity)
FROM Orders
GROUP BY customer_id
HAVING SUM(quantity) > 1
ORDER BY 1;

-- 8️⃣ Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders WHERE total_amount > 20;

-- 9️⃣ List all genres available in the Books table
SELECT genre FROM Books GROUP BY genre;

-- 🔟 Find the book with the lowest stock
SELECT * FROM Books ORDER BY stock LIMIT 1;

-- 11️⃣ Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue FROM Orders;
</details>
📊 Advanced Analytical Queries
<details> <summary>📈 Click to view advanced analytical queries</summary>
sql
Copy code
-- 1️⃣ Total number of books sold for each genre
SELECT b.genre, COUNT(o.quantity) AS total_book
FROM Books b
JOIN Orders o
ON b.book_id = o.book_id
GROUP BY b.genre;

-- 2️⃣ Average price of books in the "Fantasy" genre
SELECT genre, AVG(price)
FROM Books
GROUP BY genre
HAVING genre = 'Fantasy';

-- Alternate method
SELECT AVG(price) AS average_price
FROM Books
WHERE genre = 'Fantasy';

-- 3️⃣ Customers who have placed at least 2 orders
SELECT customer_id, COUNT(*) AS total_order
FROM Orders
GROUP BY 1
HAVING COUNT(*) >= 2;

-- 4️⃣ Most frequently ordered book
SELECT b.title, COUNT(o.*) AS frequent_order
FROM Books b
JOIN Orders o
ON b.book_id = o.book_id
GROUP BY b.title
ORDER BY COUNT(o.*) DESC;

-- Alternative method using ranking
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

-- 5️⃣ Top 3 most expensive books of 'Fantasy' Genre
SELECT title, genre, price
FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- 6️⃣ Total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) AS Total_quantity
FROM Books b
JOIN Orders o
ON b.book_id = o.book_id
GROUP BY b.author;

-- 7️⃣ Cities where customers who spent over $30 are located
SELECT DISTINCT c.city
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.total_amount > 30;

-- 8️⃣ Customer who spent the most on orders
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY SUM(o.total_amount) DESC
LIMIT 1;

-- 9️⃣ Remaining stock after fulfilling all orders
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

Key Learnings

📘 Designing relational databases

🧩 Using JOIN, GROUP BY, HAVING, and aggregate functions

📊 Writing analytical queries for business insights

📤 Importing data using COPY command

💡 Applying SQL for real-world scenarios
