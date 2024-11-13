# Lab4: Data Query Language
Partiendo de la base de datos `tiendaOnline` e insertando datos, diseñe las consultas SQL que respondan a los siguientes ejercicios.


### 1. Consultas básicas de selección
<details>
<summary><b>Lista todos los usuarios en la tabla `Usuarios`, mostrando solo sus nombres y correos electrónicos.</b></summary>

  ```sql
   SELECT nombre, email FROM Usuarios;
  ```
</details>

<details>
<summary><b>Muestra los empleados con su salario y el nombre correspondiente en la tabla `Usuarios`.</b></summary>

  ```sql
   SELECT Usuarios.nombre, Empleados.salario 
   FROM Empleados 
   JOIN Usuarios ON Empleados.usuarioId = Usuarios.id;
  ```
</details>

<details>
<summary><b>Obtén los productos de la tabla `Productos` que tienen un precio mayor o igual a 20.00.</b></summary>

  ```sql
   SELECT nombre, precio FROM Productos WHERE precio >= 20.00;
  ```
</details>

<details>
<summary><b>Lista los clientes con su dirección de envío, código postal y fecha de nacimiento.</b></summary>

  ```sql
   SELECT Usuarios.nombre, Clientes.direccionEnvio, Clientes.codigoPostal, Clientes.fechaNacimiento 
   FROM Clientes 
   JOIN Usuarios ON Clientes.usuarioId = Usuarios.id;
  ```
</details>

---

### 2. Consultas con condiciones específicas y funciones agregadas
<details>
<summary><b>Encuentra el salario promedio de los empleados.</b></summary>

  ```sql
   SELECT AVG(salario) AS salario_promedio FROM Empleados;
  ```
</details>

<details>
<summary><b>Obtén el número total de productos agrupados por tipo de producto.</b></summary>

  ```sql
   SELECT TiposProducto.nombre AS tipo, COUNT(Productos.id) AS total_productos 
   FROM Productos 
   JOIN TiposProducto ON Productos.tipoProductoId = TiposProducto.id 
   GROUP BY TiposProducto.nombre;
  ```
</details>

<details>
<summary><b>Lista los pedidos realizados por cada cliente con su nombre y la fecha de realización.</b></summary>

  ```sql
   SELECT Usuarios.nombre AS cliente, Pedidos.fechaRealizacion 
   FROM Pedidos 
   JOIN Clientes ON Pedidos.clienteId = Clientes.id 
   JOIN Usuarios ON Clientes.usuarioId = Usuarios.id;
  ```
</details>

<details>
<summary><b>Cliente que ha pedido la menor variedad de productos.</b></summary>

  ```sql
SELECT Usuarios.nombre AS cliente, COUNT(DISTINCT lp.productoId) AS numero_productos_distintos
FROM Clientes c
JOIN Pedidos p ON c.id = p.clienteId
JOIN LineasPedido lp ON p.id = lp.pedidoId
JOIN Usuarios u ON c.usuarioId = u.id;
GROUP BY c.id, c.nombre
ORDER BY numero_productos_distintos ASC
LIMIT 1;
  ```
</details>

---

### 3. Consultas con JOIN y filtrado avanzado
<details>
<summary><b>Encuentra los pedidos realizados por clientes mayores de edad (18 años o más).</b></summary>

  ```sql
   SELECT Usuarios.nombre AS cliente, Pedidos.fechaRealizacion 
   FROM Pedidos 
   JOIN Clientes ON Pedidos.clienteId = Clientes.id 
   JOIN Usuarios ON Clientes.usuarioId = Usuarios.id 
   WHERE TIMESTAMPDIFF(YEAR, Clientes.fechaNacimiento, pedidos.fechaRealizacion) >= 18;
  ```
</details>

