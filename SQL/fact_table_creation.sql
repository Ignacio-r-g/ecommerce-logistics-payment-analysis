USE brazilian_store;

#CREATE MASTER TABLE
DROP TABLE IF EXISTS fact_orders;
SET SQL_SAFE_UPDATES = 1;
CREATE TABLE fact_orders AS

SELECT
	o.order_id,
    c.customer_id,
    c.customer_city,
    oi.product_id,
	oi.price,
    oi.freight_value,
	p.product_category_name,
    (p.product_weight_g) / 1000 AS product_weight_kg,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
	(p.product_length_cm *
	 p.product_height_cm *
     p.product_width_cm) / 1000000 AS product_volume_m3
 

FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c
ON o.customer_id = c.customer_id

LEFT JOIN olist_order_items_dataset oi
ON o.order_id = oi.order_id

LEFT JOIN olist_products_dataset p
ON oi.product_id = p.product_id


