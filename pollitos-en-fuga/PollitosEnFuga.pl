% animal(Nombre, Especie)
% gallina(Nombre, Peso, HuevosPorSemana) -> Se puede utilizar como Functor
% gallo(Nombre, Profesion)


gallina(ginger, 10, 5).
gallina(babs, 15, 2).
gallina(mac, 8, 7).
gallina(bunty, 23, 6).
gallina(turuleca, 15, 1).

gallo(rocky, animalDeCirco).
gallo(fowler, piloto).
gallo(oro, arrocero).

rata(nick).
rata(fetcher).

% granja(NombreDeGranja, Animal)
granja(delSol, turuleca).
granja(delSol, oro).
granja(delSol, nick).
granja(delSol, fetcher).

granja(tweedys, ginger).
granja(tweedys, babs).
granja(tweedys, bunty).
granja(tweedys, mac).
granja(tweedys, fowler).


% Punto 2) puedeCederle/2
puedeCederle(GallinaTrabajadora, GallinaHaragana):-
  gallina(GallinaTrabajadora, _, 7),
  gallina(GallinaHaragana, _, PocosHuevos),
  PocosHuevos < 3.


% Puntos 3) animalLibre/1
animalLibre(Animal):-
  animal(Animal),
  not(granja(_, Animal)).

animal(Animal):-
  rata(Animal).

animal(Animal):-
  gallo(Animal, _).

animal(Animal):-
  gallina(Animal, _, _).


% Punto 4) valoracionDeGranja/2
% Necesito encontrar todas las valoraciones, y luego sumarlas
valoracionDeGranja(Granja, ValoracionGranja):-
  granja(Granja, _),
  findall(ValoracionAnimal, valoracionDeQuienesVivenEn(Granja, ValoracionAnimal), ValoracionesAnimales),
  sumlist(ValoracionesAnimales, ValoracionGranja).

valoracionDeQuienesVivenEn(Granja, ValoracionAnimal):-
  granja(Granja, Animal),
  valoracionAnimal(Animal, ValoracionAnimal).

% en este caso el predicado valoracionDeGranja quiere decir:
% dada una Granja
% encontrame la valoracion de todos los animales que vivan en esta granja,
% luego almacename todas las valoraciones (por separado) en la lista ValoracionesAnimales
% suma todos los valores de la lista ValoracionesAnimales y ponelos en ValoracionGranja

/*
Si lo hago asi, llega unificado Granja y Animal, generandote mas de lo que necesitabas
De esta forma busca UN animal en SU granja, cosa que esta mal
Te genera MUCHAS listas, una con cada valoracion de SU ANIMAL en SU GRANJA.

valoracionDeGranja(Granja, ValoracionGranja):-
  granja(Granja, Animal),
  findall(ValoracionAnimal, valoracionAnimal(Animal, ValoracionAnimal), ValoracionesAnimales),
  sumlist(ValoracionesAnimales, ValoracionGranja).
*/

valoracionAnimal(Rata, 0):-
  rata(Rata).

valoracionAnimal(Gallo, 50):-
  sabeVolar(Gallo).

valoracionAnimal(Gallo, 25):-
  gallo(Gallo, _),        %% -> Aca necesito saber si es un gallo, ya que la negacion me trae problemas.
  not(sabeVolar(Gallo)).  %%    Si no verifico que sea un gallo, toda la negacion de "Gallos que vuelan",
                          %%    es "cualquier cosa que no vuela", y no estaria comprobando que sea un gallo

valoracionAnimal(Gallina, Valor):-
  gallina(Gallina, Peso, HuevosSemanales),
  Valor is Peso * HuevosSemanales.

sabeVolar(Gallo):-
  gallo(Gallo, piloto).

sabeVolar(Gallo):-
  gallo(Gallo, animalDeCirco).


% Punto 5)
granjaDeluxe(Granja):-
  granjaPiola(Granja),
  granjaLibreDeRatas(Granja).

granjaLibreDeRatas(Granja):-
  granja(Granja, _),
  forall(granja(Granja, Animal), not(rata(Animal))).

/*
granjaLibreDeRatas(Granja):-
  granja(Granja, _),
  not(hayRatas(Granja)).
*/

hayRatas(Granja):-
  granja(Granja, Rata),
  rata(Rata).

granjaPiola(Granja):-
  granja(Granja, _),
  findall(Animal, granja(Granja, Animal), Animales),
  length(Animales, CantidadDeAnimales),
  CantidadDeAnimales > 50.

granjaPiola(Granja):-
  valoracionDeGranja(Granja, 1000).




% Punto 6)
buenaPareja(Animal, OtroAnimal):-
  vivenEnLaMismaGranja(Animal, OtroAnimal),
  esBuenaParejaDe(Animal, OtroAnimal).

esBuenaParejaDe(Animal, OtroAnimal):-
  buenaParejaPorEspecie(Animal, OtroAnimal).

esBuenaParejaDe(Animal, OtroAnimal):-
  buenaParejaPorEspecie(OtroAnimal, Animal).

vivenEnLaMismaGranja(Animal, OtroAnimal):-
  granja(Granja, Animal),
  granja(Granja, OtroAnimal),
  Animal \= OtroAnimal.

gallinasDelMismoPeso(Gallina, OtraGallina):-
  gallina(Gallina, Peso, _),
  gallina(OtraGallina, Peso, _).

buenaParejaPorEspecie(Gallina, OtraGallina):-
  puedeCederle(Gallina, OtraGallina),
  gallinasDelMismoPeso(Gallina, OtraGallina).

buenaParejaPorEspecie(Gallo, OtroGallo):-
  sabeVolar(Gallo),
  not(sabeVolar(OtroGallo)).

buenaParejaPorEspecie(Rata, OtraRata):-
  rata(Rata),
  rata(OtraRata).


% Punto 7)
/*
escapePerfecto/1: para escapar hay que tener huevos. Una granja puede realizar un escape perfecto cuando todas sus gallinas ponen más de cinco huevos por semana y todos sus animales hacen buena pareja con algún otro.
*/

escapePerfecto(Granja):-
  granja(Granja, _),
  forall(gallinaQueViveEn(Granja, Gallina), poneMasDe5HuevosPorSemana(Gallina)),
  forall(granja(Granja, Animal),            buenaPareja(Animal, _)).
% Necesito otro forall porque pide una condicion sobre ANIMALES, no sobre Gallinas

gallinaQueViveEn(Granja, Gallina):-
  gallina(Gallina, _, _),
  granja(Granja, Gallina).

poneMasDe5HuevosPorSemana(Gallina):-
  gallina(Gallina, _, HuevosPorSemana),
  HuevosPorSemana > 5.
