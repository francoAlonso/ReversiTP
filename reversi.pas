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
	vectorDireccion[1].direccionX:= 1; // derecha
	vectorDireccion[1].direccionY:= 0;  // derecha
	vectorDireccion[2].direccionX:= -1;  // izquierda
	vectorDireccion[2].direccionY:= 0;  // izquierda
	vectorDireccion[3].direccionX:= 0;  // arriba
	vectorDireccion[3].direccionY:= 1;  // arriba
	vectorDireccion[4].direccionX:= 0;  // abajo
	vectorDireccion[4].direccionY:= -1;  // abajo
	vectorDireccion[5].direccionX:= 1;  // diagonal superior derecha
	vectorDireccion[5].direccionY:= 1;  // diagonal superior derecha
	vectorDireccion[6].direccionX:= 1;  // diagonal inferior derecha
	vectorDireccion[6].direccionY:= -1;  // diagonal inferior derecha
	vectorDireccion[7].direccionX:= -1;  // diagonal superior izquierda
	vectorDireccion[7].direccionY:= 1;  // diagonal superior izquierda
	vectorDireccion[8].direccionX:= -1;  // diagonal inferior izquierda
	vectorDireccion[8].direccionY:= -1;  // diagonal inferior izquierda
		
	for i:=1 to dimension-1 do
	begin
		vectorDireccion[i].direccionvalida:=false;
		vectorDireccion[i].fichasADarVuelta:= 0;
	end;
			
end;

(*-----------------------------verificar_jugada_usuario-------------------------*)

function verificar_jugada(var vectorDireccion:tDireccion; tablero:tTablero; posicionX:byte; posicionY:byte;
 fichaAliada:char; fichaContraria:char):boolean;
	var i:byte;
		contador_fichas_invertidas:byte;
		seguirContando:boolean;
		contador_direcciones_validas:byte;
begin 
	contador_fichas_invertidas:= 0;
	seguirContando:= true;
	contador_direcciones_validas:= 0;
	
	if not (tablero[posicionX,posicionY] = ESPACIO_EN_BLANCO) then //pregunta si el espacio no esta en blanco
		verificar_jugada:=false
	else 
	begin//en caso de estarlo
		for i:=1 to dimension-1 do//este for va a recorrer el vector direccion que tiene todas las direcciones
		begin
			posicionX:=posicionX + vectorDireccion[i].direccionX; //va a saltar a la siguiente posicion de la direccion
			posicionY:=posicionY + vectorDireccion[i].direccionY;
			
			if (tablero[posicionX,posicionY]=fichaContraria) then //pregunta si es contraria para poder seguir
			begin
				contador_fichas_invertidas:=contador_fichas_invertidas+1; //este valor se va a usar cuando se encuentre con una ficha aliada
				
				while (posicionX>=1) and (posicionX<=dimension-1) and (posicionY>=1) and (posicionY<=dimension-1)
				 and (seguirContando) do //entra en un loop que no se salga de la tabla y hace uso del booleano para parar tmb
				begin
					posicionX:=posicionX + vectorDireccion[i].direccionX;//pasa a la siguien posicion de la direccion
					posicionY:=posicionY + vectorDireccion[i].direccionY;
					
					if (tablero[posicionX,posicionY] = fichaContraria) then //si tiene una ficha contraria, suma 1 al contador
						contador_fichas_invertidas:=contador_fichas_invertidas+1
					else if (tablero[posicionX,posicionY]=fichaAliada) then
					begin//si tiene una ficha aliada, agrega el contador al registro y termina con el proceso
						vectorDireccion[i].direccionvalida:=true;
						vectorDireccion[i].fichasADarVuelta:=contador_fichas_invertidas;//aca tenes el valor que te dije lo agrega al registro
						contador_direcciones_validas:= contador_direcciones_validas + 1;//este valor se va a usar despues de salir del for
						seguirContando:=false; //termino con el loop
					end
					else if tablero[posicionX,posicionY]=ESPACIO_EN_BLANCO then//si el espacio esta en blanco, va a terminar con el loop
						seguirContando:=false;
				end;//fin del while
				
			end;
		end;//fin del for
		
		if (contador_direcciones_validas = 0) then
		begin//este if va a ser quien devuelva el valor de la funcion en base si hubo alguna direccion valida en el for
			verificar_jugada:=false;
		end
		else 
			verificar_jugada:=true;
	end;
end;

(*----------------------invertirFichas------------------------*)

procedure invertir_fichas (var tablero:tTablero; var vectorDireccion:tDireccion; fichaAliada:char;
 fichaContraria:char; posicionX:byte; posicionY:byte);
	var i:byte;
		sigo:boolean;
begin
	tablero[posicionX,posicionY]:= fichaAliada;
	sigo:=true;
	for i:=1 to dimension-1 do
	begin
		if (vectorDireccion[i].direccionvalida) then
		begin
			while (sigo) do
			begin
				posicionX:=posicionX + vectorDireccion[i].direccionX;
				posicionY:=posicionY + vectorDireccion[i].direccionY;
				if (tablero[posicionX,posicionY] = fichaContraria) then
					tablero[posicionX,posicionY]:= fichaAliada
				else
					sigo:=false;
			end;
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
			if ( verificar_jugada(vectorDireccion,tablero,i,j,FICHA_BOT,FICHA_JUGADOR) )then
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



(*---------------------Juego--------------------------------------*)

var tablero:tTablero;
    juegoTerminado:boolean;
    posicionX, posicionY: byte;
    vectorDireccion: tDireccion;
    posicionConMasFichas : trJugadaBot;
    sePuedeJugar:boolean;
    mJugadaBot:tmJugadaBot;
    
BEGIN
	cargarVector(vectorDireccion);
	inicializarTablero(tablero);
	dibujarTablero(tablero);
	
	juegoTerminado:=false;

	while not(juegoTerminado) do
	begin
		ingresarFicha(posicionX, posicionY, FICHA_JUGADOR);
		sePuedeJugar:= verificar_jugada(vectorDireccion, tablero, posicionX, posicionY, FICHA_JUGADOR, FICHA_BOT);
		
		if(sePuedeJugar)then
			invertir_fichas(tablero, vectorDireccion, FICHA_JUGADOR, FICHA_BOT, posicionX, posicionY);
		dibujarTablero(tablero);
		
		resetearJugadaBot(mJugadaBot);
		cargarJugadaBot(tablero, vectorDireccion, mJugadaBot);
		
		posicionConMasFichas:= botGloton(mJugadaBot);
		if(posicionConMasFichas.fichas = 0) then
		begin
			writeln('nigga');
		end
		else
		begin
			invertir_fichas(tablero, vectorDireccion, FICHA_BOT, FICHA_JUGADOR, posicionConMasFichas.posX, posicionConMasFichas.posY);
			writeln('Jugada del bot:');
		end;
		
		dibujarTablero(tablero);
	end;
	
	contarFichas(tablero);
END.
