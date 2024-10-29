SELECT * FROM Cliente;
# 1. Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por DNI
USE Ejercicio1;

SELECT nombre, apellido, DNI, telefono, direccion
FROM Cliente
WHERE apellido LIKE "Pe%"
ORDER BY DNI;

# 2. Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente durante 2017
SELECT nombre, apellido, DNI, telefono, direccion
FROM Cliente NATURAL JOIN Factura
WHERE Year(Factura.fecha) = 2017;