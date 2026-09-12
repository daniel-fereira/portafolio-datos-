
-- ============================================================
-- FASE 1: VISTA DE DATOS LIMPIOS (CLEAN LAYER)
-- ============================================================



CREATE OR REPLACE VIEW vw_online_retail_clean AS
WITH deduplicated AS (
    SELECT *,
        ROW_NUMBER() OVER(
            PARTITION BY invoice_no, stock_code, quantity, invoice_date, unit_price, customer_id
            ORDER BY invoice_date
        ) AS row_num
    FROM online_retail
)
SELECT 
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    (quantity * unit_price) AS total_amount,
    customer_id,
    country
FROM deduplicated
WHERE row_num = 1                  -- 1. Elimina duplicados
  AND customer_id IS NOT NULL      -- 2. Elimina clientes anónimos
  AND quantity > 0                 -- 3. Elimina cantidades negativas/devoluciones
  AND unit_price > 0               -- 4. Elimina precios cero o errores
  AND invoice_no NOT LIKE 'C%';    -- 5. Elimina facturas canceladas