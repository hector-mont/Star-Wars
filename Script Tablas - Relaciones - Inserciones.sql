-- TABLAS:

-- Tabla Actor
CREATE TABLE ACTOR(
	Nombre_actor varchar(30) PRIMARY KEY NOT NULL,
	Fecha_nacimiento date NOT NULL,
	Genero varchar(4) NOT NULL CHECK(Genero IN('M','F','Desc','Otro')),
	Nacionalidad varchar(25) NOT NULL,
	Tipo varchar(25) NOT NULL CHECK(Tipo IN('Interpreta','Presta su voz'))
);
		
-- Tabla Planeta
CREATE TABLE PLANETA(
	Nombre_planeta varchar(15) PRIMARY KEY NOT NULL,
	Sistema_solar varchar(20) NOT NULL,
	Sector varchar(15) NOT NULL,
	Clima varchar(15) NOT NULL
);

-- Tabla Nave
CREATE TABLE NAVE(
	ID_nave serial PRIMARY KEY NOT NULL,
	Nombre_nave varchar(30) NOT NULL,
	Fabricante varchar(70) NOT NULL,
	Longitud float NOT NULL,
	Uso varchar(30) NOT NULL,
	Modelo varchar(50) NOT NULL,
	CHECK(Nombre_nave <> 'Destructor Estelar' OR (Nombre_nave = 'Destructor Estelar' AND Longitud >= 900 AND Uso = 'Combate'))
);

-- Tabla Ciudad
CREATE TABLE CIUDAD(
	Nombre_ciudad varchar(30) PRIMARY KEY NOT NULL,
	Nombre_planeta varchar(15) NOT NULL,
	FOREIGN KEY (Nombre_planeta) REFERENCES PLANETA(Nombre_planeta)
);

-- Tabla Lugar_interes
CREATE TABLE LUGAR_INTERES(
	Nombre_ciudad varchar(30),
    Lugar varchar(30),
    CONSTRAINT PK_LUGAR_INTERES PRIMARY KEY (Nombre_ciudad, Lugar),
    FOREIGN KEY (Nombre_ciudad) REFERENCES CIUDAD(Nombre_ciudad)
);

-- Tabla Medio 
CREATE TABLE MEDIO(
	ID_medio serial PRIMARY KEY NOT NULL
);	
	
-- Tabla Película (Rating BETWEEN (1 AND 5))
CREATE TABLE PELICULA(
	ID_pelicula serial PRIMARY KEY NOT NULL,
	Titulo varchar(60) NOT NULL,
	Fecha_estreno date NOT NULL,
	Rating float NOT NULL CHECK(Rating >= 1 AND Rating <= 5),
    Sinopsis varchar(1000) NOT NULL,
	Director varchar(20) NOT NULL,
	Duracion float NOT NULL,
	Distribuidor varchar(50) NOT NULL,
	Coste_prod decimal(20, 2) NOT NULL,
	Ingreso_taquilla decimal(20, 2) NOT NULL,
    Tipo_pelicula varchar(60) NOT NULL,
	Ganancia decimal(20, 2) GENERATED ALWAYS AS (Ingreso_taquilla - Coste_prod ) STORED,
	CONSTRAINT CK_GANANCIA CHECK (Ganancia >= 0),
	FOREIGN KEY (ID_pelicula) REFERENCES MEDIO(ID_medio)
);
	
-- Tabla Serie (Rating BETWEEN (1 AND 5))
CREATE TABLE SERIE(
	ID_serie serial PRIMARY KEY NOT NULL,
	Titulo varchar(60) NOT NULL,
	Fecha_estreno date NOT NULL,
	Rating float NOT NULL CHECK(Rating >= 1 AND Rating <= 5),
    Sinopsis varchar(1000) NOT NULL,
	Creador varchar(50) NOT NULL,
	Total_episodios integer NOT NULL,
	Canal varchar(50) NOT NULL,
	Tipo_serie varchar(20) NOT NULL,
    FOREIGN KEY (ID_serie) REFERENCES MEDIO(ID_medio)
);	
	
-- Tabla Videojuego (Rating BETWEEN (1 AND 5))
CREATE TABLE VIDEOJUEGO(
	ID_videojuego serial PRIMARY KEY NOT NULL,
	Titulo varchar(60) NOT NULL,
	Fecha_estreno date NOT NULL,
	Rating float NOT NULL CHECK(Rating >= 1 AND Rating <= 5),
    Sinopsis varchar(1000) NOT NULL,
    Compania varchar(50) NOT NULL,
	Tipo_juego varchar(50) NOT NULL,
	FOREIGN KEY (ID_videojuego) REFERENCES MEDIO(ID_medio)
);

-- Tabla Plataforma
CREATE TABLE PLATAFORMA(
	ID serial NOT NULL,
    Plataforma varchar(40) NOT NULL,
	CONSTRAINT PK_PLATAFORMA PRIMARY KEY (ID, Plataforma),
    FOREIGN KEY (ID) REFERENCES VIDEOJUEGO(ID_videojuego)
);
		
-- Tabla Afiliación
CREATE TABLE AFILIACION(
	Nombre_Af varchar(20) PRIMARY KEY NOT NULL,
	Tipo_Af varchar(20) NOT NULL,
	Nombre_planeta varchar(15) NOT NULL,
	FOREIGN KEY (Nombre_planeta) REFERENCES PLANETA(Nombre_planeta)
);

-- Tabla Especie
CREATE TABLE ESPECIE(
	Nombre_especie varchar(30) PRIMARY KEY NOT NULL
);

-- Tabla Robot
CREATE TABLE ROBOT(
	Nombre_robot varchar(30) PRIMARY KEY NOT NULL,
	Idioma varchar(40) NOT NULL,
	Creador varchar(40) NOT NULL,
	Clase varchar(40) NOT NULL,
	FOREIGN KEY (Nombre_robot) REFERENCES ESPECIE(Nombre_especie)
);
	
-- Tabla Humano
CREATE TABLE HUMANO(
	Nombre_humano varchar(30) PRIMARY KEY NOT NULL,
	Idioma varchar(40) NOT NULL,
	Fecha_nacimiento date NOT NULL,
	Fecha_muerte date NOT NULL,
	FOREIGN KEY (Nombre_humano) REFERENCES ESPECIE(Nombre_especie)
);	
	
-- Tabla Criatura
CREATE TABLE CRIATURA(
	Nombre_criatura varchar(30) PRIMARY KEY NOT NULL,
	Idioma varchar(40) NOT NULL,
	Color_piel varchar(30) NOT NULL,
	Dieta varchar(20) NOT NULL CHECK(Dieta IN('Herbívoro','Carnívoro','Omnívoro','Carroñeros', 'Geófago', 'Electrófago')),
	FOREIGN KEY (Nombre_criatura) REFERENCES ESPECIE(Nombre_especie)
);	
		
