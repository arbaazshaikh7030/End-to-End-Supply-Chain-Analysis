USE supply_chain_db;
SHOW TABLES;

USE supply_chain_db;

CREATE TABLE supply_chain (
    product_type VARCHAR(100),
    sku VARCHAR(100),
    price DECIMAL(12,2),
    availability INT,
    number_of_products_sold INT,
    revenue_generated DECIMAL(15,2),
    customer_demographics VARCHAR(100),
    stock_levels INT,
    lead_times INT,
    order_quantities INT,
    shipping_times INT,
    shipping_carriers VARCHAR(100),
    shipping_costs DECIMAL(12,2),
    supplier_name VARCHAR(150),
    location VARCHAR(100),
    lead_time INT,
    production_volumes INT,
    manufacturing_lead_time INT,
    manufacturing_costs DECIMAL(12,2),
    inspection_results VARCHAR(100),
    defect_rates DECIMAL(12,4),
    transportation_modes VARCHAR(100),
    routes VARCHAR(100),
    costs DECIMAL(15,2),
    shipping_time_category VARCHAR(50),
    inventory_status VARCHAR(100)
);


USE supply_chain_db;

SHOW TABLES;

USE supply_chain_db;

SELECT COUNT(*) AS total_records
FROM supply_chain;

USE supply_chain_db;

TRUNCATE TABLE supply_chain;

SELECT COUNT(*) AS total_records
FROM supply_chain;

SELECT *
FROM supply_chain
LIMIT 10;

DESCRIBE supply_chain;

SELECT
    sku,
    COUNT(*) AS record_count
FROM supply_chain
GROUP BY sku
HAVING COUNT(*) > 1;

SELECT
    SUM(product_type IS NULL) AS missing_product_type,
    SUM(sku IS NULL) AS missing_sku,
    SUM(supplier_name IS NULL) AS missing_supplier,
    SUM(shipping_times IS NULL) AS missing_shipping_time,
    SUM(shipping_costs IS NULL) AS missing_shipping_cost,
    SUM(stock_levels IS NULL) AS missing_stock_levels
FROM supply_chain;

SELECT
    ROUND(AVG(shipping_times), 2) AS average_shipping_time
FROM supply_chain;

SELECT
    transportation_modes,
    COUNT(*) AS total_shipments,
    ROUND(AVG(shipping_times), 2) AS average_shipping_time
FROM supply_chain
GROUP BY transportation_modes
ORDER BY average_shipping_time;

SELECT
    shipping_carriers,
    COUNT(*) AS total_records,
    ROUND(AVG(shipping_times), 2) AS average_shipping_time
FROM supply_chain
GROUP BY shipping_carriers
ORDER BY average_shipping_time;

SELECT
    sku,
    product_type,
    shipping_carriers,
    transportation_modes,
    shipping_times
FROM supply_chain
WHERE shipping_times > 5
ORDER BY shipping_times DESC;

SELECT
    shipping_time_category,
    COUNT(*) AS total_records
FROM supply_chain
GROUP BY shipping_time_category
ORDER BY total_records DESC;

SELECT DISTINCT supplier_name
FROM supply_chain
ORDER BY supplier_name;

SELECT
    supplier_name,
    COUNT(*) AS total_records,
    ROUND(AVG(lead_time), 2) AS average_lead_time,
    ROUND(AVG(manufacturing_lead_time), 2) AS average_manufacturing_time,
    ROUND(AVG(defect_rates), 2) AS average_defect_rate,
    ROUND(AVG(manufacturing_costs), 2) AS average_manufacturing_cost
FROM supply_chain
GROUP BY supplier_name
ORDER BY average_lead_time;

SELECT
    supplier_name,
    ROUND(AVG(defect_rates), 2) AS average_defect_rate,
    COUNT(*) AS total_records
FROM supply_chain
GROUP BY supplier_name
ORDER BY average_defect_rate DESC;

SELECT
    supplier_name,
    inspection_results,
    COUNT(*) AS total_records
FROM supply_chain
GROUP BY supplier_name, inspection_results
ORDER BY supplier_name;

