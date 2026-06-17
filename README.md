# E-Commerce Database Management System

A relational database system for managing an e-commerce platform, built with MySQL, covering schema design, ACID-compliant transactions, and optimized queries.
                                             
                                              **This project was done as a part of my course curriculum.**

**Dataset:** Kaggle  
**Tools:** MySQL

## Project Structure
```
ecommerce-db/
├── schema/
│   └── create_tables.sql      # Full schema with relationships and indexes
├── queries/
│   ├── transactions.sql        # ACID-compliant order transactions
│   └── analytics.sql           # Business queries (revenue, top sellers, etc.)
├── data/
│   └── seed_data.sql           # Sample data for testing
└── README.md
```

## Setup

1. Start MySQL and create the database:
```sql
CREATE DATABASE ecommerce;
USE ecommerce;
```

2. Run scripts in order:
```bash
mysql -u root -p ecommerce < schema/create_tables.sql
mysql -u root -p ecommerce < data/seed_data.sql
mysql -u root -p ecommerce < queries/transactions.sql
```

## Schema Overview

| Table       | Description                          |
|-------------|--------------------------------------|
| sellers     | Registered sellers on the platform   |
| customers   | Customer accounts                    |
| products    | Product listings linked to sellers   |
| orders      | Purchase records with ACID support   |
| order_items | Line items per order                 |
