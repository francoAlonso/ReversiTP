program reversi;

{$mode objfpc}{$H+}

uses crt;

const 
	dimension = 9;
	FICHA_JUGADOR = 'N';
	FICHA_BOT = 'B';
	ESPACIO_EN_BLANCO = '_';
	
type 
	tTablero = array[0..dimension,0..dimension] of char;
	trDatos= record
		direccionX:shortInt;
		direccionY:shortInt;
		direccionValida:boolean;
		fichasADarVuelta:byte;
	end;
	tDireccion = array[1..dimension-1] of trDatos;
	trJugadaBot = record
		posX:byte;
		posY:byte;
		fichas:byte;
	end;
	tmJugadaBot = array[1..dimension-1,1..dimension-1] of trJugadaBot;
	
(*-----------------Inicializar Tablero-----------------------*)	

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
                      tablero[i,n]:=ESPACIO_EN_BLANCO;
             end;
      tablero[4,4]:=FICHA_JUGADOR;
      tablero[4,5]:=FICHA_BOT;
      tablero[5,4]:=FICHA_BOT;
      tablero[5,5]:=FICHA_JUGADOR;
end;

(*-------------------CargarVector-----------------------*)

procedure cargarVector (var vectorDireccion:tDireccion);
	var i:byte;
	
begin
	vectorDireccion[1].direccionX:= 0; // derecha
	vectorDireccion[1].direccionY:= 1;  // derecha
	vectorDireccion[2].direccionX:= 0;  // izquierda
	vectorDireccion[2].direccionY:= -1;  // izquierda
	vectorDireccion[3].direccionX:= 1;  // arriba
	vectorDireccion[3].direccionY:= 0;  // arriba
	vectorDireccion[4].direccionX:= -1;  // abajo
	vectorDireccion[4].direccionY:= 0;  // abajo
	vectorDireccion[5].direccionX:= 1;  // diagonal superior derecha
	vectorDireccion[5].direccionY:= 1;  // diagonal superior derecha
	vectorDireccion[6].direccionX:= -1;  // diagonal inferior derecha
	vectorDireccion[6].direccionY:= 1;  // diagonal inferior derecha
	vectorDireccion[7].direccionX:= 1;  // diagonal superior izquierda
	vectorDireccion[7].direccionY:= -1;  // diagonal superior izquierda
	vectorDireccion[8].direccionX:= -1;  // diagonal inferior izquierda
	vectorDireccion[8].direccionY:= -1;  // diagonal inferior izquierda
		
	for i:=1 to dimension-1 do
	begin
		vectorDireccion[i].direccionvalida:=false;
		vectorDireccion[i].fichasADarVuelta:= 0;
	end;
			
end;

(*----------------------verificar_direccion-------------------*)

function verificarDireccion(var tablero:tTablero; var vectorDireccion:tDireccion;
 posicionX,posicionY:byte; fichaAliada,fichaContraria:char; i:byte):boolean;
	var fichasComidas:byte;
begin
	fichasComidas:=0;
	
	while (tablero[posicionX,posicionY]= ESPACIO_EN_BLANCO)
	 and (tablero[posicionX+vectorDireccion[i].direccionX , posicionY+vectorDireccion[i].direccionY] = fichaContraria)
	 and (not vectorDireccion[i].direccionValida) do
	begin
		fichasComidas:= fichasComidas+1;
		posicionX:= posicionX + vectorDireccion[i].direccionX;
		posicionY:= posicionY + vectorDireccion[i].direccionY;
		
		while (tablero[posicionX, posicionY]<>ESPACIO_EN_BLANCO) and ((tablero[posicionX, posicionY]='B') or (tablero[posicionX, posicionY]='N')) and (not vectorDireccion[i].direccionValida) do
		begin
			if (tablero[posicionX, posicionY]=fichaContraria) then
			begin
				fichasComidas:= fichasComidas+1;
				posicionX:= posicionX + vectorDireccion[i].direccionX;
				posicionY:= posicionY + vectorDireccion[i].direccionY;
			end
			else if(tablero[posicionX, posicionY]=fichaAliada) then
			begin
				vectorDireccion[i].direccionValida:= true;
				vectorDireccion[i].fichasADarVuelta:= fichasComidas;
			end;
		end;//segundo while
			
	end;//primer while
	
	verificarDireccion:= vectorDireccion[i].direccionValida;
end;

(*------------------------------verificarValido-----------------------*)

function verificarValido(var tablero:tTablero; var vectorDireccion:tDireccion;
 posicionX,posicionY:byte; fichaAliada,fichaContraria:char):boolean;
	var i:byte;
		valido:boolean;
