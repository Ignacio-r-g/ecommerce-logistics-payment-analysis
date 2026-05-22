USE brazilian_store;
## ===================================================================================================================================================================
## Se crea las views, dim_category nos servirá para conectar todas las views en power bi, para respetar el modelado.
## ===================================================================================================================================================================

CREATE VIEW view_dim_category AS
SELECT DISTINCT
    product_category_name
FROM fact_orders
WHERE product_category_name IS NOT NULL
AND product_category_name <> '';
    
CREATE VIEW view_shipping_efficiency AS
SELECT
    product_category_name,

    CASE
        WHEN product_weight_kg <= 0.5 THEN 'light'
        WHEN product_weight_kg <= 2 THEN 'medium'
        ELSE 'heavy'
    END AS weight_category,

    CASE
        WHEN product_volume_m3 <= 0.01 THEN 'small volume'
        WHEN product_volume_m3 <= 0.05 THEN 'medium volume'
        ELSE 'large volume'
    END AS volume_category,

    ROUND(AVG(price),2) AS avg_price,
    ROUND(AVG(freight_value),2) AS avg_freight,

   ROUND(SUM(freight_value) / SUM(price),2) AS shipping_cost_ratio

FROM fact_orders

WHERE price > 0

GROUP BY
    product_category_name,
    weight_category,
    volume_category;
    
    
DROP VIEW IF EXISTS orders_for_payments;
    CREATE VIEW view_orders_for_payments AS
SELECT
    order_id,
    product_category_name,
    price,
    freight_value,

    ROUND(freight_value / price,2) AS shipping_cost_ratio,

    product_weight_kg,
    product_volume_m3

FROM fact_orders

WHERE price > 0;
