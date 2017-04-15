program reversi;

{$mode objfpc}{$H+}

uses

  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

const dimension = 9;
type tTablero = array[0..dimension,0..dimension] of char;

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
procedure ContinuarJuego (*Variable para que cuente los Verificar validos falsos*);
          var ContInv:byte; 
          begin
          if verificarValido=false then
             ContInv:= ContInv+1;
             (*Habria que agregar la condicion en el ciclo y setear el contador a 0 cuando empieza el ciclo*)
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

     while((IOResult<>0) or (posicionX<1) or (posicionX>dimension) or (posicionY<1) or (posicionX>dimension)) do
     begin
          write('Ingrese valores entre 1 a ', dimension, ': ');
          readln(input);
          Val(input[1], posicionY, code);
          Val(input[2], posicionX, code);
     end;

     tablero[posicionX,posicionY]:=letra;
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
begin
  juegoTerminado:=false;
  inicializarTablero(tablero);

  while(juegoTerminado=false) do
  begin
       dibujarTablero(tablero);
       ingresarFicha(tablero, posicionX, posicionY, 'N');
       botJuega(tablero);
       readln();
       contarFichas(tablero);
  end;
end.

