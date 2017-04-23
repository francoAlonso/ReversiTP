
procedure verificar_jugada_usuario (var vectorcarga:tvectorcarga,tablero:ttablero,posicionX:byte,posicionY:byte,ficha:char,fichacontraria:char)
var i:byte;
	t:byte;
	contador_fichas_invertidas:byte;
	contador_direcciones_validas:byte;
	
begin
	contador_fichas_invertidas=0;
	contador_direcciones_validas=0;
	t=1;
	
	if tablero(posicionX,posicionY)='_' then
	
		for i:=1 to 8 do
			posicionX=posicionX+vectorcarga[i].direccionX
			posicionY=posicionY+vectorcarga[i].direccionY
			
				if tablero(posicionX,posicionY)='fichacontraria' then
					contador_fichas_invertidas=contador_fichas_invertidas+1
					
					while (posicionX>=1) and (posicionX<=8) and (posicionY>=1) and (posicionY<=8) and (t=1)
		
						posicionX=posicionX+vectorcarga[i].direccionX
						posicionY=posicionY+vectorcarga[i].direccionY
			
						if tablero(posicionX,posicionY)='fichacontraria'
						contador_fichas_invertidas=contador_fichas_invertidas+1
					
						if tablero(posicionX,posicionY)='ficha'
						VectorCarga[i].jugadavalida='true'
						contador_direcciones_validas=contador_direcciones_validas+1
						VectorCarga[i].fichasdarvuelta=contador_fichas_invertidas
						t=2
					
						if tablero(posicionX,posicionY)='_'
						t=2
					
						else
						t=2
					
					end
								
	else
	writeln('Jugada invalida, ingrese nuevamente sus coordenadas.')
	
end

