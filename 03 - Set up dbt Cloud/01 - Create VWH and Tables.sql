-- Create a new Warehouse Instance
create warehouse transforming;

-- Create two databases: raw and analytics
create database raw;
create database analytics;

-- Create jaffle_shop schema in raw database
create schema raw.jaffle_shop;

-- Create table customers in raw.jaffle_shop
create table raw.jaffle_shop.customers
(
    id          integer,
    first_name  varchar,
    last_name   varchar
);

-- Load data into customers from public S3 file
copy into raw.jaffle_shop.customers (id, first_name, last_name)
    from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
        file_format = (
            type = 'CSV'
            field_delimiter = ','
            skip_header = 1
        )
;

-- Create table orders in raw.jaffle_shop
create table raw.jaffle_shop.orders
(
    id                integer,
    user_id           integer,
    order_date        date,
    status            varchar,
    _etl_loaded_at    timestamp default current_timestamp
);

-- Load data into orders from public S3 file
copy into raw.jaffle_shop.orders (id, user_id, order_date, status)
    from 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
        file_format = (
            type = 'CSV'
            field_delimiter = ','
            skip_header = 1
        )
;

-- Create stripe schema in raw database
create schema raw.stripe;

-- Create table payment in raw.stripe
create table raw.stripe.payment (
    id              integer,
    orderid         integer,
    paymentmethod   varchar,
    status          varchar,
    amount          integer,
    created         date,
    _batched_at     timestamp default current_timestamp
);

-- Load data into payment from public S3 file
copy into raw.stripe.payment (id, orderid, paymentmethod, status, amount, created)
from 's3://dbt-tutorial-public/stripe_payments.csv'
    file_format = (
        type = 'CSV'
        field_delimiter = ','
        skip_header = 1
    )
;