-- Tabla Personaje
CREATE TABLE PERSONAJE(
	Nombre_personaje varchar(20) PRIMARY KEY NOT NULL,
	Genero varchar(4) NOT NULL CHECK(Genero IN('M','F','Desc','Otro')),
	Altura float NOT NULL,
	Peso float NOT NULL,
	Nombre_planeta varchar(15) NOT NULL,
    Nombre_especie varchar (20) NOT NULL,
	FOREIGN KEY (Nombre_planeta) REFERENCES PLANETA(Nombre_planeta),
	FOREIGN KEY (Nombre_especie) REFERENCES ESPECIE(Nombre_especie)
);	
	
-- Tabla Idioma
CREATE TABLE IDIOMA(
	Nombre_planeta varchar(15) NOT NULL,
	Idioma varchar(30) NOT NULL,
	CONSTRAINT PK_IDIOMA PRIMARY KEY (Nombre_planeta, Idioma),
	FOREIGN KEY (Nombre_planeta) REFERENCES PLANETA(Nombre_planeta)
);

--RELACIONES:
	
-- Relación Combate - Verificar(Participante_1, Participante_2, ID_medio)
CREATE TABLE COMBATE(
	Participante_1 varchar(20) NOT NULL,
	Participante_2 varchar(20) NOT NULL,
	ID_medio serial NOT NULL,
	Fecha_combate date NOT NULL,
	Lugar_combate varchar (150) NOT NULL,
	CONSTRAINT PK_COMBATE PRIMARY KEY (Participante_1, Participante_2, ID_medio, Fecha_combate),
	FOREIGN KEY (Participante_1) REFERENCES PERSONAJE(Nombre_personaje),
	FOREIGN KEY (Participante_2) REFERENCES PERSONAJE(Nombre_personaje),
	FOREIGN KEY (ID_medio) REFERENCES MEDIO(ID_medio)
);

-- Relación Afiliado - Verificar(Nombre_Af, Nombre_personaje)
CREATE TABLE AFILIADO(
	Nombre_Af varchar(20) NOT NULL,
	Nombre_personaje varchar(20) NOT NULL,
	Fecha_Af date NOT NULL,
	CONSTRAINT PK_AFILIADO PRIMARY KEY (Nombre_Af, Nombre_personaje, Fecha_Af),
	FOREIGN KEY (Nombre_Af) REFERENCES AFILIACION(Nombre_Af),
	FOREIGN KEY (Nombre_personaje) REFERENCES PERSONAJE(Nombre_personaje)
);

-- Relación Tripula - Verificar(Nombre_personaje, ID_nave)
CREATE TABLE TRIPULA(
	Nombre_personaje varchar(20) NOT NULL,
	ID_nave serial NOT NULL,
	Tipo_tripulacion varchar(100) NOT NULL,
	CONSTRAINT PK_TRIPULA PRIMARY KEY (Nombre_personaje, ID_nave),
	FOREIGN KEY (Nombre_personaje) REFERENCES PERSONAJE(Nombre_personaje),
	FOREIGN KEY (ID_nave) REFERENCES NAVE(ID_nave)
);

-- Relación Dueño - Verificar(Nombre_personaje, ID_nave)
CREATE TABLE DUENO(
	Nombre_personaje varchar(20) NOT NULL,
	ID_nave serial NOT NULL,
	Fecha_compra date NOT NULL,
	CONSTRAINT PK_DUENO PRIMARY KEY (Nombre_personaje, ID_nave, Fecha_compra),
	FOREIGN KEY (Nombre_personaje) REFERENCES PERSONAJE(Nombre_personaje),
	FOREIGN KEY (ID_nave) REFERENCES NAVE(ID_nave)
);

-- Relación Aparece - Verificar(Nombre_personaje, ID_medio)
CREATE TABLE APARECE(
	Nombre_personaje varchar(20) NOT NULL,
	ID_medio serial NOT NULL,
	Fecha_estreno date NOT NULL,
	CONSTRAINT PK_APARECE PRIMARY KEY (Nombre_personaje, ID_medio, Fecha_estreno),
	FOREIGN KEY (Nombre_personaje) REFERENCES PERSONAJE(Nombre_personaje),
	FOREIGN KEY (ID_medio) REFERENCES MEDIO(ID_medio)
);

-- Relación Interpretado - Verificar(Nombre_personaje, ID_medio, Nombre_actor)
CREATE TABLE INTERPRETADO(
	Nombre_personaje varchar(20) NOT NULL,
	ID_medio serial NOT NULL,
	Nombre_actor varchar(30) NOT NULL,
	CONSTRAINT PK_INTERPRETADO PRIMARY KEY (Nombre_personaje, ID_medio, Nombre_actor),
	FOREIGN KEY (Nombre_personaje) REFERENCES PERSONAJE(Nombre_personaje),
	FOREIGN KEY (ID_medio) REFERENCES MEDIO(ID_medio),
	FOREIGN KEY (Nombre_actor) REFERENCES ACTOR(Nombre_actor)
);

-- INSERTS

-- PLANETA
INSERT INTO public.planeta(Nombre_planeta, Sistema_solar, Sector, Clima)
VALUES 
  ('Coruscant', 'Sistema Coruscant', 'Corusca', 'Templado'),
  ('Chandrila', 'Desconocido', 'Desconocido', 'Templado'),
  ('Tatooine', 'Sistema Tatoo', 'Arkanis', 'Húmedo'),
  ('Shili', 'Sistema Shili', 'Desconocido', 'Árido'),
  ('Alderaan', 'Sistema Alderaan', 'Alderaan', 'Templado'),
  ('Jakku', 'Sistema Jakku', 'Desconocido', 'Gélido'),
  ('Stewjon', 'Desconocido', 'Desconocido', 'Desconocido'),
  ('Corellia', 'Sistema Corellia', 'Corelliano', 'Desconocido'),
  ('Ilum', 'Sistema Ilum', '7G', 'Gélido'),
  ('Iktotch', 'Sistema Iktotch', 'Narvath', 'Desconocido'),
  ('Kalee', 'Desconocido', 'Desconocido', 'Desconocido'),
  ('Kashyyyk', 'Sistema Kashyyyk', 'Mytaranor', 'Templado'),
  ('Dagobah', 'Sistema Dagobah', 'Sluis', 'Lluvioso'),
  ('Axxila', 'Desconocido', 'Desconocido', 'Desconocido'),
  ('Concord Dawn', 'Sistema Concord Dawn', 'Mandalore', 'Desconocido'),
  ('Carida', 'Sistema Carida', 'Desconocido', 'Desconocido'),
  ('Alsakan', 'Desconocido', 'Desconocido', 'Desconocido'),
  ('Ryloth', 'Sistema Ryloth', 'Gaulus', 'Templado'),
  ('D´Qar', 'Sistema Ileenium', 'Sanbra', 'Boscoso'),
  ('Geonosis', 'Sistema Geonosis', 'Arkanis', 'Árido'),
  ('Hosnian Prime', 'Sistema Hosnian', 'Desconocido', 'Desconocido'),
  ('Korriban', 'Sistema Korriban', 'Esstran', 'Árido'),
  ('Mandalore', 'Sistema Mandalore', 'Mandalore', 'Árido'),
  ('Mustafar', 'Sistema Mustafar', 'Atravis', 'Volcánico'),
  ('Naboo', 'Sistema Naboo', 'Chommell', 'Templado'),
  ('Starkiller Base', 'Desconocido', 'Desconocido', 'Gélido'),
  ('Yavin 4', 'Sistema Yavin', 'Gordian Reach', 'Tropical');
  