<details>
<summary><b>Encuentra los productos que no han sido pedidos por ningún cliente menor de 18 años.</b></summary>

  ```sql
   SELECT pr.id AS producto_id, pr.nombre
FROM Productos pr
WHERE pr.id NOT IN (
    SELECT lp.productoId
    FROM LineasPedido lp
    JOIN Pedidos p ON lp.pedidoId = p.id
    JOIN Clientes c ON p.clienteId = c.id
    WHERE TIMESTAMPDIFF(YEAR, c.fechaNacimiento, CURDATE()) < 18
);

  ```
</details>

<details>	
<summary><b>Muestra los pedidos y las líneas de pedido asociadas, incluyendo el nombre del producto y las unidades solicitadas.</b></summary>

  ```sql
   SELECT Pedidos.id AS pedido_id, Productos.nombre AS producto, LineasPedido.unidades 
   FROM LineasPedido 
   JOIN Pedidos ON LineasPedido.pedidoId = Pedidos.id 
   JOIN Productos ON LineasPedido.productoId = Productos.id;
  ```
</details>

<details>
<summary><b>Lista los productos no permitidos para menores (`puedeVenderseAMenores = FALSE`) y sus precios.</b></summary>

  ```sql
   SELECT nombre, precio 
   FROM Productos 
   WHERE puedeVenderseAMenores = FALSE;
  ```
</details>
<details>
<summary><b>Lista los clientes cuya mayoría de productos pedidos (en cantidad total de unidades) son aquellos no permitidos para menores de 18 años.</b></summary>

  ```sql
   SELECT c.id AS cliente_id, u.nombre, u.email
FROM Clientes c
JOIN Usuarios u ON c.usuarioId = u.id
JOIN Pedidos p ON c.id = p.clienteId
JOIN LineasPedido lp ON p.id = lp.pedidoId
JOIN Productos pr ON lp.productoId = pr.id
GROUP BY c.id
HAVING 
    (SELECT SUM(lp1.unidades)
     FROM LineasPedido lp1
     JOIN Productos pr1 ON lp1.productoId = pr1.id
     JOIN Pedidos p1 ON lp1.pedidoId = p1.id
     WHERE p1.clienteId = c.id AND pr1.puedeVenderseAMenores = FALSE) >
    (SELECT SUM(lp2.unidades)
     FROM LineasPedido lp2
     JOIN Productos pr2 ON lp2.productoId = pr2.id
     JOIN Pedidos p2 ON lp2.pedidoId = p2.id
     WHERE p2.clienteId = c.id AND pr2.puedeVenderseAMenores = TRUE);
  ```
</details>

---

### 4. Consultas con subconsultas y cálculos
<details>
<summary><b>Encuentra el cliente con el mayor número de pedidos.</b></summary>

  ```sql
   SELECT Usuarios.nombre AS cliente, COUNT(Pedidos.id) AS total_pedidos 
   FROM Pedidos 
   JOIN Clientes ON Pedidos.clienteId = Clientes.id 
   JOIN Usuarios ON Clientes.usuarioId = Usuarios.id 
   GROUP BY Usuarios.nombre 
   ORDER BY total_pedidos DESC 
   LIMIT 1;
  ```
</details>

<details>
<summary><b>Muestra los pedidos con un total calculado de precio para cada pedido (sumando `precio * unidades` de `LineasPedido`).</b></summary>

  ```sql
   SELECT Pedidos.id AS pedido_id, SUM(LineasPedido.precio * LineasPedido.unidades) AS total_precio 
   FROM Pedidos 
   JOIN LineasPedido ON Pedidos.id = LineasPedido.pedidoId 
   GROUP BY Pedidos.id;
  ```
</details>

<details>
<summary><b>Muestra los pedidos cuyo importe sea el máximo. Si hay más de un pedido con el mismo importe máximo, devolverlos todos.</b></summary>

  ```sql
   SELECT 
    Pedidos.id AS pedido_id, 
    SUM(LineasPedido.precio * LineasPedido.unidades) AS total_precio,
    (SELECT MAX(t.total) 
     FROM (SELECT SUM(lp.precio * lp.unidades) AS total
           FROM Pedidos p
           JOIN LineasPedido lp ON p.id = lp.pedidoId
           GROUP BY p.id) AS t) AS importe_maximo
FROM Pedidos
JOIN LineasPedido ON Pedidos.id = LineasPedido.pedidoId 
GROUP BY Pedidos.id
HAVING total_precio = importe_maximo;
  ```
