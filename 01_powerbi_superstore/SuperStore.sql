== BIGQUERY ==
-- ============================================================
-- PROYECTO SUPERSTORE
-- ============================================================
-- Objetivo:
-- Analizar el rendimiento comercial y la rentabilidad.
-- mediante consultas SQL en BigQuery.
--
-- Estructura:
-- 1. Consultas de negocio
-- 2. Auditoría y limpieza de datos
-- ============================================================

-- ============================================================
-- 1. CONSULTAS DE NEGOCIO
-- ============================================================

-- == Visión Geográfica y Mercados == 

-- Análisis de Ventas y Rentabilidad General por Región --

SELECT 
   region, 
   ROUND(SUM(sales),2) AS total_sales,
   ROUND(SUM(profit),2) AS total_profit
FROM `superstore-506416`.SuperStoreConsultas.Super_Store
GROUP BY region 
ORDER BY total_sales DESC;

-- Top 5 Países por Volumen de Ventas y su Contribución a la Ganancia --

SELECT 
   country,
   ROUND(SUM(sales),2) AS total_sales,
   ROUND(SUM(profit),2) AS total_profit 
FROM`superstore-506416`.SuperStoreConsultas.Super_Store 
GROUP BY country 
ORDER BY total_sales DESC 
LIMIT 5;

-- == Producto y Margen == 

-- Desempeño Comparativo de Categorías: Ventas, Ganancia y Margen de Utilidad (%) -- 

SELECT 
   category,
   ROUND(SUM(sales),2) AS total_sales,
   ROUND(SUM(profit),2) AS total_profit,
   ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin
FROM`superstore-506416`.SuperStoreConsultas.Super_Store 
GROUP BY  category
ORDER BY total_profit DESC;

-- Identificación de Productos deficitarios y Análisis de Pérdidas por SKU -- 

SELECT 
   product_name,
   ROUND(SUM(sales),2) AS total_sales,
   ROUND(SUM(profit),2) AS total_profit
FROM `superstore-506416`.SuperStoreConsultas.Super_Store
GROUP BY  product_name
HAVING SUM(profit) <0
ORDER BY total_profit ASC;

-- Sensibilidad de la Rentabilidad según el Margen de Descuento Aplicado -- 

SELECT 
   discount,
   COUNT(DISTINCT order_id) AS total_order,
   ROUND(SUM(sales),2) AS total_sales,
   ROUND(SUM(profit),2) AS total_profit
FROM `superstore-506416`.SuperStoreConsultas.Super_Store 
GROUP BY discount
ORDER BY discount ASC;

-- == Clientes y Comportamiento ==

-- Perfil de Rentabilidad y Margen Porcentual por Segmento de Cliente 

SELECT  segment,
   COUNT(DISTINCT order_id) AS total_orders,
   ROUND(SUM(sales),2) AS total_sales,
   ROUND(SUM(profit),2) AS total_profit,
   ROUND((SUM(profit) / SUM(sales)) * 100, 2 ) AS profit_margin_pct
FROM `superstore-506416`.SuperStoreConsultas.Super_Store
GROUP BY segment
ORDER BY total_sales DESC;

-- Ranking Analítico (Window Functions) del Top 10 Clientes de Mayor Valor Neta (VIPs) -- 

WITH customer_profit AS (
SELECT 
   customer_name, 
   ROUND(SUM(sales),2) AS total_sales,
   ROUND(SUM(profit),2) AS total_profit

FROM `superstore-506416`.SuperStoreConsultas.Super_Store
GROUP BY customer_name
), 
   ranked_customers  AS (
   SELECT 
      customer_name,
      total_sales,
      total_profit,
      DENSE_RANK() OVER(ORDER BY total_profit DESC) AS ranking
   FROM customer_profit
) 
SELECT * 
FROM ranked_customers
WHERE ranking <= 10
ORDER BY ranking;

-- == Operaciones y Envíos ==

-- Métricas de Eficiencia Logística: Tiempo Promedio, Mínimo y Máximo de Despacho por Tipo de Envío --

