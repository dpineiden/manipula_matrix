%Una funcion que inspecione a fondo un directorio, listando la ruta de
%todos sus archivos.
function inspeccion=inspeccion_directorio(Directorio_Padre,BaseDir)
%listar u obtener la catnidad los archivos en que despues del tercer '_'
%diga 'hijo', esto es la lista de archivos en forma RAW dentro de carpetas
Nivel=1;
%hijas del directorio
hijo='hijo';
str='|';
h1=contar_txt(Directorio_Padre,hijo);
h2=h1;
while h2<=h1
%inspeccion es la ruta del archivo que contiene la lista completa
DP=Directorio_Padre
[nietos_Path directorios]=listar_nietos_directorio(Directorio_Padre,Nivel,BaseDir);
%inspeccionar cada lista de directorio
h1=contar_txt(Directorio_Padre,hijo);
[n m]=size(directorios);
Nivel=Nivel+1
for i=2:n
    %entregar el índice si hay carpetas dentro de directorio.
    archivo_dir=directorios{i-1,1}
    FID_D=fopen(archivo_dir,'r');
    %extraer linea
    d=1;
    while ~feof(FID_D)
        	leer_linea=fgetl(FID_D);
            %buscar separador '|'
            k_str=strfind(leer_linea,str);
            %obtener numero de linea
            numero_linea(d)=str2num(leer_linea(1:k_str-1));
            %obtener nombre de carpeta
            nombre_carpeta{d}=leer_linea(k_str+1:length(leer_linea));
            d=d+1;%se termina con un indice aumentado
    end
    %separar numero de linea 
    fclose(FID_D);
end
    for j=1:d-2
     Nuevo_dir=nombre_carpeta{j}
    [nietos_Path directorios]=listar_nietos_directorio(Nuevo_dir,Nivel,BaseDir);
    end
h2=contar_txt(Directorio_Padre,hijo);
end
inspeccion='archivos_total.txt';
end