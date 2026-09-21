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

## 🔍 Fases del Proyecto

### 1. Auditoría & Data Hygiene (Excel)
* **Diagnóstico Estructural:** Identificación de registros duplicados, valores nulos en IDs de clientes y precios/cantidades en negativo.
* **Estandarización:** Corrección y formato de fechas, limpieza de espacios en blanco.

### 2. Transformación y Análisis Exploratorio (SQL en PostgreSQL)
* **Validación de Integridad:** Detección de nulos, eliminación de cancelaciones y verificación de registros duplicados.
* **Análisis de Negocio:** Consultas exploratorias para calcular agregaciones clave (ventas por país, ticket promedio) antes de construir las visualizaciones.
* **Modelo RFM:** Cálculo de puntuaciones comportamentales mediante `NTILE(4)` y `WINDOW FUNCTIONS` para segmentar clientes en *Champions*, *Loyal*, *Needs Attention* y *At Risk*.

### 3. Modelado y Visualización (Power BI)
* **Importación:** Carga de datos validados desde PostgreSQL a Power BI Desktop.
* **Desarrollo DAX:** Creación de medidas analíticas mediante `CALCULATE`, `DISTINCTCOUNT`, `SUMX` y funciones avanzadas.
* **Diseño UI/UX:** Interfaz ejecutiva en estilo Matte Theme con indicadores condicionales y distribución simétrica.

---

## 📸 Vista Previa del Dashboard

### 1. Customer RFM Analytics
![Customer RFM Analytics](./Power%20BI/online%20retail.png)

---

## 📊 KPIs Principales y Funcionalidades

* **Métricas Clave:** Seguimiento de **Total Revenue**, **Active Customers**, **Total Orders** y **Customer Segments**.
* **Segmentación Dinámica RFM:** Desglose interactivo de clientes según comportamiento de compra (*Champions*, *Loyal*, *Needs Attention*, *At Risk*).
* **Filtros Dinámicos:** Filtros cruzados por país (**Sales by Country**) y período de tiempo (**Year & Month**).

---

## 🌐 Dashboard Interactivo

🔗 [**Ver Online Retail Analytics en Power BI Service**](https://app.powerbi.com/links/l0w3P9AiGJ?ctid=44186e7d-49dd-4615-b523-00a197f81e90&pbi_source=linkShare)

---

## 🛠️ Tecnologías y Herramientas

* **Excel:** Limpieza y estandarización inicial de datos.
* **SQL (PostgreSQL):** Análisis exploratorio, filtrado transaccional y modelo de segmentación RFM.
* **Power BI Desktop & Power Query:** Modelado de datos, medidas DAX e interfaz gráfica.
* **Git & GitHub:** Control de versiones y documentación de repositorio.

---

## 📁 Archivos en esta carpeta

* **`online_retail_dashboard.pbix`** - Archivo fuente del informe de Power BI.
* **`online_retail_audited.xlsx`** - Dataset auditado utilizado para el análisis.
