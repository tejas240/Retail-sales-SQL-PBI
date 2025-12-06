-- creating tables with data normalization
-- Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    location VARCHAR(50)
);

-- Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- inserting data into customers table
INSERT INTO Customers (customer_id, name, age, location) 
VALUES
(1, 'Alice Johnson', 28, 'New York'),
(2, 'Bob Smith', 35, 'Chicago'),
(3, 'Charlie Davis', 42, 'Los Angeles'),
(4, 'Diana Lee', 30, 'New York'),
(5, 'Ethan Brown', 25, 'Houston');

-- inserting data into products table
INSERT INTO Products (product_id, product_name, category, price) 
VALUES
(101, 'Smartphone X', 'Electronics', 699.99),
(102, 'Laptop Pro', 'Electronics', 1199.99),
(103, 'Coffee Maker', 'Home Appliances', 89.99),
(104, 'Running Shoes', 'Sportswear', 129.99),
(105, 'Headphones', 'Electronics', 199.99);

-- inserting data into orders table
INSERT INTO Orders (order_id, customer_id, product_id, order_date, quantity) VALUES
(1001, 1, 101, '2025-01-15', 1),
(1002, 2, 102, '2025-01-20', 1),
(1003, 3, 103, '2025-02-05', 2),
(1004, 4, 104, '2025-02-10', 1),
(1005, 5, 105, '2025-02-12', 3),
(1006, 1, 105, '2025-03-01', 1),
(1007, 2, 103, '2025-03-03', 1),
(1008, 3, 101, '2025-03-10', 2),
(1009, 4, 102, '2025-03-15', 1),
(1010, 5, 104, '2025-03-20', 2);

select * from customers;
select * from products;
select * from orders;

-- find distinct places from customers table
select distinct location from customers;

-- find distinct products
select distinct product_name from products;

-- find different product categories
select distinct category from products;

-- find all products from electronics category
select product_id,product_name from products 
where category='Electronics';

-- calculate total revenue
select sum(o.quantity*p.price) as total_revenue 
from orders o join products p on o.product_id=p.product_id;

-- product wise sales
select p.product_name,sum(o.quantity*p.price) as total_revenue ,sum(o.quantity) as units_sold
from orders o join products p on o.product_id=p.product_id
group by p.product_name;

-- average order value 
select avg(o.quantity*p.price) as average_order_value
from orders o join products p on o.product_id=p.product_id;

-- total quantity ordered per category and revenue
select p.category,sum(o.quantity) as units_sold,sum(o.quantity*p.price) as category_revenue 
from orders o join products p on o.product_id=p.product_id
group by p.category;

-- each order with customer name and product details
select o.order_id,c.name,p.product_name,o.quantity,(o.quantity*p.price) as sales 
from orders o left join products p on o.product_id=p.product_id
left join customers c on c.customer_id=o.customer_id;

-- top 3 customers by spending
select c.name,sum(o.quantity*p.price) as total_sale from orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id
group by c.name
order by total_sale desc
limit 3
;


-- monthly sales 
select monthname(order_date) as month_name,month(order_date) as month,sum(o.quantity*p.price) as monthly_sales
from orders o left join products p on p.product_id=o.product_id
group by monthname(order_date),month(order_date) 
order by month;

-- running total revenue by date
select order_date,sum(o.quantity*p.price) as daily_sales,sum(sum(o.quantity*p.price)) over(order by order_date) as running_revenue
from orders o left join products p on p.product_id=o.product_id
group by order_date
order by order_date;

-- units sold by product per month
select product_name,sum(quantity) as units_sold,sum(quantity*price) as sales,month(order_date) as month_num,monthname(order_date) as month 
from orders o join products p on o.product_id=p.product_id
 group by product_name,month(order_date),monthname(order_date);