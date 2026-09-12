-- ============================================================
-- FASE 2: KPIs DE NEGOCIO Y MÉTRICAS GLOBALES (BUSINESS LAYER)
-- ============================================================


-- ------------------------------------------------------------
-- 2.1 KPIs GLOBALES: FACTURACIÓN, ÓRDENES Y CLIENTES ÚNICOS
-- ------------------------------------------------------------

SELECT 
	COUNT (DISTINCT invoice_no) AS total_orders,
	COUNT (DISTINCT customer_id) total_costomer,
	ROUND(SUM(total_amount),2) as total_revenue
FROM public.vw_online_retail_clean


-- ------------------------------------------------------------
-- 2.2 KPI GLOBAL: TICKET PROMEDIO POR ORDEN (AOV)
-- ------------------------------------------------------------

WITH order_totals AS (
    SELECT 
        invoice_no, 
        SUM(total_amount) AS order_total
    FROM public.vw_online_retail_clean
    GROUP BY invoice_no
)
SELECT 
    ROUND(AVG(order_total), 2) AS average_order_value
FROM order_totals;

-- ------------------------------------------------------------
-- 2.3 ANÁLISIS GEOGRÁFICO: TOP 5 PAÍSES POR INGRESOS TOTALES
-- ------------------------------------------------------------

WITH ranking_revenue AS (
SELECT 
	country AS country, 
	ROUND(SUM(total_amount),2) AS total_revenue, 
	ROW_NUMBER() OVER(
			ORDER BY ROUND(SUM(total_amount),2) DESC
	) AS ranking 
FROM public.vw_online_retail_clean
GROUP BY country

)   

SELECT *
FROM ranking_revenue 
WHERE ranking <= 5 ;


-- ------------------------------------------------------------
-- 2.4 DESEMPEÑO DE PRODUCTO: TOP 10 SKUs MÁS VENDIDOS (VOLUMEN)
-- ------------------------------------------------------------

 WITH sku_performance_ranking AS (
SELECT 
	stock_code, 
	description,
	ROUND(SUM(total_amount),2) AS total_revenue_generated, 
	SUM(quantity) AS total_units_sold,  
	ROW_NUMBER() OVER(
			ORDER BY SUM(quantity) DESC
	) AS sales_volume_rank 
FROM public.vw_online_retail_clean
GROUP BY stock_code, description
)
SELECT 
sales_volume_rank,
    stock_code,
    description,
    total_units_sold,
    total_revenue_generated
FROM sku_performance_ranking 
WHERE sales_volume_rank <= 10
ORDER BY sales_volume_rank ASC

-- ------------------------------------------------------------
-- 2.5 CUSTOMER ANALYTICS: TOP 10 CLIENTES VIP (LTV)
-- ------------------------------------------------------------

WITH CustomerVIP AS (
SELECT 
	customer_id,
	COUNT(DISTINCT invoice_no) total_orders_placed,
	SUM(quantity) AS total_units_purchased,
	ROUND(SUM(total_amount),2) AS total_lifetime_value, 
	ROW_NUMBER() OVER(
			ORDER BY ROUND(SUM(total_amount),2) DESC
	) AS vip_customer_rank
FROM public.vw_online_retail_clean
GROUP BY customer_id

) 
	SELECT 
	vip_customer_rank,
    customer_id,
    total_orders_placed,
    total_units_purchased,
    total_lifetime_value
	FROM CustomerVIP 
	WHERE  vip_customer_rank <= 10
    ORDER BY vip_customer_rank ASC;