function VerificarValido (tablero:tTablero;posicionX:byte; posicionY:byte):boolean; //beta :)
  var Valido: boolean;
  begin  
    Valido:=false
    if tablero[posicionX+1,posicionY]=FichaContraria then
      begin
        while (tablero[posicionX+1,posicionY]<>FichaJugadorActual) and (tablero[posicionX+1,posicionY]<>'_') do
          begin
            if (tablero[posicionX+1,posicionY]=FichaContraria) then 
              Valido:=true
            else posicionX:=posicionX+1;
          end;
      end;
    VerificarValido:=Valido;
end;   
    
    
    
procedure DarVuelta (var tablero:tTablero; VerificarValido:boolean);
var
  begin
  if (VerificarValido:=true) then
  FichaContraria:=FichaJugadorActual;
