:- discontiguous felicidadSegunTipoDe/3, esRaro/1, juguete/2.
% Relaciona al dueño con el nombre del juguete y la cantidad de años que lo ha tenido 
duenio(andy, woody, 8). 
duenio(sam, jessie, 3).

% La tematica de los juguetes de la forma (es tambien el functor juguete):
% deTrapo(tematica).
% deAccion(tematica, partes).
% miniFiguras(tematica, cantidadDeFiguras).
% caraDePapa(partes).

% juguete/2: relaciona al nombre del juguete con el juguete en sí
juguete(woody, deTrapo(vaquero)). 
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)). 
juguete(monitosEnBarril, miniFiguras(mono, 50)). 
juguete(seniorCaraDePapa, caraDePapa([original(pieIzquierdo), original(pieDerecho), repuesto(nariz)])). 

% % Dice si un juguete es raro 
esRaro(deAccion(stacyMalibu, [original(sombrero)])).

% % Dice si una persona es coleccionista 
esColeccionista(sam).

% Agrego para probar:
juguete(seniorCaraDePapa2, caraDePapa([ original(pieIzquierdo) ])).
esRaro(caraDePapa([ original(pieIzquierdo) ])).

% 1) a- tematica/2: relaciona a un juguete con su temática. La temática de los cara de papa es caraDePapa.
% tematica(FJuguete, Tematica).
tematica(deTrapo(Tematica), Tematica).
tematica(miniFiguras(Tematica,_), Tematica).
tematica(deAccion(Tematica,_), Tematica).
tematica(caraDePapa(_), caraDePapa).


% 1) b- esDePlastico
esDePlastico(Juguete) :- % Aca verifico que efectivamente sea un juguete primero que nada
  juguete(_, Juguete),   % Si no hago eso, va a devolverme basura
  esDePlasticoJuguete(Juguete).

esDePlasticoJuguete(miniFiguras(_, _)).
esDePlasticoJuguete(caraDePapa(_)).


% % 1) c-
esDeColeccion(Juguete):-
  juguete(_, Juguete),
  esDeColeccionJuguete(Juguete).

esDeColeccionJuguete(Juguete):-
  esCaraDePapaODeAccion(Juguete),
  esRaro(Juguete).

esDeColeccionJuguete(deTrapo(_)).

esCaraDePapaODeAccion(caraDePapa(_)).  
esCaraDePapaODeAccion(deAccion(_,_)).


% 2) amigoFiel(Duenio, NombreJuguete)
%  Relaciona a un dueño con el nombre del juguete
%  que no sea de plástico que tiene hace más tiempo

amigoFiel(Duenio, NombreJuguete):-
  duenio(Duenio, NombreJuguete, Anios),
  forall(
    jugueteQueNoEsDePlastico(Duenio, _, Anios2),
    Anios >= Anios2
  ).

jugueteQueNoEsDePlastico(Duenio, NombreJuguete, Anios):-
  duenio(Duenio, NombreJuguete, Anios),
  juguete(NombreJuguete, _),
  not(esDePlastico(NombreJuguete)).



% 3) superValioso/1: Genera los nombres de juguetes de colección
% que tengan todas sus piezas originales, y que no estén en posesión de un coleccionista.

superValioso(NombreJuguete):-
  juguete(NombreJuguete, Juguete),
  esDeColeccion(Juguete),
  not(esDeColeccionista(NombreJuguete)),
  tieneTodasSusPiezasOriginales(NombreJuguete).

esDeColeccionista(NombreJuguete):-
  duenio(SuDuenio, NombreJuguete,_),
  esColeccionista(SuDuenio).

tieneTodasSusPiezasOriginales(NombreJuguete):-
  juguete(NombreJuguete, Juguete),
  todasPartesOriginales(Juguete).

todasPartesOriginales(caraDePapa(Partes)):-
  not(poseeRepuesto(Partes)).

todasPartesOriginales(deAccion(_, Partes)):-
  not(poseeRepuesto(Partes)).

poseeRepuesto(Partes):-
  member(repuesto(_), Partes).
% Este predicado devuelve True cuando en la lista de Partes
% encuentra un repuesto.



% 4) dúoDinámico/3: Relaciona un dueño y a dos nombres de juguetes que le pertenezcan que hagan buena pareja. 
% Dos juguetes distintos hacen buena pareja si son de la misma temática. 
% Además woody y buzz hacen buena pareja. Debe ser complemenente inversible

%--------
duoDinamico(Duenio, NombreJuguete1, NombreJuguete2):-
  duenio(Duenio, NombreJuguete1, _),
  duenio(Duenio, NombreJuguete2, _),
  NombreJuguete1 \= NombreJuguete2,
  buenaPareja(NombreJuguete1, NombreJuguete2).

buenaPareja(Nombre1, Nombre2):- hacenBuenaPareja(Nombre1, Nombre2).
buenaPareja(Nombre1, Nombre2):- hacenBuenaPareja(Nombre2, Nombre1).

hacenBuenaPareja(woody, buzz).
hacenBuenaPareja(NombreJuguete1, NombreJuguete2):-
  juguete(NombreJuguete1, TipoJuguete1), 
  juguete(NombreJuguete2, TipoJuguete2),
  tematica(TipoJuguete1, TematicaDelJuguete),
  tematica(TipoJuguete2, TematicaDelJuguete).