-- ESPECIE
INSERT INTO public.especie(Nombre_especie)
VALUES 
  ('Humano'),
  ('R2-D2'),
  ('R4-P17'),
  ('T3-M4'),
  ('BB-8'),
  ('K-3PO'),
  ('U-3PO'),
  ('TC-14'),
  ('4-LOM'),
  ('Droide de combate B1'),
  ('Superdroide de combate B2'),
  ('Soldado Oscuro'),
  ('Droideka'),
  ('MagnaGuardia IG-100'),
  ('2-1B'),
  ('FX-7'),
  ('C-3PX'),
  ('HK-47'),
  ('IG-88'),
  ('Droide serie DUM'),
  ('Wookiees'),
  ('Hutts'),
  ('Jawas'),
  ('Ewoks'),
  ('Twi´lek'),
  ('Dathomiriano'),
  ('Togruta'),
  ('Trandoshanos'),
  ('Gungans'),
  ('Kaminoanos'),
  ('Mon Calamari'),
  ('Zabraks'),
  ('Tauntauns'),
  ('Shaaks'),
  ('Iktotchi'),
  ('Kaleesh'),
  ('Especie de Yoda');

-- PERSONAJE
INSERT INTO public.personaje(Nombre_personaje, Genero, Altura, Peso, Nombre_planeta, Nombre_especie)
VALUES
    ('Kylo Ren','M','191','90','Chandrila','Humano'),
    ('Achk Med-Beq','M','180','70','Coruscant','Humano'),
    ('C-3PO','M','177','75','Tatooine','C-3PX'),
    ('Ahsoka Tano','F','188','80','Shili','Togruta'),
    ('Leia Organa','F','155','51','Alderaan','Humano'),
    ('Ulic Qel-Droma','M','177','81','Alderaan','Humano'),
    ('Rey','F','170','54','Jakku','Humano'),
    ('Darth Vader','M','203','120','Tatooine','Humano'),
    ('Obi-Wan Kenobi','M','182','71','Stewjon','Humano'),
    ('Han Solo','M','180','75','Corellia','Humano'),
    ('Palpatine​','M','175','75','Naboo','Humano'),
    ('Finn','M','178','73','Ilum','Humano'),
    ('Baash','M','120','20','Iktotch','Iktotchi'),
    ('Padmé Amidala','F','165','53','Naboo','Humano'),
    ('Luke Skywalker','M','172','73','Tatooine','Humano'),
    ('General Grievous','M','216','130','Kalee','Kaleesh'),
    ('Chewbacca','M','230','150','Kashyyyk','Wookiees'),
    ('Yoda','M','0.66','213','Dagobah','Especie de Yoda'),
    ('Firmus Piett','M','173','70','Axxila','Humano'),
    ('Jango Fett','M','183','79','Concord Dawn','Humano'),
    ('Qui-Gon Jinn','M','193','90','Coruscant','Humano'),
    ('Raymus Antilles','M','188','92','Alderaan','Humano'),
    ('Poe Dameron','M','172','80','Yavin 4','Humano'),
    ('Kendal Ozzel','M','175','69','Carida','Humano'),
    ('Enric Pryde','M','188','78','Alsakan','Humano'),
    ('Anakin Skywalker','M','188','80','Tatooine','Humano'),
    ('Hera Syndulla','F','176','50','Ryloth','Twi´lek');

-- ACTOR
INSERT INTO public.actor(Nombre_actor, Fecha_nacimiento, Genero, Nacionalidad, Tipo)
VALUES 
    ('Adam Driver', '1983-11-19', 'M', 'Estadounidense', 'Interpreta'),
    ('Ahmed Best', '1973-08-19', 'M', 'Estadounidense', 'Interpreta'),
    ('Anthony Daniels', '1946-02-21', 'M', 'Británico', 'Presta su voz'),
    ('Ashley Eicksten', '1981-09-22', 'F', 'Estadounidense', 'Presta su voz'),
    ('Carrie Fisher', '1956-10-21', 'F', 'Estadounidense', 'Interpreta'),
    ('Charles Dennis', '1946-12-16', 'M', 'Canadiense', 'Presta su voz'),
    ('Daisy Ridley', '1992-04-10', 'F', 'Inglesa', 'Interpreta'),
    ('David Charles Prowse', '1935-01-07', 'M', 'Británico', 'Interpreta'),
    ('Ewan Mcgregor', '1971-03-31', 'M', 'Británico', 'Interpreta'),
    ('Harrison Ford', '1942-07-13', 'M', 'Estadounidense', 'Interpreta'),
    ('Hayden Christensen', '1981-04-19', 'M', 'Canadiense', 'Interpreta'),
    ('Ian McDiarmid', '1944-08-11', 'M', 'Escocés', 'Interpreta'),
    ('James Earl Jones', '1931-01-17', 'M', 'Estadounidense', 'Presta su voz'),
    ('John Boyega', '1992-03-17', 'M', 'Británico', 'Interpreta'),
    ('John Dimaggio', '1968-09-04', 'M', 'Estadounidense', 'Presta su voz'),
    ('Natalie Portman', '1981-06-09', 'F', 'Israelí - Estadounidense', 'Interpreta'),
    ('Mark Hamill', '1951-09-25', 'M', 'Estadounidense', 'Interpreta'),
    ('Matthew Grievous', '1972-08-15', 'M', 'Estadounidense', 'Presta su voz'),
    ('Peter Mayhew', '1944-05-19', 'M', 'Británico', 'Presta su voz'),
    ('Richard Oznowicz', '1944-05-25', 'M', 'Estadounidense', 'Presta su voz'),
    ('Rosario Dawson', '1979-05-09', 'M', 'Británico', 'Interpreta'),
    ('Kenneth Colley', '1937-12-07', 'F', 'Estadounidense', 'Interpreta'),
    ('Temuera Morrison', '1960-12-26', 'M', 'Neozelandés', 'Interpreta'),
    ('Liam Neeson', '1952-06-07', 'M', 'Británico', 'Presta su voz'),
    ('Rohan Nichol', '1976-07-04', 'M', 'Australiano', 'Interpreta'),
    ('Oscar Isaac', '1979-03-09', 'M', 'Guatemalteco', 'Interpreta'),
    ('Michael Sheard', '1938-06-18', 'M', 'Escocés', 'Interpreta'),
    ('Richard E. Grant', '1957-05-05', 'M', 'Suazí - Británico', 'Interpreta'),
    ('Vanessa Marshall', '1969-10-19', 'F', 'Estadounidense', 'Presta su voz');
  