</details>


<details>
<summary><b>Lista los productos que no se han vendido.</b></summary>

  ```sql
   SELECT Productos.nombre 
   FROM Productos 
   LEFT JOIN LineasPedido ON Productos.id = LineasPedido.productoId 
   WHERE LineasPedido.productoId IS NULL;
  ```
</details>

<details>
<summary><b>Ganancias mensuales obtenidas.</b></summary>

  ```sql
   SELECT MONTH(pedidos.fechaRealizacion) AS Mes, SUM(LineasPedido.precio * LineasPedido.unidades) AS total_precio 
   FROM Pedidos 
   JOIN LineasPedido ON Pedidos.id = LineasPedido.pedidoId
   GROUP BY MONTH(pedidos.fechaRealizacion);
  ```
</details>

<details>
<summary><b>Empleado que ha gestionado más dinero en ventas.</b></summary>

  ```sql
SELECT usuarios.nombre AS Empleado, SUM(lineaspedido.precio * lineaspedido.unidades) AS dinero
FROM empleados 
	JOIN usuarios ON empleados.usuarioId=usuarios.id
	JOIN pedidos ON pedidos.empleadoId=empleados.id
	JOIN lineaspedido ON lineaspedido.pedidoId=pedidos.id
GROUP BY empleados.id
ORDER BY dinero DESC
LIMIT 1;
  ```
</details>

<details>
<summary><b>Empleado que ha gestionado un total de más de 1000.00€ en ventas.</b></summary>

  ```sql
SELECT usuarios.nombre, SUM(lineaspedido.precio * lineaspedido.unidades) AS dinero
FROM empleados 
	JOIN usuarios ON empleados.usuarioId=usuarios.id
	JOIN pedidos ON pedidos.empleadoId=empleados.id
	JOIN lineaspedido ON lineaspedido.pedidoId=pedidos.id
GROUP BY empleados.id
HAVING dinero > 1000.00;
  ```
</details>

<details>
<summary><b>5 pedidos con mayor importe de entre aquellos que tienen un importe menor a la media de pedidos.</b></summary>

  ```sql
SELECT p.id AS pedidoId, SUM(lp.unidades * lp.precio) AS importeTotal
FROM Pedidos p
JOIN LineasPedido lp ON p.id = lp.pedidoId
GROUP BY p.id
HAVING importeTotal < (
    SELECT AVG(total_importe)
    FROM (
        SELECT SUM(lp2.unidades * lp2.precio) AS total_importe
        FROM Pedidos p2
        JOIN LineasPedido lp2 ON p2.id = lp2.pedidoId
        GROUP BY p2.id
    ) AS importes
)
ORDER BY importeTotal DESC
LIMIT 5;
  ```
</details>

<details>
<summary><b>Clientes que han pedido en más de 3 meses distintos del último año uno de los 3 productos más vendidos de los últimos 5 años.</b></summary>

  ```sql
SELECT c.nombre, c.fechaNacimiento, u.email
FROM Clientes c
JOIN Usuarios u ON c.usuarioId = u.id
JOIN Pedidos p ON c.id = p.clienteId
JOIN LineasPedido lp ON p.id = lp.pedidoId
JOIN (
    SELECT productoId
    FROM LineasPedido
    JOIN Pedidos ON LineasPedido.pedidoId = Pedidos.id
    WHERE Pedidos.fechaRealizacion >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
    GROUP BY productoId
    ORDER BY SUM(unidades) DESC
    LIMIT 3
) AS topProductos ON lp.productoId = topProductos.productoId
WHERE p.fechaRealizacion >= DATE_FORMAT(CURDATE(), '%Y-01-01')
GROUP BY c.id
HAVING COUNT(DISTINCT DATE_FORMAT(p.fechaRealizacion, '%Y-%m')) >= 3;
  ```
</details>

---


