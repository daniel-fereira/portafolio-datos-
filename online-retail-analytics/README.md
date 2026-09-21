# 🛒 Online Retail Analytics & Customer Segmentation (Excel + SQL + Power BI)

Un caso de estudio end-to-end de **Analytics Engineering** enfocado en la auditoría inicial de datos en **Excel**, el modelado y procesamiento avanzado en **PostgreSQL**, y la creación de un dashboard ejecutivo interactivo en **Power BI** para la toma de decisiones estratégicas.

---

## 📌 Visión General del Proyecto

Este proyecto aborda el ciclo completo de procesamiento analítico del **Online Retail Dataset**:

1. **Auditoría & Data Hygiene (Excel):** Diagnóstico inicial, identificación de anomalías estructurales y limpieza previa de inconsistencias.
2. **Layered Data Architecture (SQL):** Estructuración de los datos en PostgreSQL mediante una arquitectura de tres capas (Clean, Business y Analytics Layers).
3. **RFM Customer Segmentation (SQL):** Implementación de un modelo de puntuación comportamental de clientes (*Recency, Frequency, Monetary*).
4. **Interactive Dashboard (Power BI):** Construcción de tableros dinámicos para los equipos de Growth, Ventas y Marketing.

---

## 🛠️ Stack Tecnológico

* **Excel:** Auditoría inicial, validación de tipos de datos, inspección de valores nulos y formatos.
* **Base de Datos & SQL:** PostgreSQL (pgAdmin 4) — Uso avanzado de CTEs, Window Functions (`NTILE`, `ROW_NUMBER`), casting de fechas y agregaciones.
* **Visualización & BI:** Power BI Desktop — Modelado relacional, DAX y tableros interactivos.
* **Control de Versiones:** Git & GitHub

---

## 🏗️ Flujo de Trabajo y Arquitectura del Proyecto

```text
📁 online-retail-analytics/
 ├── 📁 excel/
 │   └── online_retail_audited.xlsx   # Fase 0: Auditoría inicial y correcciones
 ├── 📁 sql/
 │   ├── 01_clean_layer.sql           # Fase 1: Limpieza, deduplicación y filtros en PostgreSQL
 │   ├── 02_business_layer.sql        # Fase 2: KPIs globales, análisis geográfico y SKUs
 │   └── 03_analytics_layer.sql       # Fase 3: Modelo de segmentación de clientes RFM
 └── 📁 powerbi/
     └── online_retail_dashboard.pbix # Informe interactivo con KPIs y Segmentación RFM
