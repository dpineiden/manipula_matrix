%Ruta es una ruta de directorio con archivo
%signo es el caracter que separa cada directorio de la ruta
function nombre=desmembrar(Ruta, Signo)
  patron=Ruta;
  str=Signo;
  k_str=strfind(patron,str);
  n= length(k_str);
  for i=1:n-1
     nombre{i,1}=Ruta(k_str(i)+1:k_str(i+1)-1); 
  end
  nombre{n,1}=Ruta(k_str(n)+1:length(Ruta));

end