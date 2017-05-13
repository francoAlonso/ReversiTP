program reversi;

{$mode objfpc}{$H+}

uses crt;

const 
	dimension = 9;
	FICHA_NEGRA = 'N';
	FICHA_BLANCA = 'B';
	ESPACIO_EN_BLANCO = '_';
	CANTIDAD_DIRECCIONES = 8;
	
type 
	tTablero = array[0..dimension,0..dimension] of char;
	trDireccion = record
		direccionX:shortInt;
		direccionY:shortInt;
		direccionValida:boolean;
		fichasADarVuelta:byte;
	end;
	tDireccion = array[1..CANTIDAD_DIRECCIONES] of trDireccion;
	trJugadaBot = record
		posX:byte;
		posY:byte;
		fichas:byte;
	end;
	tmJugadaBot = array[1..dimension-1,1..dimension-1] of trJugadaBot;
	
(*-----------------Inicializar Tablero-----------------------*)	
//va a llenar el vector tTablero con chars una sola vez en el principio para simular un tablero.
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
      tablero[4,4]:=FICHA_BLANCA;
      tablero[4,5]:=FICHA_NEGRA;
      tablero[5,4]:=FICHA_NEGRA;
      tablero[5,5]:=FICHA_BLANCA;
end;

(*-------------------CargarVectorDireccion-----------------------*)
//inicializa el array tDireccion para que le indique al programa las direcciones que se va a tomar. Tmb es usado para resetearse
procedure cargarVectorDireccion (var vectorDireccion:tDireccion);
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
		
	for i:=1 to CANTIDAD_DIRECCIONES do
	begin
		vectorDireccion[i].direccionvalida:=false;
		vectorDireccion[i].fichasADarVuelta:= 0;
	end;
			
end;

(*----------------------verificar_direccion-------------------*)
//va a ir en una direccion a verificar si es valida preguntando en base de B y N.
function verificarDireccionValida(var tablero:tTablero; var vectorDireccion:tDireccion;
 posicionX,posicionY:byte; fichaAliada,fichaContraria:char; direccion:byte):boolean;
	var fichasComidas:byte;
begin
	fichasComidas:=0;
	
	while (tablero[posicionX,posicionY]= ESPACIO_EN_BLANCO)
	 and (tablero[posicionX+vectorDireccion[direccion].direccionX , posicionY+vectorDireccion[direccion].direccionY] = fichaContraria)
	 and (not vectorDireccion[direccion].direccionValida) do
	begin
		fichasComidas:= fichasComidas+1;
		posicionX:= posicionX + vectorDireccion[direccion].direccionX;
		posicionY:= posicionY + vectorDireccion[direccion].direccionY;
		
		while (tablero[posicionX, posicionY]<>ESPACIO_EN_BLANCO)and((tablero[posicionX, posicionY]=FICHA_BLANCA) or (tablero[posicionX, posicionY]=FICHA_NEGRA)) 
		 and (not vectorDireccion[direccion].direccionValida) do
		begin
			if (tablero[posicionX, posicionY]=fichaContraria) then
			begin
				fichasComidas:= fichasComidas+1;
				posicionX:= posicionX + vectorDireccion[direccion].direccionX;
				posicionY:= posicionY + vectorDireccion[direccion].direccionY;
			end
			else
			begin
				vectorDireccion[direccion].direccionValida:= true;
				vectorDireccion[direccion].fichasADarVuelta:= fichasComidas;
			end;
		end;//segundo while
			
	end;//primer while
	
	verificarDireccionValida:= vectorDireccion[direccion].direccionValida;
end;

(*------------------------------verificarValido-----------------------*)
//es la que devuelve si la casilla es valida o no, va a llamar a verificarDireccionValida por la cantidad de direcciones
function verificarCasillaValida(var tablero:tTablero; var vectorDireccion:tDireccion;
 posicionX,posicionY:byte; fichaAliada,fichaContraria:char):boolean;
	var i:byte;
		valido:boolean;
begin
	valido:= false;
	for i:=1 to CANTIDAD_DIRECCIONES do
	begin
		if( verificarDireccionValida(tablero, vectorDireccion, posicionX, posicionY, fichaAliada, fichaContraria, i) ) then
		begin
			valido:= true;
		end;
	end;
	
	verificarCasillaValida:= valido;
