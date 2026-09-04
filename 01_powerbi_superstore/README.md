# 📊 Sales Overview - SuperStore - Power BI

## 🎯 Objetivo del Proyecto
Analizar el rendimiento comercial, la rentabilidad y el volumen de pedidos de la empresa **Superstore** (2011–2014) mediante un flujo de trabajo completo de datos (*End-to-End*): desde la preparación inicial en Excel y el análisis exploratorio con SQL (BigQuery), hasta la creación de un dashboard interactivo en Power BI.

---

## 🔄 Flujo de Trabajo y Tratamiento de Datos

### 1. Limpieza Exploratoria Inicial (Excel)
* Inspección del dataset original (*Superstore Dataset*).
* Estandarización y corrección del formato de fechas.

### 2. Transformación y Análisis Exploratorio (SQL en BigQuery)
* **Validación de Integridad:** Detección de nulos y verificación de registros duplicados.
* **Análisis de Negocio:** Ejecución de consultas exploratorias para calcular agregaciones clave (ventas y margen por región,
*  Top 5 de países por volumen, desempeño por categoría y detección de productos deficitarios/SKU con pérdidas) antes de construir las visualizaciones.

### 3. Modelado y Visualización (Power BI)
* Importación de los datos validados a Power BI Desktop.
* Desarrollo de medidas analíticas en **DAX** (Inteligencia de Tiempo: `SAMEPERIODLASTYEAR`, `CALCULATE`, `DIVIDE`).
* Diseño de interfaz multipágina en estilo *Matte Theme* con indicadores de formato condicional.

---

## 📸 Vista Previa del Dashboard

### 1. Sales Overview
![Sales Overview](docs/sales_overview.png)

### 2. Product Details
![Product Details](docs/product_details.png)

---

## 🔑 KPIs Principales y Funcionalidades
* **Métricas Clave:** Seguimiento de `Total Orders` (51.29K), `Total Sales` ($12.64M), `Profit Margin %` (11.62%) y `Total Profit` ($1.47M).
* **Análisis YoY:** Indicador dinámico de variaciones interanuales (`Sales YoY Growth %` de 51.54%).
* **Filtros Dinámicos:** Segmentación interactiva por tipo de cliente (**Segment**) y línea temporal (**Year** 2011–2014).

---

## 🔗 Dashboard Interactivo
👉 [Ver Sales Overview - SuperStore en Power BI Service](https://app.powerbi.com/reportEmbed?reportId=7d4fc7fd-0af8-4e35-94ac-e0f443a5f976&autoAuth=true&ctid=44186e7d-49dd-4615-b523-00a197f81e90)

---

## 🛠️ Tecnologías y Herramientas
* **Excel:** Limpieza y estandarización de fechas.
* **SQL (BigQuery):** Análisis exploratorio de agregaciones, márgenes y pérdidas.
* **Power BI Desktop & Power Query:** Modelado de datos, medidas DAX e interfaz gráfica.

---

## 📂 Archivos en esta carpeta
* `Superstore_Sales.pbix` - Archivo fuente del informe de Power BI.
* `dataset_superstore.xlsx` - Dataset utilizado para el análisis.
