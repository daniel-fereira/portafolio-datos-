Calcular las ventas totales, clasificadas por año.
                
SELECT        
CASE        
WHEN strftime('%Y', OrderDate) = '1996' THEN '1996'        
WHEN strftime('%Y', OrderDate) = '1997' THEN '1997'        
WHEN strftime('%Y', OrderDate) = '1998' THEN '1998'        
ELSE 'Other' END AS Año,        
ROUND(SUM(ExtendedPrice),0) AS Facturacion        
FROM Invoices        
GROUP BY Año;        


Calcular las ventas totales, clasificadas por mes, del año 1997.


SELECT        
CASE        
WHEN strftime('%m', OrderDate) = '01' THEN 'Enero'        
WHEN strftime('%m', OrderDate) = '02' THEN 'Febrero'        
WHEN strftime('%m', OrderDate) = '03' THEN 'Marzo'        
WHEN strftime('%m', OrderDate) = '04' THEN 'Abril'        
WHEN strftime('%m', OrderDate) = '05' THEN 'Mayo'        
WHEN strftime('%m', OrderDate) = '06' THEN 'Junio'        
WHEN strftime('%m', OrderDate) = '07' THEN 'Julio'        
WHEN strftime('%m', OrderDate) = '08' THEN 'Agosto'        
WHEN strftime('%m', OrderDate) = '09' THEN 'Septiembre'        
WHEN strftime('%m', OrderDate) = '10' THEN 'Octubre'        
WHEN strftime('%m', OrderDate) = '11' THEN 'Noviembre'        
WHEN strftime('%m', OrderDate) = '12' THEN 'Diciembre'        
ELSE 'Other' END AS Mes,        
ROUND(SUM(ExtendedPrice),0) AS Facturacion        
FROM Invoices        
WHERE strftime('%Y', OrderDate) = '1997'        
GROUP BY Mes        
ORDER BY OrderDate ASC;        




Calcular las ventas totales, clasificadas por año, de la categoría ‘Condimentos’.


SELECT        
CASE        
WHEN strftime('%Y', INV.OrderDate) = '1996' THEN '1996'        
WHEN strftime('%Y', INV.OrderDate) = '1997' THEN '1997'        
WHEN strftime('%Y', INV.OrderDate) = '1998' THEN '1998'        
ELSE 'Other'        
END AS Año,        
ROUND(SUM(INV.ExtendedPrice),0) AS Facturacion        
FROM Invoices INV        
JOIN Products PRO ON PRO.ProductID = INV.ProductID        
JOIN Categories CAT ON CAT.CategoryID = PRO.CategoryID        
WHERE CAT.CategoryName = 'Condiments'        
GROUP BY Año        
ORDER BY Año;        


Mostrar cuántos pedidos fueron enviados por Speedy Express,
                     cuántos por United Package y cuántos Federal Shipping.                                                


SELECT                                        
SUM(CASE WHEN ShipVia = 1 THEN 1 ELSE 0 END) AS Pedidos_Speedy_Express,                        
SUM(CASE WHEN ShipVia = 2 THEN 1 ELSE 0 END) AS Pedidos_United_Package,                        
SUM(CASE WHEN ShipVia = 3 THEN 1 ELSE 0 END) AS Pedidos_Federal_Shipping                                
FROM Orders;




Mostrar la facturación mensual del año 1997,
                          comparando las categorías ‘Beverages’ y ‘Confections’.                                                


SELECT                        
CASE                        
WHEN STRFTIME('%m', INV.OrderDate) = '01' THEN 'Enero'                        
WHEN STRFTIME('%m', INV.OrderDate) = '02' THEN 'Febrero'                        
WHEN STRFTIME('%m', INV.OrderDate) = '03' THEN 'Marzo'                        
WHEN STRFTIME('%m', INV.OrderDate) = '04' THEN 'Abril'                        
WHEN STRFTIME('%m', INV.OrderDate) = '05' THEN 'Mayo'                        
WHEN STRFTIME('%m', INV.OrderDate) = '06' THEN 'Junio'                        
WHEN STRFTIME('%m', INV.OrderDate) = '07' THEN 'Julio'                        
WHEN STRFTIME('%m', INV.OrderDate) = '08' THEN 'Agosto'                        
WHEN STRFTIME('%m', INV.OrderDate) = '09' THEN 'Septiembre'                        
WHEN STRFTIME('%m', INV.OrderDate) = '10' THEN 'Octubre'                        
WHEN STRFTIME('%m', INV.OrderDate) = '11' THEN 'Noviembre'                        
WHEN STRFTIME('%m', INV.OrderDate) = '12' THEN 'Diciembre'                        
ELSE 'Other' END AS Mes,                        
ROUND(SUM(CASE WHEN CAT.CategoryName = 'Beverages' THEN INV.ExtendedPrice ELSE 0 END),0) AS Facturacion_Bebidas,                        
ROUND(SUM(CASE WHEN CAT.CategoryName = 'Confections' THEN INV.ExtendedPrice ELSE 0 END),0) AS Facturacion_Confites                        
FROM Invoices INV                        
JOIN Products PRO ON PRO.ProductID = INV.ProductID                        
JOIN Categories CAT ON CAT.CategoryID = PRO.CategoryID                        
WHERE strftime('%Y', INV.OrderDate) = '1997'                        
AND CAT.CategoryName IN ('Beverages', 'Confections')                        
GROUP BY STRFTIME('%m', INV.OrderDate)                        
ORDER BY STRFTIME('%m', INV.OrderDate) ASC ;