-- MEDIO
INSERT INTO public.medio(ID_medio)
VALUES 
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10),
    (11),
    (12),
    (13),
    (14),
    (15),
    (16),
    (17),
    (18),
    (19),
    (20),
    (21),
    (22),
    (23),
    (24),
    (25),
    (26),
    (27),
    (28),
    (29);

-- PELICULA
INSERT INTO public.pelicula (ID_pelicula, Titulo, Fecha_estreno, Rating, Sinopsis, Director, Duracion, Distribuidor, Coste_prod, Ingreso_taquilla, Tipo_pelicula)
VALUES
(1, 'Star Wars: Episodio V - El Imperio Contraataca', '1980-05-21', '4.5', 'Son tiempos adversos para la rebelión. Aunque la Estrella de la Muerte ha sido destruida, las tropas imperiales han hecho salir a las fuerzas rebeldes de sus bases ocultas y los persiguen a través de la galaxia. Tras escapar de la terrible Flota Imperial, un grupo de guerreros de la libertad, encabezados por Luke Skywalker, ha establecido una nueva base secreta en el remonto mundo helado de Hoth.', 'Irvin Kershner', 124,'20th Century Fox',18, 547.9,'Ciencia ficción, Aventura'),
(2, 'Star Wars: Episodio IV - Una Nueva Esperanza', '1997-03-26', '4.5', 'La nave en la que viaja la princesa Leia es capturada por las tropas imperiales al mando del temible Darth Vader. Antes de ser atrapada, Leia consigue introducir un mensaje en su robot R2-D2, quien acompañado de su inseparable C-3PO logran escapar. Tras aterrizar en el planeta Tattooine son capturados y vendidos al joven Luke Skywalker, quien descubrirá el mensaje oculto que va destinado a Obi Wan Kenobi, maestro Jedi a quien Luke debe encontrar para salvar a la princesa.', 'George Lucas', 121, '20th Century Fox', 11 , 775.4 , 'Ciencia ficción, Aventura'),
(3, 'Star Wars: Episodio VI - El retorno del Jedi', '1983-07-05', '4.5', 'El Imperio Galáctico, bajo el mando del temible Emperador Palpatine y su aprendiz Darth Vader, se enfrenta a la Alianza Rebelde, liderada por Luke Skywalker, la Princesa Leia y Han Solo. Luke, ahora un Jedi más experimentado, se embarca en una misión para rescatar a Han Solo de las garras del poderoso mafioso Jabba the Hutt. Después, los Rebeldes se preparan para un ataque final contra la nueva Estrella de la Muerte, la cual destruir planetas enteros. Mientras tanto, Vader comienza a cuestionar su lealtad al Emperador, lo que lleva a un enfrentamiento épico entre el lado oscuro y la redención.', 'Richard Marquand', 131, '20th Century Fox', 32.5 , 572.7 , 'Ciencia ficción, Aventura'),
(4, 'Star Wars: Episodio 1 - La Amenaza Fantasma', '1999-06-30', '3.7', 'La República Galáctica está sumida en el caos. Los impuestos de las rutas comerciales a los sistemas estelares exteriores están en disputa. Esperando resolver el asunto con un bloqueo de poderosas naves de guerra, la codiciosa Federación del Comercio ha detenido todos los envíos al pequeño planeta de Naboo.', 'George Lucas', 136, '20th Century Fox', 115, 1027, 'Ciencia ficción, Aventura'),
(5, 'Star Wars: Episodio II - El Ataque de los Clones', '2002-05-16', '3.7', 'En el Senado Galáctico reina la inquietud. Varios miles de sistemas solares han declarado su intención de abandonar la República. Este movimiento separatista, liderado por el misterioso conde Dooku, ha provocado que al limitado número de caballeros Jedi les resulte difícil mantener la paz y el orden en la galaxia. La senadora Amidala, antigua Reina de Naboo, regresa al Senado Galáctico para dar su voto en la crítica cuestión de crear un ejército de la República que ayude a los desbordados Jedi.', 'George Lucas', 160, '20th Century Fox', 115 , 653.8 , 'Ciencia ficción, Aventura'),
(6, 'Star Wars: Episodio III - La Venganza de los Sith', '2005-05-19', '4.5', 'Años después del inicio de las Guerra de los Clones, los nobles Caballeros Jedi lideran un gran ejército clon en un combate de toda la galaxia contra los separatistas. Cuando el siniestro Sith devela un plan de mil años de antigüedad para gobernar la galaxia, la República se desmorona y de sus cenizas se eleva el malvado Imperio Galáctico. El heroico Jedi, Anakin Skywalker, es seducido por el lado oscuro de la Fuerza para convertirse en el nuevo aprendiz del Emperador, Darth Vader. Los Jedi son diezmados, mientras Obi-Wan Kenobi y el Maestro Jedi Yoda se ven obligados a esconderse.', 'George Lucas', 140, '20th Century Fox', 113, 868.4 , 'Ciencia ficción, Aventura'),
(7, 'Star Wars: Episodio VII - El Despertar de la Fuerza', '2015-12-18', '4.1', 'Treinta años después de la victoria de la Alianza Rebelde sobre la segunda Estrella de la Muerte, la galaxia tiene que enfrentarse a una nueva amenaza: el malvado Kylo Ren y la Primera Orden. Cuando el desertor Finn llega a un planeta desierto conoce a Rey, cuyo androide contiene un mapa secreto. Juntos, la joven pareja unirá fuerzas con Han Solo para asegurarse de que la resistencia encuentra a Luke Skywalker, el último de los caballeros Jedi.', 'J. J. Abrams', 135, 'Walt Disney Studios Motion Pictures', 306, 2071, 'Ciencia ficción, Aventura'),
(8, 'Star Wars: Episodio IX - El Ascenso de Skywalker', '2019-12-19', '4.0', 'La conclusión de la saga Skywalker, la Resistencia liderada por Rey, Finn y Poe Dameron se enfrenta a la amenaza final de la malvada Emperatriz Palpatine y su resurgida flota imperial. Mientras tanto, Kylo Ren lucha con sus propios conflictos internos. Rey continúa su entrenamiento Jedi mientras busca respuestas sobre su linaje y su conexión con la Fuerza. En una carrera contra el tiempo, los héroes se enfrentan a peligrosas misiones, viejos enemigos y toman decisiones que afectarán el destino de la galaxia.', 'J. J. Abrams', 155, 'Walt Disney Studios Motion Pictures', 275, 1074, 'Ciencia ficción, Aventura');  