end;

(*------------------------------------------sePuedeJugar---------------------------------------*)
//verifica que ambos jugadores tengan la oportunidad de jugar, en caso contrario, saltea su turno
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
        if ( verificarCasillaValida(tablero, vectorDireccion,i,j,fichaAliada,fichaContraria) ) then
          jugada:=true;
        j:=j+1;
      end;
      i:=i+1;
    end;
    sePuedeJugar:=jugada;
end;

(*---------------------invertirFila-------------------------*)
//encargado de invertir las fichas opoenentes en una sola direccion.
procedure invertir_fila (var tablero:tTablero; var vectorDireccion:tDireccion; 
 fichaAliada,fichaContraria:char; posicionX,posicionY, direccion:byte);
begin
	posicionX:=posicionX + vectorDireccion[direccion].direccionX;
	posicionY:=posicionY + vectorDireccion[direccion].direccionY;
	while (tablero[posicionX,posicionY] = fichaContraria) do
	begin
		tablero[posicionX,posicionY]:= fichaAliada;
		posicionX:=posicionX + vectorDireccion[direccion].direccionX;
		posicionY:=posicionY + vectorDireccion[direccion].direccionY;
	end;
end;

(*----------------------invertirFichas------------------------*)
//si o si siendo una casilla valida, dara vuelta toda ficha del oponente. Llama a invertir_fila por la cantidad de direcciones
procedure invertir_fichas (var tablero:tTablero; var vectorDireccion:tDireccion; 
 fichaAliada,fichaContraria:char; posicionX,posicionY:byte);
	var i:byte;
begin
	tablero[posicionX,posicionY]:= fichaAliada;

	for i:=1 to CANTIDAD_DIRECCIONES do
	begin
		if (vectorDireccion[i].direccionvalida) then
		begin
			invertir_fila(tablero, vectorDireccion, fichaAliada, fichaContraria, posicionX, posicionY, i);
		end;
	end;
end;

(*------------------------cargarJugadaBot----------------------*)
//le asignara al array del bot que casillas va a poder ingresar y cuantas a comer
procedure cargarJugadaBot (var tablero:tTablero; var vectorDireccion:tDireccion;var mJugadaBot:tmJugadaBot; fichaBot,fichaJugador:char);
var i,j,k:byte;
  begin
    for i:=1 to dimension-1 do
    begin
		for j:=1 to dimension-1 do
        begin
			if ( verificarCasillaValida(tablero, vectorDireccion,i,j,fichaBot,fichaJugador) )then
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
//esta funcion reiniciara la posicion que tiene mayor cantidad de fichas para comer
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
//esta funcion elije la posicion con mayor capacidad de comer fichas enemigas
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
//imprime por pantalla el estado actual del tablero
procedure dibujarTablero(tablero:tTablero);
    var i,n:byte;
begin
     for i:=0 to dimension do
         begin
         for n:=0 to dimension do
             write(tablero[i,n], '  ');		
         writeln();
         writeln();
         end;
end;

(*----------------------Ingresar Ficha-----------------------*)
//el usuario va a tener que ingresar dos valores entre 1 a 8
procedure ingresarFicha(var tablero:tTablero; var vectorDireccion:tDireccion; var posicionX:byte; var posicionY:byte; fichaJugador, fichaBot:char);
	var input:string[2];
		code:byte;(*Variable para que funcione Val() unicamente*)
begin
     write('Ingrese las coordenadas en Y e X entre 1 a ', dimension-1, ' para cada digito: ');
     readln(input);
     Val(input[1], posicionY, code);
     Val(input[2], posicionX, code);
     
     while( (posicionX<1) or (posicionX>dimension-1) or (posicionY<1) or (posicionY>dimension-1) or
      not verificarCasillaValida(tablero, vectorDireccion, posicionX, posicionY, fichaJugador, fichaBot) and (code=0) ) do
     begin
          write('Posicion invalida, pruebe nuevamente: ');
          readln(input);
          Val(input[1], posicionY, code);
          Val(input[2], posicionX, code);
     end;

end;

