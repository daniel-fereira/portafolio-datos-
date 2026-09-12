-- ============================================================
-- FASE 3: SEGMENTACIÓN AVANZADA RFM (ANALYTICS LAYER)
-- ============================================================


-- ------------------------------------------------------------
-- 3.1 BASE RFM: DÍAS DE RECENCIA, FRECUENCIA Y MONTO POR CLIENTE
-- ------------------------------------------------------------

WITH max_dataset_date AS (
    SELECT MAX(invoice_date::date) AS reference_date 
    FROM public.vw_online_retail_clean
)
SELECT 
    c.customer_id,
    (m.reference_date - MAX(c.invoice_date::date)) AS recency_days,
    COUNT(DISTINCT c.invoice_no) AS frequency,
    ROUND(SUM(c.total_amount), 2) AS monetary
FROM public.vw_online_retail_clean c
CROSS JOIN max_dataset_date m
GROUP BY 
    c.customer_id, 
    m.reference_date;

-- ------------------------------------------------------------
-- 3.2 SCORING RFM: ASIGNACIÓN DE CUARTILES CON NTILE()
-- ------------------------------------------------------------

WITH max_dataset_date AS (
    SELECT MAX(invoice_date::date) AS reference_date 
    FROM public.vw_online_retail_clean
),
rfm_base AS (
    SELECT 
        c.customer_id,
        (m.reference_date - MAX(c.invoice_date::date)) AS recency_days,
        COUNT(DISTINCT c.invoice_no) AS frequency,
        ROUND(SUM(c.total_amount), 2) AS monetary
    FROM public.vw_online_retail_clean c
    CROSS JOIN max_dataset_date m
    GROUP BY 
        c.customer_id, 
        m.reference_date
)
SELECT 
    customer_id,
    recency_days,
    frequency,
    monetary,
    NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
FROM rfm_base;


-- ------------------------------------------------------------
-- 3.3 MATRIZ DE SEGMENTACIÓN Y CLASIFICACIÓN DE CLIENTES
-- ------------------------------------------------------------

WITH max_dataset_date AS (
    SELECT MAX(invoice_date::date) AS reference_date 
    FROM public.vw_online_retail_clean
),
rfm_base AS (
    SELECT 
        c.customer_id,
        (m.reference_date - MAX(c.invoice_date::date)) AS recency_days,
        COUNT(DISTINCT c.invoice_no) AS frequency,
        ROUND(SUM(c.total_amount), 2) AS monetary
    FROM public.vw_online_retail_clean c
    CROSS JOIN max_dataset_date m
    GROUP BY 
        c.customer_id, 
        m.reference_date
),
rfm_scores AS (
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
)
-- 4. Clasificación final en Segmentos Estratégicos de Negocio
SELECT 
    customer_id,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    (r_score || f_score || m_score) AS rfm_combined,
    CASE 
        WHEN r_score = 4 AND f_score = 4 AND m_score = 4 THEN 'Champions / VIP'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 3 AND f_score = 1 THEN 'Recent Customers'
        WHEN r_score = 1 AND f_score >= 3 THEN 'Cant Lose Them'
        WHEN r_score = 1 AND f_score = 1 THEN 'Lost / Inactive'
        ELSE 'At Risk / Needs Attention'
    END AS customer_segment
FROM rfm_scores
ORDER BY monetary DESC;

-- ------------------------------------------------------------
-- 3.4 RESUMEN EJECUTIVO: DISTRIBUCIÓN DE CLIENTES POR SEGMENTO
-- ------------------------------------------------------------


WITH max_dataset_date AS (
    SELECT MAX(invoice_date::date) AS reference_date 
    FROM public.vw_online_retail_clean
),
rfm_base AS (
    SELECT 
        c.customer_id,
        (m.reference_date - MAX(c.invoice_date::date)) AS recency_days,
        COUNT(DISTINCT c.invoice_no) AS frequency,
        ROUND(SUM(c.total_amount), 2) AS monetary
    FROM public.vw_online_retail_clean c
    CROSS JOIN max_dataset_date m
    GROUP BY c.customer_id, m.reference_date
),
rfm_scores AS (
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
),
rfm_segments AS (
    SELECT 
        customer_id,
        monetary,
        CASE 
            WHEN r_score = 4 AND f_score = 4 AND m_score = 4 THEN 'Champions / VIP'
            WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
            WHEN r_score >= 3 AND f_score = 1 THEN 'Recent Customers'
            WHEN r_score = 1 AND f_score >= 3 THEN 'Cant Lose Them'
            WHEN r_score = 1 AND f_score = 1 THEN 'Lost / Inactive'
            ELSE 'At Risk / Needs Attention'
        END AS customer_segment
    FROM rfm_scores
)
-- Agregación ejecutiva a nivel de Segmento
SELECT 
    customer_segment,
    COUNT(customer_id) AS total_customers,
    ROUND(
        100.0 * COUNT(customer_id) / SUM(COUNT(customer_id)) OVER (), 2
    ) AS pct_customers,
    ROUND(SUM(monetary), 2) AS total_revenue,
    ROUND(
        100.0 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 2
    ) AS pct_revenue,
    ROUND(AVG(monetary), 2) AS avg_revenue_per_customer
FROM rfm_segments
GROUP BY customer_segment
ORDER BY total_revenue DESC;