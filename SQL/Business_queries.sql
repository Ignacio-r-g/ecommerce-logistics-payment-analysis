USE brazilian_store;
## ==============================================================================
## PROBLEMA DEL NEGOCIO: ¿Qué factores impactan más el costo del envío?
## ==============================================================================

SELECT
		CASE
			WHEN product_weight_kg <= 0.5 THEN "light"
            WHEN product_weight_kg <= 2 THEN "medium"
            ELSE "heavy"
		END AS weight_category,
        
        ROUND(AVG(price),2) AS avg_price_usd,
        ROUND(AVG(freight_value),2) AS avg_freight_usd,
        ROUND(SUM(freight_value) / SUM(price),2) AS shipping_cost_ratio
        
        FROM fact_orders
        WHERE price > 0
        GROUP BY weight_category
        ORDER BY shipping_cost_ratio DESC;
## =====================================================================================================================================================================          
## Los productos ligeros presentan una mayor proporcion de costos logisticos, lo que sugiere una menor eficiencia en envios de productos de menor valor.
## lo que indica que los costos de envío pueden tener un efecto proporcionalmente mayor en los productos de menor valor
## =====================================================================================================================================================================  
    
## ================================================
## ¿Qué categorías tienen mayor freight promedio?
## ================================================

SELECT
	product_category_name,
    ROUND(AVG(freight_value),2) AS avg_freight_usd
    FROM fact_orders
    GROUP BY product_category_name
    ORDER BY avg_freight_usd DESC;
    
## ==============================================================  
##¿Qué productos son menos eficientes logísticamente TOP 10
## ==============================================================

SELECT
	product_category_name,
	ROUND(SUM(freight_value) / SUM(price),2) AS shipping_cost_ratio
    FROM fact_orders
    WHERE price > 0
    GROUP BY product_category_name
    ORDER BY shipping_cost_ratio DESC
    LIMIT 10;

SELECT
		product_category_name,
        product_weight_kg,
        price
		FROM fact_orders
        WHERE product_category_name = "casa_conforto_2";
## ==================================================================================================              
##ciertos productos tienen costos logísticos desproporcionados respecto al valor de este.     
## ==================================================================================================

## ================================================================ 
##¿Como el volumen del producto impacta el precio de los envio?
## ================================================================
SELECT
	CASE
    WHEN product_volume_m3 <=0.01 THEN "small volume"
    WHEN product_volume_m3 <=0.05 THEN "medium volume"
    ELSE "large volume"
    
    END AS volume_category,
    ROUND(AVG(freight_value),2) AS avg_freight,
    ROUND(SUM(freight_value) / SUM(price),2) AS shipping_cost_ratio 
    FROM fact_orders
    WHERE price > 0
    GROUP BY volume_category
    ORDER BY shipping_cost_ratio DESC;
    

## =====================================================================================================   
##Los productos de volumen mediano presentan la relación más baja entre flete y precio, 
##con los costos de envío representando aproximadamente el 15% del valor del producto aproximadamente.
## ===================================================================================================== 

## ==========================================================================================================================================
## Los productos ligeros pero de gran volumen tienden a generar proporciones de flete a precio desproporcionadamente altas,
## lo que sugiere que la utilización del espacio (volumen) de envío puede afectar significativamente la eficiencia logística.
## ==========================================================================================================================================

SELECT 
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
    ROUND(AVG(freight_value), 2) AS avg_freight,
    ROUND(SUM(freight_value) / SUM(price),2) AS shipping_cost_ratio,
    ROUND(AVG(price), 2) AS avg_price
FROM
    fact_orders
WHERE
    price > 0
GROUP BY weight_category , volume_category
ORDER BY shipping_cost_ratio DESC;

## =========================
##      CONCLUSION  
## =========================

## =====================================================================================================================================================================================
##El análisis SQL sugiere que las características del producto, como el peso, el volumen y la categoría, influyen significativamente en la eficiencia logística. 
##Los productos con menor valor relativo y combinaciones desfavorables de peso y volumen presentan mayores proporciones de costos de envío respecto a los ingresos generados,
##indicando posibles desafíos operacionales y menor eficiencia en el transporte.
## =====================================================================================================================================================================================



