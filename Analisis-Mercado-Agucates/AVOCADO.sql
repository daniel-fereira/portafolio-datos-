-- SQL (BigQuery) -- 

-- 1. VOLUMEN ANUAL TOTAL
SELECT year AS ANO, 
       ROUND(SUM(`Total Volume`),2) AS VolumenTotal
FROM `proyectosql-502219.AVOCADO.AVOCADO` 
WHERE region != 'TotalUS'
GROUP BY year; 

-- 2. DESGLOSE DE VENTAS POR TAMAÑO DE BOLSA

SELECT  
      ROUND(SUM(`Hass small`),2) AS Volumen_Bolsa_Pequena,
      ROUND(SUM(`Large Bags`),2) AS Volumen_Bolsa_Grande,
      ROUND(SUM(`XLarge Bags`),2) AS Volumen_Bolsa_XGrande,
      SUM(`Total Bags`) AS Total_Bolsas 
FROM `proyectosql-502219.AVOCADO.AVOCADO` 
WHERE region != 'TotalUS' AND year IN (2015, 2016, 2017)
GROUP BY year;


-- 3. ESTACIONALIDAD MENSUAL (Picos de consumo)

SELECT 
      EXTRACT(MONTH FROM Date) AS Mes,
      CASE 
          WHEN EXTRACT(MONTH FROM Date) = 01 THEN 'ENERO'
          WHEN EXTRACT(MONTH FROM Date) = 02 THEN 'FEBRERO'
          WHEN EXTRACT(MONTH FROM Date) = 03 THEN 'MARZO'
          WHEN EXTRACT(MONTH FROM Date) = 04 THEN 'ABRIL'
          WHEN EXTRACT(MONTH FROM Date) = 05 THEN 'MAYO'
          WHEN EXTRACT(MONTH FROM Date) = 06 THEN 'JUNIO'
          WHEN EXTRACT(MONTH FROM Date) = 07 THEN 'JULIO'
          WHEN EXTRACT(MONTH FROM Date) = 08 THEN 'AGOSTO'
          WHEN EXTRACT(MONTH FROM Date) = 09 THEN 'SEPTIEMBRE'
          WHEN EXTRACT(MONTH FROM Date) = 10 THEN 'OCTUBRE'
          WHEN EXTRACT(MONTH FROM Date) = 11 THEN 'NOVIEMBRE'
          WHEN EXTRACT(MONTH FROM Date) = 12 THEN 'DICIEMBRE'
      END AS Nombre_Mes,
      ROUND(AVG(`Total Volume`),2) AS Promedio_Volumen
FROM `proyectosql-502219.AVOCADO.AVOCADO` 
WHERE region != 'TotalUS' 
      AND year IN (2015, 2016, 2017)
GROUP BY EXTRACT(MONTH FROM Date), Nombre_Mes
ORDER BY Mes ASC; 


-- 4. COMPARATIVA: AGUACATE CONVENCIONAL VS. ORGÁNICO


SELECT
type AS Tipo_Aguacate,
ROUND(SUM(`Total Volume`),2) AS Volumen_Ventas,
ROUND(AVG(AveragePrice),2) AS Precio_Promedio,
ROUND(SUM(`Total Volume` * AveragePrice), 2) AS Ingresos_Totales,
ROUND(
        (SUM(`Total Volume` * AveragePrice) / SUM(SUM(`Total Volume` * AveragePrice)) OVER()) * 100, 
        2
    ) AS Porcentaje_Participacion_Ingresos
FROM `proyectosql-502219.AVOCADO.AVOCADO` 
WHERE region != 'TotalUS' 
      AND year IN (2015, 2016, 2017)
GROUP BY type 

-- 5. DISPARIDAD REGIONAL DE PRECIOS (Top 5 más caras vs. Top 5 más baratas)


WITH PROMEDIO AS (
SELECT
      region AS Region, 
      ROUND(AVG(AveragePrice),2) AS Precio_Promedio
FROM `proyectosql-502219.AVOCADO.AVOCADO` 
WHERE region != 'TotalUS' 
      AND year IN (2015, 2016, 2017)
GROUP BY region

),
 Ranking AS (
      SELECT 
      Region,
      Precio_Promedio,
      ROW_NUMBER() OVER(ORDER BY Precio_Promedio DESC ) AS Precio_Mayor,  
      ROW_NUMBER() OVER(ORDER BY Precio_Promedio ASC) AS Precio_Menor
      FROM PROMEDIO 
) 
 SELECT * 
 FROM Ranking 
 WHERE Precio_Mayor <= 5 
      OR Precio_Menor <= 5
 ORDER BY Precio_Promedio DESC;


-- 6. TENDENCIA DE EMPAQUE: VENTAS A GRANEL VS. BOLSAS (2015–2017)

SELECT
      year, 
      ROUND(SUM(`Total Volume`),2) AS Volumen_Total,
      ROUND(SUM(`Total Bags`),2) AS Volumen_Granel, 
      ROUND(((SUM(`Total Volume`) - SUM(`Total Bags`)) / SUM(`Total Volume`)) * 100, 2) AS Pct_Granel,
      ROUND(SUM(`Total Bags`) / SUM(`Total Volume`) * 100, 2) AS Pct_Bolsas
FROM `proyectosql-502219.AVOCADO.AVOCADO` 
WHERE region != 'TotalUS' 
      AND year IN (2015, 2016, 2017)

GROUP BY year 
ORDER BY year ASC;