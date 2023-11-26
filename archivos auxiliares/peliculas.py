from random import randrange
import datetime
import random
from datetime import timedelta
from datetime import datetime
import string
from faker import Faker
def random_char(char_num):
  return ''.join(random.choice(string.ascii_letters) for _ in range(char_num))

def hasCosa(r):
  return "'" in r
def random_date(start, end):
  delta = end - start
  int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
  random_second = randrange(int_delta)
  return start + timedelta(seconds=random_second)
d1 = datetime(12, 10, 30, 11, 23, 45)
d2 = datetime(12, 10, 30, 11, 23, 45)
d1 = d1.strptime('1/1/1960 1:30 PM', '%m/%d/%Y %I:%M %p')
d2 = d2.strptime('11/26/2022 11:59 PM', '%m/%d/%Y %I:%M %p')
fake = Faker("es_MX")
clasificaciones = ["AA","A","B","B15","C"]
generos_tipo = ["Accion","Aventura","Ciencia Ficcion","Comedia","Drama","Fantasia","Musical","Terror"]
idiomas_tipo = ["Ingles","Chino","Español","Arabe","Frances","Frances","Ruso","Portugues"]
# peliculaID,'titulo',duracionMin,lanzamiento,clasificacion,calificacion,'sinopsis',reproducciones , GENEROS, SUBSITUTLOS, IDIOMAS, PERSONAJES
# serieID,'titulo',temporadas,lanzamiento,clasificacion,calificacionGeneral,sinopsis, GENEROS, SUBTITULOS,IDIOMAS,PERSONAJES
# episodioID, serieID, nombre,temporada,duracionMin, calificacion, reproduccion
paises = ["Mexico","Guatemala","Chile","Argentina","Brazil","Republica Dominicana","Uruguay","Peru","Rumania","Israel","Palestina","Korea","Japon","Ucrania","Rusia","El Salvador"]
indicesActores = [i for i in range(31,101)]
cnt = 0
cntE = 0
cntI = 0
cntS = 0
cntG = 0
cntR = 0
cntA = 0
for i in range(random.randint(1500,1600)):
  cnt = cnt+1
  director = random.randint(1,30)
  numActores = random.randint(2,8)
  actores = random.sample(indicesActores,numActores)
  titulo = fake.text(25) # can I improve it ? 
  while hasCosa(titulo):
    titulo = fake.text(250)
  duracionMin = random.randint(90,180)
  clasificacion = random.choice(clasificaciones)
  sinopsis = fake.text(250)
  while hasCosa(sinopsis):
    sinopsis = fake.text(250)
  reproducciones = 0
  genero = random.sample(generos_tipo,random.randint(1,4))
  idioma = random.sample(idiomas_tipo,random.randint(1,6))
  subtitulos = random.sample(idiomas_tipo,random.randint(1,6))
  restricciones = []
  for _ in range(random.randint(0,2)):
    gg = random.choice(paises)
    restricciones.append(gg)
  calificacion = random.random()*10.0
  calificacion = round(calificacion,1)
  data = dict(
    ind=str(cnt),
    titulo="'"+str(titulo)+"'",
    duracionMin=str(duracionMin),
    lanzamiento = "'"+str(random_date(d1,d2))+"'",
    calificacion=calificacion,
    clasificacion="'"+clasificacion+"'",
    sinopsis="'"+str(sinopsis)+"'",
    reproduccion=0
  )
  print("INSERT INTO pelicula VALUES({ind},{titulo},{duracionMin},{lanzamiento},{clasificacion},{calificacion},{sinopsis},{reproduccion});".format(**data))
  for _ in subtitulos:
    cntS = cntS+1
    print("INSERT INTO subtitulos VALUES("+str(cntS)+","+str(cnt)+",'Pelicula',"+str(random.randint(12,16))+","+ random.choice(["'Negro'","'Rojo'","'Blanco'","'Azul'"])+","+str(random.randint(0,90))+",'"+str(_)+"');")
  for _ in genero:
    cntG = cntG+1
    print("INSERT INTO genero VALUES("+str(cntG)+","+str(cnt)+",'Pelicula','"+str(_)+"');")
  for _ in idioma:
    cntI = cntI+1
    print("INSERT INTO idioma VALUES("+str(cntI)+","+str(cnt)+",'Pelicula','"+str(_)+"');")
  for _ in restricciones:
    cntR = cntR+1
    print("INSERT INTO restricciones VALUES("+str(cntR)+","+str(cnt)+",'Pelicula','"+str(_)+"');")
  cntA = cntA+1
  print("INSERT INTO actordirectorparticipa VALUES("+str(director)+","+str(cnt)+",'Pelicula',0,1);")
  cntA = cntA+1
  print("INSERT INTO actordirectorparticipa VALUES("+str(actores[0])+","+str(cnt)+",'Pelicula',1,0);")
  for ia in range(1,len(actores)):
    cntA = cntA+1
    print("INSERT INTO actordirectorparticipa VALUES("+str(actores[ia])+","+str(cnt)+",'Pelicula',0,0);")
