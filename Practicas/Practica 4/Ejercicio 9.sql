USE Ejercicio9;

-- 1. Listar nombre, descripción, fecha de inicio y fecha de fin de proyectos ya finalizados que no fueron terminados antes de la fecha de fin estimada.
SELECT p.nombrP, p.descripcion, p.fechaInicioP, p.fechaFinP
FROM Proyecto p
WHERE p.fechaFinP IS NOT NULL 
	AND p.fechaFinP > p.fechaFinEstimada;
  
-- 2. Listar DNI, nombre, apellido, teléfono, dirección y fecha de ingreso de empleados que no son, ni fueron responsables de proyectos. Ordenar por apellido y nombre.
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion, e.fechaIngreso
FROM Empleado e
WHERE e.DNI NOT IN (SELECT DNIResponsable FROM Proyecto)
ORDER BY e.apellido, e.nombre;

-- 3. Listar DNI, nombre, apellido, teléfono y dirección de líderes de equipo que tenga más de un equipo a cargo.
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Empleado e INNER JOIN Equipo eq
ON e.DNI = eq.DNILider
GROUP BY e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
HAVING COUNT(*) > 1;

-- 4.  Listar DNI, nombre, apellido, teléfono y dirección de todos los empleados que trabajan en el proyecto con nombre ‘Proyecto X’. No es necesario informar responsable y líderes.
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Empleado e
INNER JOIN empleado_equipo ee ON e.DNI = ee.DNI
INNER JOIN Proyecto p ON (p.equipoBackend = ee.codEquipo OR p.equipoFrontend = ee.codEquipo)
WHERE p.nombrP = 'Proyecto X';

-- 5. Listar nombre de equipo y datos personales de líderes de equipos que no tengan empleados asignados y trabajen con tecnología ‘Java’.
SELECT eq.nombreE, e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Equipo eq
JOIN Empleado e ON eq.DNILider = e.DNI
WHERE eq.descTecnologias LIKE '%Java%'
  AND eq.codEquipo NOT IN (SELECT codEquipo FROM Empleado_Equipo);
  
-- 6. Modificar nombre, apellido y dirección del empleado con DNI 40568965 con los datos que desee
UPDATE Empleado SET
nombre='Lorenzo', apellido='Montoya', direccion='Test 123455'
WHERE DNI=40568965;

-- 7. Listar DNI, nombre, apellido, teléfono y dirección de empleados que son responsables de proyectos pero no han sido líderes de equipo.
SELECT DNI, nombre, apellido, telefono, direccion
FROM Empleado e 
INNER JOIN Proyecto p ON e.DNI = p.DNIResponsable
WHERE e.DNI NOT IN (
	SELECT ee.DNI
    FROM Empleado_Equipo ee
    WHERE ee.descripcionRol = 'Lider'
);

-- 8. Listar nombre de equipo y descripción de tecnologías de equipos que hayan sido asignados como equipos frontend y backend.
SELECT e.nombreE, e.descTecnologias
FROM Equipo e
WHERE e.codEquipo IN (
	SELECT p.equipoBackend
    FROM Proyecto p
) AND e.codEquipo IN (
	SELECT p.equipoFrontend
    FROM Proyecto p
);

-- 9. Listar nombre, descripción, fecha de inicio, nombre y apellido de responsables de proyectos que se estiman finalizar durante 2025.
SELECT p.nombrP, p.descripcion, p.fechaInicioP, e.nombre, e.apellido
FROM Empleado e
INNER JOIN Proyecto p ON p.DNIResponsable = e.DNI
WHERE YEAR(fechaFinEstimada) = 2025