SELECT 
   ship_mode,
   COUNT(DISTINCT order_id) AS total_orders,
   ROUND(AVG(DATE_DIFF(ship_date, order_date, DAY)), 1) AS avg_shipping_days,
   MIN(DATE_DIFF(ship_date, order_date, DAY)) AS min_shipping_days,
   MAX(DATE_DIFF(ship_date, order_date, DAY)) AS max_shipping_days
FROM `superstore-506416.SuperStoreConsultas.Super_Store`
GROUP BY ship_mode
ORDER BY avg_shipping_days ASC;


-- Auditoría de Cumplimiento de SLA: Tiempos de Entrega por Prioridad de Orden --

SELECT 
order_priority,
COUNT(DISTINCT order_id) AS total_orders,
ROUND(AVG(DATE_DIFF(ship_date, order_date, DAY)), 1) AS avg_shipping_days
FROM `superstore-506416`.SuperStoreConsultas.Super_Store
GROUP BY order_priority
ORDER BY avg_shipping_days ASC; 

-- == Análisis Temporal == 

-- Evolución Temporal de la Rentabilidad: Tendencia Anual de Ventas, Ganancias y Margen de Utilidad -- 

SELECT 
   EXTRACT(YEAR FROM order_date) AS order_year,
   COUNT(DISTINCT order_id) total_orders,
   ROUND(SUM(sales), 2) AS total_sales,
   ROUND(SUM(profit), 2) AS total_profit,
   ROUND((SUM(profit) / SUM(sales)) * 100, 2) profit_margin_pct
FROM `superstore-506416`.SuperStoreConsultas.Super_Store
GROUP BY order_year
ORDER BY order_year ASC;


-- ============================================================
-- 2. AUDITORÍA Y LIMPIEZA DE DATOS  (DATA CLEANING)
-- ============================================================

-- Validación de Integridad y Completitud de Datos --

SELECT
   SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS ProductosNulos,
   SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS OrdenesNulas,
   SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS FechasNulas

FROM `superstore-506416`.SuperStoreConsultas.Super_Store ;


-- Detección de Filas Duplicadas por Orden y Producto --

SELECT
   order_id,
   product_id
FROM `superstore-506416`.SuperStoreConsultas.Super_Store
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- Inspección de Filas Duplicadas para la Orden UZ-2014-7970 -- 

SELECT *
FROM `superstore-506416.SuperStoreConsultas.Super_Store`
WHERE order_id = 'UZ-2014-7970' ;


--Inspección Detallada de Duplicado en Orden UZ-2014-7970 -- 

SELECT 
  order_id,
  product_id,
  sales,
  quantity,
  discount,
  profit
FROM `superstore-506416.SuperStoreConsultas.Super_Store`
WHERE order_id = 'UZ-2014-7970' 

-- Conclusión:
-- No se trata de un duplicado por error del sistema, ya que las filas no son idénticas.
-- El cliente realizó una sola compra (order_id: UZ-2014-7970),
-- Pero el mismo producto aparece registrado en dos líneas diferentes.
--
-- Línea 1: 2 unidades, $64 de ventas y $23.64 de ganancia.
-- Línea 2: 1 unidad, $32 de ventas y $11.82 de ganancia.
--
-- Las dos filas representan registros diferentes
-- y no deben considerarse duplicados exactos.
-- Por lo tanto, ninguna de las dos filas debe eliminarse como duplicado. 

-- Verificación de Tipos de Dato en Fechas -- 

SELECT 
   order_date,
   year,
   ship_date
FROM `superstore-506416.SuperStoreConsultas.Super_Store`
LIMIT 5;

-- Consolidación de Transacciones y Limpieza de Duplicados a Nivel de Orden-Producto --

SELECT

   order_id,
   product_id,
   region,
   order_date,
   SUM(sales) AS total_sales,
   SUM(quantity) AS total_quantity,
   SUM(profit) AS total_profit,
   AVG(discount) AS avg_discount
FROM `superstore-506416`.SuperStoreConsultas.Super_Store
GROUP BY order_id,
    product_id,
    region,
    order_date;


