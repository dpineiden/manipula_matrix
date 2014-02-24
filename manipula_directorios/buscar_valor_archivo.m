function [Valor,NombreVal,n_linea]=buscar_valor_archivo(NombreValor, FilePath)
S=size(NombreValor);
L=S(2);
n=1;
NV={};
FID=fopen(FilePath);
while ~feof(FID)
	leer_linea=fgetl(FID);
	%revisa si linea esta vacia o si no es un caracter
	if isempty(leer_linea) || ~ischar(leer_linea), break, end
	linea=leer_linea;
		%leer los elementos de NombreValor a buscar en archivo
		%cada linea del archivo es NOMBRE = Valor
		%Consiste en extraer linea, buscar string en linea y obtener valor
		%N=length(NOMBRE)=5
		%si en linea LN existe, la busqueda entrega a como posicion inical
		%Tlin: total caracteres linea
		%Valor se obtiene de: [a+N+3,Tlin]
		for i=1:L
		N=length(char(NombreValor{i}));
		a=strfind(linea,char(NombreValor{i}));
			if ~isempty(a)
			%if n==61
            n_linea(i)=n;
            largo_linea=length(linea(1,:));
            NombreVal{i}=linea(a:N+a-1);
            NV{i}=linea(a+N+3:largo_linea);
			break
            end
		end
	n=n+1;
end
fclose(FID);
Valor=NV;