/* Actualizar las reproducciones de  las peliculas */ 
UPDATE pelicula as pp
SET reproducciones=Tabla.gg FROM(
SELECT p.peliculaID,pc.visualizacionMin/p.duracionMin as gg FROM Pelicula p
inner join PerfilContenido pc on pc.contenidoID=p.peliculaID and pc.tipoContenido='Pelicula' ) as Tabla where pp.peliculaID = Tabla.peliculaID



UPDATE Episodio as EF
set reproducciones = HH.toadd From
(
 SELECT E.episodioID as eid,toadd from Episodio E
 inner join (
       SELECT G.sid as aidi, pc.visualizacionMin/duracionMinutos as toAdd From perfilcontenido pc
       inner join(
             SELECT S.serieID as sID,sum(E.duracionMin)duracionMinutos
             From SERIE S
             INNER join episodio E on E.serieID = S.serieID
             group by s.serieID
       )G on pc.contenidoID = G.sid and pc.tipoContenido='Serie'
       
 ) as FF on FF.aidi = E.serieID
) as HH
where HH.eid = EF.episodioID


/* actualiza los subtitulos , tamaño de letra minimo 14, transparencia maximo 20 */
UPDATE subtitulos
SET tamanoLetra = 14 where tamanoLetra<14;
UPDATE subtitulos
SET transparencia = 20 where transparencia>20;


/* Por black friday, a todas las personas con suscripcion Basica se les subio a Normal y que tienen al menos un año de suscripcion (12 transferencias) */ 
UPDATE Usuario
SET suscripcionTipo='Normal'
where usuarioID in (
      SELECT T.usuarioID 
      from transaccion T
      inner join(SELECT usuarioID
      from Usuario U
      where U.suscripcionTipo='Basica'
      ) V on T.usuarioID = V.usuarioID
      group by T.usuarioID having
      count(*) >= 12
)


/* para cada pelicula con calificacion menor a 5, agregarle 2 */
UPDATE Pelicula
SET calificacion=calificacion+2.0 where calificacion<5.0


/* para cada episodio con calificacion menor a 7, agregarle 3 */
UPDATE Episodio
SET calificacion=calificacion+3.0 where calificacion<7.0

/* cada serie tiene la calificacion del promedio de sus capitulos */
UPDATE SERIE as S
SET CALIFICACIONGENERAL=ROUND((SELECT AVG(E.calificacion) FROM Episodio E where E.serieID=S.serieID) ,1)


/* reemplazar AA por A en peliculas */ 
UPDATE PELICULA
SET CLASIFICACION='A' where CLASIFICACION='AA'


/* reemplazar AA por A en series */ 
UPDATE Serie
SET CLASIFICACION='A' where CLASIFICACION='AA'


/* bajar el costo de membresias de 350 a 320 en las premium, apartir del siguiente pago 
 transaccion no cambia, ya que son montos que ya se recibieron */ 
UPDATE USUARIO
SET suscripcionCosto=320 where suscripcionTipo='Premium' 


/* cambiar español por espanol en idioma */ 
UPDATE idioma
SET idioma='Espanol' where idioma='Español'

/* cambiar español por espanol en subtitulos */ 
UPDATE subtitulos
SET subtitulos='Espanol' where subtitulos='Español'

/* En transacciones, cambiar bancomer por BBVA */
UPDATE TRANSACCION
SET banco='BBVA' where banco = 'Bancomer'

/* restricciones,ActorDirector y Usuario, cambiar Korea por Corea del Sur y tambien cambiar brazil por brasil*/
UPDATE RESTRICCIONES
SET restriccion='Brasil' where restriccion='Brazil';
UPDATE RESTRICCIONES
SET restriccion='Corea del Sur' where restriccion='Korea';

UPDATE ActorDirector
SET pais='Brasil' where pais='Brazil';
UPDATE ActorDirector
SET pais='Corea del Sur' where pais='Korea';

UPDATE Usuario
SET pais='Brasil' where pais='Brazil';
UPDATE Usuario
SET pais='Corea del Sur' where pais='Korea';


