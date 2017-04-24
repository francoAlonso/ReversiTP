(*Vayamos poniendo las cosas para el bot aca*)
program bot;
type trJugadaBot:record
                 posX:byte;
                 posY:byte;
                 fichas:byte;
                 end;
     tmJugadaBot:array[1..dimension,1..dimension] of trJugadaBot

(*este procedimiento lo usamos en todos los turnos para resetear el mJugadaBot*)
procedure cargaJugadasBot (var mJugadaBot:tmJugadaBot)
var i,j:byte;
  begin
    for i:=1 to dimension do
        begin
             for j:=1 to dimension do
                 begin
                      mJugadaBot[i,j].posX:=0;
                      mJugadaBot[i,j].posY:=0;
                 end;
        end;
  end;

(*Cargamos el mJugadaBot con las posiciones validas*)
procedure jugadasBot (var tablero:tTablero;var mJugadaBot:tmJugadaBot;dimension:byte);
var i,j:byte;
  begin
    for i:=1 to dimension do
        begin
             for j:=1 to dimension do
                 begin
                      if verificar_jugada_usuario(vectorCarga,tablero,i,j,'N','B',) then
                      mJugadaBot[i,j].posX:=i;
                      mJugadaBot[i,j].posY:=j;
                 end;
        end;
  end;

(*Falta el tema de cargar las fichas en cada una de esas posiciones*) 
