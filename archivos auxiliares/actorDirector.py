from random import randrange
import datetime
import random
from datetime import timedelta
from datetime import datetime
import string
from faker import Faker
fake = Faker(['en_US','es_MX'])
def random_char(char_num):
  return ''.join(random.choice(string.ascii_letters) for _ in range(char_num))

def hasCosa(r):
  return "'" in r
def random_date(start, end):
  delta = end - start
  int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
  random_second = randrange(int_delta)
  return start + timedelta(seconds=random_second)
paises = ["Mexico","Guatemala","Chile","Argentina","Brazil","Republica Dominicana","Uruguay","Peru","Rumania","Israel","Palestina","Korea","Japon","Ucrania","Rusia","El Salvador"]
with open('nombres.txt','r') as file:
  nombres = file.readlines()

with open('apellidos.txt','r') as file:
  apellidos = file.readlines()
for i in range(len(nombres)):
  nombres[i] = nombres[i][:-1]
for i in range(len(apellidos)):
  apellidos[i] = apellidos[i][:-1]
personas = []
for i in range(30):
  persona = []
  persona.append(i+1)
  persona.append(nombres[random.randint(0,len(nombres)-1)])
  persona.append(apellidos[random.randint(0,len(apellidos)-1)])
  edad = random.randint(41,80)
  persona.append(edad)
  persona.append("Director")
  premios = []
  for j in range(random.randint(0,5)):
    # premio entre oscar, globo de oro, bafta, emmy entre 2044-edad y 2023 
    k = random.randint(0,3)
    year = random.randint(2040-edad,2023)
    if k==0:
      premios.append(["Oscar",year])
    elif k==1:
      premios.append(["Globo de Oro",year])
    elif k==2:
      premios.append(["BAFTA",year])
    else:
      premios.append(["Emmy",year])
  persona.append(premios)
  personas.append(persona)
for i in range(70):
  persona = []
  persona.append(i+31)
  persona.append(nombres[random.randint(0,len(nombres)-1)])
  persona.append(apellidos[random.randint(0,len(apellidos)-1)])
  edad = random.randint(21,80)
  persona.append(edad)
  persona.append("Actor")
  premios = []
  for j in range(random.randint(0,5)):
    # premio entre oscar, globo de oro, bafta, emmy entre 2044-edad y 2023 
    k = random.randint(0,3)
    year = random.randint(2040-edad,2023)
    if k==0:
      premios.append(["Oscar",year])
    elif k==1:
      premios.append(["Globo de Oro",year])
    elif k==2:
      premios.append(["BAFTA",year])
    else:
      premios.append(["Emmy",year])
  persona.append(premios)
  personas.append(persona)
k = 0
for i in personas:
  datos = dict(ind=str(i[0]),nom="'"+i[1]+"'",ape="'"+i[2]+"'",edad=str(i[3]),tipo="'"+i[4]+"'",ciudad="'"+str(fake.state())+"'",pais="'"+random.choice(paises)+"'")
  print("INSERT INTO ActorDirector VALUES({ind},{nom},{ape},{edad},{tipo},{ciudad},{pais});".format(**datos))
  for j in i[5]:
    k = k+1
    data = dict(ind=str(k),refID=str(i[0]),tipo="'"+j[0]+"'",fecha=str(j[1]))
    print("INSERT INTO tienePremio  VALUES({ind},{refID},{tipo},{fecha});".format(**data))
 