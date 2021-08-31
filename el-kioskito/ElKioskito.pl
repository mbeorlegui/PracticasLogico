
% atiende(Profesor, Dia, HorarioApertura, HorarioCierre)
atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(juanC, sabados, 18, 22).
atiende(juanC, domingo, 18, 22).
atiende(lucas, martes, 10, 20).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).

% 1
atiende(vale, Dia, HorarioApertura, HorarioCierre):-
  atiende(dodain, Dia, HorarioApertura, HorarioCierre).
atiende(vale, Dia, HorarioApertura, HorarioCierre):-
  atiende(juanC, Dia, HorarioApertura, HorarioCierre).
/*
  Solamente ponemos lo de vale, ya que en logico
  solamente ponemos predicados y clausulas con 
  las cosas que estamos seguros que son verdaderas
  no contempla ambigüedades en ese sentido.
  El concepto que interviene es el "Principio 
  de universo cerrado"
*/


% 2 quienAtiendeElKiosko(Dia, Hora, Persona)
quienAtiende(Dia, Horario, Persona):-
  atiende(Persona, Dia, HorarioApertura, HorarioCierre),
  between(HorarioApertura, HorarioCierre, Horario).

% 3. foreverAlone(Persona, Dia, Horario) -> Saber si en ese horario atiende solo el kioskito (debe usar not/1)
foreverAlone(Persona, Dia, Horario):-
  quienAtiende(Dia, Horario, Persona),
  not((quienAtiende(Dia, Horario, OtraPersona), Persona \= OtraPersona)).
% Una persona atiende sola en un dia y horario si:
% no hay otra persona distinta que atienda en ese dia y horario


% 4. posibilidadesDeAtencion(Dia, Persona) -> Este tema no lo vimos en clase
% golosinas(ValorEnPlata)
% cigarrillos([MarcasDeCigarrillos])
% bebidas(Tipo, Cantidad) -> Tipo: alcoholica / noAlcoholica

% venta(Persona, fecha(Dia, Mes), [LoQueVendioEnElDia])
venta(dodain, fecha(10, 8), [golosinas(1200), cigarrillos([jockey]), golosinas(50)]).
venta(dodain, fecha(18, 8), [bebidas(alcoholica, 8), bebidas(noAlcoholica, 1), golosinas(10)]).
venta(martu, fecha(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas, fecha(11, 8), [golosinas(600)]).
venta(lucas, fecha(18, 8), [bebidas(noAlcoholica, 2), cigarrillos([derby])]).

vendedor(Persona):- venta(Persona, _, _).

vendedorEsSuertudo(Persona):-
  vendedor(Persona),
  forall(venta(Persona, Dia, _), primeraVentaFueImportante(Persona, Dia)).
% Para todo dia que vendio esa Persona ->
% esa Persona hizo una primera venta importante

primeraVentaFueImportante(Persona, Dia):-
  venta(Persona, Dia, LoQueVendioEnElDia),
  nth0(0, LoQueVendioEnElDia, PrimeraVenta),
  esVentaImportante(PrimeraVenta).

esVentaImportante(golosinas(ValorEnPlata)):-
  ValorEnPlata > 100.

esVentaImportante(cigarrillos(CigarrillosVendidos)):-
  length(CigarrillosVendidos, DistintosTiposDeCigarrillo),
  DistintosTiposDeCigarrillo > 2.

esVentaImportante(bebidas(alcoholica, _)).
esVentaImportante(bebidas(noAlcoholica, CantidadVendida)):-
  CantidadVendida > 5.


