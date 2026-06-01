USE brazilian_store;
## ==============================================================================
## BUSINESS PROBLEM: What factors most impact shipping costs?
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
## Lightweight products have a higher proportion of logistics costs, suggesting lower efficiency in shipping lower-value products.

## This indicates that shipping costs may have a proportionally greater impact on lower-value products.
## =====================================================================================================================================================================  
    
## ================================================
## Which categories have the highest average freight?
## ================================================

SELECT
	product_category_name,
    ROUND(AVG(freight_value),2) AS avg_freight_usd
    FROM fact_orders
    GROUP BY product_category_name
    ORDER BY avg_freight_usd DESC;
    
## ==============================================================  
## Which products are least logistically efficient? (Top 10)
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
## Certain products have logistical costs that are disproportionate to their value.   
## ==================================================================================================

## ================================================================ 
## How does product volume impact shipping costs?
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
## Medium-sized products have the lowest freight-to-price ratio,

## with shipping costs representing approximately 15% of the product's value.
## ===================================================================================================== 

## ==========================================================================================================================================
## Lightweight but high-volume products tend to generate disproportionately high freight-to-price ratios,

## suggesting that the utilization of shipping space (volume) can significantly impact logistics efficiency.
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
## SQL analysis suggests that product characteristics, such as weight, volume, and category, significantly influence logistics efficiency.

## Products with lower relative value and unfavorable weight and volume combinations exhibit higher proportions of shipping costs relative to revenue generated,
## indicating potential operational challenges and reduced transportation efficiency.
## =====================================================================================================================================================================================



