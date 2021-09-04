
% atleta(Nombre, Edad, Pais)
atleta(delfiPignatiello, 21, argentina).
atleta(chinoSimonet, 31, argentina).
atleta(kevinDurant, 32, estadosUnidos).
atleta(atletaVago, 18, singapur).
atleta(dalilahMuhammad , 31, estadosUnidos).
atleta(rudyGobert , 29, francia).
atleta(elHeredero , 32, argentina).

esAtleta(Persona):- atleta(Persona, _, _).
esPais(Pais):- atleta(_, _, Pais).

% compiteEn(Nombre, Disciplina, TipoDisciplina)
compiteEn(delfiPignatiello, natacionEstiloLibre, individual).
compiteEn(delfiPignatiello, natacionPostas, grupal).
compiteEn(chinoSimonet, handball, grupal).
compiteEn(kevinDurant, basket, grupal).
compiteEn(dalilahMuhammad, carrera400MetrosConVallasFemenino, individual).
compiteEn(unNadador, cienMetrosEspaldaMasculino, grupal).
compiteEn(otroNadador, cienMetrosEspaldaMasculino, grupal).
compiteEn(nadadorInventado, cienMetrosEspaldaMasculino, grupal).
compiteEn(rudyGobert, basket, grupal).
compiteEn(elHeredero, voley, grupal).

disciplina(Disciplina):- compiteEn(_, Disciplina, _).
esDisciplinaIndividual(Disciplina):- compiteEn(_, Disciplina, individual).
esDisciplinaGrupal(Disciplina):- compiteEn(_, Disciplina, grupal).

% medalla(Disciplina, TipoMedalla, PaisQueLoGana)
medalla(natacionEstiloLibre, oro, estadosUnidos).
medalla(basket, oro, estadosUnidos).
medalla(basket, plata, francia).
medalla(voley, bronce, argentina).
medalla(carrera400MetrosConVallasFemenino, plata, estadosUnidos).

% evento(Disciplina, Ronda, Participante) 
% -> Participante: puede ser un pais o una persona
evento(natacionEstiloLibre, ronda1, delfiPignatiello).
evento(natacionPostas, ronda2, argentina).
evento(voley, cuartosDeFinal, argentina).
evento(voley, semiFinal, argentina).
evento(handball, faseDeGrupos, argentina).
evento(basket, final, estadosUnidos).
evento(basket, final, francia).
evento(hockeyFemenino, final, argentina).
evento(hockeyFemenino, final, paisesBajos).
evento(cienMetrosEspaldaMasculino, ronda2, unNadador).
evento(cienMetrosEspaldaMasculino, ronda2, otroNadador).
evento(cienMetrosEspaldaMasculino, ronda1, nadadorInventado).

% para comprobar si el que compite en el evento es persona o equipo:
eventoEsGrupal(evento(_, _, PaisParticipante)):-
  atleta(_ , _, PaisParticipante).

eventoEsIndividual(evento(_, _, PersonaParticipante)):-
  atleta(PersonaParticipante , _, _).


% 2. vinoAPasear(Atleta)
vinoAPasear(Atleta):-
  esAtleta(Atleta),
  not(compiteEn(Atleta, _, _)).



% 3. medallasDelPais/3: nos dice en qué disciplinas ganaron medallas cuáles
% países. 
% Recordar que un país puede obtener medallas en disciplinas
% por equipo o también a través de atletas que lo representen

medallasDelPais(Pais, Disciplina, Medalla):-
  medalla(Disciplina, Medalla, Pais).


% 4. participoEn/3: relaciona en qué rondas y disciplinas se desempeñó un
% atleta. Para disciplinas individuales, dependerá de en qué eventos estuvo
% (puede haber participado en las rondas 1 y 2, por ejemplo, pero no haber
% pasado a la ronda 3); para disciplinas en equipo, se considera que los
% atletas de la disciplina participan siempre que su país participe en la
% ronda. Por ejemplo, si argentina participa en octavosDeFinal de
% voleyMasculino, todos los atletas argentinos que se desempeñen en
% voleyMasculino participan en esa ronda

participoEn(Ronda, Disciplina, Atleta):-
  esAtleta(Atleta),
  compiteEn(Atleta, Disciplina, _),
  esDisciplinaIndividual(Disciplina),
  evento(Disciplina, Ronda, Atleta).

participoEn(Ronda, Disciplina, Atleta):-
  atleta(Atleta, _, Pais),
  compiteEn(Atleta, Disciplina, _),
  esDisciplinaGrupal(Disciplina),
  evento(Disciplina, Ronda, Pais).


% 5. dominio/2: se cumple para un país y una disciplina si todas las medallas
% en esa disciplina fueron entregadas a atletas del mismo país. Naturalmente, 
% esto sólo puede ocurrir en disciplinas individuales

