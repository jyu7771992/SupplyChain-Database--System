# SupplyChain-Database--System


## Project Members: 
Pei-Pei Yu yu.pei-@northeastern.edu  
Hui Du du.hui@northeastern.edu  
Jianjian Liu liu.jianj@northeastern.edu  
Chenchen Jiang jiang.chenc@northeastern.edu



# Database Topic

Inventory Management and Sales Database System   
(Inventory, Sales, and Quality Control Management System)

# Mission Statement/Mission Goal:
To design and implement a comprehensive database system that efficiently manages inventory across various locations, tracks sales, ensures product quality, and facilitates recall procedures. This system aims to streamline operations, optimize stock levels, enhance customer satisfaction, and ensure rapid response to quality control issues.

# Mission Objectives 

## 1. Inventory Management:
* Track inventory levels in real-time across different locations, such as stores and warehouses.
* Manage inventory replenishment to prevent stockouts and reduce excess stock.
* Monitor product movements to and from various locations.

## 2. Sales Tracking:
* Record all sales transactions, associating them with specific sellers and customers
* Provide insights into top-selling products, peak sales periods, and customer buying patterns.
* Integrate with the inventory system to update stock levels after every sale.

## 3. Quality Control and Recall:
* Introduce batch IDs for products to swiftly and effectively manage any recalls or quality issues.
* Monitor returned products, identifying patterns that might indicate larger quality concerns.
* Ensure rapid communication and action in case of identified quality issues to maintain brand reputation and customer trust.

## 4. Location Management:
* Categorize locations based on their type (store, warehouse, etc.).
* Track the capacity and usage of each location to optimize space utilization.
* Manage location details including address, contact information, and type to facilitate easy communication and stock transfers.

## 5. Integrated Contact Management:
* Maintain a centralized repository of all stakeholders' contact details, including suppliers, manufacturers, sellers, and customers
* Enable swift communication for business operations, recalls, promotions, or other notifications.

## 6. Database Maintenance & Operations:
* Facilitate easy data entry, updates, and deletions to ensure the database remains current and accurate.
* Implement advanced search capabilities to retrieve specific data points or generate insights efficiently.
* Design comprehensive reporting tools to provide detailed insights, summaries, and actionable recommendations based on the data.

# Database Purpose: 

To design and implement a comprehensive database system that efficiently manages inventory across various locations, tracks sales, ensures product quality, and facilitates recall procedures. This system aims to streamline operations, optimize stock levels, enhance customer satisfaction, and ensure rapid response to quality control issues.

## Business Problems Addressed: 

* Allow businesses to maintain optimal inventory levels by providing real-time stock levels. Automated alerts can notify when stock is low or when it’s time to restock.
* Track supplier performance, manage relationships, and facilitate communication. This ensures timely reordering, better negotiation, and improved collaboration with suppliers.
* Help businesses ensure the sales track processing in terms of ordering and delivering, improving overall customer satisfaction.
* Provide a platform for businesses to centralise the sales data, reducing the risk of errors and ensuring data consistency. Automation minimises the need for manual entry, improving data accuracy.
* Analyse historical sales data to generate accurate forecasts. This helps businesses plan inventory levels based on anticipated demand, reducing the likelihood of stockouts or excess inventory.
* The system provides real-time financial insights by integrating sales and inventory data. This facilitates better financial planning, cost control, and improved overall financial management.
* The system can automate compliance checks and generate reports on sales, inventory turnover, and other key metrics, ensuring that businesses meet regulatory requirements and make informed decisions.
* The system can track products using unique identifiers (such as serial numbers or batch numbers) and maintain detailed records of sales. In the event of a recall, businesses can swiftly identify affected products, notify customers, and manage the recall process efficiently.
* The database system can store warranty information for each product sold, including warranty periods and terms. Automated alerts can notify when warranties are about to expire, and the system can streamline the warranty claims process, ensuring timely resolution and customer satisfaction.

## Business Rules: 

* Each customer may have zero or more orders, and zero or more return orders.
* Each order will have one or more products.
* Each product will belong to a certain category.
* Each product may have one or more suppliers.
* Each product will have its inventory, store location, batch number, product serial and the suppliers. 
* Each supplier may have one or more manufacturers. 
* Each supplier will have its company information.
* Each manufacturer may have one or more factory locations. 
* Each factory location will have its address information. 


# Entity Relationship Diagram (ERD)


![Copy of Supply Chain final ERD - Page 1](https://github.com/jiangchenchen000/SupplyChain-Database-DAMG6210/assets/122926291/66b1ec31-c7aa-433e-aff4-513d992520e9)

