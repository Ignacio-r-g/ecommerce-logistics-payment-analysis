SELECT * FROM brazilian_store.fact_orders;


## ================================================================================
## Now we check if INNER JOIN its enought or we should use LEFT JOIN.
## ================================================================================

SELECT COUNT(*) FROM fact_orders;

SELECT COUNT(*) FROM olist_order_items_dataset;

SELECT COUNT(*) 
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o
ON oi.order_id = o.order_id;


SELECT COUNT(*) 
FROM olist_order_items_dataset oi

JOIN olist_orders_dataset o
ON oi.order_id = o.order_id

JOIN olist_products_dataset p
ON oi.product_id = p.product_id;


SELECT COUNT(*)
FROM olist_order_items_dataset oi

JOIN olist_orders_dataset o
ON oi.order_id = o.order_id

JOIN olist_products_dataset p
ON oi.product_id = p.product_id

JOIN olist_customers_dataset c
ON o.customer_id = c.customer_id;


SELECT order_id, COUNT(*)

FROM olist_order_payments_dataset

GROUP BY order_id

HAVING COUNT(*) > 1;


SELECT order_id, product_id, COUNT(*)

FROM fact_orders

GROUP BY order_id, product_id

HAVING COUNT(*) > 1;


## ================================================================================
## 									CONLUSION
##================================================================================

## =================================================================================================
## INNER JOIN isn't enough because don't bring all information so we should use LEFT JOIN instead 
##==================================================================================================