begin
	valido:= false;
	for i:=1 to dimension-1 do
	begin
		if( verificarDireccion(tablero, vectorDireccion, posicionX, posicionY, fichaAliada, fichaContraria, i) ) then
		begin
			valido:= true;
		end;
	end;
	
	verificarValido:= valido;
end;

(*------------------------------------------sePuedeJugar---------------------------------------*)
function sePuedeJugar (var tablero:tTablero; vectorDireccion:tDireccion; fichaAliada, fichaContraria:char):boolean;
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
        if ( verificarValido(tablero, vectorDireccion,i,j,fichaAliada,fichaContraria) ) then
          jugada:=true;
        j:=j+1;
      end;
      i:=i+1;
    end;
    sePuedeJugar:=jugada;
end;

(*---------------------invertirFila-------------------------*)
procedure invertir_fila (var tablero:tTablero; var vectorDireccion:tDireccion; 
 fichaAliada,fichaContraria:char; posicionX,posicionY, i:byte);
begin
	posicionX:=posicionX + vectorDireccion[i].direccionX;
	posicionY:=posicionY + vectorDireccion[i].direccionY;
	while (tablero[posicionX,posicionY] = fichaContraria) do
	begin
		tablero[posicionX,posicionY]:= fichaAliada;
		posicionX:=posicionX + vectorDireccion[i].direccionX;
		posicionY:=posicionY + vectorDireccion[i].direccionY;
	end;
end;

(*----------------------invertirFichas------------------------*)

procedure invertir_fichas (var tablero:tTablero; var vectorDireccion:tDireccion; 
 fichaAliada,fichaContraria:char; posicionX,posicionY:byte);
	var i:byte;
begin
	tablero[posicionX,posicionY]:= fichaAliada;

	for i:=1 to dimension-1 do
	begin
		if (vectorDireccion[i].direccionvalida) then
		begin
			invertir_fila(tablero, vectorDireccion, fichaAliada, fichaContraria, posicionX, posicionY, i);
		end;
	end;
end;

(*------------------------cargarJugadaBot----------------------*)

procedure cargarJugadaBot (var tablero:tTablero; var vectorDireccion:tDireccion;var mJugadaBot:tmJugadaBot);
var i,j,k:byte;
  begin
    for i:=1 to dimension-1 do
    begin
		for j:=1 to dimension-1 do
        begin
			if ( verificarValido(tablero, vectorDireccion,i,j,FICHA_BOT,FICHA_JUGADOR) )then
			begin
				mJugadaBot[i,j].posX:=i;
				mJugadaBot[i,j].posY:=j;
				for k:=1 to dimension-1 do
					mJugadaBot[i,j].fichas:= mJugadaBot[i,j].fichas + vectorDireccion[k].fichasADarVuelta;
				
			end;
        end;
	end;
 end;

(*------------------------ResetearJugadasBot--------------------*)

procedure resetearJugadaBot (var mJugadaBot : tmJugadaBot);
var i,j:byte;
  begin
    for i:=1 to dimension-1 do
    begin
		for j:=1 to dimension-1 do
		begin
			mJugadaBot[i,j].posX:=0;
			mJugadaBot[i,j].posY:=0;
			mJugadaBot[i,j].fichas:=0;
        end;
	end;
end;

(*-----------------------botGloton--------------------*)

function botGloton(var mJugadaBot : tmJugadaBot):trJugadaBot;
	var gloton:trJugadaBot;
		i,n:byte;
begin
	gloton.posX:=0;
	gloton.posY:=0;
	gloton.fichas:=0;
	
	for i:=1 to dimension-1 do
	begin
		for n:=1 to dimension-1 do
		begin
			if(mJugadaBot[i,n].fichas>gloton.fichas) then
			begin
				gloton.posX:= mJugadaBot[i,n].posX;
				gloton.posY:= mJugadaBot[i,n].posY;
				gloton.fichas:= mJugadaBot[i,n].fichas;
			end;
		end;
	end;
	botGloton:= gloton;
end;

(*--------------------------DibujarTablero---------------------*)

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

(*----------------------Ingresar Ficha-----------------------*)

procedure ingresarFicha(var posicionX:byte; var posicionY:byte; letra:char);
	var input:string[2];
		code:byte;(*Variable para que funcione Val() unicamente*)
begin
     posicionX:=0;
     posicionY:=0;
     
     repeat
          write('Ingrese valores entre 1 a ', dimension-1, ' para cada digito: ');
          readln(input);
          Val(input[1], posicionY, code);
          Val(input[2], posicionX, code);
     until ( (posicionX>=1) and (posicionX<=dimension-1) and (posicionY>=1) and (posicionY<=dimension-1) and (code=0) );

