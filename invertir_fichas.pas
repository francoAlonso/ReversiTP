

procedure invertir_fichas (var tablero:ttablero; var vectorcarga:tvectorcarga; ficha:char; fichacontraria:char; posicionX:byte; posicionY:byte; verificar_jugada_usuario:boolean);
	var i,j,t:byte;
	
	BEGIN
	t=2
		for i:=1 to 8 do
			begin
			if (VectorCarga[i].direccionvalida:='true') then
				begin
				while (t=2) do
					posicionX:=posicionX+vectorcarga[i].direccionX;
					posicionY:=posicionY+vectorcarga[i].direccionY;
					if tablero(posicionX,posicionY)='fichacontraria' then
						tablero(posicionX,posicionY)='ficha';
					else
					t=1;
				end;
			end;
		end;
	END.