-- SERIE
INSERT INTO public.serie (ID_serie, Titulo, Fecha_estreno, Rating, Sinopsis, Creador, Total_episodios, Canal, Tipo_serie)
VALUES
(9, 'Star Wars: The Clone Wars', '2008-10-03', 4.7, 'La serie sigue las aventuras de los Jedi, los clones y otros personajes durante las Guerras Clon', 'George Lucas', 133, 'Disney+', 'Animación'),
(10, 'The Mandalorian', '2019-11-12', '4.1', 'Es una serie de televisión por internet de aventura espacial y wéstern espacial estadounidense que se estrenó en la plataforma Disney+', 'Jon Favreau', 24, 'Disney+', 'Acción, Aventura'),
(11, 'Star Wars: Rebels', '2014-10-03', 4.8, 'Un grupo de rebeldes lucha contra el Imperio Galáctico en los primeros días de la Rebelión', 'Simon Kinberg, Dave Filoni, Carrie Beck', 75, 'Disney+', 'Animación'),
(12, 'Star Wars: Resistance', '2018-10-07', 4.3, 'Un joven piloto se une a la Resistencia para espiar al Primer Orden', 'Dave Filoni', 40, 'Disney+', 'Animación'),
(13, 'Star Wars: The Bad Batch', '2021-05-04', 4.7, 'Un grupo de clones defectuosos se embarca en misiones especiales durante la transición de la República al Imperio.', 'Dave Filoni', 16, 'Disney+', 'Animación'),
(14, 'Star Wars: Ewoks', '1985-09-07', 4.2, 'Las aventuras de los Ewoks en el planeta forestal de Endor.', 'George Lucas', 35, 'ABC', 'Animación'),
(15, 'Star Wars: Droids', '1985-09-07', 4.1, 'Las aventuras de los droides C-3PO y R2-D2 antes de los eventos de la trilogía original', 'George Lucas', 13, 'ABC', 'Animación'),
(16, 'Star Wars: Clone Wars (2003)', '2003-11-07', 4.6, 'La serie muestra batallas y eventos importantes durante las Guerras Clon', 'Genndy Tartakovsky', 25, 'Cartoon Network', 'Animación'),
(17, 'Star Wars: Clone Wars (2008)', '2008-10-03', 4.7, 'La serie animada sigue las aventuras de los Jedi, los clones y otros personajes durante las Guerras Clon', 'George Lucas', 12, 'Cartoon Network', 'Animación'),
(18, 'Star Wars: The Resistance Rises', '2016-02-15', 4.4, 'Breves historias que siguen a los personajes de Star Wars: The Force Awakens', 'Various', 5, 'Disney XD', 'Animación'),
(19, 'Lego Star Wars: The Freemaker Adventures', '2016-06-20', '4.0', 'Es una serie animada de televisión que combina el universo de Star Wars con el humor y la creatividad de Lego. La historia sigue a la familia Freemaker, compuesta por Rowan, Kordi y Zander, quienes son recolectores de chatarra espacial. Cuando Rowan descubre que tiene un don especial para sentir los cristales Kyber, se embarcan en una aventura para construir y encontrar artefactos Jedi perdidos. Mientras exploran la galaxia, se enfrentan a peligrosos villanos como el Imperio Galáctico y Darth Vader, pero también se encuentran con aliados inesperados.', 'Bill Motz - Bob Roth', 26, 'Disney XD', 'Animación');

-- VIDEOJUEGO

INSERT INTO public.videojuego (ID_videojuego, Titulo, Fecha_estreno, Rating, Sinopsis, Compania, Tipo_juego)
VALUES
(20, 'Star Wars Jedi: Fallen Order', '2019-11-15', 4.8, 'Un Jedi en fuga debe completar su entrenamiento y descubrir los secretos de su pasado', 'Electronic Arts', 'Aventura'),
(21, 'Star Wars Battlefront II', '2017-11-17', 4.4, 'Un juego de disparos en primera persona basado en el universo de Star Wars', 'Electronic Arts', 'Acción'),
(22, 'LEGO Star Wars: The Skywalker Saga', '2022-06-21', 4.0, 'Una aventura de LEGO que abarca las nueve películas principales de Star Wars', 'Warner Bros. Interactive Entertainment', 'Aventura'),
(23, 'Star Wars: Squadrons', '2020-10-02', 4.6, 'Un juego de simulación de combate espacial en el universo de Star Wars', 'Electronic Arts', 'Simulación'),
(24, 'Star Wars: Knights of the Old Republic', '2003-07-15', 4.9, 'Un RPG basado en el universo de Star Wars ambientado miles de años antes de los eventos de las películas', 'LucasArts', 'RPG'),
(25, 'Star Wars: The Old Republic', '2011-12-20', 4.7, 'Un MMORPG ambientado en el universo de Star Wars', 'Electronic Arts', 'MMORPG'),
(26, 'Star Wars: Jedi Knight - Jedi Academy', '2003-09-16', 4.8, 'Un juego de acción y combate con sable de luz en el universo de Star Wars', 'LucasArts', 'Acción'),
(27, 'Star Wars: Republic Commando', '2005-03-04', 4.5, 'Un juego de disparos táctico en primera persona en el que controlas a un comando de élite en el universo de Star Wars', 'LucasArts', 'Acción'),
(28, 'Star Wars: The Force Unleashed', '2008-09-16', 4.6, 'Un juego de acción y aventura en el que controlas a un aprendiz secreto de Darth Vader', 'LucasArts', 'Acción'),
(29, 'Star Wars: Battlefront', '2015-11-17', 4.3, 'Un juego de disparos en primera persona basado en el universo de Star Wars.', 'Electronic Arts', 'Acción');

-- PLATAFORMA
INSERT INTO public.plataforma (ID, Plataforma)
VALUES 
(20, 'PS4'),
(20, 'Xbox'),
(21, 'PS4'),
(22, 'Switch'),
(22, 'Xbox'),
(22, 'PS4'),
(23, 'PS4'),
(24, 'PC'),
(25, 'PC'),
(25, 'Xbox'),
(25, 'Switch'),
(26, 'PC'),
(27, 'Xbox'),
(28, 'PS4'),
(28, 'Switch'),
(29, 'Xbox');

