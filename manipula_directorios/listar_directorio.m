function [lista_archivos lista_directorios es_Directorio n_linea_dir]=listar_directorio(Directorio_Padre,BaseDir,Etapa,Nivel,Log)
cd(BaseDir);
mkdir(Log);
Nombre_Archivo=['lista_nivel_',num2str(Nivel),'_hijo_',num2str(Etapa),'.txt'];
txt_lista=strcat(BaseDir,'/',Log,'/',Nombre_Archivo);
cd(Directorio_Padre);
%se obtiene la lista como string de carpetas(/ al final) y archivos hijos
[status lista]=unix('ls -ahalpi *');
%pasar txt lista a lista de directorios
fid=fopen(txt_lista,'w+');%crear o abrir archivo lista.txt 
%actualizando lista de archivos en directorio
fprintf(fid,lista);
fclose(fid);
lista_archivos=txt_lista;
es_Directorio={};
i=1;
n_linea=1;
%abrir archivo para lectura
linea_anterior='';
n_linea_dir(i)=n_linea+1;
es_Directorio{i}=Directorio_Padre;
lin_dir{1,1}=[num2str(n_linea_dir(i)),'|',es_Directorio{i},'\n'];
i=2;

fid=fopen(lista_archivos,'r');
while ~feof(fid)
	leer_linea=fgetl(fid);
    if length(leer_linea)>4
    if eq(leer_linea(1:5),'total')
       es_Directorio{i}=strcat(Directorio_Padre,'/',linea_anterior(1:length(linea_anterior)-1)); 
       n_linea_dir(i)=n_linea-1;
       lin_dir{i,1}=[num2str(n_linea_dir(i)),'|',es_Directorio{i},'\n'];
       i=i+1;
    end
    end
    linea_anterior=leer_linea;
    n_linea=n_linea+1;
end
n_linea_dir(i)=n_linea+1;
es_Directorio{i}='fin de linea (+1)';
lin_dir{i,1}=[num2str(n_linea_dir(i)),'|',es_Directorio{i},'\n'];
fclose(fid); 
Nombre_Archivo=['lista_nivel_',num2str(Nivel),'_directorios_',num2str(Etapa),'.txt'];
txt_listaD=strcat(BaseDir,'/',Log,'/',Nombre_Archivo);
fid=fopen(txt_listaD,'w+');%crear o abrir aarchivo lista.txt 
%actualizando lista de archivos en directorio
[n m]=size(lin_dir);
lin_dir;
for k=1:n
    fprintf(fid,lin_dir{k,1});
end
fclose(fid);
lista_directorios=txt_listaD;
end