

function verificar_jugada_usuario(var vectorcarga:tvectorcarga; tablero:ttablero; posicionX:byte; posicionY:byte; ficha:char; fichacontraria:char):boolean;
	var i:byte;
	t:byte;
	contador_fichas_invertidas:byte;
	contador_direcciones_validas:byte;
	contador_fichas_invertidas_totales:byte;
	valido:boolean;

begin 
	valido:=false;
	contador_fichas_invertidas:=0;
	contador_direcciones_validas:=0;
	t:=1;
	
	if not tablero[posicionX,posicionY]='_' then
		writeln('Jugada invalida, ingrese nuevamente sus coordenadas.')
	else 
	begin
		for i:=1 to 8 do
		begin
			posicionX:=posicionX+vectorcarga[i].direccionX;
			posicionY:=posicionY+vectorcarga[i].direccionY;
			if tablero(posicionX,posicionY)='fichacontraria' then
			begin
				contador_fichas_invertidas:=contador_fichas_invertidas+1;;
				while (posicionX>=1) and (posicionX<=8) and (posicionY>=1) and (posicionY<=8) and (t=1) do
				begin
					posicionX:=posicionX+vectorcarga[i].direccionX;
					posicionY:=posicionY+vectorcarga[i].direccionY;
					if tablero[posicionX,posicionY]='fichacontraria' then
					contador_fichas_invertidas:=contador_fichas_invertidas+1;
					if tablero[posicionX,posicionY]='ficha' then
					begin
						VectorCarga[i].direccionvalida:='true';
						contador_direcciones_validas:=contador_direcciones_validas+1;
						VectorCarga[i].fichasdarvuelta:=contador_fichas_invertidas;
						t:=2;
					end;
					if tablero[posicionX,posicionY]='_' then
					t:=2;
				end;
			end;
		end;
		if contador_direcciones_validas=0 then
		begin
			valido:=false;
			writeln('Jugada invalida, ingrese nuevamente sus coordenadas.');
			verificar_jugada_usuario=valido;
		end;
		else 
			valido:=true;
	end;
end;