dominio(Pais, Disciplina):-
  esPais(Pais),
  esDisciplinaIndividual(Disciplina),
  medalla(Disciplina, oro, Pais),
  not((medalla(Disciplina, oro, OtroPais), Pais \= OtroPais)).


% 6. medallaRapida/1: es verdadero para las disciplinas cuyas medallas se
% definieron en un evento a ronda única
medallaRapida(Disciplina):-
  evento(Disciplina, _, _),
  not(tieneMuchasRondas(Disciplina)).

tieneMuchasRondas(Disciplina):-
  disciplina(Disciplina),
  evento(Disciplina, UnaRonda, _),
  evento(Disciplina, OtraRonda, _),
  UnaRonda \= OtraRonda.




% 7. noEsElFuerte/2: relaciona a un país con las disciplinas en las que no
% participó o sólo participó en una ronda inicial. 
% En los casos de disciplinas por equipos, esa ronda es faseDeGrupos; 
% en los casos de disciplinas individuales, es la ronda 1.


noEsElFuerte(Pais, Disciplina):-
  esPais(Pais),
  disciplina(Disciplina),
  paisNoParticipoEnDisciplina(Pais, Disciplina).

noEsElFuerte(Pais, Disciplina):-
  esPais(Pais),
  disciplina(Disciplina),
  soloParticipoEnPrimeraRonda(Pais, Disciplina).

% Aclaracion: se considera que participo si hay un evento de esa persona/pais
% en esa disciplina.
paisNoParticipoEnDisciplina(Pais, Disciplina):-
  esDisciplinaIndividual(Disciplina),
  esPais(Pais),
  not(unParticipanteEsDelPais(Disciplina, Pais)).

unParticipanteEsDelPais(Disciplina, Pais):-
  disciplina(Disciplina),
  esPais(Pais),
  evento(Disciplina, _, PersonaParticipante),
  atleta(PersonaParticipante, _, Pais).


paisNoParticipoEnDisciplina(Pais, Disciplina):-
  esDisciplinaGrupal(Disciplina),
  esPais(Pais),
  not(unEquipoEsDelPais(Disciplina, Pais)).

unEquipoEsDelPais(Disciplina, Pais):-
  disciplina(Disciplina),
  esPais(Pais),
  evento(Disciplina, _, Pais).

soloParticipoEnPrimeraRonda(Disciplina, Pais):-
  esDisciplinaGrupal(Disciplina),
  esPais(Pais),
  not(pasoLaPrimeraRonda(Disciplina, Pais)).

soloParticipoEnPrimeraRonda(Disciplina, Pais):-
  esDisciplinaIndividual(Disciplina),
  esPais(Pais),
  not(pasoLaPrimeraRonda(Disciplina, Pais)).

pasoLaPrimeraRonda(Disciplina, Pais):-
  evento(Disciplina, Ronda, Pais),
  Ronda \= faseDeGrupos.

pasoLaPrimeraRonda(Disciplina, Pais):-
  evento(Disciplina, Ronda, Pais),
  Ronda \= ronda1.


% 8. medallasEfectivas/2: nos dice la cuenta final de medallas de cada país.
% No es simplemente la suma de medallas, sino que cada una vale distinto: 
% las de oro suman 3, las de plata 2, y las de bronce 1
medallasEfectivas(Pais, SumaTotal):-
  esPais(Pais),
  findall(
          Valoracion,
          (medalla(_, Medalla, Pais), valoracionPorMedalla(Medalla, Valoracion)),
          LasValoraciones
    ),
  sumlist(LasValoraciones, SumaTotal).
  
valoracionPorMedalla(oro, 3).
valoracionPorMedalla(plata, 2).
valoracionPorMedalla(bronce, 1).



% laEspecialidad/1: se cumple para los atletas que no vinieron a pasear y
% obtuvieron medalla de oro o plata en todas las disciplinas en las que participaron
laEspecialidad(Atleta):-
  esAtleta(Atleta),
  not(vinoAPasear(Atleta)),
  todasMedallasDeOroOPlata(Atleta).

todasMedallasDeOroOPlata(Atleta):-
  participoEn(_, _, Atleta),
  forall(
        participoEn(_, Disciplina, Atleta),
        ganoOroOPlataEnDisciplina(Atleta, Disciplina)
  ).
% para toda disciplina en la que participa ese atleta,
% ese atleta gano oro o plata

ganoOroOPlataEnDisciplina(Atleta, Disciplina):-
  atleta(Atleta, _, Pais),
  compiteEn(Atleta, Disciplina, _),
  medalla(Disciplina, _, Pais),
  not(medalla(Disciplina, bronce, Pais)).

