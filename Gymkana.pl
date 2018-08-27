% requiere(posta, [postas]).
% [postas] es la lista de postas requerida para completar alguna en especifico.

requiere(salto,[]).
requiere(correr,[]).
requiere(cebolla,[]).
requiere(vara,[]).
requiere(tomate,[salto]).
requiere(pintura,[correr]).
requiere(canto,[cebolla,vara]).
requiere(bala,[canto]).
requiere(crema,[pintura]).
requiere(fuerza,[bala]).
requiere(tiro,[tomate,crema,fuerza]).
requiere(camino,[tiro]).

% Si no hay postas, entonces el resultado es vacio.
porhacer([], _, []).

% porhacer, entrega una lista de las postas por realizar para llegar al objetivo.
% [Posta|Postas] es la lista de los requerimientos de una posta objetivo.
% Pyr son las postas ya realizadas.
% Ppr es la lista de postas por realizar

porhacer([Posta|Postas], Pyr, Ppr) :-
    requiere(Posta, A),
    porhacer(A, Pyr, NPpr),
    append(NPpr, Pyr, Pyr1),
    (   Postas \= [] ->
        porhacer(Postas, Pyr1, EPpr);
        EPpr = []   ),

    (   member(Posta, Pyr) ->
        APpr = [];
        APpr = [Posta]  ),

    (   subset(EPpr, NPpr) ->
        append([], NPpr, LPpr);
        append(NPpr, EPpr, LPpr)    ),

    (   member(Posta, LPpr) ->
        append([LPpr], Ppr);
        append([LPpr,APpr], Ppr)    ).


% anteriores es una funcion que entrega una lista con las postas que son necesarias para poder realizar otra en especifico.
% Posta, es la posta que se quiere realizar.
% Realizadas, lista de postas realizadas.

anteriores(Posta,Realizadas):-
    requiere(Posta,Lista_requisito),
    porhacer(Lista_requisito, Realizadas, Resultado),nl,
    write(Resultado),!;
    write('No válido').



%si la lista de postas por analizar es vacia, el resultado es vacio.
postas_directas([], _, []).

%postas_directas, obtiene las postas que se pueden realizar directamente, es decir, sin requisito.
%[H|T] es la lista de postas que son posibles candidatos para realizar directamente.
%R es la lista de postas ya realizadas.
%I es una lista con la lista de postas directas.

postas_directas([H|T], R, I):-
    postas_directas(T, R, I1),
    requiere(H, R1),
    (   member(H, R) -> Ip = [];
            (   subtract(R1, R, R2),
                R2 \= [] ->
                Ip = []; Ip = [H]   )   ),

    postas_directas(R1, R, I2),
    append([Ip, I1, I2], I3),
    list_to_set(I3, I).

%predicado inicial de postas_directas. Donde se llama al predicado anterior con [H|T] como
%una lista de las postas que no tienen pre-requisitos.
%R es la lista de postas ya realizadas.
%I es la lista con el resultado de las postas que pueden realizarse de forma directa.

postas_directas(R, I) :-
    findall(Z, requiere(Z,_), M),
    postas_directas(M, R, I1),
    union(I1, I1, I).