/* Perfil, edades menores a 8 ponerlas como 8 */
UPDATE PERFIL
SET edadPerfil=8 where edadPerfil<8



/*Para cada serie, muestra la cantidad de episodios totales que tiene y su duracion total*/
SELECT S.SERIEID, S.TITULO Titulo_Serie, COUNT(*) Episodios, SUM(E.duracionMin) Duracion_Total_min
FROM SERIE S INNER JOIN EPISODIO E ON E.serieID = S.serieID
group by S.serieID


/*Para cada actor o director, mostrar la cantidad de premios que tiene*/
SELECT ad.actorDirectorID, (ad.nombrePila || ' ' || ad.apellido) nombre, count(tp.premioID) Premios
FROM ActorDirector ad
left join tienePremio tp on tp.actorDirectorID = ad.actorDirectorID
group by ad.actorDirectorID
order by Premios desc


/*Muestra las peliculas y Series clasificacion C*/
SELECT p.titulo, 'Pelicula' Tipo from pelicula p
where p.clasificacion ="C"
UNION ALL
SELECT s.titulo,'Serie' from serie s
where s.clasificacion="C"



/*Mostrar las películas por orden descendente de calificacion*/
SELECT titulo, calificacion
from pelicula
order by calificacion desc


/*Ordenar los paises de acuerdo a cuantas restricciones tienen en peliculas y series, en orden descendente*/
SELECT restriccion Pais, count(*) cantidad_de_restricciones
FROM restricciones
group by restriccion
order by cantidad_de_restricciones desc


/*Mostrar las 10 pelicula de fantasia mejor calificadas*/
SELECT P.titulo Titulo_Pelicula, P.calificacion
FROM Pelicula P
WHERE P.peliculaID IN (
    /*IDs de las peliculas de genero fantasia*/
    SELECT contenidoID
    FROM genero
    where tipoContenido="Pelicula" and genero="Fantasia")
ORDER BY P.calificacion desc
limit 10


/*Mostrar cuanto ha gastado cada usuario en total*/
Select (u.nombrePila || ' ' || u.apellido) nombre_Usuario, SUM(t.monto) gastoTotal
FROM transaccion t
left join Usuario u ON u.usuarioID = t.usuarioID
group by t.usuarioID



/*Mostrar cuantas veces ha sido vista cada pelicula, en orden descendente*/
SELECT peliculaID,titulo,
       (
              Select SUM(PC.vecesVisto)
              from perfilContenido PC
              where tipoContenido='Pelicula' and PC.contenidoID = pelicula.peliculaID
              group by PC.contenidoID
       ) numero_de_vistas
from pelicula
order by numero_de_vistas desc


/*Mostrar numero de reproducciones de cada serie*/
Select serieID, nombre, SUM(reproducciones) reproducciones
from episodio
group by serieID


/*Mostrar por perfil, la pelicula más vista, */

SELECT pc.perfilId, p.NombrePerfil,
       (SELECT titulo
        FROM PELICULA
        INNER JOIN PerfilContenido ON PELICULA.peliculaID = pc.ContenidoID    
       )Pelicula_mas_vista
      ,pc.VecesVisto
from PerfilContenido pc
INNER JOIN (
      SELECT perfilID, Max(VecesVisto) MaxVecesVisto
      From PerfilContenido
      Where tipoContenido="Pelicula"
      Group By PerfilId
)AS Maximos ON pc.PerfilId = Maximos.PerfilId AND pc.VecesVisto = Maximos.MaxVecesVisto
INNER JOIN Perfil p ON pc.PerfilId = p.PerfilId
ORDER BY Maximos.PerfilId asc


/*Mostrar por perfil, la series más vista, */

SELECT pc.perfilId, p.NombrePerfil,
       (SELECT titulo
        FROM Serie
        INNER JOIN PerfilContenido ON Serie.serieID = pc.ContenidoID    
       )Serie_mas_vista, pc.contenidoID
      ,pc.VecesVisto