-- INTERPRETADO
INSERT INTO public.interpretado(Nombre_personaje, ID_medio, Nombre_actor)
VALUES 
    ('Kylo Ren', 7, 'Adam Driver'),
    ('Achk Med-Beq', 5, 'Ahmed Best'),
    ('C-3PO', 2 ,'Anthony Daniels'),
    ('Ahsoka Tano', 5, 'Ashley Eicksten'),
    ('Leia Organa', 2, 'Carrie Fisher'),
    ('Ulic Qel-Droma', 29,'Charles Dennis'),
    ('Rey', 7,'Daisy Ridley'),
    ('Darth Vader', 1, 'David Charles Prowse'),
    ('Obi-Wan Kenobi', 2, 'Ewan Mcgregor'),
    ('Han Solo', 2, 'Harrison Ford'),
    ('Darth Vader', 2, 'Hayden Christensen'),
    ('Darth Vader', 2, 'James Earl Jones'),
    ('Finn', 10, 'John Boyega'),
    ('Baash', 4, 'John Dimaggio'),
    ('Padmé Amidala', 3, 'Natalie Portman'),
    ('Luke Skywalker', 1, 'Mark Hamill'),
    ('General Grievous', 5, 'Matthew Grievous'),
    ('Chewbacca', 2, 'Peter Mayhew'),
    ('Yoda', 3, 'Richard Oznowicz'),
    ('Ahsoka Tano', 19, 'Rosario Dawson'),
    ('Firmus Piett', 3, 'Kenneth Colley'),
    ('Jango Fett', 5, 'Temuera Morrison'),
    ('Qui-Gon Jinn', 5, 'Liam Neeson'),
    ('Raymus Antilles', 6, 'Rohan Nichol'),
    ('Poe Dameron', 7, 'Oscar Isaac'),
    ('Kendal Ozzel', 1, 'Michael Sheard'),
    ('Enric Pryde', 8, 'Richard E. Grant'),
    ('Hera Syndulla', 19, 'Vanessa Marshall');
	
-- APARECE
INSERT INTO public.aparece(Nombre_personaje, ID_medio, Fecha_estreno)
VALUES 
    ('Kylo Ren', 7,'2015-12-18'),
    ('Kylo Ren', 8,'2019-12-19'),
    ('Kylo Ren', 5,'2002-05-16'),
    ('Ahsoka Tano', 17, '2008-10-03'),
    ('Ahsoka Tano', 11,'2014-10-03'),
    ('Ahsoka Tano', 10,'2019-11-12'),
    ('Leia Organa', 2,'1997-03-26'),
    ('Leia Organa', 1,'1980-05-21'),
    ('Leia Organa', 3,'1983-07-05'),
    ('Leia Organa', 7,'2015-12-18'),
    ('Leia Organa', 8,'2019-12-19'),
    ('Leia Organa', 9,'2008-10-03'),
    ('Leia Organa', 11,'2014-10-03'),
    ('Leia Organa', 12, '2017-10-07');

-- COMBATE
INSERT INTO public.combate(Participante_1, Participante_2, ID_medio, Fecha_combate, Lugar_combate)
VALUES 
    ('Kylo Ren','Darth Vader', 7, '2015-12-18','TIE Avanzado X1'),
    ('Luke Skywalker','Padmé Amidala', 7,'2015-12-18','Ala-X T-65B.'),
    ('Achk Med-Beq','Han Solo', 21, '2002-10-28','Centro de entrenamiento Imperial'),
    ('General Grievous','Finn', 2, '1997-03-26','Gran Mar de Artorias'),
    ('Yoda','Ahsoka Tano', 1,'1980-05-21','Aldea de Ahsoka Tano'),
    ('Chewbacca','Kylo Ren', 19, '2016-06-20','Palsaang'),
    ('Darth Vader','Rey', 4, '1999-06-30','Cementerio de Naves Estelares');

-- AFILIACIÓN
INSERT INTO public.afiliacion(Nombre_Af, Tipo_Af, Nombre_planeta)
VALUES     
    ('Alianza Rebelde', 'Organización', 'Yavin 4'), 	
    ('Imperio Galáctico', 'Gobierno', 'Coruscant'),
    ('Jedi', 'Orden', 'Coruscant'),
    ('Sith', 'Orden', 'Korriban'),
    ('República Galáctica', 'Gobierno', 'Coruscant'),
    ('Nueva República', 'Gobierno', 'Hosnian Prime'),
    ('Primera Orden', 'Régimen autoritario', 'Starkiller Base'),
    ('Resistencia', 'Organización militar', 'D´Qar'),
    ('Clan Mandaloriano', 'Grupo guerrero', 'Mandalore'),
    ('Casa Real de Naboo', 'Monarquía', 'Naboo');

-- NAVE
INSERT INTO public.nave (ID_nave, Nombre_nave, Fabricante, Longitud, Uso, Modelo)
VALUES
    ('1', 'Halcón Milenario', 'Corporación de Ingeniería Corelliana', 34.37, 'Carga y Contrabando', 'Carguero Ligero YT-1300'),
    ('2', 'Caza Estelar Ala-X', 'Incom Corporation', 12.5, 'Caza estelar', 'Ala-X T-65'),
    ('3', 'Caza TIE', 'Sistemas de Flota Sienar', 6.4, 'Caza estelar', 'Caza Estelar Motor de Iones Gemelos / LN'),
    ('4', 'Destructor Estelar Imperial', 'Astilleros de Propulsores Kuat', 1600, 'Combate', 'Destructor Estelar Clase Imperial I'),
    ('5', 'Esclavo I', 'Sistemas de Ingeniería Kuat', 21.5, 'Caza de recompensas', 'Nave de patrulla y ataque clase Firespray-31'),
    ('7', 'AT-AT', 'Astilleros de Propulsores Kuat', 22.5, 'Transporte y combate terrestre', 'Transporte Blindado Todo Terreno'),
    ('8', 'TIE Avanzado X1', 'Sistemas de Flota Sienar', 9.2, 'Caza estelar', 'Motores de Iones Gemelos Avanzado X1 '),
    ('9', 'Caza Estelar Ala-A', 'Sistemas de Ingeniería Kuat', 9.6, 'Caza estelar', 'Interceptor Ala-A RZ-1'),
    ('10', 'Destructor Estelar Ejecutor', 'Astilleros de Propulsores Kuat', 19000, 'Combate', 'Destructores Estelares Clase Executor'),
    ('11', 'Caza Bombardero Ala-Y', 'Manufactura Koensayr', 23.4, 'Caza estelar - bombardero', 'BTL-B'),
    ('12', 'Lanzadera Imperial', 'Sistemas de Flota Sienar', 20, 'Transporte de personal', 'Lanzadera T-4A clase Lambda'),
    ('13', 'Caza Estelar Naboo N-1', 'Cuerpo de Ingeniería de Vehículos Espaciales del Palacio de Theed', 11, 'Caza Estelar', 'Caza estelar N-1'),
    ('14', 'Caza Estelar Ala-B', 'Slayn & Korpil', 16.9, 'Caza pesado de asalto', 'Caza Estelar Ala-B A/SF-01'),
    ('15', 'Destructor Estelar Venator', 'Astilleros de Propulsores Kuat', 1137, 'Combate', 'Destructor Estelar Clase Venator'),
    ('16', 'Corbeta Corelliana', 'Corporación de Ingeniería Corelliana', 150, 'Nave de combate', 'Corbeta Corelliana CR90'),
    ('17', 'Lanzadera Clase Upsilon', 'Sistemas de Flota Sienar-Jaemus', 37.9, 'Transporte de personal', 'Lanzadera Clase Upsilon'),
    ('18', 'Fragata Nebulón-B', 'Astilleros de Propulsores Kuat', 300, 'Nave de combate', 'Fragata de Escolta EF76 Nebulón-B'),
    ('19', 'Caza Estelar T-70 Ala-X', 'Incom-FreiTek', 12.5, 'Caza estelar', 'Ala-X T-70'),
    ('20', 'Destructor Estelar Imperial II', 'Astilleros de Propulsores Kuat', 1600, 'Combate', 'Destructor Estelar Clase Imperial II'),
    ('21', 'Destructor Estelar Resurgente', 'Ingeniería Kuat-Entralla', 2915.81, 'Combate', 'Destructor Estelar Clase Resurgente'),
    ('22', 'Interceptor Ligero', 'Sistemas de Ingeniería Kuat', 8, 'Caza estelar', 'Interceptor Ligero Clase Delta-7 Aethersprite'),
    ('23', 'Carguero Ligero', 'Corporación de Ingeniería Corelliana', 43.9, 'Carguero Ligero', 'Carguero Ligero VCX-100');