SELECT
    supplier_name,
    ROUND(SUM(manufacturing_costs), 2) AS total_recorded_manufacturing_cost
FROM supply_chain
GROUP BY supplier_name
ORDER BY total_recorded_manufacturing_cost DESC;

SELECT
    sku,
    product_type,
    stock_levels,
    availability,
    number_of_products_sold,
    order_quantities
FROM supply_chain
ORDER BY stock_levels ASC;

#Analyze inventory status
SELECT
    inventory_status,
    COUNT(*) AS total_records
FROM supply_chain
GROUP BY inventory_status;

#Compare stock levels with sales
SELECT
    product_type,
    COUNT(*) AS total_records,
    ROUND(AVG(stock_levels), 2) AS average_stock,
    SUM(number_of_products_sold) AS total_products_sold,
    ROUND(AVG(availability), 2) AS average_availability
FROM supply_chain
GROUP BY product_type
ORDER BY total_products_sold DESC;

#Find products with relatively high sales and low stock
SELECT
    sku,
    product_type,
    stock_levels,
    number_of_products_sold
FROM supply_chain
WHERE stock_levels < 20
ORDER BY number_of_products_sold DESC;

#Shipping and Transportation Cost Analysis
#Total recorded shipping costs
SELECT
    ROUND(SUM(shipping_costs), 2) AS total_shipping_costs,
    ROUND(AVG(shipping_costs), 2) AS average_shipping_cost
FROM supply_chain;

#Shipping costs by carrier
SELECT
    shipping_carriers,
    COUNT(*) AS total_records,
    ROUND(AVG(shipping_costs), 2) AS average_shipping_cost,
    ROUND(SUM(shipping_costs), 2) AS total_recorded_shipping_cost
FROM supply_chain
GROUP BY shipping_carriers
ORDER BY average_shipping_cost DESC;

#Shipping costs by transportation mode
SELECT
    transportation_modes,
    COUNT(*) AS total_records,
    ROUND(AVG(shipping_costs), 2) AS average_shipping_cost
FROM supply_chain
GROUP BY transportation_modes
ORDER BY average_shipping_cost DESC;

#Analyze shipping costs by route
SELECT
    routes,
    COUNT(*) AS total_records,
    ROUND(AVG(shipping_costs), 2) AS average_shipping_cost,
    ROUND(AVG(shipping_times), 2) AS average_shipping_time
FROM supply_chain
GROUP BY routes
ORDER BY average_shipping_cost DESC;

#Identify high-cost shipping records
SELECT
    sku,
    product_type,
    shipping_carriers,
    transportation_modes,
    routes,
    shipping_costs,
    shipping_times
FROM supply_chain
ORDER BY shipping_costs DESC
LIMIT 10;

#Warehouse and Location Performance
#Analyze recorded locations
SELECT
    location,
    COUNT(*) AS total_records,
    ROUND(AVG(shipping_times), 2) AS average_shipping_time,
    ROUND(AVG(shipping_costs), 2) AS average_shipping_cost,
    ROUND(AVG(stock_levels), 2) AS average_stock
FROM supply_chain
GROUP BY location
ORDER BY average_shipping_time DESC;

#Analyze inventory by location
SELECT
    location,
    SUM(stock_levels) AS total_recorded_stock,
    SUM(number_of_products_sold) AS total_products_sold
FROM supply_chain
GROUP BY location
ORDER BY total_recorded_stock DESC;

#Create an Executive Summary in SQL
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT sku) AS unique_skus,
    COUNT(DISTINCT supplier_name) AS unique_suppliers,
    COUNT(DISTINCT shipping_carriers) AS unique_carriers,
    ROUND(AVG(shipping_times), 2) AS average_shipping_time,
    ROUND(AVG(shipping_costs), 2) AS average_shipping_cost,
    ROUND(AVG(lead_time), 2) AS average_supplier_lead_time,
    ROUND(AVG(defect_rates), 2) AS average_defect_rate,
    SUM(number_of_products_sold) AS total_recorded_products_sold,
    SUM(stock_levels) AS total_recorded_stock
FROM supply_chain;