% 5. felicidad/2: Relaciona un dueño con la cantidad de felicidad que le otorgan todos sus juguetes: 
% - las minifiguras le dan a cualquier dueño 20 * la cantidad de figuras del conjunto 
% - los cara de papas dan tanta felicidad según que piezas tenga: las originales dan 5, las de repuesto, 8. 
% - los de trapo, dan 100.
% - los de accion, dan 120 si son de coleccion y el dueño es coleccionista. Si no dan lo mismo que los de trapo. 

felicidad(Duenio, NivelDeFelicidad):-
  duenio(Duenio, _, _),
  findall(
          FelicidadDeJuguete, 
          jugueteTieneFelicidadDe(Duenio, FelicidadDeJuguete),
          NivelesDeFelicidadPorJuguete
          ),
  sumlist(NivelesDeFelicidadPorJuguete, NivelDeFelicidad).

jugueteTieneFelicidadDe(Duenio, Felicidad):-
  duenio(Duenio, NombreJuguete, _),
  juguete(NombreJuguete, Juguete),
  felicidadSegunTipoDe(Juguete, Felicidad, NombreJuguete). % Hasta aca bien

felicidadSegunTipoDe(miniFiguras(_, CantidadDeFiguras), Felicidad, _):- % miniFiguras (OK)
  Felicidad is 20 * CantidadDeFiguras.

felicidadSegunTipoDe(caraDePapa(Partes), Felicidad, _):- % Esta anda
  cantidadDePiezasRepuestos(Partes, CantidadRepuestos),
  cantidadDePiezasOriginales(Partes, CantidadOriginales),
  Felicidad is (8 * CantidadRepuestos) + (5 * CantidadOriginales).

cantidadDePiezasRepuestos(Partes, CantidadRepuestos):- % OK
  findall(Repuesto, nth0(Repuesto, Partes, repuesto(_)), LosRepuestos),
  length(LosRepuestos, CantidadRepuestos).

cantidadDePiezasOriginales(Partes, CantidadOriginales):- % OK
  findall(Originales, nth0(Originales, Partes, original(_)), LosOriginales),
  length(LosOriginales, CantidadOriginales).

felicidadSegunTipoDe(deTrapo(_), 100, _).

felicidadSegunTipoDe(_, 120, NombreJuguete):-
  duenio(Duenio, NombreJuguete, _),
  juguete(NombreJuguete, Juguete),
  esDeAccionDeColeccionYdeColeccionista(Duenio, Juguete).

felicidadSegunTipoDe(deAccion(_), 100, NombreJuguete):-
  duenio(Duenio, NombreJuguete, _),
  juguete(NombreJuguete, Juguete),
  not(esDeAccionDeColeccionYdeColeccionista(Duenio, Juguete)).

esDeAccionDeColeccionYdeColeccionista(Duenio, deAccion(Tematica, Partes)):-
  esDeColeccion(deAccion(Tematica, Partes)),
  esColeccionista(Duenio).

% Es de coleccion y es de duenio coleccionista   -> vale 120
% Si no es de coleccion O no es de coleccionista -> vale 100



% 6. puedeJugarCon/2: 
% Relaciona a alguien con un nombre de juguete cuando puede jugar con él.
% Esto ocurre cuando:
%   - este alguien es el dueño del juguete (OK)
%   - o bien, cuando exista otro que pueda jugar con este juguete y pueda prestárselo
% (Alguien puede prestarle un juguete a otro cuando es dueño de una mayor cantidad de juguetes)

puedeJugarCon(Alguien, NombreJuguete):-
  duenio(Alguien, NombreJuguete, _).

puedeJugarCon(Alguien, NombreJuguete):-
  duenio(Alguien, _, _).
  puedeJugarCon(OtroAlguien, NombreJuguete),
  Alguien \= OtroAlguien,
  puedePrestarleElJugueteAOtro(Alguien, OtroAlguien).


puedePrestarleElJugueteAOtro(Alguien, OtroAlguien):-
  cantidadDeJuguetesQueTiene(Alguien, CantidadDeAlguien),
  cantidadDeJuguetesQueTiene(OtroAlguien, CantidadDeOtroAlguien),
  CantidadDeOtroAlguien > CantidadDeAlguien.

cantidadDeJuguetesQueTiene(Alguien, CantidadDeJuguetes):-
  duenio(Alguien, _, _),
  findall(NombreJuguete, duenio(Alguien, CantidadDeAlguien, _), LosJuguetes),
  length(LosJuguetes, CantidadDeJuguetes).



% 7. podriaDonar/3: relaciona a un dueño, una lista de juguetes propios y una 
% cantidad de felicidad cuando entre todos los juguetes de la lista le
% generan menos que esa cantidad de felicidad. Debe ser completamente inversible.

podriaDonar(Duenio, SusJuguetes, FelicidadMaxima):-
  duenio(Duenio, _, _),
  juguetesDe(Duenio, SusJuguetes),
  felicidad(Duenio, Felicidad),
  FelicidadMaxima >= Felicidad.


juguetesDe(Duenio, NombresJuguetes) :-
  duenio(Duenio, _, _),
  findall(NombreJuguete, duenio(Duenio, NombreJuguete, _), NombresJuguetes).

% 8. Comentar dónde se aprovechó el polimorfismo
%   - tematica/2
%   - esDePlasticoJuguete/1
%   - esCaraDePapaODeAccion/1
%   - todasPartesOriginales/1
%   - felicidadSegunTipoDe/3