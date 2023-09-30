-- CONSULTAS
	
-- Listar nombre planetas Jedi y personajes que nacieron en ellos

SELECT P.Nombre_planeta, PER.Nombre_personaje
FROM PLANETA as P, AFILIACION as A, PERSONAJE as PER
WHERE (P.Nombre_planeta = A.Nombre_planeta) and (P.Nombre_planeta = PER.Nombre_planeta) and (A.Nombre_af = 'Jedi');

-- Listar planetas en el sistema Coruscant

SELECT *
FROM PLANETA as P
WHERE P.Sistema_solar = 'Sistema Coruscant';
	
-- Cantidad de combates por medio y lugar
	
SELECT ID_medio, Lugar_combate, COUNT(*) AS Cantidad_combate
FROM Combate
GROUP BY ID_medio, Lugar_combate

-- Series que han tenido más episodios que el promedio

SELECT S.ID_serie, S.Titulo, S.Total_episodios
FROM SERIE as S
WHERE S.Total_episodios > (select avg(S.Total_episodios) from Serie as S);
	
-- Información de las naves de tipo “Carguero” cuyos dueños han aparecido en más de 2 películas	
-- No tenemos ninguna nave tipo Carguero, pero se puede intentar con "Caza estelar" o "Nave de combate"

SELECT N.ID_nave, N.Nombre_nave, N.Fabricante, N.Longitud, N.uso, N.Modelo
FROM NAVE AS N, DUENO AS D, APARECE AS A
WHERE (N.Uso = 'Carguero') AND (N.ID_nave = D.ID_nave) AND (D.Nombre_personaje = A.Nombre_personaje)
GROUP BY N.ID_nave, N.Nombre_nave, N.Fabricante, N.Longitud, N.Uso, N.Modelo
HAVING COUNT(Distinct ID_medio) > 2;	

-- Liste las películas que tengan más de 2 horas y media de duración, sean de tipo animada, cuya ganancia sea mayor al promedio de todas las películas del mismo tipo, ordenadas cronológicamente por el costo de producción	
-- No tenemos ninguna película tipo Animada, pero se puede intentar con "Ciencia ficción, Aventura"
-- Asimismo, las películas que cumplen esta condición tienen menos de 150 minutos

SELECT PE.Titulo, PE.Ganancia
FROM PELICULA as PE	
WHERE (PE.Duracion > 150) AND (PE.Tipo_pelicula = 'Animada') AND (PE.Ganancia > (SELECT AVG(PE.Ganancia) from PELICULA as PE))
order by PE.Coste_prod;

-- Consultas extras
-- Pelis mas taquilleras
	
SELECT PE.Titulo , PE.Ingreso_taquilla
FROM PELICULA as PE
ORDER BY PE.Ingreso_taquilla DESC
LIMIT 5;
	
-- Personajes con más de dos naves

SELECT P.Nombre_personaje, COUNT(D.ID_nave) AS Total_naves
FROM PERSONAJE P, DUENO D
WHERE P.Nombre_personaje = D.Nombre_personaje
GROUP BY P.Nombre_personaje
HAVING COUNT(D.ID_nave) > 2;
	