import random
perfiles = 1432
peliculas = 1577
series = 303

for i in range(random.randint(13123,22312)):
  perfilID = random.randint(1,perfiles)
  if random.randint(1,2)==1:
    contenidoID = random.randint(1,peliculas)
    tipoContenido="Pelicula"
  else:
    contenidoID = random.randint(1,series)
    tipoContenido="Serie"
  segundos = random.randint(1,1234)
  veces = random.randint(0,7)
  print("INSERT INTO perfilContenido VALUES("+str(perfilID)+","+str(contenidoID)+",'"+tipoContenido+"',"+str(segundos)+","+str(veces)+");")