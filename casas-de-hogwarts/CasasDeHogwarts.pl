% casa(NombreDeCasa)
casa(ravenclaw).
casa(slytherin).
casa(hufflepuff).
casa(gryffindor).

% mago(NombreDeMago)
mago(harry).
mago(hermione).
mago(draco).
mago(ron).
mago(luna).

% casaOdiadaPorMago(Mago, CasaQueOdia)
casaOdiadaPorMago(harry, slytherin).
casaOdiadaPorMago(draco, hufflepuff).

% sangreDelMago(Mago, TipoSangre)
sangreDelMago(harry, mestizo).
sangreDelMago(draco, pura).
sangreDelMago(hermione, impura).

% caracteristicaDeMago(Mago, Caracteristica)
caracteristicaDeMago(harry, corajudo).
caracteristicaDeMago(harry, amistoso).
caracteristicaDeMago(harry, orgulloso).
caracteristicaDeMago(harry, inteligente).
caracteristicaDeMago(draco, inteligente).
caracteristicaDeMago(draco, orgulloso).
caracteristicaDeMago(hermione, inteligente).
caracteristicaDeMago(hermione, orgulloso).
caracteristicaDeMago(hermione, responsable).

% masImportantePorCasa(Casa, [CaracteristicasImportantes]).
caracteristicaPorCasa(gryffindor, corajudo).
caracteristicaPorCasa(slytherin, orgulloso).
caracteristicaPorCasa(slytherin, inteligente).
caracteristicaPorCasa(ravenclaw, inteligente).
caracteristicaPorCasa(ravenclaw, responsable).
caracteristicaPorCasa(hufflepuff, amistoso).

% 1.1 casaAdmiteMago(Casa, Mago)
casaAdmiteMago(Casa, Mago):-
  casa(Casa),
  Casa \= slytherin,
  mago(Mago).

casaAdmiteMago(slytherin, Mago):-
  mago(Mago),
  sangreDelMago(Mago, TipoSangre),
  TipoSangre \= impura.

% 1.2 tieneCaracterApropiadoParaCasa(Mago, Casa)
tieneCaracterApropiadoParaCasa(Mago, Casa):-
  mago(Mago),
  casa(Casa),
  forall(caracteristicaPorCasa(Casa, Caracteristica), caracteristicaDeMago(Mago, Caracteristica)).
% toda caracteristica necesaria para la casa, la tiene ese mago

% 1.3 magoPodriaIrACasa(Mago, Casa)
magoPodriaIrACasa(Mago, Casa):-
  tieneCaracterApropiadoParaCasa(Mago, Casa),
  casaAdmiteMago(Casa, Mago),
  not(casaOdiadaPorMago(Mago, Casa)).
  
magoPodriaIrACasa(hermione, gryffindor).


% 1.4 cadenaDeAmistades(ListaDeMagosAmistosos)
cadenaDeAmistades(LosMagos):-
  todosSonAmistosos(LosMagos).
% cadenaDeCasas(LosMagos). -> Falta predicado

todosSonAmistosos(LosMagos):- % Para todo miembro de la lista de magos
  forall(member(Mago, LosMagos), esAmistosoElmago(Mago)). % el mago es amistoso

esAmistosoElmago(Mago):-
  caracteristicaDeMago(Mago, amistoso).

% Parte 2:
% accionesDeMagos(Mago, AccionQueRealizo, Puntaje)

accionesDeMagos(harry, andarFueraDeCasa, -50).
accionesDeMagos(harry, irAlBosque, -50).
accionesDeMagos(harry, irAlTercerPiso, -70).
accionesDeMagos(harry, ganarleAVoldemort, 60).
accionesDeMagos(hermione, irAlTercerPiso, -70).
accionesDeMagos(hermione, irASeccionRestringidaDeBiblioteca, -10).
accionesDeMagos(hermione, salvarAmigos, 50).
accionesDeMagos(ron, ganarAjedrezMagico, 50).
accionesDeMagos(draco, irALasMazmorras, 0).
accionesDeMagos(luna, loQueSea, 1000). % Prueba

% esDe(Mago, SuCasa)
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% 2.1 esBuenAlumno(Mago) -> si hizo alguna acción y ninguna de las cosas que hizo se
% considera una mala acción (que son aquellas que provocan un puntaje negativo).
esBuenAlumno(Mago):-
  hizoAlgunaAccion(Mago),
  not(hizoAlgoMalo(Mago)).

hizoAlgunaAccion(Mago):-
  accionesDeMagos(Mago, _, _).

hizoAlgoMalo(Mago):-
  accionesDeMagos(Mago, _, PuntajeDeAccion),
  PuntajeDeAccion < 0.

accionEsRecurrente(Accion):-
  accionesDeMagos(Mago1, Accion, _),
  accionesDeMagos(Mago2, Accion, _),
  Mago1 \= Mago2.

% 2.2 puntajeTotalDeCasa(Casa) -> Suma de puntajes obtenidos por sus miembros
puntajeTotalDeCasa(Casa, PuntajeTotal):-
  casa(Casa),
  findall(Puntaje, puntajeDeMiembro(Casa, Puntaje), LosPuntajes),
  sumlist(LosPuntajes, PuntajeTotal).
% Halla todos los puntajes de los miembros de la casa
% y almacenalos en la lista LosPuntajes

puntajeDeMiembro(Casa, PuntajeDeAccion):-
  esDe(Mago, Casa),
  accionesDeMagos(Mago, _, PuntajeDeAccion).


% 2.3 casaGanadora(Casa) -> Saber cuál es la casa ganadora de la copa
% que se verifica para aquella casa que haya obtenido una cantidad mayor
% de puntos que todas las otras

casaGanadora(Casa):-
  puntajeTotalDeCasa(Casa, PuntajeMayor),
  forall(
        (puntajeTotalDeCasa(OtraCasa, PuntajeMenor), Casa \= OtraCasa),
        PuntajeMayor > PuntajeMenor).

% 2.4 preguntas(Mago, PreguntaQueHizo, Dificultad, ProfesorQueLaHizo)
preguntas(hermione, dondeEncontrarBezoar, 20, snape).
preguntas(hermione, hacerLevitarPluma, 25, flitwick).

puntosPorPreguntas(Mago, PuntajeDePregunta):-
  preguntas(Mago, _, PuntajeDePregunta, Profesor),
  Profesor \= snape.

puntosPorPreguntas(Mago, PuntajeDePregunta):-
  preguntas(Mago, _, Dificultad, snape),
  PuntajeDePregunta is Dificultad/2.