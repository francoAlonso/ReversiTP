program reversi;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

const dimension = 8;
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
                  else if(n=0) then
                       begin
                       tablero[i,n]:= Chr(48+i);
                       end
                  else
                      tablero[i,n]:='_';
             end;
      tablero[4,4]:='N';
      tablero[4,5]:='B';
      tablero[5,4]:='B';
      tablero[5,5]:='N';
end;

procedure dibujarTablero(tablero:tTablero);
    var i,n:byte;
begin
     for i:=0 to dimension do
         begin
         for n:=0 to dimension do
             write(tablero[i,n]);
         writeln();
         end;
end;

var tablero:tTablero;
begin
  inicializarTablero(tablero);
  dibujarTablero(tablero);
  readln();
end.