-- CIUDAD
INSERT INTO public.ciudad(Nombre_ciudad, Nombre_planeta)
VALUES 
  ('Ciudad Imperial', 'Coruscant'),  
  ('Ciudad CoCo', 'Coruscant'),
  ('Desconocida', 'D´Qar'),
  ('Ciudad Progate', 'Geonosis'),
  ('Colmena Stalgasin', 'Geonosis'),
  ('Tierras Yermas de N´gzi','Geonosis'),
  ('Ciudad República', 'Hosnian Prime'),
  ('Dreshdae', 'Korriban'),
  ('Keldabe', 'Mandalore'), 
  ('Sundari', 'Mandalore'),
  ('Enceri', 'Mandalore'),
  ('Fralideja', 'Mustafar'),
  ('Theed', 'Naboo'),
  ('Ciudad Jan-gwa', 'Naboo'),
  ('Otoh Gunga', 'Naboo'),
  ('Gran Templo','Yavin 4');

-- LUGAR
INSERT INTO public.lugar_interes(nombre_ciudad, lugar)
VALUES 
  ('Ciudad Imperial', 'Distrito Federal'), 
  ('Ciudad Imperial', 'Gran Instalación Médica'), 
  ('Ciudad Imperial', 'Plaza de los Monumentos'),
  ('Ciudad Imperial', 'Distrito Uscru'), 
  ('Ciudad Imperial', 'Distrito del Templo Jedi'),
  ('Ciudad Imperial', 'Distrito Sah´c'),
  ('Ciudad Imperial', 'Los Talleres'), 
  ('Ciudad CoCo', 'Restaurante de Dexter Jettster'),
  ('Desconocida', 'Base de la Resistencia'),
  ('Ciudad Progate', 'Templo Progate'),
  ('Colmena Stalgasin', 'Agujas de la Colmena'),
  ('Colmena Stalgasin', 'Arena Petranaki'),
  ('Tierras Yermas de N´gzi','Valle Nge´u'),
  ('Tierras Yermas de N´gzi','Desierto E´Y-Akh'),
  ('Ciudad República', 'Plaza del Senado'),
  ('Dreshdae', 'Valle de los Señores Oscuros'),
  ('Dreshdae', 'Templo Sith'),
  ('Keldabe', 'Río Kelita'),
  ('Keldabe', 'Refinería Bes´uliik'),
  ('Keldabe', 'Kyrimorut'),
  ('Sundari', 'Palacio Real de Sundari'),
  ('Sundari', 'Prisión de Sundari'),
  ('Sundari', 'Centro Bancario de Mandalore'),
  ('Enceri', 'Academia de Mandalore'),
  ('Fralideja', 'Base Imperial'),
  ('Fralideja', 'Centro Industrial'),
  ('Fralideja', 'Marisma de Corvax'),
  ('Fralideja', 'Llanuras Gahenn'),
  ('Theed', 'Palacio Real'),
  ('Theed', 'Hangar de Theed'),
  ('Theed', 'Espaciopuerto de Theed'),
  ('Ciudad Jan-gwa', 'Plaza de la ciudad Jan-gwa'),
  ('Otoh Gunga', 'Aldeas de Otoh'),
  ('Otoh Gunga', 'Alta Sala de Juntas'),
  ('Gran Templo','Pueblo Massassi');

-- IDIOMA
INSERT INTO public.idioma (Nombre_planeta, Idioma)
VALUES 
('Coruscant','Basic'),
('Coruscant','High Galactic'),
('D´Qar','Galactic Basic Standard'),
('Geonosis','Geonosian'),
('Hosnian Prime','Desconocido'),
('Korriban','Sith'),
('Mandalore','Mandalorian'),
('Mustafar','Mustafarian'),
('Naboo','Gungan Basic'),
('Yavin 4','Massassi'),
('Starkiller Base','Desconocido'),
('Naboo','Galactic Basic Standard'),
('Yavin 4','Basic');

-- AFILIADO
INSERT INTO public.afiliado(Nombre_Af, Nombre_personaje, Fecha_Af)
VALUES     
    ('Primera Orden', 'Kylo Ren', '2000-02-02'),
    ('Jedi', 'Achk Med-Beq', '1950-10-03'),
    ('Alianza Rebelde', 'C-3PO', '1977-12-12'),
    ('Alianza Rebelde', 'Ahsoka Tano', '1990-11-08'),
    ('Alianza Rebelde', 'Leia Organa', '1999-10-19'),
    ('Jedi', 'Ulic Qel-Droma', '1977-12-24'),
    ('Resistencia', 'Rey', '2004-06-02'),
    ('Imperio Galáctico', 'Darth Vader', '2000-02-02'),
    ('Alianza Rebelde', 'Obi-Wan Kenobi', '2006-06-03'),
    ('Alianza Rebelde','Han Solo','1977-10-07'),
    ('Resistencia', 'Finn', '2000-02-02'),
    ('República Galáctica', 'Padmé Amidala', '2000-02-02'),
    ('Alianza Rebelde','Luke Skywalker','2000-02-02'),
    ('República Galáctica','General Grievous','1999-11-09'),
    ('Alianza Rebelde','Chewbacca','2000-12-12'),
    ('Jedi','Yoda','1980-01-03'),
    ('Imperio Galáctico','Firmus Piett','1985-12-01'),
    ('Casa Real de Naboo','Jango Fett','1979-01-20'),
    ('Jedi','Qui-Gon Jinn','1989-09-09'),
    ('Alianza Rebelde', 'Raymus Antilles', '2000-05-02'),
    ('Resistencia','Poe Dameron','2001-06-07'),
    ('Clan Mandaloriano','Kendal Ozzel','1902-10-10'),
    ('Sith','Enric Pryde','2003-03-03'),
    ('Nueva República','Anakin Skywalker','1903-06-09'),
    ('Alianza Rebelde', 'Hera Syndulla', '2010-10-05'),
    ('Jedi', 'Baash', '2014-12-02');