from PerfilContenido pc
INNER JOIN (
      SELECT perfilID, Max(VecesVisto) MaxVecesVisto
      From PerfilContenido
      Where tipoContenido="Serie"
      Group By PerfilId
)AS Maximos ON pc.PerfilId = Maximos.PerfilId AND pc.VecesVisto = Maximos.MaxVecesVisto
INNER JOIN Perfil p ON pc.PerfilId = p.PerfilId
ORDER BY Maximos.PerfilId asc




/*Mostrar peliculas y series con un solo genero y cual es ese genero*/
SELECT P.peliculaID ID, G.tipoContenido, G.genero
From Pelicula p, Serie s
inner join (
           SELECT contenidoID, tipoContenido, genero
           From Genero
           group by CAST(contenidoID as VARCHAR) || tipoContenido
           having count(*) = 1
      ) G
on (G.contenidoID = p.peliculaID and G.tipoContenido='Pelicula' and S.serieID=p.peliculaID)
or (G.contenidoID = s.serieID and G.tipoContenido ='Serie' and S.serieID=p.peliculaID)



/* Mostrar titulo de peliculas y series con un solo genero y cual es el genero */ 
SELECT pp.titulo,H.cont,H.generoT as genero from Pelicula pp
inner join 
(SELECT p.peliculaID as ID,G.tipoContenido as cont,G.genero as generoT FROM Pelicula p,Serie s 
inner join (
SELECT contenidoID,tipoContenido,genero FROM Genero
group by CAST(contenidoID as VARCHAR) || tipoContenido having count(*)=1) as G
on (G.contenidoID=p.peliculaID and G.tipoContenido='Pelicula' and S.serieID=p.peliculaID) or (G.contenidoID=s.serieID and G.tipoContenido='Serie' and S.serieID=p.peliculaID )) as H
on pp.peliculaID = H.ID and H.cont='Pelicula'
union All
SELECT ss.titulo,H.cont,H.generoT  as genero from Serie ss
inner join 
(SELECT p.peliculaID as ID,G.tipoContenido as cont,G.genero as GeneroT FROM Pelicula p,Serie s 
inner join (
SELECT contenidoID,tipoContenido,genero FROM Genero
group by CAST(contenidoID as VARCHAR) || tipoContenido having count(*)=1) as G
on (G.contenidoID=p.peliculaID and G.tipoContenido='Pelicula' and S.serieID=p.peliculaID) or (G.contenidoID=s.serieID and G.tipoContenido='Serie' and S.serieID=p.peliculaID )) as H
on ss.serieID = H.ID and H.cont='Serie'


/* Muestra todo el contenido tal que tenga al menos dos idiomas que no tenga subtitulos en ese idioma (puede haber subtitulos sin idioma pero no importan) */
SELECT I.contenidoID,I.tipoContenido FROM IDIOMA I
left join Subtitulos S
on I.contenidoID=S.contenidoID and I.tipoContenido=S.tipoContenido and I.idioma=S.subtitulos
group by CAST(i.contenidoID as VARCHAR) || i.tipoContenido having count(*)>=2
order by I.contenidoID asc



/* Para cada perfil, muestra la cantidad de peliculas y series que puede ver, considerando restricciones de pais */

SELECT J.perfilID, PIUMPIUM.total-count(*) as contenidoDisponibleEnElPais FROM (
SELECT pe.peliculaID as ID,pe.clasificacion,'Pelicula' as Tipo from Pelicula pe
union all
SELECT se.serieID,se.clasificacion,'Serie' from Serie se ) as H
cross join (SELECT p.perfilID,R.contenidoID,R.tipoContenido FROM PERFIL p
inner join Usuario U
on U.usuarioID=p.usuarioID
cross join restricciones R
on R.restriccion=U.pais) as J,(SELECT COUNT(DISTINCT peliculaID)+COUNT(distinct serieID) as total from pelicula,serie ) as PIUMPIUM
on h.ID=J.contenidoID and H.tipo=J.tipoContenido
group by J.perfilID
order by J.perfilID asc



