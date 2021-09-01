
% persona(Hash)
persona(ab570).
persona(ce234).
persona(a013).
persona(f2682).
persona(yo). % Yo!
persona(ba4d9).

% trabajaEn(Hash, Trabajo)
trabajaEn(ab570, ingenieriaMecanica).
trabajaEn(ce234, aviacionMilitar).
trabajaEn(a013, inteligenciaMilitar).
trabajaEn(f2682, limpieza).
trabajaEn(yo, jugadorDeFulbo).

% viveEn(Hash, LugarDondeVive)
viveEn(ab570, laSeverino).
viveEn(ba4d9, laSeverino).
viveEn(ce234, laSeverino).
viveEn(a013, comisaria48).
viveEn(f2682, suCasa).
viveEn(yo, miCasa).

% viveCon(Persona1, Persona2)
vive(ab570, ba4d9).
vive(ab570, ce234).
viveCon(A,B):- vive(A,B).
viveCon(A,B):- vive(B,A).

% gustos(Hash, Gusto)
gusto(ab570, fuego).
gusto(ab570, destruccion).
gusto(a013, juegosDeAzar).
gusto(a013, ajedrez).
gusto(a013, tiroAlBlanco).
gusto(f2682, nada).
gusto(yo, deportes).
gusto(yo, musica).
gusto(yo, codear).
gusto(yo, tocarLaViola).

% habilidad(Hash, Gustos)
habilidad(ab570, armarBombas).
habilidad(ce234, conducirAutos).
habilidad(a013, tiroAlBlanco).
habilidad(f2682, serMalaEnTodo).
habilidad(yo, haceTodoBien).

% historial(Hash, Delito)
historial(ce234, roboDeAeronaves).
historial(ce234, fraude).
historial(ce234, tenenciaDeCafeina).
historial(a013, falsificarVacunas).
historial(a013, fraude).

% vivienda(Nombre, Composicion)
vivienda(laSeverino, [cuartoSecreto(4, 8), pasadizo, tunel(8, finalizado), tunel(5, finalizado), tunel(1, enConstruccion)]).
vivienda(laCasona, [cuartoSecreto(2, 2), pasadizo, tunel(100, finalizado), patio(6, 6)]).

/* 2. esDisidente(Hash)
  a. Tener una habilidad en algo considerado terrorista sin tener un trabajo de índole militar.
  b. No tener gustos registrados en sistema, tener más de 3, o que le guste aquello en lo que es bueno.
  c. Tiene más de un registro en su historial criminal o vive junto con alguien que sí lo tiene.
*/

esDisidente(Persona):-
  persona(Persona),
  tieneHabilidadTerroristaSinTenerTrabajoMilitar(Persona),
  requisitoB(Persona),
  requisitoC(Persona).

tieneHabilidadTerroristaSinTenerTrabajoMilitar(Persona):-
  trabajaEn(Persona, Trabajo),
  habilidad(Persona, Habilidad),
  habilidadEsTerrorista(Habilidad),
  not(trabajoEsMilitar(Trabajo)).

trabajoEsMilitar(aviacionMilitar).
trabajoEsMilitar(inteligenciaMilitar).
habilidadEsTerrorista(armarBombas).

requisitoB(Persona):-
  persona(Persona),
  not(tieneGustoRegistrado(Persona)).

requisitoB(Persona):-
  tieneMasDe3Gustos(Persona).

requisitoB(Persona):-
  leGustaAlgoEnLoQueEsBueno(Persona).

tieneGustoRegistrado(Persona):-
  gusto(Persona, _).

tieneMasDe3Gustos(Persona):-
  persona(Persona),
  findall(Gustos, gusto(Persona, Gustos), LosGustos),
  length(LosGustos, CantidadDeGustosQueTiene),
  CantidadDeGustosQueTiene > 3.

leGustaAlgoEnLoQueEsBueno(Persona):-
  gusto(Persona, Gusto),
  habilidad(Persona, Gusto).

requisitoC(Persona):-
  tieneMasDeUnRegistroEnSuHistorial(Persona).

requisitoC(Persona):-
  tieneMasDeUnRegistroEnSuHistorial(Persona).

tieneMasDeUnRegistroEnSuHistorial(Persona):-
  persona(Persona),
  historial(Persona, UnRegistro),
  historial(Persona, OtroRegistro),
  UnRegistro \= OtroRegistro.

viveConAlguienConMasDeUnRegistroEnElHistorial(Persona):-
  persona(Persona),
  viveCon(Persona, SuCompaniero),
  tieneMasDeUnRegistroEnSuHistorial(SuCompaniero).

% 3. Detectar si en una casa
%   a- No vive nadie
%   b- Todos los que viven tienen al menos un gusto en comun

noViveNadie(Casa):-
  vivienda(Casa, _),
  not(viveEn(_, Casa)).

losQueVivenTienenGustoEnComun(Casa):-
  vivienda(Casa, _),
  viveEn(UnaPersona, Casa),
  forall(
        (viveEn(OtraPersona, Casa), UnaPersona \= OtraPersona),
        (gusto(UnaPersona, GustoComun), gusto(OtraPersona, GustoComun))
        ).


% 4. viviendaRebelde(Casa)

viviendaRebelde(Casa):-
  vivienda(Casa, _),
  viveEn(UnaPersona, Casa),
  esDisidente(UnaPersona),
  superficie(Casa, SuSuperficie),
  SuSuperficie > 50.

superficie(Casa, SuperficieTotal):-
  vivienda(Casa, Composicion),
  findall(
          Superficie,
          (member(Componente, Composicion), superficieUnitaria(Componente, Superficie)),
          LasSuperficies
  ),
  sumlist(LasSuperficies, SuperficieTotal).
  
% Dado una casa, con su composicion:
% Halla todas las superficies de los miembros (Componente)
% de la composicion de la casa, y guardalos en la lista de LasSuperficies
% Finalmente sumo la lista.

superficieUnitaria(cuartoSecreto(A,B), Superficie):- Superficie is A*B.
superficieUnitaria(tunel(Largo, finalizado), Superficie):- Superficie is 2*Largo.
superficieUnitaria(tunel(_, enConstruccion), 0). 
superficieUnitaria(pasadizo, 1).
superficieUnitaria(patio(_,_), 0).

/*
7. Si en algún momento se agregara algún tipo nuevo de ambiente en las
   viviendas, por ejemplo bunkers donde se esconden secretos o entradas
   a cuevas donde se puede viajar en el tiempo
   a. ¿Qué pasaría con la actual solución? 
   b. ¿Qué se podría hacerse si se quisiera contemplar su superficie para
      determinar la superficie total de la casa? Implementar una solución
      con una lógica simple
   c. Justificar

a. Gracias al polimorfismo utilizado en superficieUnitaria, la solucion 
   propuesta es bastante facil de modificar.
b. En el caso de agregar un bunker, dada la solucion propuesta por mi,
   lo unico que habria que hacer es implementar un predicado del tipo:
   superficieUnitaria(bunker(), Superficie)


*/