(*-----------------------Contar fichas-------------------------------*)
//va a contar solo las fichas N y B
procedure contarFichas(var tablero:tTablero; fichaJugador,fichaBot:char);
var i,n, negras, blancas:byte;
begin
     negras:=0;
     blancas:=0;
     for i:=1 to dimension-1 do
         for n:=1 to dimension-1 do
         begin
              if( tablero[i,n] = fichaBot) then
                  blancas := blancas + 1;
              if( tablero[i,n] = fichaJugador) then
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
//llamando a sePuedeJugar, verifica que ambos jugadores juegen. Si ambos no pueden jugar, se termina el juego
function continuarJuego(var tablero:tTablero; vectorDireccion:tDireccion; var contInv:byte;var juegoTerminado:boolean; 
 fichaAliada, fichaContraria:char):boolean;
	var resultado:boolean;
begin
	if( sePuedeJugar(tablero, vectorDireccion, fichaAliada, fichaContraria) ) then
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

procedure verificarColorValido(var color:char);
begin
	repeat
		write('Elija el color de su ficha, N o B? ');
		readln(color);
	until (color='n') or (color='b') or (color='B') or (color='N');
end;

(*---------------------Juego--------------------------------------*)

var tablero:tTablero;
    juegoTerminado:boolean;
    posicionX, posicionY: byte;
    vectorDireccion: tDireccion;
    posicionConMasFichas : trJugadaBot;
    mJugadaBot:tmJugadaBot;
    contInv:byte;
    fichaJugador, fichaBot, fichaIngresadaPorUsuario: char;
    
BEGIN
	inicializarTablero(tablero);
	dibujarTablero(tablero);
	
	contInv:=0;
	juegoTerminado:=false;
	
	verificarColorValido(fichaIngresadaPorUsuario);
	
	if (fichaIngresadaPorUsuario = 'b') or (fichaIngresadaPorUsuario = 'B') then
	begin
		fichaJugador:= FICHA_BLANCA;
		fichaBot:= FICHA_NEGRA;
		cargarVectorDireccion(vectorDireccion);
		cargarJugadaBot(tablero, vectorDireccion, mJugadaBot, fichaBot, fichaJugador);
		posicionConMasFichas:= botGloton(mJugadaBot);
		invertir_fichas(tablero, vectorDireccion, fichaBot, fichaJugador, posicionConMasFichas.posX, posicionConMasFichas.posY);
		ClrScr();
		dibujarTablero(tablero);
		writeln('Jugada del bot: ', posicionConMasFichas.posY, '', posicionConMasFichas.posX);
	end
	else
	begin
		fichaJugador:= FICHA_NEGRA;
		fichaBot:= FICHA_BLANCA;
	end;

	while not(juegoTerminado) do
	begin
		cargarVectorDireccion(vectorDireccion);
		
		if( continuarJuego(tablero, vectorDireccion, contInv, juegoTerminado, fichaJugador, fichaBot) ) then
		begin	
			ingresarFicha(tablero, vectorDireccion, posicionX, posicionY, fichaJugador, fichaBot);

			invertir_fichas(tablero, vectorDireccion, fichaJugador, fichaBot, posicionX, posicionY);
		end
		else
			writeln('Al jugador no le es posible ingresar fichas este turno');
		
		
		cargarVectorDireccion(vectorDireccion);
		
		if( continuarJuego(tablero, vectorDireccion, contInv, juegoTerminado, fichaBot, fichaJugador)) then
		begin
			resetearJugadaBot(mJugadaBot);
			cargarJugadaBot(tablero, vectorDireccion, mJugadaBot, fichaBot, fichaJugador);
			posicionConMasFichas:= botGloton(mJugadaBot);
			invertir_fichas(tablero, vectorDireccion, fichaBot, fichaJugador, posicionConMasFichas.posX, posicionConMasFichas.posY);
			ClrScr();
			dibujarTablero(tablero);
			writeln('Jugada del bot: ', posicionConMasFichas.posY, '', posicionConMasFichas.posX);
		end
		else
			writeln('Al bot no le es posible ingresar fichas este turno');
		
	end;
	
	contarFichas(tablero, fichaJugador, fichaBot);
	readln();
END.
