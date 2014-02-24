%leer directorio en que se encuentran las imágenes:
BaseDir='/home/david/Documents/Proyectos_CEA/CNM008/Codigo_Mat';
Directorio='DesAtacama';
ProjectDir='/home/david/Documents/Proyectos_CEA/CNM008/Codigo_Mat/DesAtacama/233_076';
cd(ProjectDir);
[A lista]=unix(['find -name *.txt']);
RutaLog=[BaseDir,'/Logs'];
archivos_TXT='archivos_TXT.txt';
FID=fopen([RutaLog,'/',archivos_TXT],'w+');
fprintf(FID,lista);
fclose(FID);
charMTL='_MTL.txt';
fid=fopen([RutaLog,'/',archivos_TXT],'r');
MTL=0
MTLset={};
while ~feof(fid)
    leer_linea=fgetl(fid);
    cola=leer_linea(length(leer_linea)-length(charMTL)+1:length(leer_linea));
    patron=leer_linea;
    str=charMTL;
    k_str=strfind(patron,str);

    if strcmp(cola,charMTL)
        MTL=MTL+1;
        MTLset{MTL,1}=[leer_linea,'\n'];
    end%se han creado las carpetas
    %se descomprime aqui el archivo (dentro de carpeta)
end
fclose(fid);
archivos_MTL=['archivos_MTL_' Directorio '.txt'];
[a b]=size(MTLset);
FID=fopen([RutaLog,'/',archivos_MTL],'w+');
for i=1:a
fprintf(FID,MTLset{i,1});
end
fclose(FID);
FID=fopen([RutaLog,'/',archivos_MTL],'r');
savemat=0;
Proceso='proyecto'
  str='/';  
while ~feof(fid)
MTL_lin=fgetl(fid);
patron=MTL_lin;
k_str=strfind(patron,str);
n= length(k_str);
MTLDIR=MTL_lin(1:k_str(length(k_str)));
NDVI=ndvi(BaseDir,MTLDIR,savemat,Proceso);
pack;
end
fclose(FID);