cnt=0

for i in range(random.randint(300,310)):
  cnt = cnt+1
  director = random.randint(1,30)
  numActores = random.randint(4,12)
  actores = random.sample(indicesActores,numActores)
  titulo = fake.text(25) # can I improve it ? 
  while hasCosa(titulo):
    titulo = fake.text(250)
  temporadas = random.randint(1,4)
  clasificacion = random.choice(clasificaciones)
  sinopsis = fake.text(250)
  while hasCosa(sinopsis):
    sinopsis = fake.text(250)
  genero = random.sample(generos_tipo,random.randint(1,6))
  idioma = random.sample(idiomas_tipo,random.randint(1,6))
  subtitulos = random.sample(idiomas_tipo,random.randint(1,6))
  restricciones = []
  for _ in range(random.randint(0,2)):
    gg = random.choice(paises)
    restricciones.append(gg)
  calificacion = random.random()*10.0
  calificacion = round(calificacion,1)
  data = dict(
    ind=str(cnt),
    titulo="'"+str(titulo)+"'",
    temporadas=str(temporadas),
    lanzamiento = "'"+str(random_date(d1,d2))+"'",
    calificacion=0.0,
    clasificacion="'"+clasificacion+"'",
    sinopsis="'"+str(sinopsis)+"'",
  )
  print("INSERT INTO Serie VALUES({ind},{titulo},{temporadas},{lanzamiento},{clasificacion},{calificacion},{sinopsis});".format(**data))
  for _ in subtitulos:
    cntS = cntS+1
    print("INSERT INTO subtitulos VALUES("+str(cntS)+","+str(cnt)+",'Serie',"+str(random.randint(12,16))+","+ random.choice(["'Negro'","'Rojo'","'Blanco'","'Azul'"])+","+str(random.randint(0,90))+",'"+str(_)+"');")
  for _ in genero:
    cntG = cntG+1
    print("INSERT INTO genero VALUES("+str(cntG)+","+str(cnt)+",'Serie','"+str(_)+"');")
  for _ in idioma:
    cntI = cntI+1
    print("INSERT INTO idioma VALUES("+str(cntI)+","+str(cnt)+",'Serie','"+str(_)+"');")
  for _ in restricciones:
    cntR = cntR+1
    print("INSERT INTO restricciones VALUES("+str(cntR)+","+str(cnt)+",'Serie','"+str(_)+"');")
  cntA = cntA+1
  print("INSERT INTO actordirectorparticipa VALUES("+str(director)+","+str(cnt)+",'Serie',0,1);")
  cntA = cntA+1
  print("INSERT INTO actordirectorparticipa VALUES("+str(actores[0])+","+str(cnt)+",'Serie',1,0);")
  for ia in range(1,len(actores)):
    cntA = cntA+1
    print("INSERT INTO actordirectorparticipa VALUES("+str(actores[ia])+","+str(cnt)+",'Serie',0,0);")
  for k in range(1,temporadas+1):
    num = random.randint(4,6)
    for l in range(num):
      cntE = cntE+1
      txt = fake.text(20)
      while hasCosa(txt):
        txt = fake.text(20)
      print("INSERT INTO episodio VALUES("+str(cntE)+","+str(cnt)+",'"+str(txt)+"',"+ str(k)+", "+str(random.randint(25,50))+","+str(round(10.0*random.random(),1))+",0);")