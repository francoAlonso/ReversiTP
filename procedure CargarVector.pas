

procedure CargarVector (rdatos:trdatos; VectorCarga:tVectorCarga; posicionX:byte; posicionY:byte);
	var i:byte;
	
	begin
		VectorCarga[1].direccionX:= 1 ;  // derecha
		VectorCarga[1].direccionY:= 0 ;  // derecha
		VectorCarga[2].direccionX:= -1;  // izquierda
		VectorCarga[2].direccionY:= 0 ;  // izquierda
		VectorCarga[3].direccionX:= 0 ;  // arriba
		VectorCarga[3].direccionY:= 1 ;  // arriba
		VectorCarga[4].direccionX:= 0 ;  // abajo
		VectorCarga[4].direccionY:= -1;  // abajo
		VectorCarga[5].direccionX:= 1 ;  // diagonal superior derecha
		VectorCarga[5].direccionY:= 1 ;  // diagonal superior derecha
		VectorCarga[6].direccionX:= 1 ;  // diagonal inferior derecha
		VectorCarga[6].direccionY:= -1;  // diagonal inferior derecha
		VectorCarga[7].direccionX:= -1;  // diagonal superior izquierda
		VectorCarga[7].direccionY:= 1 ;  // diagonal superior izquierda
		VectorCarga[8].direccionX:= -1;  // diagonal inferior izquierda
		VectorCarga[8].direccionY:= -1;  // diagonal inferior izquierda
		
		for i:=1 to MAX_VECTOR_CARGA do
		
			begin
				VectorCarga[i].direccionvalida:=false;
				VectorCarga[i].fichasdarvuelta:= 0;
			end;
			
	end;

