CREATE DATABASE Ejercicio9;
USE Ejercicio9;

-- Crear Tablas
CREATE TABLE Empleado (
    DNI INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    telefono VARCHAR(15),
    direccion VARCHAR(100),
    fechaIngreso DATE
);

CREATE TABLE Equipo (
    codEquipo INT PRIMARY KEY,
    nombreE VARCHAR(50),
    descTecnologias VARCHAR(100),
    DNILider INT,
    FOREIGN KEY (DNILider) REFERENCES Empleado(DNI)
);

CREATE TABLE Proyecto (
    codProyecto INT PRIMARY KEY,
    nombrP VARCHAR(100),
    descripcion TEXT,
    fechaInicioP DATE,
    fechaFinP DATE,
    fechaFinEstimada DATE,
    DNIResponsable INT,
    equipoBackend INT,
    equipoFrontend INT,
    FOREIGN KEY (DNIResponsable) REFERENCES Empleado(DNI),
    FOREIGN KEY (equipoBackend) REFERENCES Equipo(codEquipo),
    FOREIGN KEY (equipoFrontend) REFERENCES Equipo(codEquipo)
);

CREATE TABLE Empleado_Equipo (
    codEquipo INT,
    DNI INT,
    fechaInicio DATE,
    fechaFin DATE,
    descripcionRol VARCHAR(100),
    PRIMARY KEY (codEquipo, DNI),
    FOREIGN KEY (codEquipo) REFERENCES Equipo(codEquipo),
    FOREIGN KEY (DNI) REFERENCES Empleado(DNI)
);

-- Insertar datos de ejemplo
INSERT INTO Empleado (DNI, nombre, apellido, telefono, direccion, fechaIngreso) VALUES
(12345678, 'Juan', 'Perez', '123456789', 'Calle Falsa 123', '2020-01-01'),
(23456789, 'Ana', 'Garcia', '987654321', 'Calle Verdadera 456', '2019-02-15'),
(34567890, 'Luis', 'Martinez', '555555555', 'Av. Siempre Viva 742', '2018-06-10'),
(45678901, 'Maria', 'Lopez', '444444444', 'Calle Sin Nombre 101', '2017-09-23');

INSERT INTO Equipo (codEquipo, nombreE, descTecnologias, DNILider) VALUES
(1, 'Backend Team', 'Java, Spring Boot', 12345678),
(2, 'Frontend Team', 'JavaScript, React', 23456789),
(3, 'Data Science Team', 'Python, Machine Learning', 34567890);

INSERT INTO Proyecto (codProyecto, nombrP, descripcion, fechaInicioP, fechaFinP, fechaFinEstimada, DNIResponsable, equipoBackend, equipoFrontend) VALUES
(1, 'Proyecto A', 'Proyecto de desarrollo A', '2023-01-01', '2023-12-01', '2023-10-01', 12345678, 1, 2),
(2, 'Proyecto B', 'Proyecto de desarrollo B', '2022-06-01', '2023-05-01', '2023-05-01', 23456789, 1, 3),
(3, 'Proyecto X', 'Proyecto especial X', '2024-01-01', NULL, '2025-12-31', 34567890, 2, 3);

INSERT INTO Empleado_Equipo (codEquipo, DNI, fechaInicio, fechaFin, descripcionRol) VALUES
(1, 12345678, '2020-01-01', NULL, 'Desarrollador Backend'),
(2, 23456789, '2019-02-15', NULL, 'Desarrollador Frontend'),
(3, 34567890, '2018-06-10', NULL, 'Data Scientist');

------------------
--  EJERCICIOS  --
------------------

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
