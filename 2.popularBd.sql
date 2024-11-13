-- Insertar datos en la tabla Usuarios
INSERT INTO Usuarios (email, contraseña, nombre) VALUES
('cliente1@example.com', 'password123', 'Cliente Uno'),
('empleado1@example.com', 'password123', 'Empleado Uno'),
('cliente2@example.com', 'password123', 'Cliente Dos'),
('empleado2@example.com', 'password123', 'Empleado Dos');

-- Insertar datos en la tabla Empleados
-- El usuarioId corresponde al segundo usuario, que es un empleado
INSERT INTO Empleados (usuarioId, salario) VALUES
(2, 35000.00);
INSERT INTO Empleados (usuarioId, salario) VALUES
(4, 40000.00);

-- Insertar datos en la tabla Clientes
-- Corresponde a los usuarios cliente
INSERT INTO Clientes (usuarioId, direccionEnvio, codigoPostal, fechaNacimiento) VALUES
(1, '123 Calle Principal', '28001', '2005-03-25'),
(3, '456 Avenida Secundaria', '28002', '2008-07-15'); -- Mayor de 14 años

-- Insertar datos en la tabla TiposProducto
-- Insertar datos en la tabla TiposProducto
INSERT INTO TiposProducto (nombre) VALUES
('Físicos'),
('Digitales');

-- Insertar datos en la tabla Productos
INSERT INTO Productos (nombre, descripción, precio, tipoProductoId, puedeVenderseAMenores) VALUES
('Smartphone', 'Teléfono inteligente de última generación', 699.99, 1, TRUE), -- Físico
('Laptop', 'Portátil con características avanzadas', 1200.00, 1, TRUE), -- Físico
('Libro Electrónico', 'Libro descargable en formato PDF', 9.99, 2, TRUE), -- Digital
('Videojuego', 'Videojuego descargable para PC', 59.99, 2, FALSE), -- Digital no vendible a menores
('Camiseta', 'Camiseta de algodón', 15.99, 1, TRUE), -- Físico
('Curso Online', 'Acceso a curso en línea sobre programación', 150.00, 2, TRUE), -- Digital
('Película', 'Película en formato digital HD', 19.99, 2, FALSE), -- Digital no vendible a menores
('Audífonos', 'Audífonos inalámbricos', 29.99, 1, TRUE), -- Físico
('Tableta Gráfica', 'Tableta para diseño gráfico', 85.99, 1, TRUE), -- Físico
('Documental', 'Documental descargable', 12.99, 2, TRUE); -- Digital

-- Insertar datos en la tabla Pedidos
INSERT INTO Pedidos (fechaRealizacion, fechaEnvio, direccionEntrega, comentarios, clienteId, empleadoId) VALUES
('2024-10-01', '2024-10-03', '123 Calle Principal', 'Entregar en la puerta', 1,  1),
('2024-10-02', NULL, '456 Avenida Secundaria', 'Entregar en recepción', 2, NULL),
('2010-06-01', '2010-06-03', '123 Calle VeteTuASaber', 'Cliente con movilidad reducida', 1,  2);

-- Insertar datos en la tabla LineasPedido - Conjunto de inserciones correctas
-- Productos permitidos para todos los clientes
INSERT INTO LineasPedido (pedidoId, productoId, unidades, precio) VALUES
(1, 1, 1, 699.99),   -- Smartphone (permitido)
(1, 5, 2, 15.99),    -- Camiseta (permitido)
(1, 3, 1, 9.99),     -- Libro Electrónico (permitido)
(3, 2, 1, 1100.00),   -- Laptop (permitido)
(3, 8, 2, 29.99),    -- Audífono (permitido)
(3, 9, 1, 12.99);     -- Tableta (permitido)

-- Insertar datos en la tabla LineasPedido - Conjunto de inserciones correctas
-- Productos permitidos para todos los clientes
INSERT INTO LineasPedido (pedidoId, productoId, unidades, precio) VALUES
(2, 8, 1, 29.99),    -- Audífonos (permitido)
(2, 9, 1, 59.99);    -- Tableta gráfica (permitido)


