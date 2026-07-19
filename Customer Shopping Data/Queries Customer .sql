Facturación Bruta Total
Descuentos Totales
Facturación Neta
Cantidad de Pedidos




SELECT
SUM(quantity * list_price) AS groos_bookings,
SUM(quantity * list_price * discount) AS discount,
SUM(quantity * list_price * (1-discount)) net_bookings,
COUNT(DISTINCT order_id) AS Order_acount


FROM `Bike_Shop.order_items`








Facturación Neta por Estado


SELECT
C.state,
SUM(OT.list_price * OT.quantity * (1 -OT.discount)) AS net_bookings


FROM `Bike_Shop.orders` O
JOIN `Bike_Shop.order_items` OT ON OT.order_id = O.order_id
JOIN `Bike_Shop.customers` C ON C.customer_id = O.customer_id
GROUP BY C.state
ORDER BY net_bookings DESC;




Facturación Neta por Año  


SELECT 
EXTRACT ( YEAR FROM O.order_date) AS Year,
SUM(OT.list_price * OT.quantity * (1 -OT.discount)) AS net_bookings


FROM `Bike_Shop.orders`  O
JOIN `Bike_Shop.order_items`  OT ON OT.order_id = O.order_id
GROUP BY Year 
ORDER BY Year ASC;


Facturación Neta por Categoría


SELECT 
C.category_name AS Category,
SUM(OT.list_price * OT.quantity * (1 -OT.discount)) AS net_bookings


FROM `Bike_Shop.categories` C
JOIN `Bike_Shop.products` P ON P.category_id = C.category_id
JOIN `Bike_Shop.order_items` OT ON OT.product_id = P.product_id 
GROUP BY C.category_name 
ORDER BY net_bookings DESC;