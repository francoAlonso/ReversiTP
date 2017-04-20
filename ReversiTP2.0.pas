program reversi;

{$mode objfpc}{$H+}

uses

  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

const dimension = 9;
      MAX_VECTOR_CARGA= 8;
type tTablero = array[0..dimension,0..dimension] of char;
     tvDireccion=array [1..2] of ShortInt;
      trDatos=record
       direccion:tvDireccion;
       jugadavalida:boolean;
       fichasdarvuelta:byte;
       end;
     tVectorCarga=array [1..8] of trDatos;   

procedure inicializarTablero(var tablero:tTablero);
   var i,n:byte;
begin
     for i:=0 to dimension do
         for n:=0 to dimension do
             begin
                  if(i=0)then
                       begin
                       tablero[i,n]:= Chr(48+n);
                       end
                  else if(i=9) then
                       begin
                       tablero[i,n]:= Chr(48+n);
                       end
                  else if(n=0) then
                       begin
                       tablero[i,n]:= Chr(48+i);
                       end
                  else if(n=9) then
                       begin
                       tablero[i,n]:= Chr(48+i);
                       end
                  else
                      tablero[i,n]:='_';
             end;
      tablero[4,4]:='N';
      tablero[4,5]:='B';
      tablero[5,4]:='N';
      tablero[5,5]:='N';
      tablero[6,5]:='N';
      tablero[4,6]:='B';
end;

procedure dibujarTablero(tablero:tTablero);
    var i,n:byte;
begin
     for i:=0 to dimension do
         begin
         for n:=0 to dimension do
             write(tablero[i,n], ' ');
         writeln();
         end;
end;

function verificarValido():boolean;
begin
     verificarValido:=true;
end;

function sePuedeJugar (var tablero:tTablero):boolean;
  var i,j:byte;
      jugada:boolean;
begin
  i:=1;
  j:=1;
  jugada:=false;
  
  while (i<=dimension-1) and (jugada=false) do
    begin 
      while (j<=dimension-1) and (jugada=false) do
      begin
        if (verificarValido()=true) then
          jugada:=true;
        j:=j+1;
      end;
      i:=i+1;
    end;
    sePuedeJugar:=jugada;
end;

procedure continuarJuego(var tablero:tTablero; var contInv:byte; var juegoTerminado:boolean);
begin
  if (sePuedeJugar(tablero)=false) then
             contInv:= contInv+1
          else
             contInv:=0;
  if (contInv=2) then
    juegoTerminado:=True;
end;


            

procedure ingresarFicha(var tablero:tTablero; var posicionX:byte; var posicionY:byte; letra:char);
          var input:string[2];
              code:byte;(*Variable para que funcione Val() unicamente*)
begin
     posicionX:=0;
     posicionY:=0;
     write('Ingrese su jugada: ');
     read(input);
     Val(input[1], posicionY, code); (*Transforma char en ingeteger/byte*)
     Val(input[2], posicionX, code);

     while((IOResult<>0) and (posicionX>=1) and (posicionX<=dimension-1) and (posicionY>=1) and (posicionY<=dimension-1) and (code=0) ) do
     begin
          write('Ingrese valores entre 1 a ', dimension, ': ');
          readln(input);
          Val(input[1], posicionY, code);
          Val(input[2], posicionX, code);
     end;

     tablero[posicionX,posicionY]:=letra;
end;

procedure CargarVector (rdatos:trdatos; VectorCarga:tVectorCarga; posicionX:byte; posicionY:byte);
	var i:byte;
	begin
		VectorCarga[1].direccion[1]:= 1 ;   // derecha
		VectorCarga[1].direccion[2]:= 0 ;   // derecha
		VectorCarga[2].direccion[1]:= -1;  // izquierda
		VectorCarga[2].direccion[2]:= 0 ;  // izquierda
		VectorCarga[3].direccion[1]:= 0 ;   // arriba
		VectorCarga[3].direccion[2]:= 1 ;   // arriba
		VectorCarga[4].direccion[1]:= 0 ;  // abajo
		VectorCarga[4].direccion[2]:= -1;  // abajo
		VectorCarga[5].direccion[1]:= 1 ;   // diagonal superior derecha
		VectorCarga[5].direccion[2]:= 1 ;   // diagonal superior derecha
		VectorCarga[6].direccion[1]:= 1 ;  // diagonal inferior derecha
		VectorCarga[6].direccion[2]:= -1;  // diagonal inferior derecha
		VectorCarga[7].direccion[1]:= -1;  // diagonal superior izquierda
		VectorCarga[7].direccion[2]:= 1 ;  // diagonal superior izquierda
		VectorCarga[8].direccion[1]:= -1; // diagonal inferior izquierda
		VectorCarga[8].direccion[2]:= -1; // diagonal inferior izquierda
		for i:=1 to MAX_VECTOR_CARGA do
			begin
				VectorCarga[i].jugadavalida:=false;
				VectorCarga[i].fichasdarvuelta:= 0;
			end;
    end;   
 
procedure botJuega(var tablero:tTablero);
var i,n:byte;
begin
     for i:=1 to dimension-1 do
         for n:=1 to dimension-1 do   (*Recuerden que ahora es un array de 10 dimensiones de 0 a 9*)
         begin
              verificarValido();
         end;
end;

procedure contarFichas(var tablero:tTablero);
var i,n, negras, blancas:byte;
begin
     negras:=0;
     blancas:=0;
     for i:=1 to dimension-1 do
         for n:=1 to dimension-1 do
         begin
              if( tablero[i,n] = 'B') then
                  blancas := blancas + 1;
              if( tablero[i,n] = 'N') then
                  negras := negras + 1;
         end;
     if(blancas>negras)then
         writeln('Blancas ganan con ', blancas, ' fichas');
     if(negras>blancas)then
         writeln('Negras ganan con', negras, ' fichas');  (*No hay empate por el momento porque me tira error por X motivo en el else*)
end;

var tablero:tTablero;
    juegoTerminado:boolean;
    posicionX, posicionY: byte;
    contInv:byte;
   // VectorCarga:tVectorCarga;
begin
  contInv:=0;
  juegoTerminado:=false;
  inicializarTablero(tablero);

  while (juegoTerminado=false) do
  begin
       dibujarTablero(tablero);
       continuarJuego(tablero, contInv, juegoTerminado);
       ingresarFicha(tablero, posicionX, posicionY, 'N');
       botJuega(tablero);
       readln();
       contarFichas(tablero);
  end;
end.
