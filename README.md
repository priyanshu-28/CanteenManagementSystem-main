## Introduction

The Canteen Management System is a portal built to simplify the management aspects across the canteen with respect to managing customers, orders, analytics, and suppliers. CMS provides a full-fledged solution for most of the general problems as well as a streamlined workflow for the same.

## Tech Stack

The Following is a web-based application which can run on any computer and operating system with a browser. The Tech Stack used by the application:
Frontend:

- HTML
- CSS
- Javascript
  Backend:
- Express
- Node
  Database:
- PostgreSQL

The respective tech-stack was chosen to develop a more user-friendly application which would be cross platform and have no system requirements when deployed to the server.

PostgreSQL was used as a database because it is Free and Open source. It is also a more robust system with better compatibility across platforms, light-weight and has better error handling and response. This enables easier and faster transactions across the backend and the database.

## Comprehensive Overview

The Canteen Management System is pretty comprehensive in its application and purposes. It offers the following features for Canteen Management

- Viewing the list of product (caterer and customer)
- Viewing the list of orders (caterer)
- Viewing the list of suppliers (caterer)
- Viewing the list of customers (caterer)
- Viewing specific customer data (caterer)
- Creating and Deleting New Orders (customer)
- Canceling and Updating Orders (caterer)
- Analytics - Overview of the database. Valuable information with respect to the System. (caterer)
- Total Sales of the Canteen
- Total Number of Orders
- Count of Customers
- Cost of Material (Canteen Management Cost)
- Adding and Deleting products (caterer)
- Adding and Deleting Suppliers

## Application flow

A customer selects an order based on the product list visible. The product list is set by the caterer. The selected product is taken as an order by the application and stored as unprocessed. The caterer can update the status once the order is processed. A customer portal exists for showing the number of orders / analytics of a customer as well as the list of customers.

The caterer is a sole connecting entity and holds the maximum power and thus the maximum viewing access. The caterer can also view the suppliers and has access to the materials left in the inventory. The caterer can add and delete products and also add and delete orders based on the requirement. Updating orders is also one of the responsibilities of the caterer.

The analytics portal is meant for both the customer and the caterer. The analytics portal shows canteen analytics which could be helpful and useful to any caterer for improving their system.

ERD Diagram:

![ERD - Canteen Management](https://user-images.githubusercontent.com/87660206/166644174-ba4d0182-2c41-45ba-91c4-cae1a2cf1b44.png)

Table Design

The system consists of seven tables namely:

- Customer
- OrderTable
- Product
- Caterer
- Bill
- Material
- Supplier
- Mat_req
- Feedback

## Setup

1. Install Postgres: https://www.postgresql.org/download/
2. Open a terminal and run the following commands

```
psql --version // check the version

sudo -u postgres psql // for linux

```

3. Create a database

```
create database 'canteen2'

```

4. Create a user and grant all privileges to that user

```
create user 'client' with password 'abcdefg1';
grant all privileges on database canteen2 to client;
grant all privileges on all tables in schema public to client;

```

5. Go to that database

```
\c canteen2

```

6. Run the tables.sql file

```
\i 'Path to tables.sql'
```

7. Similarly run the functions and procedures file.

8. Open the base directory of the project

```
node index.js
```

### Some helpful Postgress Commands

```
\l - show all databases
\c 'databaseName' - connect to specific database
\t - show all tupples
\d - show all tables
\




```