-- TRIPULA
INSERT INTO public.tripula(Nombre_personaje, ID_nave, Tipo_tripulacion)
VALUES 
  ('Han Solo', '1', '1 Piloto - 1 Copiloto - 2 Artilleros'),
  ('Luke Skywalker', '2', '1 piloto - 1 androide'),
  ('Darth Vader', '3', '1 piloto'),
  ('Firmus Piett', '4', '9235 Oficiales - 9700 Soldados de Asalto - 27850 Alistados - 275 Artilleros'),
  ('Jango Fett', '5', '1 piloto - 1 cazarrecompensas'),
  ('Qui-Gon Jinn', '13', '1 piloto - 1 droide astromecánico'),
  ('Raymus Antilles', '16', '165 tripulantes'),
  ('Poe Dameron', '19', '1 piloto - 1 droide astromecánico'),
  ('Kendal Ozzel', '20', '36755 tripulación - 330 artilleros'),
  ('Enric Pryde', '21', '19000 oficiales - 55000 enlistados - 8000 soldados de asalto'),
  ('Anakin Skywalker', '22', '1 piloto - 1 droide astromecánico integrado'),
  ('Hera Syndulla', '23', '1 piloto - 5 pasajeros');

-- DUENO
INSERT INTO public.dueno(Nombre_personaje, ID_nave, Fecha_compra)
VALUES
    ('Ahsoka Tano','22', '1922-09-15'),
    ('Leia Organa','16', '2012-02-18'),
    ('Darth Vader','8', '2010-01-07'),
    ('Han Solo','1', '1902-09-12'),
    ('Darth Vader','4', '2010-05-29'),
    ('Leia Organa','9', '1929-12-02'),
    ('Leia Organa','10', '2020-02-02'),
    ('Luke Skywalker','11', '2002-03-03'),
    ('Luke Skywalker','14', '1995-01-05'),
    ('Kylo Ren','17','1969-09-03'),
    ('Kylo Ren','21','2009-09-03'),
    ('Yoda','2','1999-10-09'),
    ('Chewbacca','3','1978-10-21'),
    ('General Grievous','5','1998-12-25'),
    ('Achk Med-Beq','18','1980-03-20'),
    ('Padmé Amidala','19','2020-02-28'),
    ('Rey','23','2005-05-03'),
    ('Ulic Qel-Droma','20','2003-01-23'),
    ('Ahsoka Tano','15','2004-04-13'),
    ('Achk Med-Beq','13','2000-10-19'),
    ('Rey','12','1998-07-03');

-- CRIATURA
INSERT INTO public.criatura(Nombre_criatura, Idioma, Color_piel, Dieta)
VALUES 
  ('Wookiees', 'Shyriiwook', 'Marrón', 'Omnívoro'),
  ('Hutts', 'Huttese', 'Marrón - Púrpura - Verde', 'Carnívoro'),
  ('Jawas', 'Jawaese', 'Negro', 'Carroñeros'),
  ('Ewoks', 'Ewokese', 'Negro - Marrón - Crema', 'Herbívoro'),
  ('Twi´lek', 'Twi´leki', 'Amplia variedad de colores', 'Omnívoro'),
  ('Dathomiriano', 'Básico', 'Blancas', 'Omnívoro'),
  ('Togruta', 'Togruti', 'Rojo - Blanco - Naranja', 'Carnívoro'),
  ('Trandoshanos', 'Dosh', 'Verde - Amarillo - Marrón', 'Carnívoro'),
  ('Gungans', 'Gunganese', 'Marrón - Naranja - Amarillo', 'Omnívoro'),
  ('Kaminoanos', 'Kaminoano', 'Blanco', 'Herbívoro'),
  ('Mon Calamari', 'Mon Calamarian', 'Marrón - Rosado - Naranja', 'Omnívoro'),
  ('Zabraks', 'Zabraki', 'Naranja - Rojo - Amarillo', 'Carnívoro'),
  ('Tauntauns', 'Sonidos y gruñidos', 'Blanco', 'Herbívoro'),
  ('Shaaks', 'Sonidos y gruñidos', 'Marrón', 'Herbívoro'),
  ('Iktotchi', 'Iktotchis', 'Marrón', 'Carnívoro'),
  ('Kaleesh', 'Kaleeshi', 'Blanco', 'Herbívoro'),
  ('Especie de Yoda', 'Básico', 'Verde', 'Carnívoro');

-- ROBOT
INSERT INTO public.robot(Nombre_robot, Idioma, Creador, Clase)
VALUES 
  ('R2-D2', 'Binario | Pitidos y sonidos electrónicos', 'Industrial Automaton', 'Droides astromecánicos'),
  ('R4-P17', 'Binario | Pitidos y sonidos electrónicos', 'Industrial Automaton', 'Droides astromecánicos'),
  ('T3-M4', 'Binario | Pitidos y sonidos electrónicos', 'Industrial Automaton', 'Droides astromecánicos'),
  ('BB-8', 'Binario | Pitidos y sonidos electrónicos', 'Industrial Automaton', 'Droides astromecánicos'),
  ('K-3PO', 'Básico', 'Cybot Galactica', 'Droides de protocolo'),
  ('U-3PO', 'Básico', 'Cybot Galactica', 'Droides de protocolo'),
  ('TC-14', 'Básico', 'Cybot Galactica', 'Droides de protocolo'),
  ('4-LOM', 'Básico', 'Industrial Automaton', 'Droides de protocolo'),
  ('Droide de combate B1', 'Frases y comandos preprogramados', 'Corporación de Ingeniería Baktoid', 'Droides de combate'),
  ('Superdroide de combate B2', 'Binario | Básico', 'Autómatas de Combate Baktoid', 'Droides de combate'),
  ('Soldado Oscuro', 'Básico', 'Desconocido', 'Droides de combate'),
  ('Droideka', 'No tiene', 'Colicoid Creation Nest', 'Droides de combate'),
  ('MagnaGuardia IG-100', 'Señales y protocolos internos', 'Mecánicas Holowan', 'Droides de combate'),
  ('2-1B', 'Básico', 'Industrial Automaton', 'Droides médicos'),
  ('FX-7', 'Básico', 'Medtech Industries', 'Droides médicos'),
  ('C-3PX', 'Binario | Pitidos y sonidos electrónicos', 'Cybot Galactica', 'Droides de protocolo - Droides asesinos'),
  ('HK-47', 'Binario | Pitidos y sonidos electrónicos', 'Revan y Malak', 'Droides asesinos - Droides de espionaje'),
  ('IG-88', 'Binario | Pitidos y sonidos electrónicos', 'Holowan Laboratories', 'Droides asesinos'),
  ('Droide serie DUM', 'Binario | Pitidos y sonidos electrónicos', 'Serv-O-Droide, Inc.', 'Droides de reparación');