end;

(*-------------------ingresarFichaUsuario----------------------------*)

procedure ingresarFichaUsuario(tablero:tTablero; vectorDireccion:tDireccion; var posicionX:byte; var posicionY:byte; FICHA_JUGADOR,FICHA_BOT:char);
begin
	repeat
		ingresarFicha(posicionX, posicionY, FICHA_JUGADOR);
	until ( verificarValido(tablero, vectorDireccion, posicionX, posicionY, FICHA_JUGADOR, FICHA_BOT) );
end;

(*-----------------------Contar fichas-------------------------------*)

procedure contarFichas(var tablero:tTablero);
var i,n, negras, blancas:byte;
begin
     negras:=0;
     blancas:=0;
     for i:=1 to dimension-1 do
         for n:=1 to dimension-1 do
         begin
              if( tablero[i,n] = FICHA_BOT) then
                  blancas := blancas + 1;
              if( tablero[i,n] = FICHA_JUGADOR) then
                  negras := negras + 1;
         end;
     if(blancas>negras)then
     begin
         writeln('Blancas ganan con ', blancas, ' fichas');
     end
     else if(negras>blancas)then
     begin
         writeln('Negras ganan con', negras, ' fichas');
     end
     else
		writeln('Empate');
end;

(*-----------------------------------------continuarJuego------------------------------------*)
function continuarJuego(var tablero:tTablero; vectorDireccion:tDireccion; var contInv:byte;var juegoTerminado:boolean; 
 fichaAliada, fichaContraria:char):boolean;
	var resultado:boolean;
begin
	if not (sePuedeJugar(tablero, vectorDireccion, fichaAliada, fichaContraria)=false) then
	begin
		contInv:= contInv+1;
		resultado:= false;
	end
	else
	begin
		contInv:=0;
		resultado:= true;
	end;
	
	if (contInv=2) then
		juegoTerminado:=True;
	
	continuarJuego:=resultado;
end;

(*---------------------Juego--------------------------------------*)

var tablero:tTablero;
    juegoTerminado:boolean;
    posicionX, posicionY: byte;
    vectorDireccion: tDireccion;
    posicionConMasFichas : trJugadaBot;
    mJugadaBot:tmJugadaBot;
    contInv:byte;
    
BEGIN
	inicializarTablero(tablero);
	dibujarTablero(tablero);
	
	contInv:=0;
	juegoTerminado:=false;

	while not(juegoTerminado) do
	begin
		cargarVector(vectorDireccion);
		if( continuarJuego(tablero, vectorDireccion, contInv, juegoTerminado, FICHA_JUGADOR, FICHA_BOT) ) then
		begin
			
			//ingresarFichaUsuario(tablero, vectorDireccion, posicionX, posicionY, FICHA_JUGADOR, FICHA_BOT);
			//invertir_fichas(tablero, vectorDireccion, FICHA_JUGADOR, FICHA_BOT, posicionX, posicionY);
			ingresarFicha(posicionX, posicionY, FICHA_JUGADOR);
			
			if( verificarValido(tablero, vectorDireccion, posicionX, posicionY, FICHA_JUGADOR, FICHA_BOT) )then
				invertir_fichas(tablero, vectorDireccion, FICHA_JUGADOR, FICHA_BOT, posicionX, posicionY)
			else
			begin
				repeat
					ingresarFicha(posicionX, posicionY, FICHA_JUGADOR);
				until ( verificarValido(tablero, vectorDireccion, posicionX, posicionY, FICHA_JUGADOR, FICHA_BOT) );
				invertir_fichas(tablero, vectorDireccion, FICHA_JUGADOR, FICHA_BOT, posicionX, posicionY);
			end;
			dibujarTablero(tablero)
		end
		else
			writeln('Al jugador no le es posible ingresar fichas este turno');
		
		
		cargarVector(vectorDireccion);
		if( continuarJuego(tablero, vectorDireccion, contInv, juegoTerminado, FICHA_BOT, FICHA_JUGADOR)) then
		begin
			resetearJugadaBot(mJugadaBot);
			cargarJugadaBot(tablero, vectorDireccion, mJugadaBot);
			posicionConMasFichas:= botGloton(mJugadaBot);
			invertir_fichas(tablero, vectorDireccion, FICHA_BOT, FICHA_JUGADOR, posicionConMasFichas.posX, posicionConMasFichas.posY);
			writeln('Jugada del bot: ', posicionConMasFichas.posY, '', posicionConMasFichas.posX);
			
			dibujarTablero(tablero);
		end
		else
			writeln('Al bot no le es posible ingresar fichas este turno');
		
	end;
	
	contarFichas(tablero);
END.
