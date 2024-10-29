-- 2. Listar todos los pacientes que se atendieron con todos los especialistas
SELECT P.DNI, P.nombre, P.apellido, P.domicilio, P.telefono
FROM Paciente P
WHERE NOT EXISTS (
    SELECT E.Matricula
    FROM Especialista E
    WHERE NOT EXISTS (
        SELECT T.Matricula
        FROM Turno T
        WHERE T.DNI = P.DNI AND T.Matricula = E.Matricula
    )
);

-- 3. Listar todos los pacientes que se atendieron en 2021 y no se atendieron en 2019
SELECT P.DNI, P.nombre, P.apellido, P.domicilio, P.telefono
FROM Paciente P INNER JOIN Turno T 
ON P.DNI = T.DNI
WHERE YEAR(T.fecha) = '2021' -- Pacientes atendidos en 2021
AND P.DNI NOT IN (
    SELECT T2.DNI
    FROM Turno T2
    WHERE YEAR(T2.fecha) = '2019' -- Pacientes atendidos en 2019
);

-- 4. Listar todos los pacientes que se atendieron con "OSDE" y tambien con "IOMA"
SELECT P.DNI, P.nombre, P.apellido, P.domicilio, P.telefono
FROM Paciente P INNER JOIN Turno T
ON P.DNI = T.DNI
WHERE T.nombre = "OSDE"
AND P.DNI IN (
	SELECT T2.DNI
	FROM Turno T2
	WHERE T2.nombre = "IOMA"
);

-- 5. Listar para cada especialista la cantidad de turnos en el 2022
SELECT E.nombre, E.Apellido, Count(*)
FROM Especialista E INNER JOIN Turno T
ON E.Matricula = T.Matricula
WHERE YEAR(T.fecha) = '2022'
GROUP BY E.Matricula;

-- 6. Listar los pacientes que se hayan atendido mas de 5 veces en el año 2020
SELECT P.DNI, P.nombre, P.apellido
FROM Paciente P INNER JOIN Turno T
ON P.DNI = T.DNI
WHERE YEAR(T.fecha) = '2020'
GROUP BY P.DNI
HAVING COUNT(*) > 5
