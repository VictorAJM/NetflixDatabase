CREATE TABLE [ActorDirector](
  [actorDirectorID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 
  [nombrePila] VARCHAR, 
  [apellido] VARCHAR, 
  [edad] INTEGER, 
  [tipoPersona] VARCHAR, 
  [ciudad] VARCHAR, 
  [pais] VARCHAR);

CREATE TABLE [ActorDirectorParticipa](
  [actorDirectorID] INTEGER NOT NULL REFERENCES [ActorDirector]([actorDirectorID]), 
  [contenidoID] INTEGER, 
  [tipoContenido] VARCHAR, 
  [protagonista] INTEGER NOT NULL, 
  [director] INTEGER NOT NULL);

CREATE TABLE [Serie](
  [serieID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 
  [titulo] VARCHAR, 
  [Temporadas] INTEGER, 
  [lanzamiento] DATE, 
  [clasificacion] VARCHAR, 
  [calificacionGeneral] FLOAT, 
  [sinopsis] VARCHAR);

CREATE TABLE [Episodio](
  [episodioID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 
  [serieID] INTEGER REFERENCES [Serie]([serieID]), 
  [nombre] VARCHAR, 
  [temporada] INTEGER, 
  [duracionMin] INTEGER, 
  [calificacion] FLOAT, 
  [reproducciones] INTEGER);

CREATE TABLE [genero](
  [generoID] INTEGER PRIMARY KEY, 
  [contenidoID] INTEGER, 
  [tipoContenido] VARCHAR, 
  [genero] VARCHAR);

CREATE TABLE [idioma](
  [idiomaID] INTEGER PRIMARY KEY AUTOINCREMENT, 
  [contenidoID] INTEGER, 
  [tipoContenido] VARCHAR, 
  [idioma] VARCHAR);

CREATE TABLE [Pelicula](
  [peliculaID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 
  [titulo] VARCHAR, 
  [duracionMin] INTEGER, 
  [lanzamiento] DATE, 
  [clasificacion] VARCHAR, 
  [calificacion] FLOAT, 
  [sinopsis] VARCHAR, 
  [reproducciones] INTEGER);

CREATE TABLE [Usuario](
  [usuarioID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 
  [email] VARCHAR NOT NULL, 
  [nombrePila] VARCHAR, 
  [apellido] VARCHAR, 
  [calle] VARCHAR, 
  [numeroCasa] INTEGER, 
  [ciudad] VARCHAR, 
  [pais] VARCHAR, 
  [suscripcionTipo] VARCHAR, 
  [suscripcionCosto] FLOAT);

CREATE TABLE [Perfil](
  [perfilID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 
  [usuarioID] INTEGER NOT NULL REFERENCES [Usuario]([usuarioID]), 
  [nombrePerfil] VARCHAR NOT NULL, 
  [edadPerfil] INTEGER NOT NULL);

CREATE TABLE [PerfilContenido](
  [perfilID] INTEGER, 
  [contenidoID] INTEGER, 
  [tipoContenido] VARCHAR, 
  [visualizacionMin] INTEGER, 
  [vecesVisto] INTEGER);

CREATE TABLE [restricciones](
  [restriccionID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
  [contenidoID] INTEGER NOT NULL, 
  [tipoContenido] VARCHAR NOT NULL, 
  [restriccion] VARCHAR);

CREATE TABLE [subtitulos](
  [subtitulosID] INTEGER PRIMARY KEY AUTOINCREMENT, 
  [contenidoID] INTEGER, 
  [tipoContenido] VARCHAR, 
  [tamanoLetra] INTEGER, 
  [colorLetra] VARCHAR, 
  [transparencia] INTEGER, 
  [subtitulos] VARCHAR);

CREATE TABLE [tienePremio](
  [premioID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 
  [actorDirectorID] INTEGER REFERENCES [ActorDirector]([actorDirectorID]), 
  [premio] VARCHAR, 
  [fecha] INTEGER);

CREATE TABLE [Transaccion](
  [transaccionID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 
  [usuarioID] INTEGER NOT NULL REFERENCES [Usuario]([usuarioID]), 
  [monto] FLOAT, 
  [fecha] DATETIME, 
  [banco] VARCHAR, 
  [tipoTarjeta] VARCHAR, 
  [numTarjeta] LARGEINT);

CREATE VIEW [VW_Catalogo_Infantil_Peliculas]
AS
SELECT 
       [titulo], 
       [duracionMin] AS [duracion], 
       [calificacion]
FROM   [PELICULA]
WHERE  [clasificacion] = "AA" OR [clasificacion] = "A";

CREATE VIEW [VW_Catalogo_Infantil_Series]
AS
SELECT 
       [titulo], 
       [temporadas], 
       [calificacionGeneral] AS [Calificacion]
FROM   [Serie]
WHERE  [clasificacion] = "AA" OR [clasificacion] = "A";

CREATE VIEW [VW_ganancia_por_banco]
AS
SELECT 
       [banco], 
       SUM ([monto]) AS [ganancia]
FROM   [Transaccion]
GROUP  BY [banco]
ORDER  BY SUM ([monto]) desc;

CREATE VIEW [VW_informacion_membresias]
AS
SELECT 
       [suscripcionTipo] AS [TipoDeSuscripcion], 
       COUNT (*) AS [cantidad], 
       ROUND (COUNT (*) * 100.0 / (SELECT COUNT (*)
       FROM   [usuario]), 2) AS [porcentajeDeMembresias]
FROM   [usuario]
GROUP  BY [suscripcionTipo]
ORDER  BY [cantidad] DESC;

CREATE VIEW [VW_Mejores_Peliculas]
AS
SELECT *
FROM   [Pelicula]
ORDER  BY [calificacion] DESC
limit 15;

CREATE VIEW [VW_Mejores_Series]
AS
SELECT *
FROM   [Serie]
ORDER  BY [calificacionGeneral] DESC
limit 15;

