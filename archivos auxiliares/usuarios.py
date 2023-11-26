from random import randrange
import datetime
import random
from datetime import timedelta
from datetime import datetime
import string
from faker import Faker
def hasCosa(r):
  return "'" in r

with open('nombres.txt','r') as file:
  nombres = file.readlines()

with open('apellidos.txt','r') as file:
  apellidos = file.readlines()
for i in range(len(nombres)):
  nombres[i] = nombres[i][:-1]
for i in range(len(apellidos)):
  apellidos[i] = apellidos[i][:-1]

def random_char(char_num):
  return ''.join(random.choice(string.ascii_letters) for _ in range(char_num))


def random_date(start, end):
  delta = end - start
  int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
  random_second = randrange(int_delta)
  return start + timedelta(seconds=random_second)
d1 = datetime(12, 10, 30, 11, 23, 45)
d2 = datetime(12, 10, 30, 11, 23, 45)
d1 = d1.strptime('1/1/2018 1:30 PM', '%m/%d/%Y %I:%M %p')
d2 = d2.strptime('11/26/2023 11:59 PM', '%m/%d/%Y %I:%M %p')
fake = Faker("es_MX")

usuarios = []
transacciones = []
perfiles = []
cntT = cntP = 0
paises = ["Mexico","Guatemala","Chile","Argentina","Brazil","Republica Dominicana","Uruguay","Peru","Rumania","Israel","Palestina","Korea","Japon","Ucrania","Rusia","El Salvador"]
numUsuarios = random.randint(500,600)
numPerfiles = 0
for i in range(numUsuarios):
  usuario = []
  usuario.append(i+1)
  usuario.append(fake.email())
  suscripcion = []
  k = random.randint(0,2)
  if k==0:
    suscripcion.append(["Basica",100.0])
  elif k==1:
    suscripcion.append(["Normal",250.0])
  else:
    suscripcion.append(["Premium",350.0])
  usuario.append(suscripcion)
  usuario.append(nombres[random.randint(0,len(nombres)-1)])
  usuario.append(apellidos[random.randint(0,len(apellidos)-1)]) 
  r = fake.street_name()
  while hasCosa(r):
    r = fake.street_name()
  usuario.append(r)
  usuario.append(fake.building_number()) 
  usuario.append(fake.state())
  usuario.append(random.choice(paises))
  bancos = ["Santander","Bancomer","BBVA","Banco del Bienestar", "HSBC"]
  tarjetas = ["Debito","Credito"]
  fecha = random_date(d1,d2)
  cntT = cntT+1
  transacciones.append([cntT,i+1,suscripcion[0][1],fecha,random.choice(bancos),random.choice(tarjetas)])
  for j in range(random.randint(0,40)):
    transaccion = []
    cntT = cntT+1
    transaccion.append(cntT)
    transaccion.append(i+1)
    tt = random.randint(0,2)
    if tt==0:
      transaccion.append(100.0)
    elif tt==1: 
      transaccion.append(250.0)
    else:
      transaccion.append(350.0)
    fecha = fecha-timedelta(days=30)
    transaccion.append(fecha)
    transaccion.append(random.choice(bancos))
    transaccion.append(random.choice(tarjetas))
    transacciones.append(transaccion)
  for j in range(random.randint(1,4)):
    cntP = cntP +1 
    perfil = []
    perfil.append(cntP)
    perfil.append(i+1)
    perfil.append(fake.first_name())
    perfil.append(random.randint(5,70))
    perfiles.append(perfil)
  usuarios.append(usuario)



for i in usuarios:
  #indice,email,nombre,apellido,calle,numeroCasa,ciudad,pais,tipo,costo
  datosUsuario = dict(ind=str(i[0]),nom="'"+i[3]+"'",ape="'"+i[4]+"'",email="'"+i[1]+"'",calle="'"+i[5]+"'",num=i[6],ciudad="'"+i[7]+"'",pais="'"+i[8]+"'",tipo="'"+str(i[2][0][0])+"'",costo=i[2][0][1])
  # query
  print("INSERT INTO USUARIO VALUES ({ind},{email},{nom},{ape},{calle},{num},{ciudad},{pais},{tipo},{costo});".format(**datosUsuario))
for _ in transacciones:
  datosTransacciones = dict(ind=str(_[0]),indUser=str(_[1]),monto=_[2],fecha=_[3],banco="'"+_[4]+"'",tarjeta="'"+_[5]+"'",numTarjeta=random.randint(10**15,10**16-1))
  #query
  print("INSERT INTO Transaccion VALUES ({ind},{indUser},{monto},'{fecha}',{banco},{tarjeta},{numTarjeta});".format(**datosTransacciones))
for _ in perfiles:
  numPerfiles = numPerfiles +1 
  datosPerfiles = dict(ind=str(_[0]),indUser=str(_[1]),nom="'"+_[2]+"'",edad=_[3])
  print("INSERT INTO Perfil VALUES ({ind},{indUser},{nom},{edad});".format(**datosPerfiles))