-- Prueba para Clientes que han pedido en más de 3 meses distintos del último año uno de los 3 productos más vendidos de los últimos 5 años
-- Insertar pedidos adicionales en diferentes meses para Cliente 1 y Cliente 2 dentro del último año
INSERT INTO Pedidos (fechaRealizacion, fechaEnvio, direccionEntrega, comentarios, clienteId, empleadoId) VALUES
('2024-01-15', '2024-01-16', '123 Calle Principal', 'Pedido de enero', 1, 1),
('2024-03-10', '2024-03-11', '123 Calle Principal', 'Pedido de marzo', 1, 1),
('2024-05-20', '2024-05-21', '123 Calle Principal', 'Pedido de mayo', 1, 1),
('2024-07-05', '2024-07-06', '123 Calle Principal', 'Pedido de julio', 1, 1),  -- Pedido adicional para cumplir condición

('2024-02-15', '2024-02-16', '456 Avenida Secundaria', 'Pedido de febrero', 2, NULL),
('2024-04-10', '2024-04-11', '456 Avenida Secundaria', 'Pedido de abril', 2, NULL),
('2024-08-20', '2024-08-21', '456 Avenida Secundaria', 'Pedido de agosto', 2, NULL); -- Otro cliente sin cumplir


-- Insertar líneas de pedido adicionales para los pedidos recientes en diferentes meses
INSERT INTO LineasPedido (pedidoId, productoId, unidades, precio) VALUES
(4, 1, 1, 699.99),   -- Smartphone (Cliente 1 en enero)
(5, 1, 1, 699.99),   -- Smartphone (Cliente 1 en marzo)
(6, 2, 1, 1200.00),  -- Laptop (Cliente 1 en mayo)
(7, 3, 1, 9.99),     -- Libro Electrónico (Cliente 1 en julio) -- Cumple condición

(8, 1, 1, 699.99),   -- Smartphone (Cliente 2 en febrero)
(9, 3, 2, 9.99),     -- Libro Electrónico (Cliente 2 en abril)
(10, 2, 1, 1200.00); -- Laptop (Cliente 2 en agosto) -- No cumple condición de más de 3 meses distintos


-- Prueba para 5 pedidos con mayor importe de entre aquellos que tienen un importe menor a la media de pedidos
-- Insertar pedidos adicionales para Cliente 1 y Cliente 2
INSERT INTO Pedidos (fechaRealizacion, fechaEnvio, direccionEntrega, comentarios, clienteId, empleadoId) VALUES
('2024-09-01', '2024-09-02', '123 Calle Principal', 'Pedido con importe bajo', 1, 1),
('2024-09-10', '2024-09-12', '123 Calle Principal', 'Pedido con importe medio', 1, 1),
('2024-09-15', '2024-09-16', '456 Avenida Secundaria', 'Pedido con importe alto', 2, NULL),
('2024-09-20', '2024-09-22', '456 Avenida Secundaria', 'Otro pedido con importe bajo', 2, NULL),
('2024-09-25', '2024-09-26', '123 Calle Principal', 'Pedido adicional con importe medio', 1, 1);

-- Insertar líneas de pedido para los pedidos adicionales con distintos importes
INSERT INTO LineasPedido (pedidoId, productoId, unidades, precio) VALUES
(11, 5, 1, 15.99),      -- Pedido 11, Importe bajo (15.99)
(11, 8, 2, 29.99),      -- Pedido 11, Importe total = 75.97

(12, 1, 1, 699.99),     -- Pedido 12, Importe medio (699.99)
(12, 5, 1, 15.99),      -- Pedido 12, Importe total = 715.98

(13, 2, 1, 1200.00),    -- Pedido 13, Importe alto (1200.00)
(13, 3, 3, 9.99),       -- Pedido 13, Importe total = 1229.97

(14, 8, 1, 29.99),      -- Pedido 14, Importe bajo (29.99)
(14, 9, 2, 85.99),      -- Pedido 14, Importe total = 201.97

(15, 1, 1, 699.99),     -- Pedido 15, Importe medio (699.99)
(15, 5, 1, 15.99),      -- Pedido 15, Importe total = 715.98

